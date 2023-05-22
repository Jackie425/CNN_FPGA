`timescale 1ns / 1ps

module ConvUnit # (
    parameter           CONV_IN_NUM              =   9                                    ,
    parameter           CONV_OUT_NUM             =   18                                   ,
    parameter           APM_COL_NUM             =   Conv_OUT_NUM / 2                      ,//9
    parameter           APM_ROW_NUM             =   Conv_IN_NUM                           ,//9
    parameter           DATA_WIDTH              =   8                                    ,
    parameter           WEIGHT_WIDTH            =   8                                    ,
    parameter           BIAS_WIDTH              =   16                                   ,
    parameter           MULT_PIPELINE_STAGE     =   2                                    ,
    parameter           ROW_BUFFER_DEPTH        =   9                                    ,
    parameter           BUFF_LEN                =   320-2
)
(
    input   wire                clk                                                         ,
    input   wire                rstn                                                        ,

//data path 
    input   wire    [CONV_IN_NUM*DATA_WIDTH-1:0]                Conv_data_in                 ,
    input   wire                                                Conv_data_valid_in           ,

    input   wire    [CONV_IN_NUM*WEIGHT_WIDTH*CONV_OUT_NUM-1:0] Conv_weight_in               ,
    input   wire                                                Conv_weight_valid_in         ,

    input   wire    [BIAS_WIDTH*CONV_OUT_NUM-1:0]               Conv_bias_in                 ,
    input   wire                                                Conv_bias_valid_in            ,

    output  wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]               Conv_data_out                ,
    output  wire                                                Conv_data_valid_out          ,
  
    
//control path 
    input   wire    [2:0]                                       current_state               ,
    output  wire                                                state_rst                   
);

    wire                            adder_rst     ;
    wire    [4-1:0]                 Conv_scale_in  ;
    wire    [ROW_BUFFER_DEPTH-1:0]  buff_len_ctrl ;
    wire                            buff_len_rst  ;

    NPUCore # (
        .NPU_IN_NUM         (CONV_IN_NUM         ),
        .NPU_OUT_NUM        (CONV_OUT_NUM        ),
        .APM_COL_NUM        (APM_COL_NUM        ),
        .APM_ROW_NUM        (APM_ROW_NUM        ),
        .DATA_WIDTH         (DATA_WIDTH         ),
        .WEIGHT_WIDTH       (WEIGHT_WIDTH       ),
        .BIAS_WIDTH         (BIAS_WIDTH         ),
        .MULT_PIPELINE_STAGE(MULT_PIPELINE_STAGE)
    )
    NPUCore_inst(
        .clk                    (clk                ),
        .rstn                   (rstn               ),
        .NPU_data_in            (Conv_data_in        ),
        .NPU_data_valid_in      (Conv_data_valid_in  ),
        .NPU_weight_in          (Conv_weight_in      ),
        .NPU_weight_valid_in    (Conv_weight_valid_in),
        .NPU_bias_in            (Conv_bias_in        ),
        .NPU_bias_valid_in      (Conv_bias_valid_in  ),
        .NPU_scale_in           (Conv_scale_in       ),
        .NPU_data_out           (Conv_data_out       ),
        .NPU_data_valid_out     (Conv_data_valid_out ),
        .adder_rst              (adder_rst          )            
    );
    
    ConvCtrl # (
        .CONV_IN_NUM         (CONV_IN_NUM         ),
        .CONV_OUT_NUM        (CONV_OUT_NUM        ),
        .APM_COL_NUM        (APM_COL_NUM        ),
        .APM_ROW_NUM        (APM_ROW_NUM        ),
        .DATA_WIDTH         (DATA_WIDTH         ),
        .WEIGHT_WIDTH       (WEIGHT_WIDTH       ),
        .BIAS_WIDTH         (BIAS_WIDTH         ),
        .MULT_PIPELINE_STAGE(MULT_PIPELINE_STAGE),
        .ROW_BUFFER_DEPTH   (ROW_BUFFER_DEPTH)
    )
    ConvCtrl_inst(
        .clk          (clk          ),
        .rstn         (rstn         ),
        .current_state(current_state),
        .state_rst    (state_rst    ),
        .adder_rst    (adder_rst    ),
        .scale_in     (Conv_scale_in ),
        .buff_len_ctrl(buff_len_ctrl),
        .buff_len_rst (buff_len_rst )
    );

    DWConvPreProcess # (
      .DATA_WIDTH(DATA_WIDTH ),
      .IN_CHANNEL_NUM(CONV_IN_NUM ),
      .OUT_CHANNEL_NUM(CONV_OUT_NUM ),
      .BUFF_LEN(BUFF_LEN ),
      .DEPTH (ROW_BUFFER_DEPTH )
    )
    DWConvPreProcess_dut (
      .clk (clk ),
      .rstn (rstn ),
      .data_in (data_in ),
      .valid_in (valid_in ),
      .win_reg (win_reg ),
      .valid_out (valid_out ),
      .buff_len_ctrl (buff_len_ctrl ),
      .buff_len_rst  ( buff_len_rst)
    );
  
endmodule