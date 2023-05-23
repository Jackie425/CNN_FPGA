`timescale 1ns / 1ps

module ConvUnit # (
    parameter           CONV_IN_NUM              =   9                                    ,
    parameter           CONV_OUT_NUM             =   18                                   ,
    parameter           APM_COL_NUM             =   CONV_OUT_NUM / 2                      ,//9
    parameter           APM_ROW_NUM             =   CONV_IN_NUM                           ,//9
    parameter           DATA_WIDTH              =   8                                    ,
    parameter           WEIGHT_WIDTH            =   8                                    ,
    parameter           BIAS_WIDTH              =   16                                   ,
    parameter           ROW_BUFFER_DEPTH        =   9                                    ,
    parameter           BUFF_LEN                =   320-2
)
(
    input   wire                clk                                                         ,
    input   wire                rstn                                                        ,

//data path 
    input   wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]               Conv_data_in                 ,
    input   wire                                                Conv_data_valid_in           ,

    input   wire    [CONV_IN_NUM*WEIGHT_WIDTH*CONV_OUT_NUM-1:0] Conv_weight_in               ,
    input   wire                                                Conv_weight_valid_in         ,

    input   wire    [BIAS_WIDTH*CONV_OUT_NUM-1:0]               Conv_bias_in                 ,
    input   wire                                                Conv_bias_valid_in            ,

    output  wire    [CONV_OUT_NUM*DATA_WIDTH-1:0]               Conv_data_out                ,
    output  wire                                                Conv_data_valid_out          ,
  
    
//control path 
    input   wire    [2:0]                                       current_state               ,
    output  wire                                                state_rst                   ,
//********************************************************
    input   wire                                                adder_rst                   ,
    input   wire    [4-1:0]                                     Conv_scale_in               ,
    input   wire    [ROW_BUFFER_DEPTH-1:0]                      buff_len_ctrl               ,
    input   wire                                                buff_len_rst                ,
    input   wire                                                PW_mode  
    //********************************************************    
);
    //control path inner
//********************************************************
    //wire                                                adder_rst           ;
    //wire    [4-1:0]                                     Conv_scale_in       ;
    //wire    [ROW_BUFFER_DEPTH-1:0]                      buff_len_ctrl       ;
    //wire                                                buff_len_rst        ;
    //wire                                                PW_mode 
//********************************************************            ;
    //data path inner
    wire    [CONV_OUT_NUM*CONV_IN_NUM*DATA_WIDTH-1:0]   NPU_data_in         ; 
    wire                                                NPU_data_valid_in   ;  

    NPUCore # (
        .NPU_IN_NUM         (9         ),
        .NPU_OUT_NUM        (18        ),
        .DATA_WIDTH         (8         ),
        .WEIGHT_WIDTH       (8       ),
        .BIAS_WIDTH         (16         )
    )
    NPUCore_inst(
        .clk                    (clk                ),
        .rstn                   (rstn               ),
        .NPU_data_in            (NPU_data_in        ),
        .NPU_data_valid_in      (NPU_data_valid_in  ),
        .NPU_weight_in          (Conv_weight_in      ),
        .NPU_weight_valid_in    (Conv_weight_valid_in),
        .NPU_bias_in            (Conv_bias_in        ),
        .NPU_bias_valid_in      (Conv_bias_valid_in  ),
        .NPU_scale_in           (Conv_scale_in       ),
        .NPU_data_out           (Conv_data_out       ),
        .NPU_data_valid_out     (Conv_data_valid_out ),
        .adder_rst              (adder_rst          )            
    );
    //********************************************************
    /*
    ConvCtrl # (
        .CONV_IN_NUM        (CONV_IN_NUM         ),
        .CONV_OUT_NUM       (CONV_OUT_NUM        ),
        .APM_COL_NUM        (APM_COL_NUM        ),
        .APM_ROW_NUM        (APM_ROW_NUM        ),
        .DATA_WIDTH         (DATA_WIDTH         ),
        .WEIGHT_WIDTH       (WEIGHT_WIDTH       ),
        .BIAS_WIDTH         (BIAS_WIDTH         ),
        .ROW_BUFFER_DEPTH   (ROW_BUFFER_DEPTH)
    )
    ConvCtrl_inst(
        .clk          (clk          ),
        .rstn         (rstn         ),
        .current_state(current_state),
        .state_rst    (state_rst    ),
        .adder_rst    (adder_rst    ),
        .scale_in     (Conv_scale_in),
        .PW_mode      (PW_mode      ),
        .buff_len_ctrl(buff_len_ctrl),
        .buff_len_rst (buff_len_rst )
    );
*/
//********************************************************
    ConvPreProcess # (
      .CONV_IN_NUM(9),
      .CONV_OUT_NUM(18),
      .DATA_WIDTH(8),
      .WEIGHT_WIDTH(8),
      .BIAS_WIDTH(16)
    )
    ConvPreProcess_inst (
      .clk (clk ),
      .rstn (rstn ),
      .data_in (Conv_data_in ),
      .valid_in (Conv_data_valid_in ),
      .data_out (NPU_data_in ),
      .valid_out (NPU_data_valid_in ),
      .buff_len_ctrl (buff_len_ctrl ),
      .buff_len_rst (buff_len_rst ),
      .PW_mode (PW_mode )
    );
  

endmodule