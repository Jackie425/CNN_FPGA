`timescale 1ns / 1ps

module PWconv # (
    parameter           MAC_IN_NUM              =   8'd10                        ,
    parameter           MAC_OUT_NUM             =   8'd16                        ,
    parameter           DATA_WIDTH              =   4'd8                         ,
    parameter           CNT_WIDTH               =   8'd10                        ,
    parameter           MAC_IN_WIDTH            =   MAC_IN_NUM * DATA_WIDTH      ,
    parameter           MAC_OUT_WIDTH           =   MAC_OUT_NUM * DATA_WIDTH
)
(
    input   wire                clk                                              ,
    input   wire                rstn                                             ,

    input   wire    [MAC_IN_WIDTH-1:0]          fifo_rdata                   ,
    input   wire                                fifo_rde                     ,
    input   wire    [MAC_IN_WIDTH-1:0]          fifo_rpram                   ,
    input   wire                                fifo_rpe                     ,

    

    output  wire    [MAC_OUT_WIDTH-1:0]         fifo_wdata                   ,
    output  wire                                fifo_wde                       
    
);

wire    [CNT_WIDTH-1:0]     count                           ;





endmodule