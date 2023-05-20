`timescale 1ns / 1ps

module DWConvWinGen # (
    parameter   OUT_CHANNEL_NUM =   18      ,
    parameter   DATA_WIDTH      =   8       ,
    parameter   IN_CHANNEL_NUM  =   9
)
(
    input  wire                                                 clk             ,
    input  wire                                                 rstn            ,
    input  wire     [OUT_CHANNEL_NUM*3*DATA_WIDTH-1:0]              data_in         ,
    input  wire                                                     valid_in        ,
    output reg      [OUT_CHANNEL_NUM*IN_CHANNEL_NUM*DATA_WIDTH-1:0] win_out         ,
    output wire                                                     vailid_out 
);

    integer i,j;
    always @(posedge clk or negedge rstn) begin
        for(i = 0 ; i < IN_CHANNEL_NUM ; i = i + 1) begin
            for(j = 0 ; j < OUT_CHANNEL_NUM ; j = j + 1) begin
                if(!rstn) begin
                    win_out <= 1296'b0;
                end else if(i!=0&&i!=3&&i!=6)begin
                    win_out[j*IN_CHANNEL_NUM*DATA_WIDTH+i*DATA_WIDTH +: DATA_WIDTH] <= win_out[j*IN_CHANNEL_NUM*DATA_WIDTH+(i-1)*DATA_WIDTH +: DATA_WIDTH];
                end else begin
                    win_out[j*IN_CHANNEL_NUM*DATA_WIDTH+i*DATA_WIDTH +: DATA_WIDTH] <= data_in[i*3*DATA_WIDTH+i/3*DATA_WIDTH +: DATA_WIDTH];
                end
            end
        end
    end


endmodule