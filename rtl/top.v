`timescale 1ns / 1ps

module top (
    input   wire                        clk                 ,
    input   wire                        rstn                ,
//control path in   
    input   wire    [255:0]             DDR_data_in         ,
    input   wire                        DDR_valid_in        ,
    input   wire    [143:0]             Conv_data_in         ,
    input   wire                        Conv_data_valid_in   ,

    output  wire    [143:0]             Conv_data_out        ,
    output  wire                        Conv_data_valid_out 

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
        .state_rst    (state_rst    ),
        .current_state(current_state)
    );

    ConvUnit # (
        .CONV_IN_NUM         (9  ),
        .CONV_OUT_NUM        (18 ),
        .APM_COL_NUM        (9  ),
        .APM_ROW_NUM        (9  ),
        .DATA_WIDTH         (8  ),
        .WEIGHT_WIDTH       (8  ),
        .BIAS_WIDTH         (16 ),
        .MULT_PIPELINE_STAGE(2  )
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
        .state_rst          (state_rst          )
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
        .state_rst        (state_rst    )
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
        .state_rst          (state_rst      )
    );

    DRM_W144_D13 FeatureMapMem_inst (
        .wr_data(Conv_data_out),        // input [143:0]
        .wr_addr(wr_addr),        // input [12:0]
        .wr_en(Conv_data_valid_out),            // input
        .wr_clk(clk),          // input
        .wr_clk_en(1'b1),    // input
        .wr_rst(~rstn),          // input
        .rd_addr(rd_addr),        // input [12:0]
        .rd_data(Conv_data_in),        // output [143:0]
        .rd_clk(clk),          // input
        .rd_clk_en(1'b1),    // input
        .rd_rst(~rstn)           // input
    );
endmodule