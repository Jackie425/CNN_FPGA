`timescale 1ns / 1ps

module align_reg_in # (
    parameter           REG_IN_CHANNEL_NUM          =   9                                   ,
    parameter           REG_OUT_CHANNEL_NUM         =   18                                  ,
    parameter           DATA_WIDTH_IN               =   8                                   ,
    parameter           TOTAL_WIDTH_IN              =   REG_IN_CHANNEL_NUM * DATA_WIDTH_IN   //72
)
(
    input   wire                clk                                                         ,
    input   wire                rstn                                                        ,
//data path
    input   wire    [TOTAL_WIDTH_IN*REG_OUT_CHANNEL_NUM-1:0]            reg_data_in         ,
    output  wire    [TOTAL_WIDTH_IN*REG_OUT_CHANNEL_NUM-1:0]            reg_data_out                                
                     
);
    //寄存器输入输出冗余导致重复寄存器被优化
    localparam TOTAL_WIDTH_IN_D1 = TOTAL_WIDTH_IN - 8           ;
    localparam TOTAL_WIDTH_IN_D2 = TOTAL_WIDTH_IN_D1 - 8        ;
    localparam TOTAL_WIDTH_IN_D3 = TOTAL_WIDTH_IN_D2 - 8        ;
    localparam TOTAL_WIDTH_IN_D4 = TOTAL_WIDTH_IN_D3 - 8        ;
    localparam TOTAL_WIDTH_IN_D5 = TOTAL_WIDTH_IN_D4 - 8        ;
    localparam TOTAL_WIDTH_IN_D6 = TOTAL_WIDTH_IN_D5 - 8        ;
    localparam TOTAL_WIDTH_IN_D7 = TOTAL_WIDTH_IN_D6 - 8        ;
    localparam TOTAL_WIDTH_IN_D8 = TOTAL_WIDTH_IN_D7 - 8        ;



    reg [TOTAL_WIDTH_IN_D1-1:0]  x_d1   [0:REG_OUT_CHANNEL_NUM-1];   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D2-1:0]  x_d2   [0:REG_OUT_CHANNEL_NUM-1];   // [0:MULT_PIPELINE_STAGE-1]   ;    
    reg [TOTAL_WIDTH_IN_D3-1:0]  x_d3   [0:REG_OUT_CHANNEL_NUM-1];   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D4-1:0]  x_d4   [0:REG_OUT_CHANNEL_NUM-1];   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D5-1:0]  x_d5   [0:REG_OUT_CHANNEL_NUM-1];   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D6-1:0]  x_d6   [0:REG_OUT_CHANNEL_NUM-1];   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D7-1:0]  x_d7   [0:REG_OUT_CHANNEL_NUM-1];   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D8-1:0]  x_d8   [0:REG_OUT_CHANNEL_NUM-1];   // [0:MULT_PIPELINE_STAGE-1]   ;

    wire    [TOTAL_WIDTH_IN-1:0]   reg_concat    [0:REG_OUT_CHANNEL_NUM-1];  


    generate
        genvar i;
        for(i = 0 ; i < REG_OUT_CHANNEL_NUM ; i = i + 1) begin:align_reg
            always @(posedge clk or negedge rstn) begin
                if(!rstn)begin
                    x_d1[i] <= 64'b0;
                    x_d2[i] <= 56'b0;
                    x_d3[i] <= 48'b0;
                    x_d4[i] <= 40'b0;
                    x_d5[i] <= 32'b0;
                    x_d6[i] <= 24'b0;
                    x_d7[i] <= 16'b0;
                    x_d8[i] <= 8'b0;
                end else begin
                    x_d1[i] <= reg_data_in[(TOTAL_WIDTH_IN*i+8)+:(TOTAL_WIDTH_IN-8)];
                    x_d2[i] <= x_d1[i][TOTAL_WIDTH_IN_D1-1:8];
                    x_d3[i] <= x_d2[i][TOTAL_WIDTH_IN_D2-1:8];
                    x_d4[i] <= x_d3[i][TOTAL_WIDTH_IN_D3-1:8];
                    x_d5[i] <= x_d4[i][TOTAL_WIDTH_IN_D4-1:8];
                    x_d6[i] <= x_d5[i][TOTAL_WIDTH_IN_D5-1:8];          
                    x_d7[i] <= x_d6[i][TOTAL_WIDTH_IN_D6-1:8];
                    x_d8[i] <= x_d7[i][TOTAL_WIDTH_IN_D7-1:8];
                end
            end
        
        end
    endgenerate       
    
//reg concat
    generate
        genvar j;
        for(j = 0 ; j < REG_OUT_CHANNEL_NUM ; j = j + 1) begin: concat_wire
            assign reg_concat[j] = {x_d8[j][7:0],x_d7[j][7:0],
            x_d6[j][7:0],x_d5[j][7:0],x_d4[j][7:0],
            x_d3[j][7:0],x_d2[j][7:0],x_d1[j][7:0],
            reg_data_in[j*TOTAL_WIDTH_IN+:8]};
        end
    endgenerate


    assign reg_data_out = {reg_concat[17],reg_concat[16],reg_concat[15],reg_concat[14],
    reg_concat[13],reg_concat[12],reg_concat[11],reg_concat[10],reg_concat[9],
    reg_concat[8],reg_concat[7],reg_concat[6],reg_concat[5],reg_concat[4],
    reg_concat[3],reg_concat[2],reg_concat[1],reg_concat[0]};
endmodule