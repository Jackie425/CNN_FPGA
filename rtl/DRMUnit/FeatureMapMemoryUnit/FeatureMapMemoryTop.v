`timescale 1ns / 1ps

module FeatureMapMemoryTop # (
    parameter           CONV_IN_NUM             =   9                                    ,
    parameter           CONV_OUT_NUM            =   18                                   ,
    parameter           DATA_WIDTH              =   8                                    ,
    parameter           WEIGHT_WIDTH            =   8                                    ,
    parameter           BIAS_WIDTH              =   16                                   ,
    parameter           FM_MEM_DEPTH            =   13  

)
(
    input   wire                                        clk       ,
    input   wire                                        rstn         ,
    //data path
    input   wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]       wr_data      ,
    output  wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]       rd_data      ,
    //control path
    input   wire    [2:0]                               current_state,
    output  wire                                        state_rst

);

    wire    [FM_MEM_DEPTH-1:0]                  wr_addr     ;
    wire    [FM_MEM_DEPTH-1:0]                  rd_addr     ;
    wire                                        wr_en       ;

    DRM_W144_D13 DRM_W144_D13_inst (
        .wr_data(wr_data),        // input [143:0]
        .wr_addr(wr_addr),        // input [12:0]
        .wr_en(wr_en),            // input
        .wr_clk(clk),          // input
        .wr_clk_en(1'b1),    // input
        .wr_rst(~rstn),          // input
        .rd_addr(rd_addr),        // input [12:0]
        .rd_data(rd_data),        // output [143:0]
        .rd_clk(clk),          // input
        .rd_clk_en(1'b1),    // input
        .rd_rst(~rstn)           // input
    );

    FeatureMapCtrl # (
      .WR_ADDR_DEPTH( 13 ),
      .RD_ADDR_DEPTH( 13 )
    )
    FeatureMapCtrl_inst (
      .clk (clk),
      .rstn (rst),
      .current_state (current_state),
      .state_rst (state_rst),
      .WeightDRM_valid_rd (WeightDRM_valid_rd),
      .wr_addr  (wr_addr),
      .rd_addr  (rd_addr),
      .wr_en(wr_en)
    );

endmodule