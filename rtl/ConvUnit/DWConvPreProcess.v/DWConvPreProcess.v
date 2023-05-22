`timescale 1ns / 1ps

module DWConvPreProcess # (
    parameter   DATA_WIDTH              =       8                           ,
    parameter   IN_CHANNEL_NUM          =       9                           ,
    parameter   OUT_CHANNEL_NUM         =       18                          ,
    parameter   BUFF_LEN                =       320-2                       ,
    parameter   DEPTH                   =       $clog2(BUFF_LEN)       
)
(           
    input   wire                                                    clk             ,
    input   wire                                                    rstn            ,
//data path
    input   wire    [OUT_CHANNEL_NUM*DATA_WIDTH-1:0]                data_in         ,
    input   wire                                                    valid_in        ,
    output  reg     [OUT_CHANNEL_NUM*IN_CHANNEL_NUM*DATA_WIDTH-1:0] win_reg         ,
    output  wire                                                    valid_out       ,
//control path
    input  wire     [DEPTH-1:0]                                     buff_len_ctrl   ,
    input  wire                                                     buff_len_rst    
);

    wire    [OUT_CHANNEL_NUM*DATA_WIDTH*3-1:0]      row_buf_out  ;

    DWRowBuf # (
      .DATA_WIDTH(DATA_WIDTH ),
      .IN_CHANNEL_NUM(IN_CHANNEL_NUM ),
      .OUT_CHANNEL_NUM(OUT_CHANNEL_NUM ),
      .BUFF_LEN(BUFF_LEN ),
      .DEPTH (DEPTH )
    )
    DWRowBuf_inst (
      .clk          (clk          ),
      .rstn         (rstn         ),
      .data_in      (data_in      ),
      .valid_in     (valid_in     ),
      .data_out     (row_buf_out  ),
      .buff_len_ctrl(buff_len_ctrl),
      .buff_len_rst (buff_len_rst )
    );

    DWConvWinGen # (
      .OUT_CHANNEL_NUM(OUT_CHANNEL_NUM ),
      .DATA_WIDTH(DATA_WIDTH ),
      .IN_CHANNEL_NUM (IN_CHANNEL_NUM )
    )
    DWConvWinGen_inst (
      .clk (clk ),
      .rstn (rstn ),
      .data_in (row_buf_out ),
      .valid_in (valid_in ),
      .win_reg (win_reg ),
      .vailid_out  ( vailid_out)
    );
  
endmodule