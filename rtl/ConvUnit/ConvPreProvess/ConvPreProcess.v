`timescale 1ns / 1ps

module ConvPreProcess # (
    parameter           CONV_IN_NUM              =   9                                    ,
    parameter           CONV_OUT_NUM             =   18                                   ,
    parameter           APM_COL_NUM             =   CONV_OUT_NUM / 2                      ,//9
    parameter           APM_ROW_NUM             =   CONV_IN_NUM                           ,//9
    parameter           DATA_WIDTH              =   8                                    ,
    parameter           WEIGHT_WIDTH            =   8                                    ,
    parameter           BIAS_WIDTH              =   16                                   ,
    parameter           MULT_PIPELINE_STAGE     =   2                                    ,
    parameter           ROW_BUFFER_DEPTH        =   9                                    ,
    parameter           BUFF_LEN                =   320-2
)
(
    input  wire                                                 clk             ,
    input  wire                                                 rstn            ,
    //data path
    input  wire     [CONV_OUT_NUM*DATA_WIDTH-1:0]               data_in         ,
    input  wire                                                 valid_in        ,
    output wire     [CONV_OUT_NUM*CONV_IN_NUM*DATA_WIDTH-1:0]   data_out        ,
    output wire                                                 valid_out       ,
    //control path
    input  wire     [ROW_BUFFER_DEPTH-1:0]                                     buff_len_ctrl   ,
    input  wire                                                     buff_len_rst    
);

    DWConvPreProcess # (
        .DATA_WIDTH(DATA_WIDTH ),
        .IN_CHANNEL_NUM(CONV_IN_NUM ),
        .OUT_CHANNEL_NUM(CONV_OUT_NUM ),
        .BUFF_LEN(BUFF_LEN ),
        .DEPTH (ROW_BUFFER_DEPTH )
      )
      DWConvPreProcess_inst (
        .clk (clk ),
        .rstn (rstn ),
        .data_in (data_in ),
        .valid_in (valid_in ),
        .win_reg (win_reg ),
        .valid_out (valid_out ),
        .buff_len_ctrl (buff_len_ctrl ),
        .buff_len_rst  ( buff_len_rst)
      );

      PWConvPreProcess # (
        .DATA_WIDTH    (DATA_WIDTH),
        .IN_CHANNEL    (CONV_IN_NUM),
        .OUT_CHANNEL   (CONV_OUT_NUM),
        .TOTAL_IN_WIDTH(DATA_WIDTH*CONV_IN_NUM),
        .TOTAL_PW_WIDTH(DATA_WIDTH*CONV_OUT_NUM)
      )
      PWConvPreProcess_inst (
        .clk (clk ),
        .rstn (rstn ),
        .data_in (data_in ),
        .data_out  ( data_out)
      );

endmodule