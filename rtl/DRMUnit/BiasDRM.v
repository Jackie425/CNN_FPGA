`timescale 1ns / 1ps

module BiasDRM # (
    parameter       BIAS_CHANNEL_WIDTH      =       288             ,
    parameter       RD_ADDR_DEPTH           =       9

)
(
    input   wire    clk                                         ,
    input   wire    rstn                                        ,
//channel out
    input  wire     [RD_ADDR_DEPTH-1:0]         addr_rd         ,
    output  wire    [BIAS_CHANNEL_WIDTH-1:0]    data_rd

);

DRM_ROM_W288_A512 DRM_ROM_W288_A512_inst (
    .addr(addr_rd),          // input [8:0]
    .clk(clk),            // input
    .clk_en(1'b1),      // input
    .rst(~rstn),            // input
    .rd_data(data_rd)     // output [287:0]
  );

endmodule