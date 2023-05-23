`timescale 1ns / 1ps

module top (
    input   wire                        clk                 ,
    input   wire                        rstn                ,
//control path in   
    input   wire    [255:0]                 DDR_data_in         ,
    input   wire                            DDR_valid_in        ,
    input   wire                            Conv_data_valid_in  ,
    output  wire    [143:0]                 Conv_data_out       ,
    output  wire                            Conv_data_valid_out ,
    //********************************************************
    input   wire                            adder_rst           ,
    input   wire    [4-1:0]                 Conv_scale_in       ,
    input   wire    [9-1:0]                 buff_len_ctrl       ,
    input   wire                            buff_len_rst        ,
    input   wire                            PW_mode             ,
    //********************************************************
    input   wire    [13-1:0]                fm_wr_addr          ,
    input   wire    [13-1:0]                fm_rd_addr          ,
    input   wire                            fm_wr_en            ,
    //********************************************************
    input   wire    [10-1:0]                wm_addr_wr          ,
    input   wire    [8-1:0]                 wm_addr_rd          ,
    input   wire                            wm_cvt_rstn         ,
    //********************************************************
    input   wire    [9-1:0]                 bm_addr_rd          ,
    input   wire                            bias_out_valid      ,
    //*********************************************************
    input   wire                            state_rst1
);


    wire    [2:0]       current_state;
    wire                state_rst; 
    wire    [1295:0]    Weight_data;
    wire                Weight_valid;
    wire    [287:0]     Bias_data;
    wire                Bias_valid;

    StateMachine StateMachine_inst(
        .clk          (clk),
        .rstn         (rstn),
        .state_rst    (state_rst1    ),
        .current_state(current_state)
    );

    ConvUnit # (
        .CONV_IN_NUM         (9  ),
        .CONV_OUT_NUM        (18 ),
        .APM_COL_NUM        (9  ),
        .APM_ROW_NUM        (9  ),
        .DATA_WIDTH         (8  ),
        .WEIGHT_WIDTH       (8  ),
        .BIAS_WIDTH         (16 )
    )
    ConvUnit_inst(
        .clk                (clk                ),
        .rstn               (rstn               ),
        .Conv_data_in        (Conv_data_in        ),
        .Conv_data_valid_in  (Conv_data_valid_in  ),
        .Conv_weight_in      (Weight_data        ),
        .Conv_weight_valid_in(Weight_valid       ),
        .Conv_bias_in        (Bias_data        ),
        .Conv_bias_valid_in  (Bias_valid  ),
        .Conv_data_out       (Conv_data_out       ),
        .Conv_data_valid_out (Conv_data_valid_out ),
        .current_state      (current_state      ),
        .state_rst          (state_rst          ),
        //********************************************************
        .adder_rst          (adder_rst    ),
        .Conv_scale_in      (Conv_scale_in),
        .buff_len_ctrl      (buff_len_ctrl),
        .buff_len_rst       (buff_len_rst ),
        .PW_mode            (PW_mode      )
        //********************************************************
    );

    BiasMemoryTop # (
        .BIAS_CHANNEL_WIDTH(288),
        .RD_ADDR_DEPTH     (9  )
    )
    BiasMemoryTop_inst(
        .clk              (clk          ),
        .rstn             (rstn         ),
        .BiasMem_data_out (Bias_data  ),
        .BiasMem_valid_out(Bias_valid),
        .current_state    (current_state),
        .state_rst        (state_rst    ),
        //********************************************************
        .addr_rd          (bm_addr_rd       ),
        .bias_out_valid   (bias_out_valid)
        //********************************************************
    );

    
    WeightMemoryTop # (
        .DDR_RD_WIDTH        (256 )         ,
        .DRM_IN_WIDTH        (324 )         ,
        .WEIGHT_CHANNEL_WIDTH(1296)         ,
        .WR_ADDR_DEPTH       (10  )         ,
        .RD_ADDR_DEPTH       (8   )         ,
        .DRM_NUM             (9   )         
    )
    WeightMemoryTop_inst(
        .sys_clk            (clk            ),
        .calc_clk           (clk            ),
        .rstn               (rstn           ),
        .DDR_data_in        (DDR_data_in    ),
        .DDR_valid_in       (DDR_valid_in   ),
        .WeightMem_data_out (Weight_data    ),
        .WeightMem_valid_out(Weight_valid   ), 
        .current_state      (current_state  ),
        .state_rst          (state_rst      ),
        //********************************************************
        .addr_wr            (wm_addr_wr        ),
        .addr_rd            (wm_addr_rd        ),
        .cvt_rstn           (wm_cvt_rstn       )
        //********************************************************
    );

    FeatureMapMemoryTop # (
      .CONV_IN_NUM(9),
      .CONV_OUT_NUM(18),
      .DATA_WIDTH(8),
      .WEIGHT_WIDTH(8),
      .BIAS_WIDTH(16),
      .FM_MEM_DEPTH(13)
    )
    FeatureMapMemoryTop_inst (
        .clk (clk),
        .rstn (rstn),
        .wr_data (Conv_data_out),
        .rd_data (Conv_data_in),
        .current_state (current_state),
        .state_rst    (state_rst),
        //********************************************************
        .wr_addr(fm_wr_addr),
        .rd_addr(fm_rd_addr),
        .wr_en  (fm_wr_en  )
        //********************************************************
    );
  

endmodule