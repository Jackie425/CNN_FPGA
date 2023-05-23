`timescale 1ns / 1ps

module FeatureMapMemoryTop # (
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
    //data path
    input   wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]       Conv_wr_data    ,
    input   wire                                        Conv_wr_valid   ,
    input   wire    [DDR_WIDTH-1:0]                     DDR_wr_data     ,
    input   wire                                        DDR_wr_valid    ,
    output  wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]       Conv_rd_data    ,
    input  wire                                         Conv_rd_valid   , 
    output  wire    [DDR_WIDTH-1:0]                     DDR_rd_data     ,
    output  wire                                        DDR_rd_valid    , 
    //control path
    input   wire    [2:0]                               current_state   ,
    output  wire                                        state_rst       ,

//********************************************************
    input   wire    [FM_MEM_DEPTH-1:0]                  wr_addr         ,
    input   wire    [FM_MEM_DEPTH-1:0]                  rd_addr         ,
    input   wire                                        fm_DDR_wr              
    //********************************************************
);
//********************************************************
   //wire    [FM_MEM_DEPTH-1:0]                  wr_addr     ;
   //wire    [FM_MEM_DEPTH-1:0]                  rd_addr     ;
//********************************************************
    wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]       DDR_converter_data;
    wire                                        DDR_converter_valid;
    wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]       wr_data;
    wire                                        wr_en;

    DRM_W144_D13 DRM_W144_D13_inst (
        .wr_data(wr_data),        // input [143:0]
        .wr_addr(wr_addr),        // input [12:0]
        .wr_en(wr_en),            // input
        .wr_clk(calc_clk),          // input
        .wr_clk_en(1'b1),    // input
        .wr_rst(~rstn),          // input
        .rd_addr(rd_addr),        // input [12:0]
        .rd_data(Conv_rd_data),        // output [143:0]
        .rd_clk(calc_clk),          // input
        .rd_clk_en(1'b1),    // input
        .rd_rst(~rstn)           // input
    );

    FeatureMapInWidthConverter # (
      .WIDTH_IN(256),
      .WIDTH_CONVERT(288),
      .WIDTH_OUT(144),
      .NUM_IN(9),
      .NUM_OUT(8)
    )
    FeatureMapInWidthConverter_inst (
      .sys_clk  (sys_clk),
      .calc_clk (calc_clk),
      .rstn     (rstn),
      .data_in  (DDR_wr_data),
      .valid_in (DDR_wr_valid),
      .data_out (DDR_converter_data),
      .valid_out(DDR_converter_valid)
    );
    FeatureMapOutWidthConverter # (
      .WIDTH_IN(144),
      .WIDTH_OUT(256),
      .NUM_IN(16),
      .NUM_OUT(9)
    )
    FeatureMapOutWidthConverter_inst (
      .sys_clk  (sys_clk  ),
      .calc_clk (calc_clk ),
      .rstn     (rstn     ),
      .data_in  (Conv_rd_data),
      .valid_in (Conv_rd_valid),
      .data_out (DDR_rd_data),
      .valid_out(DDR_rd_valid)
    );
  
    //FeatureMapMemory write MUX
    assign wr_data = fm_DDR_wr ? DDR_converter_data : Conv_wr_data;
    assign wr_en = DDR_converter_valid | Conv_wr_valid;




//********************************************************
    /*
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
    */
//********************************************************
endmodule