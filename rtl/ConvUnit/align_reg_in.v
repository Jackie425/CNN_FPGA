`timescale 1ns / 1ps

module align_reg_in # (
    parameter           REG_CHANNEL_NUM             =   8'd9                                   ,
    parameter           DATA_WIDTH_IN               =   4'd8                                    ,
    parameter           DATA_WIDTH_OUT              =   4'd9                                    ,
    parameter           TOTAL_WIDTH_IN              =   REG_CHANNEL_NUM * DATA_WIDTH_IN         ,//80
    parameter           TOTAL_WIDTH_OUT             =   REG_CHANNEL_NUM * DATA_WIDTH_OUT        ,//90
    parameter           MULT_PIPELINE_STAGE         =   2'd2
)
(
    input   wire                clk                                                         ,
    input   wire                rstn                                                        ,
//data path
    input   wire    [TOTAL_WIDTH_IN-1:0]            reg_data_in                                 ,
    output  wire    [TOTAL_WIDTH_OUT-1:0]           reg_data_out                                
                     
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
    //localparam TOTAL_WIDTH_IN_D9 = TOTAL_WIDTH_IN_D8-8        ;



    reg [TOTAL_WIDTH_IN_D1-1:0]  x_d1;   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D2-1:0]  x_d2;   // [0:MULT_PIPELINE_STAGE-1]   ;    
    reg [TOTAL_WIDTH_IN_D3-1:0]  x_d3;   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D4-1:0]  x_d4;   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D5-1:0]  x_d5;   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D6-1:0]  x_d6;   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D7-1:0]  x_d7;   // [0:MULT_PIPELINE_STAGE-1]   ;
    reg [TOTAL_WIDTH_IN_D8-1:0]  x_d8;   // [0:MULT_PIPELINE_STAGE-1]   ;
    //reg [TOTAL_WIDTH_IN_D9-1:0]  x_d9;   // [0:MULT_PIPELINE_STAGE-1]   ;


    assign reg_data_out = {x_d8[7],x_d8[7:0],x_d7[7],x_d7[7:0],
                           x_d6[7],x_d6[7:0],x_d5[7],x_d5[7:0],x_d4[7],x_d4[7:0],
                           x_d3[7],x_d3[7:0],x_d2[7],x_d2[7:0],x_d1[7],x_d1[7:0],
                           reg_data_in[7],reg_data_in[7:0]};
    always @(posedge clk or negedge rstn) begin
        if(!rstn)begin
            x_d1 <= 72'b0;
            x_d2 <= 64'b0;
            x_d3 <= 56'b0;
            x_d4 <= 48'b0;
            x_d5 <= 40'b0;
            x_d6 <= 32'b0;
            x_d7 <= 24'b0;
            x_d8 <= 16'b0;
        end else begin
            x_d1 <= reg_data_in[TOTAL_WIDTH_IN-1:8] ;
            x_d2 <= x_d1[TOTAL_WIDTH_IN_D1-1:8] ;
            x_d3 <= x_d2[TOTAL_WIDTH_IN_D2-1:8] ;
            x_d4 <= x_d3[TOTAL_WIDTH_IN_D3-1:8] ;
            x_d5 <= x_d4[TOTAL_WIDTH_IN_D4-1:8] ;
            x_d6 <= x_d5[TOTAL_WIDTH_IN_D5-1:8] ;          
            x_d7 <= x_d6[TOTAL_WIDTH_IN_D6-1:8] ;
            x_d8 <= x_d7[TOTAL_WIDTH_IN_D7-1:8] ;
        end
    end


endmodule