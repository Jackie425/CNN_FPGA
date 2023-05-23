`timescale 1ns / 1ps

module WeightMemoryTop # (
    parameter       DDR_RD_WIDTH            =   256             ,
    parameter       DRM_IN_WIDTH            =   324             ,
    parameter       WEIGHT_CHANNEL_WIDTH    =   1296            ,
    parameter       WR_ADDR_DEPTH           =   10              ,
    parameter       RD_ADDR_DEPTH           =   8               ,
    parameter       DRM_NUM                 =   9               
)
(
    input   wire             sys_clk                                 ,//system clk 100M
    input   wire             calc_clk                                ,//MAC clk 200M(100M)
    input   wire             rstn                                    ,
//data path
    input   wire     [DDR_RD_WIDTH-1:0]          DDR_data_in         ,
    input   wire                                 DDR_valid_in        ,

    output  wire     [WEIGHT_CHANNEL_WIDTH-1:0]  WeightMem_data_out  ,
    output  wire                                 WeightMem_valid_out ,

//control path
    input   wire     [2:0]                       current_state       ,
    output  wire                                 state_rst           ,
    //********************************************************
    input   wire    [WR_ADDR_DEPTH-1:0]     addr_wr                     ,
    input   wire    [RD_ADDR_DEPTH-1:0]     addr_rd                     ,
    input   wire                            cvt_rstn    
    //********************************************************
);

//data path inner 
    wire    [DRM_IN_WIDTH-1:0]      DRM_data_in;
    wire                            DRM_valid_in;
//control path inner
    //********************************************************
    //wire    [WR_ADDR_DEPTH-1:0]     addr_wr     ;
    //wire    [RD_ADDR_DEPTH-1:0]     addr_rd     ;
    //wire                            cvt_rstn    ;
    //********************************************************
//Width Converter from DDR_RD_256 to DRM_WR_324
    WeightWidthConverter # (
        .WIDTH_IN (DDR_RD_WIDTH),
        .WIDTH_OUT(DRM_IN_WIDTH),
        .NUM_IN   (81),
        .NUM_OUT  (64)
    )
    WeightWidthConverter_inst(
        .clk      (sys_clk),
        .rstn     (cvt_rstn&rstn),
        .data_in  (DDR_data_in),
        .valid_in (DDR_valid_in),
        .data_out (DRM_data_in),
        .valid_out(DRM_valid_in)
    );
//WeightDRM Block 
    WeightDRM # (
        .DATA_IN_WIDTH (DRM_IN_WIDTH),
        .DATA_OUT_WIDTH(WEIGHT_CHANNEL_WIDTH),
        .DRM_NUM       (DRM_NUM),
        .WR_ADDR_DEPTH (WR_ADDR_DEPTH),
        .RD_ADDR_DEPTH (RD_ADDR_DEPTH)
    )
    WeightDRM_inst(
        .wr_clk            (sys_clk),
        .rd_clk            (calc_clk),
        .rstn              (rstn),
        .WeightDRM_data_wr (DRM_data_in),
        .WeightDRM_valid_wr(DRM_valid_in),
        .WeightDRM_addr_wr (addr_wr),
        .WeightDRM_data_rd (WeightMem_data_out),
        .WeightDRM_addr_rd (addr_rd)
    );
//Weight Control Unit
    //*******************************************
    /*
    WeightCtrl #(
        .WR_ADDR_DEPTH(WR_ADDR_DEPTH),
        .RD_ADDR_DEPTH(RD_ADDR_DEPTH)
    )
    WeightCtrl_inst(
        .clk          (sys_clk),
        .rstn         (rstn),
        .current_state(current_state),
        .state_rst    (state_rst),
        .WeightDRM_valid_rd(WeightMem_valid_out),
        .cvt_rstn     (cvt_rstn),
        .addr_wr      (addr_wr),
        .addr_rd      (addr_rd)
    );
    */
    //*******************************************
endmodule