`timescale 1ns / 1ps
module align_reg_old # (
    parameter           REG_CHANNEL_NUM             =   8'd10                                   ,
    parameter           DATA_WIDTH_IN               =   4'd8                                    ,
    parameter           DATA_WIDTH_OUT              =   4'd9                                    ,
    parameter           TOTAL_WIDTH_IN              =   REG_CHANNEL_NUM * DATA_WIDTH_IN         ,//80
    parameter           TOTAL_WIDTH_OUT             =   REG_CHANNEL_NUM * DATA_WIDTH_OUT         //90
)
(
    input   wire                clk                                                         ,
    input   wire                rstn                                                        ,
//data path
    input   wire    [TOTAL_WIDTH_IN-1:0]            reg_data_in                                 ,
    input   wire    [TOTAL_WIDTH_IN-1:0]            reg_param_in                                ,

    output  wire    [TOTAL_WIDTH_OUT-1:0]           reg_data_out                                ,
    output  wire    [TOTAL_WIDTH_OUT-1:0]           reg_param_out                              
);

wire    [DATA_WIDTH_IN-1:0]       x_in        [0:REG_CHANNEL_NUM-1]              ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d1     [0:REG_CHANNEL_NUM-10][0:1]               ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d2     [0:REG_CHANNEL_NUM-9][0:1]               ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d3     [0:REG_CHANNEL_NUM-8][0:1]               ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d4     [0:REG_CHANNEL_NUM-7][0:1]               ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d5     [0:REG_CHANNEL_NUM-6][0:1]               ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d6     [0:REG_CHANNEL_NUM-5][0:1]               ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d7     [0:REG_CHANNEL_NUM-4][0:1]               ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d8     [0:REG_CHANNEL_NUM-3][0:1]               ;
reg     [DATA_WIDTH_IN-1:0]       x_in_d9     [0:REG_CHANNEL_NUM-2][0:1]              ;

wire    [DATA_WIDTH_IN-1:0]       y_in        [0:REG_CHANNEL_NUM-1]                     ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d1     [0:REG_CHANNEL_NUM-10][0:1]              ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d2     [0:REG_CHANNEL_NUM-9][0:1]              ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d3     [0:REG_CHANNEL_NUM-8][0:1]              ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d4     [0:REG_CHANNEL_NUM-7][0:1]              ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d5     [0:REG_CHANNEL_NUM-6][0:1]              ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d6     [0:REG_CHANNEL_NUM-5][0:1]              ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d7     [0:REG_CHANNEL_NUM-4][0:1]              ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d8     [0:REG_CHANNEL_NUM-3][0:1]              ;
reg     [DATA_WIDTH_IN-1:0]       y_in_d9     [0:REG_CHANNEL_NUM-2][0:1]             ;


    //output concat
    assign reg_data_out = {x_in_d9[0][1][7],x_in_d9[0][1],x_in_d8[0][1][7],x_in_d8[0][1],x_in_d7[0][1][7],
                           x_in_d7[0][1],x_in_d6[0][1][7],x_in_d6[0][1],x_in_d5[0][1][7],x_in_d5[0][1],
                           x_in_d4[0][1][7],x_in_d4[0][1],x_in_d3[0][1][7],x_in_d3[0][1],x_in_d2[0][1][7],
                           x_in_d2[0][1],x_in_d1[0][1][7],x_in_d1[0][1],x_in[0][7],x_in[0]};
    assign reg_param_out = {y_in_d9[0][1][7],y_in_d9[0][1],y_in_d8[0][1][7],y_in_d8[0][1],y_in_d7[0][1][7],
                            y_in_d7[0][1],y_in_d6[0][1][7],y_in_d6[0][1],y_in_d5[0][1][7],y_in_d5[0][1],
                            y_in_d4[0][1][7],y_in_d4[0][1],y_in_d3[0][1][7],y_in_d3[0][1],y_in_d2[0][1][7],
                            y_in_d2[0][1],y_in_d1[0][1][7],y_in_d1[0][1],y_in[0][7],y_in[0]};

    //input split
    generate
        genvar i;
        for(i = 0 ; i < REG_CHANNEL_NUM ; i = i + 1) begin:input_split
            assign x_in[i] = reg_data_in[DATA_WIDTH_IN*(i + 1)-1:0]     ;
            assign y_in[i] = reg_param_in[DATA_WIDTH_IN*(i + 1)-1:0]    ;
        end
    endgenerate

    //aligns inputs with registers
    generate
        genvar j;
        for(j = 0 ; j < REG_CHANNEL_NUM ; j = j + 1) begin:input_reg_data
            case (j)
                0:begin
                    always @(posedge clk or negedge rstn) begin:col1_x
                        if(!rstn)begin
                            x_in_d1[0][0] <= 8'b0;
                            x_in_d1[0][1] <= 8'b0;
                            x_in_d2[j][0] <= 8'b0;
                            x_in_d2[j][1] <= 8'b0;
                            x_in_d3[j][0] <= 8'b0;
                            x_in_d3[j][1] <= 8'b0;
                            x_in_d4[j][0] <= 8'b0;
                            x_in_d4[j][1] <= 8'b0;
                            x_in_d5[j][0] <= 8'b0;
                            x_in_d5[j][1] <= 8'b0;
                            x_in_d6[j][0] <= 8'b0;
                            x_in_d6[j][1] <= 8'b0;
                            x_in_d7[j][0] <= 8'b0;
                            x_in_d7[j][1] <= 8'b0;
                            x_in_d8[j][0] <= 8'b0;
                            x_in_d8[j][1] <= 8'b0;
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d1[0][0] <= x_in[j + 1];
                            x_in_d1[0][1] <= x_in_d1[0][0];
                            x_in_d2[j][0] <= x_in_d2[j + 1][1];
                            x_in_d2[j][1] <= x_in_d2[j][0];
                            x_in_d3[j][0] <= x_in_d3[j + 1][1];
                            x_in_d3[j][1] <= x_in_d3[j][0];
                            x_in_d4[j][0] <= x_in_d4[j + 1][1];
                            x_in_d4[j][1] <= x_in_d4[j][0];
                            x_in_d5[j][0] <= x_in_d5[j + 1][1];
                            x_in_d5[j][1] <= x_in_d5[j][0];
                            x_in_d6[j][0] <= x_in_d6[j + 1][1];
                            x_in_d6[j][1] <= x_in_d6[j][0];
                            x_in_d7[j][0] <= x_in_d7[j + 1][1];
                            x_in_d7[j][1] <= x_in_d7[j][0];
                            x_in_d8[j][0] <= x_in_d8[j + 1][1];
                            x_in_d8[j][1] <= x_in_d8[j][0];
                            x_in_d9[j][0] <= x_in_d9[j + 1][1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
                1:begin 
                    always @(posedge clk or negedge rstn) begin:col2_x
                        if(!rstn)begin
                            x_in_d2[j][0] <= 8'b0;
                            x_in_d2[j][1] <= 8'b0;
                            x_in_d3[j][0] <= 8'b0;
                            x_in_d3[j][1] <= 8'b0;
                            x_in_d4[j][0] <= 8'b0;
                            x_in_d4[j][1] <= 8'b0;
                            x_in_d5[j][0] <= 8'b0;
                            x_in_d5[j][1] <= 8'b0;
                            x_in_d6[j][0] <= 8'b0;
                            x_in_d6[j][1] <= 8'b0;
                            x_in_d7[j][0] <= 8'b0;
                            x_in_d7[j][1] <= 8'b0;
                            x_in_d8[j][0] <= 8'b0;
                            x_in_d8[j][1] <= 8'b0;
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d2[j][0] <= x_in[j + 1];
                            x_in_d2[j][1] <= x_in_d2[j][0];
                            x_in_d3[j][0] <= x_in_d3[j + 1][1];
                            x_in_d3[j][1] <= x_in_d3[j][0];
                            x_in_d4[j][0] <= x_in_d4[j + 1][1];
                            x_in_d4[j][1] <= x_in_d4[j][0];
                            x_in_d5[j][0] <= x_in_d5[j + 1][1];
                            x_in_d5[j][1] <= x_in_d5[j][0];
                            x_in_d6[j][0] <= x_in_d6[j + 1][1];
                            x_in_d6[j][1] <= x_in_d6[j][0];
                            x_in_d7[j][0] <= x_in_d7[j + 1][1];
                            x_in_d7[j][1] <= x_in_d7[j][0];
                            x_in_d8[j][0] <= x_in_d8[j + 1][1];
                            x_in_d8[j][1] <= x_in_d8[j][0];
                            x_in_d9[j][0] <= x_in_d9[j + 1][1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
                2:begin
                    always @(posedge clk or negedge rstn) begin:col3_x
                        if(!rstn)begin
                            x_in_d3[j][0] <= 8'b0;
                            x_in_d3[j][1] <= 8'b0;
                            x_in_d4[j][0] <= 8'b0;
                            x_in_d4[j][1] <= 8'b0;
                            x_in_d5[j][0] <= 8'b0;
                            x_in_d5[j][1] <= 8'b0;
                            x_in_d6[j][0] <= 8'b0;
                            x_in_d6[j][1] <= 8'b0;
                            x_in_d7[j][0] <= 8'b0;
                            x_in_d7[j][1] <= 8'b0;
                            x_in_d8[j][0] <= 8'b0;
                            x_in_d8[j][1] <= 8'b0;
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d3[j][0] <= x_in[j + 1];
                            x_in_d3[j][1] <= x_in_d3[j][0];
                            x_in_d4[j][0] <= x_in_d4[j + 1][1];
                            x_in_d4[j][1] <= x_in_d4[j][0];
                            x_in_d5[j][0] <= x_in_d5[j + 1][1];
                            x_in_d5[j][1] <= x_in_d5[j][0];
                            x_in_d6[j][0] <= x_in_d6[j + 1][1];
                            x_in_d6[j][1] <= x_in_d6[j][0];
                            x_in_d7[j][0] <= x_in_d7[j + 1][1];
                            x_in_d7[j][1] <= x_in_d7[j][0];
                            x_in_d8[j][0] <= x_in_d8[j + 1][1];
                            x_in_d8[j][1] <= x_in_d8[j][0];
                            x_in_d9[j][0] <= x_in_d9[j + 1][1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
                3:begin
                    always @(posedge clk or negedge rstn) begin:col4_x
                        if(!rstn)begin
                            x_in_d4[j][0] <= 8'b0;
                            x_in_d4[j][1] <= 8'b0;
                            x_in_d5[j][0] <= 8'b0;
                            x_in_d5[j][1] <= 8'b0;
                            x_in_d6[j][0] <= 8'b0;
                            x_in_d6[j][1] <= 8'b0;
                            x_in_d7[j][0] <= 8'b0;
                            x_in_d7[j][1] <= 8'b0;
                            x_in_d8[j][0] <= 8'b0;
                            x_in_d8[j][1] <= 8'b0;
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d4[j][0] <= x_in[j + 1];
                            x_in_d4[j][1] <= x_in_d4[j][0];
                            x_in_d5[j][0] <= x_in_d5[j + 1][1];
                            x_in_d5[j][1] <= x_in_d5[j][0];
                            x_in_d6[j][0] <= x_in_d6[j + 1][1];
                            x_in_d6[j][1] <= x_in_d6[j][0];
                            x_in_d7[j][0] <= x_in_d7[j + 1][1];
                            x_in_d7[j][1] <= x_in_d7[j][0];
                            x_in_d8[j][0] <= x_in_d8[j + 1][1];
                            x_in_d8[j][1] <= x_in_d8[j][0];
                            x_in_d9[j][0] <= x_in_d9[j + 1][1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
                4:begin
                    always @(posedge clk or negedge rstn) begin:col5_x
                        if(!rstn)begin
                            x_in_d5[j][0] <= 8'b0;
                            x_in_d5[j][1] <= 8'b0;
                            x_in_d6[j][0] <= 8'b0;
                            x_in_d6[j][1] <= 8'b0;
                            x_in_d7[j][0] <= 8'b0;
                            x_in_d7[j][1] <= 8'b0;
                            x_in_d8[j][0] <= 8'b0;
                            x_in_d8[j][1] <= 8'b0;
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d5[j][0] <= x_in[j + 1];
                            x_in_d5[j][1] <= x_in_d5[j][0];
                            x_in_d6[j][0] <= x_in_d6[j + 1][1];
                            x_in_d6[j][1] <= x_in_d6[j][0];
                            x_in_d7[j][0] <= x_in_d7[j + 1][1];
                            x_in_d7[j][1] <= x_in_d7[j][0];
                            x_in_d8[j][0] <= x_in_d8[j + 1][1];
                            x_in_d8[j][1] <= x_in_d8[j][0];
                            x_in_d9[j][0] <= x_in_d9[j + 1][1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
                5:begin
                    always @(posedge clk or negedge rstn) begin:col6_x
                        if(!rstn)begin
                            x_in_d6[j][0] <= 8'b0;
                            x_in_d6[j][1] <= 8'b0;
                            x_in_d7[j][0] <= 8'b0;
                            x_in_d7[j][1] <= 8'b0;
                            x_in_d8[j][0] <= 8'b0;
                            x_in_d8[j][1] <= 8'b0;
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d6[j][0] <= x_in[j + 1];
                            x_in_d6[j][1] <= x_in_d6[j][0];
                            x_in_d7[j][0] <= x_in_d7[j + 1][1];
                            x_in_d7[j][1] <= x_in_d7[j][0];
                            x_in_d8[j][0] <= x_in_d8[j + 1][1];
                            x_in_d8[j][1] <= x_in_d8[j][0];
                            x_in_d9[j][0] <= x_in_d9[j + 1][1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
                6:begin
                    always @(posedge clk or negedge rstn) begin:col7_x
                        if(!rstn)begin
                            x_in_d7[j][0] <= 8'b0;
                            x_in_d7[j][1] <= 8'b0;
                            x_in_d8[j][0] <= 8'b0;
                            x_in_d8[j][1] <= 8'b0;
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d7[j][0] <= x_in[j + 1];
                            x_in_d7[j][1] <= x_in_d7[j][0];
                            x_in_d8[j][0] <= x_in_d8[j + 1][1];
                            x_in_d8[j][1] <= x_in_d8[j][0];
                            x_in_d9[j][0] <= x_in_d9[j + 1][1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
                7:begin
                    always @(posedge clk or negedge rstn) begin:col8_x
                        if(!rstn)begin
                            x_in_d8[j][0] <= 8'b0;
                            x_in_d8[j][1] <= 8'b0;
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d8[j][0] <= x_in[j + 1];
                            x_in_d8[j][1] <= x_in_d8[j][0];
                            x_in_d9[j][0] <= x_in_d9[j + 1][1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
                8:begin
                    always @(posedge clk or negedge rstn) begin:col9_x
                        if(!rstn)begin
                            x_in_d9[j][0] <= 8'b0;
                            x_in_d9[j][1] <= 8'b0;
                        end else begin
                            x_in_d9[j][0] <= x_in[j + 1];
                            x_in_d9[j][1] <= x_in_d9[j][0];
                        end
                    end
                end
            endcase
        end
    endgenerate

    generate
        genvar k;
        for(k = 0 ; k < REG_CHANNEL_NUM ; k = k  +  1) begin:input_reg_param
            case (k)
                0:begin
                    always @(posedge clk or negedge rstn) begin:col1_y
                        if(!rstn)begin
                            y_in_d1[0][0] <= 8'b0;
                            y_in_d1[0][1] <= 8'b0;
                            y_in_d2[k][0] <= 8'b0;
                            y_in_d2[k][1] <= 8'b0;
                            y_in_d3[k][0] <= 8'b0;
                            y_in_d3[k][1] <= 8'b0;
                            y_in_d4[k][0] <= 8'b0;
                            y_in_d4[k][1] <= 8'b0;
                            y_in_d5[k][0] <= 8'b0;
                            y_in_d5[k][1] <= 8'b0;
                            y_in_d6[k][0] <= 8'b0;
                            y_in_d6[k][1] <= 8'b0;
                            y_in_d7[k][0] <= 8'b0;
                            y_in_d7[k][1] <= 8'b0;
                            y_in_d8[k][0] <= 8'b0;
                            y_in_d8[k][1] <= 8'b0;
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d1[0][0] <= y_in[k + 1];
                            y_in_d1[0][1] <= y_in_d1[0][0];
                            y_in_d2[k][0] <= y_in_d2[k + 1][1];
                            y_in_d2[k][1] <= y_in_d2[k][0];
                            y_in_d3[k][0] <= y_in_d3[k + 1][1];
                            y_in_d3[k][1] <= y_in_d3[k][0];
                            y_in_d4[k][0] <= y_in_d4[k + 1][1];
                            y_in_d4[k][1] <= y_in_d4[k][0];
                            y_in_d5[k][0] <= y_in_d5[k + 1][1];
                            y_in_d5[k][1] <= y_in_d5[k][0];
                            y_in_d6[k][0] <= y_in_d6[k + 1][1];
                            y_in_d6[k][1] <= y_in_d6[k][0];
                            y_in_d7[k][0] <= y_in_d7[k + 1][1];
                            y_in_d7[k][1] <= y_in_d7[k][0];
                            y_in_d8[k][0] <= y_in_d8[k + 1][1];
                            y_in_d8[k][1] <= y_in_d8[k][0];
                            y_in_d9[k][0] <= y_in_d9[k + 1][1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
                1:begin
                    always @(posedge clk or negedge rstn) begin:col2_y
                        if(!rstn)begin
                            y_in_d2[k][0] <= 8'b0;
                            y_in_d2[k][1] <= 8'b0;
                            y_in_d3[k][0] <= 8'b0;
                            y_in_d3[k][1] <= 8'b0;
                            y_in_d4[k][0] <= 8'b0;
                            y_in_d4[k][1] <= 8'b0;
                            y_in_d5[k][0] <= 8'b0;
                            y_in_d5[k][1] <= 8'b0;
                            y_in_d6[k][0] <= 8'b0;
                            y_in_d6[k][1] <= 8'b0;
                            y_in_d7[k][0] <= 8'b0;
                            y_in_d7[k][1] <= 8'b0;
                            y_in_d8[k][0] <= 8'b0;
                            y_in_d8[k][1] <= 8'b0;
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d2[k][0] <= y_in[k + 1];
                            y_in_d2[k][1] <= y_in_d2[k][0];
                            y_in_d3[k][0] <= y_in_d3[k + 1][1];
                            y_in_d3[k][1] <= y_in_d3[k][0];
                            y_in_d4[k][0] <= y_in_d4[k + 1][1];
                            y_in_d4[k][1] <= y_in_d4[k][0];
                            y_in_d5[k][0] <= y_in_d5[k + 1][1];
                            y_in_d5[k][1] <= y_in_d5[k][0];
                            y_in_d6[k][0] <= y_in_d6[k + 1][1];
                            y_in_d6[k][1] <= y_in_d6[k][0];
                            y_in_d7[k][0] <= y_in_d7[k + 1][1];
                            y_in_d7[k][1] <= y_in_d7[k][0];
                            y_in_d8[k][0] <= y_in_d8[k + 1][1];
                            y_in_d8[k][1] <= y_in_d8[k][0];
                            y_in_d9[k][0] <= y_in_d9[k + 1][1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
                2:begin
                    always @(posedge clk or negedge rstn) begin:col3_y
                        if(!rstn)begin
                            y_in_d3[k][0] <= 8'b0;
                            y_in_d3[k][1] <= 8'b0;
                            y_in_d4[k][0] <= 8'b0;
                            y_in_d4[k][1] <= 8'b0;
                            y_in_d5[k][0] <= 8'b0;
                            y_in_d5[k][1] <= 8'b0;
                            y_in_d6[k][0] <= 8'b0;
                            y_in_d6[k][1] <= 8'b0;
                            y_in_d7[k][0] <= 8'b0;
                            y_in_d7[k][1] <= 8'b0;
                            y_in_d8[k][0] <= 8'b0;
                            y_in_d8[k][1] <= 8'b0;
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d3[k][0] <= y_in[k + 1];
                            y_in_d3[k][1] <= y_in_d3[k][0];
                            y_in_d4[k][0] <= y_in_d4[k + 1][1];
                            y_in_d4[k][1] <= y_in_d4[k][0];
                            y_in_d5[k][0] <= y_in_d5[k + 1][1];
                            y_in_d5[k][1] <= y_in_d5[k][0];
                            y_in_d6[k][0] <= y_in_d6[k + 1][1];
                            y_in_d6[k][1] <= y_in_d6[k][0];
                            y_in_d7[k][0] <= y_in_d7[k + 1][1];
                            y_in_d7[k][1] <= y_in_d7[k][0];
                            y_in_d8[k][0] <= y_in_d8[k + 1][1];
                            y_in_d8[k][1] <= y_in_d8[k][0];
                            y_in_d9[k][0] <= y_in_d9[k + 1][1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
                3:begin
                    always @(posedge clk or negedge rstn) begin:col4_y
                        if(!rstn)begin
                            y_in_d4[k][0] <= 8'b0;
                            y_in_d4[k][1] <= 8'b0;
                            y_in_d5[k][0] <= 8'b0;
                            y_in_d5[k][1] <= 8'b0;
                            y_in_d6[k][0] <= 8'b0;
                            y_in_d6[k][1] <= 8'b0;
                            y_in_d7[k][0] <= 8'b0;
                            y_in_d7[k][1] <= 8'b0;
                            y_in_d8[k][0] <= 8'b0;
                            y_in_d8[k][1] <= 8'b0;
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d4[k][0] <= y_in[k + 1];
                            y_in_d4[k][1] <= y_in_d4[k][0];
                            y_in_d5[k][0] <= y_in_d5[k + 1][1];
                            y_in_d5[k][1] <= y_in_d5[k][0];
                            y_in_d6[k][0] <= y_in_d6[k + 1][1];
                            y_in_d6[k][1] <= y_in_d6[k][0];
                            y_in_d7[k][0] <= y_in_d7[k + 1][1];
                            y_in_d7[k][1] <= y_in_d7[k][0];
                            y_in_d8[k][0] <= y_in_d8[k + 1][1];
                            y_in_d8[k][1] <= y_in_d8[k][0];
                            y_in_d9[k][0] <= y_in_d9[k + 1][1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
                4:begin
                    always @(posedge clk or negedge rstn) begin:col5_y
                        if(!rstn)begin
                            y_in_d5[k][0] <= 8'b0;
                            y_in_d5[k][1] <= 8'b0;
                            y_in_d6[k][0] <= 8'b0;
                            y_in_d6[k][1] <= 8'b0;
                            y_in_d7[k][0] <= 8'b0;
                            y_in_d7[k][1] <= 8'b0;
                            y_in_d8[k][0] <= 8'b0;
                            y_in_d8[k][1] <= 8'b0;
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d5[k][0] <= y_in[k + 1];
                            y_in_d5[k][1] <= y_in_d5[k][0];
                            y_in_d6[k][0] <= y_in_d6[k + 1][1];
                            y_in_d6[k][1] <= y_in_d6[k][0];
                            y_in_d7[k][0] <= y_in_d7[k + 1][1];
                            y_in_d7[k][1] <= y_in_d7[k][0];
                            y_in_d8[k][0] <= y_in_d8[k + 1][1];
                            y_in_d8[k][1] <= y_in_d8[k][0];
                            y_in_d9[k][0] <= y_in_d9[k + 1][1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
                5:begin
                    always @(posedge clk or negedge rstn) begin:col6_y
                        if(!rstn)begin
                            y_in_d6[k][0] <= 8'b0;
                            y_in_d6[k][1] <= 8'b0;
                            y_in_d7[k][0] <= 8'b0;
                            y_in_d7[k][1] <= 8'b0;
                            y_in_d8[k][0] <= 8'b0;
                            y_in_d8[k][1] <= 8'b0;
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d6[k][0] <= y_in[k + 1];
                            y_in_d6[k][1] <= y_in_d6[k][0];
                            y_in_d7[k][0] <= y_in_d7[k + 1][1];
                            y_in_d7[k][1] <= y_in_d7[k][0];
                            y_in_d8[k][0] <= y_in_d8[k + 1][1];
                            y_in_d8[k][1] <= y_in_d8[k][0];
                            y_in_d9[k][0] <= y_in_d9[k + 1][1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
                6:begin
                    always @(posedge clk or negedge rstn) begin:col7_y
                        if(!rstn)begin
                            y_in_d7[k][0] <= 8'b0;
                            y_in_d7[k][1] <= 8'b0;
                            y_in_d8[k][0] <= 8'b0;
                            y_in_d8[k][1] <= 8'b0;
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d7[k][0] <= y_in[k + 1];
                            y_in_d7[k][1] <= y_in_d7[k][0];
                            y_in_d8[k][0] <= y_in_d8[k + 1][1];
                            y_in_d8[k][1] <= y_in_d8[k][0];
                            y_in_d9[k][0] <= y_in_d9[k + 1][1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
                7:begin
                    always @(posedge clk or negedge rstn) begin:col8_y
                        if(!rstn)begin
                            y_in_d8[k][0] <= 8'b0;
                            y_in_d8[k][1] <= 8'b0;
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d8[k][0] <= y_in[k + 1];
                            y_in_d8[k][1] <= y_in_d8[k][0];
                            y_in_d9[k][0] <= y_in_d9[k + 1][1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
                8:begin
                    always @(posedge clk or negedge rstn) begin:col9_y
                        if(!rstn)begin
                            y_in_d9[k][0] <= 8'b0;
                            y_in_d9[k][1] <= 8'b0;
                        end else begin
                            y_in_d9[k][0] <= y_in[k + 1];
                            y_in_d9[k][1] <= y_in_d9[k][0];
                        end
                    end
                end
            endcase
        end
    endgenerate
endmodule