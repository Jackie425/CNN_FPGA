`timescale 1ns / 1ps

module top (
    input   wire                        clk                 ,
    input   wire                        rstn                ,
//control path in   
    input   wire    [255:0]             DDR_data_in         ,
    input   wire                        DDR_valid_in        ,
    input   wire    [143:0]             MAC_data_in         ,
    input   wire                        MAC_data_valid_in   ,
    input   wire    [287:0]             MAC_bias_in         ,
    output  wire    [143:0]             MAC_data_out        ,
    output  wire                        MAC_data_valid_out 

);


    wire    [2:0]       current_state;
    wire                state_rst; 
    wire    [1295:0]    Weight_data;
    wire                Weight_valid;
    wire                MAC_bias_valid_in;

    StateMachine StateMachine_inst(
        .clk          (clk),
        .rstn         (rstn),
        .state_rst    (state_rst    ),
        .current_state(current_state)
    );

    ConvUnit # (
        .MAC_IN_NUM         (9  ),
        .MAC_OUT_NUM        (18 ),
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
        .MAC_data_in        (MAC_data_in        ),
        .MAC_data_valid_in  (MAC_data_valid_in  ),
        .MAC_weight_in      (Weight_data        ),
        .MAC_weight_valid_in(Weight_valid       ),
        .MAC_bias_in        (MAC_bias_in        ),
        .MAC_bias_valid_in  (MAC_bias_valid_in  ),
        .MAC_data_out       (MAC_data_out       ),
        .MAC_data_valid_out (MAC_data_valid_out ),
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
        .BiasMem_data_out (MAC_bias_in  ),
        .BiasMem_valid_out(MAC_bias_valid_in),
        .adder_rst        (adder_rst    ),
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
        .sys_clk            (clk),
        .calc_clk           (clk),
        .rstn               (rstn    ),
        .DDR_data_in        (DDR_data_in        ),
        .DDR_valid_in       (DDR_valid_in       ),
        .WeightMem_data_out (Weight_data),
        .WeightMem_valid_out(Weight_valid),
        .current_state      (current_state      ),
        .state_rst          (state_rst          )
    );
endmodule