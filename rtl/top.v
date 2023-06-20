`timescale 1ns / 1ps

module top #(
    parameter MEM_ROW_ADDR_WIDTH   = 15                 ,
	parameter MEM_COL_ADDR_WIDTH   = 10                 ,
	parameter MEM_BADDR_WIDTH      = 3                  ,
	parameter MEM_DQ_WIDTH         = 32                 ,
	parameter MEM_DQS_WIDTH        = MEM_DQ_WIDTH/8     ,//4
    parameter CTRL_ADDR_WIDTH      =   MEM_ROW_ADDR_WIDTH + MEM_BADDR_WIDTH + MEM_COL_ADDR_WIDTH//28
)
(
    input   wire                            clk                 ,
    input   wire                            rstn                ,
//DDR
    output                                  mem_rst_n                 ,
    output                                  mem_ck                    ,
    output                                  mem_ck_n                  ,
    output                                  mem_cke                   ,
    output                                  mem_cs_n                  ,
    output                                  mem_ras_n                 ,
    output                                  mem_cas_n                 ,
    output                                  mem_we_n                  ,
    output                                  mem_odt                   ,
    output      [MEM_ROW_ADDR_WIDTH-1:0]    mem_a                     ,
    output      [MEM_BADDR_WIDTH-1:0]       mem_ba                    ,
    inout       [MEM_DQ_WIDTH/8-1:0]        mem_dqs                   ,
    inout       [MEM_DQ_WIDTH/8-1:0]        mem_dqs_n                 ,
    inout       [MEM_DQ_WIDTH-1:0]          mem_dq                    ,//32
    output      [MEM_DQ_WIDTH/8-1:0]        mem_dm                    ,
    output reg                              heart_beat_led            ,
    output                                  ddr_init_done             ,
//control path in
    //********************************************************
    input   wire                            Conv_data_valid_in  ,
    input   wire                            adder_rst           ,
    input   wire    [4-1:0]                 Conv_scale_in       ,
    input   wire    [9-1:0]                 buff_len_ctrl       ,
    input   wire                            buff_len_rst        ,
    input   wire                            PW_mode             ,
    //********************************************************
    input   wire    [13-1:0]                fm_wr_addr          ,
    input   wire    [13-1:0]                fm_rd_addr          ,
    input   wire                            fm_DDR_wr           ,
    //********************************************************
    input   wire    [10-1:0]                wm_addr_wr          ,
    input   wire    [8-1:0]                 wm_addr_rd          ,
    input   wire                            wm_cvt_rstn         ,
    //********************************************************
    input   wire    [9-1:0]                 bm_addr_rd          ,
    input   wire                            bias_out_valid      ,
    //*********************************************************
    input   wire    [2:0]                   current_state       ,
    output  wire                            state_rst
);

//*****************************************
   // wire    [2:0]       current_state;
   // wire                state_rst; 
//*****************************************
    wire    [143:0]     Conv_data_in;
    wire    [1295:0]    Weight_data;
    wire                Weight_valid;
    wire    [287:0]     Bias_data;
    wire                Bias_valid;
    wire                sys_clk;
    wire    [143:0]     Conv_data_out       ;
    wire                Conv_data_valid_out ;
//********************************************************
    wire    [255:0]     DDR_data_in         ;
    wire                DDR_valid_in        ;
    wire    [255:0]     DDR_data_out        ;
    wire                DDR_valid_out       ;
//********************************************************
    //axi bus   
    wire [CTRL_ADDR_WIDTH-1:0]  axi_awaddr                 ;
    wire                        axi_awuser_ap              ;
    wire [3:0]                  axi_awuser_id              ;
    wire [3:0]                  axi_awlen                  ;
    wire                        axi_awready                ;/*synthesis PAP_MARK_DEBUG="1"*/
    wire                        axi_awvalid                ;/*synthesis PAP_MARK_DEBUG="1"*/
    wire [MEM_DQ_WIDTH*8-1:0]   axi_wdata                  ;
    wire [MEM_DQ_WIDTH*8/8-1:0] axi_wstrb                  ;
    wire                        axi_wready                 ;/*synthesis PAP_MARK_DEBUG="1"*/
    wire [3:0]                  axi_wusero_id              ;
    wire                        axi_wusero_last            ;
    wire [CTRL_ADDR_WIDTH-1:0]  axi_araddr                 ;
    wire                        axi_aruser_ap              ;
    wire [3:0]                  axi_aruser_id              ;
    wire [3:0]                  axi_arlen                  ;
    wire                        axi_arready                ;/*synthesis PAP_MARK_DEBUG="1"*/
    wire                        axi_arvalid                ;/*synthesis PAP_MARK_DEBUG="1"*/
    wire [MEM_DQ_WIDTH*8-1:0]   axi_rdata                   /* synthesis syn_keep = 1 */;
    wire                        axi_rvalid                  /* synthesis syn_keep = 1 */;
    wire [3:0]                  axi_rid                    ;
    wire                        axi_rlast                  ;
/////////////////////////////////////////////////////////////////////////////////////
    assign sys_clk = clk;
    PLL_CLK PLL_CLK_inst (
        .clkin1(clk),        // input
        .pll_lock(pll_lock),    // output
        .clkout0(calc_clk)       // output
    );
//*****************************************
/*
    StateMachine StateMachine_inst(
        .clk          (sys_clk),
        .rstn         (rstn),
        .state_rst    (state_rst    ),
        .current_state(current_state)
    );
*/
//*****************************************
    ConvUnit # (
        .CONV_IN_NUM        (9  ),
        .CONV_OUT_NUM       (18 ),
        .APM_COL_NUM        (9  ),
        .APM_ROW_NUM        (9  ),
        .DATA_WIDTH         (8  ),
        .WEIGHT_WIDTH       (8  ),
        .BIAS_WIDTH         (16 )
    )
    ConvUnit_inst(
        .clk                (calc_clk           ),
        .rstn               (rstn               ),
        .Conv_data_in        (Conv_data_in      ),
        .Conv_data_valid_in  (Conv_data_valid_in),
        .Conv_weight_in      (Weight_data       ),
        .Conv_weight_valid_in(Weight_valid      ),
        .Conv_bias_in        (Bias_data         ),
        .Conv_bias_valid_in  (Bias_valid        ),
        .Conv_data_out       (Conv_data_out     ),
        .Conv_data_valid_out (Conv_data_valid_out),
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
        .clk              (calc_clk          ),
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
        .sys_clk            (sys_clk            ),
        .calc_clk           (calc_clk            ),
        .rstn               (rstn           ),
        .DDR_data_in        (DDR_data_in    ),
        .DDR_valid_in       (DDR_valid_in   ),
        .WeightMem_data_out (Weight_data    ),
        .WeightMem_valid_out(Weight_valid   ),
        .current_state      (current_state  ),
        .state_rst          (state_rst      ),
        //********************************************************
        .addr_wr            (wm_addr_wr     ),
        .addr_rd            (wm_addr_rd     ),
        .cvt_rstn           (wm_cvt_rstn    )
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
        .sys_clk (sys_clk),
        .calc_clk(calc_clk),
        .rstn (rstn),
        .Conv_wr_data(Conv_data_out),
        .Conv_wr_valid(Conv_data_valid_out),
        .DDR_wr_data (DDR_data_in),
        .DDR_wr_valid(DDR_valid_in),
        .Conv_rd_data (Conv_data_in),
        .Conv_rd_valid(Conv_data_valid_in),
        .DDR_rd_data(DDR_data_out),
        .DDR_rd_valid(DDR_valid_out),
        .current_state (current_state),
        .state_rst    (state_rst),
        //********************************************************
        .wr_addr(fm_wr_addr),
        .rd_addr(fm_rd_addr),
        .fm_DDR_wr(fm_DDR_wr)
        //********************************************************
    );
  
//DDR    
    DDR3_50H u_DDR3_50H (
        .ref_clk                   (sys_clk            ),// input
        .resetn                    (rstn           ),// input
        .ddr_init_done             (ddr_init_done      ),// output
        .ddrphy_clkin              (core_clk           ),// output
        .pll_lock                  (pll_lock           ),// output

        .axi_awaddr                (axi_awaddr         ),// input [27:0]
        .axi_awuser_ap             (1'b0               ),// input
        .axi_awuser_id             (axi_awuser_id      ),// input [3:0]
        .axi_awlen                 (axi_awlen          ),// input [3:0]
        .axi_awready               (axi_awready        ),// output
        .axi_awvalid               (axi_awvalid        ),// input
        .axi_wdata                 (axi_wdata          ),
        .axi_wstrb                 (axi_wstrb          ),// input [31:0]
        .axi_wready                (axi_wready         ),// output
        .axi_wusero_id             (                   ),// output [3:0]
        .axi_wusero_last           (axi_wusero_last    ),// output
        .axi_araddr                (axi_araddr         ),// input [27:0]
        .axi_aruser_ap             (1'b0               ),// input
        .axi_aruser_id             (axi_aruser_id      ),// input [3:0]
        .axi_arlen                 (axi_arlen          ),// input [3:0]
        .axi_arready               (axi_arready        ),// output
        .axi_arvalid               (axi_arvalid        ),// input
        .axi_rdata                 (axi_rdata          ),// output [255:0]
        .axi_rid                   (axi_rid            ),// output [3:0]
        .axi_rlast                 (axi_rlast          ),// output
        .axi_rvalid                (axi_rvalid         ),// output

        .apb_clk                   (1'b0               ),// input
        .apb_rst_n                 (1'b1               ),// input
        .apb_sel                   (1'b0               ),// input
        .apb_enable                (1'b0               ),// input
        .apb_addr                  (8'b0               ),// input [7:0]
        .apb_write                 (1'b0               ),// input
        .apb_ready                 (                   ), // output
        .apb_wdata                 (16'b0              ),// input [15:0]
        .apb_rdata                 (                   ),// output [15:0]
        .apb_int                   (                   ),// output

        .mem_rst_n                 (mem_rst_n          ),// output
        .mem_ck                    (mem_ck             ),// output
        .mem_ck_n                  (mem_ck_n           ),// output
        .mem_cke                   (mem_cke            ),// output
        .mem_cs_n                  (mem_cs_n           ),// output
        .mem_ras_n                 (mem_ras_n          ),// output
        .mem_cas_n                 (mem_cas_n          ),// output
        .mem_we_n                  (mem_we_n           ),// output
        .mem_odt                   (mem_odt            ),// output
        .mem_a                     (mem_a              ),// output [14:0]
        .mem_ba                    (mem_ba             ),// output [2:0]
        .mem_dqs                   (mem_dqs            ),// inout [3:0]
        .mem_dqs_n                 (mem_dqs_n          ),// inout [3:0]
        .mem_dq                    (mem_dq             ),// inout [31:0]
        .mem_dm                    (mem_dm             ),// output [3:0]
        //debug
        .debug_data                (                   ),// output [135:0]
        .debug_slice_state         (                   ),// output [51:0]
        .debug_calib_ctrl          (                   ),// output [21:0]
        .ck_dly_set_bin            (                   ),// output [7:0]
        .force_ck_dly_en           (1'b0               ),// input
        .force_ck_dly_set_bin      (8'h05              ),// input [7:0]
        .dll_step                  (                   ),// output [7:0]
        .dll_lock                  (                   ),// output
        .init_read_clk_ctrl        (2'b0               ),// input [1:0]
        .init_slip_step            (4'b0               ),// input [3:0]
        .force_read_clk_ctrl       (1'b0               ),// input
        .ddrphy_gate_update_en     (1'b0               ),// input
        .update_com_val_err_flag   (                   ),// output [3:0]
        .rd_fake_stop              (1'b0               ) // input
  );

endmodule