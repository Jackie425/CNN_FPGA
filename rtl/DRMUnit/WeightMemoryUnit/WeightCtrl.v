`timescale 1ns / 1ps

module WeightCtrl # (
    parameter       WR_ADDR_DEPTH           =   10              ,
    parameter       RD_ADDR_DEPTH           =   8               
)
(
    input   wire                        clk             ,
    input   wire                        rstn            , 
//control path in
    input   wire    [2:0]               current_state   ,
//control path out
    output  wire                        state_rst       ,
//control path inner
    output  wire    [WR_ADDR_DEPTH-1:0] addr_wr         ,
    output  wire    [RD_ADDR_DEPTH-1:0] addr_rd         
);

endmodule
