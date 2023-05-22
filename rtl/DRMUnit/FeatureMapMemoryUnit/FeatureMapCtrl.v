`timescale 1ns / 1ps

module FeatureMapCtrl # (
    parameter       WR_ADDR_DEPTH           =   13              ,
    parameter       RD_ADDR_DEPTH           =   13       
)
(
    input   wire                        clk                 ,
    input   wire                        rstn                , 
//control path in   
    input   wire    [2:0]               current_state       ,
//control path out  
    output  wire                        state_rst           ,
    output  wire                        WeightDRM_valid_rd  ,
//control path inner   
    output  wire    [WR_ADDR_DEPTH-1:0] wr_addr             ,
    output  wire    [RD_ADDR_DEPTH-1:0] rd_addr             ,
    output  wire                        wr_en               
);


endmodule
