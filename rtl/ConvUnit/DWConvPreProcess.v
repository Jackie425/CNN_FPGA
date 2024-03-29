`timescale 1ns / 1ps

module DWConvPreProcess # (
    parameter   DATA_WIDTH              =       8                           ,
    parameter   IN_CHANNEL_NUM          =       9                           ,
    parameter   OUT_CHANNEL_NUM         =       18                          ,
    parameter   BUFF_LEN                =       320-2                       ,
    parameter   ROW_BUFFER_DEPTH        =       $clog2(BUFF_LEN)       
)
(           
    input   wire                                                    clk             ,
    input   wire                                                    rstn            ,
//data path
    input   wire    [OUT_CHANNEL_NUM*DATA_WIDTH-1:0]                data_in         ,
    input   wire                                                    valid_in        ,
    output  wire    [OUT_CHANNEL_NUM*IN_CHANNEL_NUM*DATA_WIDTH-1:0] win_reg         ,
    output  wire                                                    valid_out       ,
//control path
    input  wire     [ROW_BUFFER_DEPTH-1:0]                          buff_len_ctrl   ,
    input  wire                                                     buff_len_rst    
);

    wire    [OUT_CHANNEL_NUM*DATA_WIDTH*3-1:0]      row_buff_out  ;
    wire      row_buff_valid_out;
    DWRowBuff # (
      .DATA_WIDTH(8 ),
      .IN_CHANNEL_NUM(9 ),
      .OUT_CHANNEL_NUM(18 ),
      .BUFF_LEN(320-2)
    )
    DWRowBuff_inst (
      .clk          (clk          ),
      .rstn         (rstn         ),
      .data_in      (data_in      ),
      .valid_in     (valid_in     ),
      .data_out     (row_buff_out ),
      .valid_out    (row_buff_valid_out), 
      .buff_len_ctrl(buff_len_ctrl),
      .buff_len_rst (buff_len_rst )
    );

    DWConvWinGen # (
      .OUT_CHANNEL_NUM(18),
      .DATA_WIDTH(8),
      .IN_CHANNEL_NUM (9)
    )
    DWConvWinGen_inst (
      .clk (clk ),
      .rstn (rstn ),
      .data_in (row_buff_out ),
      .valid_in (row_buff_valid_out),
      .win_reg (win_reg ),
      .valid_out  (valid_out)
    );


endmodule