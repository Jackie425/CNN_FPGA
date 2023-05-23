`timescale 1ns / 1ps

module DWRowBuff # (
    parameter   DATA_WIDTH              =       8                           ,
    parameter   IN_CHANNEL_NUM          =       9                           ,
    parameter   OUT_CHANNEL_NUM         =       18                          ,
    parameter   BUFF_LEN                =       320-2                       ,
    parameter   DEPTH                   =       $clog2(BUFF_LEN)             
)   
(   
    input  wire                                         clk             ,
    input  wire                                         rstn            ,
//data path 
    input  wire     [OUT_CHANNEL_NUM*DATA_WIDTH-1:0]    data_in         ,
    input  wire                                         valid_in        ,
    output wire     [OUT_CHANNEL_NUM*3*DATA_WIDTH-1:0]  data_out        ,
    output wire                                         valid_out       ,
//buffer control path
    input  wire     [DEPTH-1:0]                         buff_len_ctrl   ,
    input  wire                                         buff_len_rst    
);

    reg     [DEPTH-1:0]                                     addr_in;
    reg     [DEPTH-1:0]                                     addr_out;
    wire    [OUT_CHANNEL_NUM*DATA_WIDTH-1:0]                row1_data_out;
    wire    [OUT_CHANNEL_NUM*DATA_WIDTH-1:0]                row2_data_out;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            addr_in  <= BUFF_LEN - 1'b1;
            addr_out <= 0;
        end else if(buff_len_rst) begin
            addr_in  <= buff_len_ctrl - 1'b1;
            addr_out <= 0;
        end else if(addr_in == DEPTH - 1'b1) begin
            addr_in  <= 0;
            addr_out <= addr_out + 1'b1;
        end else if(addr_out == DEPTH - 1'b1) begin
            addr_in  <= addr_in + 1'b1;
            addr_out <= 0;
        end else if(valid_in) begin
            addr_in  <= addr_in  + 1'b1;
            addr_out <= addr_out + 1'b1;
        end
    end

    DRM_288_512 Row_Buff_DRM_inst (
        .wr_data({data_in,row1_data_out}),        // input [287:0]
        .wr_addr(addr_in),        // input [8:0]
        .wr_en(valid_in),            // input
        .wr_clk(CLK),          // input
        .wr_clk_en(1'b1),    // input
        .wr_rst(~rstn),          // input
        .rd_addr(addr_out),        // input [8:0]
        .rd_data({row1_data_out,row2_data_out}),        // output [287:0]
        .rd_clk(clk),          // input
        .rd_clk_en(1'b1),    // input
        .rd_rst(~rstn)           // input
      );
      
    assign data_out = {row2_data_out,row1_data_out,data_in};
endmodule