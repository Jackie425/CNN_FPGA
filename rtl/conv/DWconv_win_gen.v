`timescale 1ns / 1ps

module DWconv_win_gen # (
    parameter           MULT_PIPELINE_STAGE     =   2'd2                        ,
    parameter           Z_INIT                  =   48'd0                       ,
    parameter           ASYNC_RST               =   1'b0
)
(
    input   wire                clk                                             ,
    input   wire                rstn                                            ,

    input   wire    [7:0]       data_in                                         ,

    output  wire    [7:0]       conv_win_0                                      ,
    output  wire    [7:0]       conv_win_1                                      ,
    output  wire    [7:0]       conv_win_2                                      ,
    output  wire    [7:0]       conv_win_3                                      ,
    output  wire    [7:0]       conv_win_4                                      ,
    output  wire    [7:0]       conv_win_5                                      ,
    output  wire    [7:0]       conv_win_6                                      ,
    output  wire    [7:0]       conv_win_7                                      ,
    output  wire    [7:0]       conv_win_8                                      
);


/*
    DWconv_windows_generator
     Function:
        input: [7:0]data_in
        output: [7:0]convolution_windows[0:8]

    `using DRM9K as row buffer
    `
    `pipeline stages 1

    `SYNC_RST
*/


endmodule