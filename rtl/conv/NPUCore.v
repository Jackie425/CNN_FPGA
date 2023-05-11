`timescale 1ns / 1ps

module NPUCore # (
    parameter           MAC_IN_NUM              =   9                                    ,
    parameter           MAC_OUT_NUM             =   18                                   ,
    parameter           APM_COL_NUM             =   MAC_OUT_NUM / 2                      ,//9
    parameter           APM_ROW_NUM             =   MAC_IN_NUM                           ,//9
    parameter           DATA_WIDTH              =   8                                    ,
    parameter           WEIGHT_WIDTH            =   8                                    ,
    parameter           BIAS_WIDTH              =   16                                   ,
    parameter           MULT_PIPELINE_STAGE     =   2                                    
)
(
    input   wire                clk                                                         ,
    input   wire                rstn                                                        ,

//data path common 
    input   wire    [MAC_IN_NUM*DATA_WIDTH-1:0]                 MAC_data_in                 ,
    input   wire                                                MAC_data_valid_in           ,

    input   wire    [MAC_IN_NUM*WEIGHT_WIDTH*MAC_OUT_NUM-1:0]   MAC_weight_in               ,
    input   wire                                                MAC_weight_valid_in         ,

    input   wire    [BIAS_WIDTH*MAC_OUT_NUM-1:0]                MAC_bias_in                 ,
    input   wire    [16-1:0]                                    MAC_scale_in                ,

    output  wire    [MAC_OUT_NUM*DATA_WIDTH-1:0]                MAC_data_out                ,
    output  wire                                                MAC_data_valid_out          ,

    input   wire    [8-1:0]                                     MAC_accumulate_num_in       ,      
    
//control path 
    input   wire    [MAC_OUT_NUM-1:0]           adder_rst                                   
);

    wire  signed    [23:0]              APM_z_in        [0:MAC_OUT_NUM-1][0:MAC_IN_NUM-1]   ; 
    wire  signed    [23:0]              APM_p_out       [0:MAC_OUT_NUM-1][0:MAC_IN_NUM-1]   ;   
    wire            [8:0]               APM_x_in        [0:MAC_IN_NUM-1]                    ;
    wire  signed    [8:0]               APM_y_in        [0:MAC_OUT_NUM-1][0:MAC_IN_NUM-1]   ;   
    reg   signed    [23:0]              MAC_out         [0:MAC_OUT_NUM-1]                   ;
    reg   signed    [24-1:0]            scaled_out      [0:MAC_OUT_NUM-1]                   ;
    reg   signed    [24-1:0]            scaled_out_d1    [0:MAC_OUT_NUM-1]                  ;
    reg             [1:0]               clip_state      [0:MAC_OUT_NUM-1]                   ;
    reg   signed    [DATA_WIDTH-1:0]    cliped_out      [0:MAC_OUT_NUM-1]                   ;
    
    //weight wire in
    generate
        genvar p,q;
        for (p = 0; p < MAC_OUT_NUM; p = p + 1)
        begin
            for(q = 0; q < MAC_IN_NUM; q = q + 1)
            begin
                assign APM_y_in[p][q] = 
                    {
                        MAC_weight_in[(p*MAC_IN_NUM*WEIGHT_WIDTH + q*WEIGHT_WIDTH) + WEIGHT_WIDTH-1], //sign-bit
                        MAC_weight_in[(p*MAC_IN_NUM*WEIGHT_WIDTH + q*WEIGHT_WIDTH) +: WEIGHT_WIDTH]
                    }; 
            end
        end
    endgenerate

    //output concat
    assign MAC_data_o = {cliped_out[17], cliped_out[16], cliped_out[15],
                         cliped_out[14], cliped_out[13], cliped_out[12],
                         cliped_out[11], cliped_out[10], cliped_out[9] ,
                         cliped_out[8] , cliped_out[7] , cliped_out[6] ,
                         cliped_out[5] , cliped_out[4] , cliped_out[3] , 
                         cliped_out[2] , cliped_out[1][7:0], cliped_out[0]};/*位宽不对没截断导致APM被优化*/

    //aligns inputs with registers
    align_reg_in #(
        .MULT_PIPELINE_STAGE (MULT_PIPELINE_STAGE)
    )
    u_align_reg_in(
        .clk(clk)                                       ,
        .rstn(rstn)                                     ,
        .reg_data_in(MAC_data_in)                       ,
        .reg_data_out({APM_x_in[8],APM_x_in[7],
        APM_x_in[6],APM_x_in[5],APM_x_in[4],APM_x_in[3],APM_x_in[2],APM_x_in[1],APM_x_in[0]})                             
    );

    //Z in wire
    generate 
        genvar m,n;
        for(m = 0 ; m < MAC_OUT_NUM ; m = m + 1)
        begin:col_wire
            for(n = 1 ; n < MAC_IN_NUM ; n = n + 1)
            begin:row_wire
                assign APM_z_in[m][n] = APM_p_out[m][n - 1];
            end
            assign APM_z_in[m][0] = 24'b0;
        end
    endgenerate
    
    //APM systolic array
    generate
        genvar j,k;
        for(j = 0 ; j < APM_COL_NUM ; j = j + 1) begin:systolic_array_out
            for(k = 0 ; k < APM_ROW_NUM ; k = k + 1) begin:systolic_array_in
                APM #(
                    .MULT_PIPELINE_STAGE   (MULT_PIPELINE_STAGE)
                )
                u_APM(
                    .clk(clk),    
                    .rstn(rstn),
                    .low_x(APM_x_in[k]),
                    .low_y(APM_y_in[2 * j][k]),
                    .low_z(APM_z_in[2 * j][k]),
                    .high_x(APM_x_in[k]),
                    .high_y(APM_y_in[2 * j + 1][k]),
                    .high_z(APM_z_in[2 * j + 1][k]),
                    .data_valid(MAC_data_in_valid & MAC_param_in_valid),
                    .low_p(APM_p_out[2 * j][k]),
                    .high_p(APM_p_out[2 * j + 1][k])    
                );
            end
        end
    endgenerate

    //MAC_out accumulating
    integer i;
    always @(posedge clk or negedge rstn)
    begin
        for(i = 0 ; i < MAC_OUT_NUM ; i = i + 1) begin:adder
            if(!rstn)
            begin
                MAC_out[i] <= 24'b0;
            end else if(adder_rst)
            begin
                MAC_out[i] <= APM_p_out[i][MAC_IN_NUM-1];
            end else
            begin
                MAC_out[i] <= MAC_out[i] + APM_p_out[i][MAC_IN_NUM-1];
            end
        end
    end
    integer l;
    //MAC out scaling shift
    always @(posedge clk or negedge rstn)
    begin
        for(l = 0 ; l < MAC_OUT_NUM ; l = l + 1)
        begin
            if(!rstn)
            begin
                scaled_out[l]   <= 24'b0;
                scaled_out_d1[l] <= 24'b0;
                clip_state[l]   <= 2'b00;          
            end 
            else
            begin
                scaled_out[l] <= (MAC_out[l] >>> MAC_scale_in);//scale register
                clip_state[l][0] <= (scaled_out[l] < -24'd128);//clipstate register
                clip_state[l][1] <= (scaled_out[l] >  24'd127);
                scaled_out_d1[l]  <= scaled_out[l];
                case (clip_state[l])
                    2'b00: cliped_out[l] <= scaled_out_d1[l][7:0];
                    2'b01: cliped_out[l] <= -8'd128;
                    2'b10: cliped_out[l] <=  8'd127;
                    default: cliped_out[l] <= 8'd0;
                endcase
            end
        end
    end

    
endmodule