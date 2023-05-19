`timescale 1ns / 1ps

module BiasCtrl # (
    parameter       RD_ADDR_DEPTH           =       9               
)
(
    input   wire                        clk                 ,
    input   wire                        rstn                , 
//control path in   
    input   wire    [2:0]               current_state       ,
//control path out  
    output  wire                        state_rst           ,
    output  wire                        BiasMem_valid_out   ,
//control path inner
    output  wire    [RD_ADDR_DEPTH-1:0] addr_rd             ,
    output  wire                        bias_out_valid
);

endmodule
