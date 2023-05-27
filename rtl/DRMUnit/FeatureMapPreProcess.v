`timescale 1ns / 1ps

module FeatureMapPreProcess # (
    parameter           CONV_IN_NUM             =   9                                    ,
    parameter           CONV_OUT_NUM            =   18                                   ,
    parameter           DATA_WIDTH              =   8                                    ,
    parameter           WEIGHT_WIDTH            =   8                                    ,
    parameter           BIAS_WIDTH              =   16                                   ,
    parameter           FM_MEM_DEPTH            =   13                                   ,
    parameter           DDR_WIDTH               =   256                                  
)
(
    input   wire                                        sys_clk         ,
    input   wire                                        calc_clk        ,
    input   wire                                        rstn            ,

    input   wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]       Conv_wr_data    ,
    input   wire                                        Conv_wr_valid   ,
    input   wire    [DDR_WIDTH-1:0]                     DDR_wr_data     ,
    input   wire                                        DDR_wr_valid    ,

    output  wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]       wr_data         ,
    output  wire                                        wr_en
);



endmodule