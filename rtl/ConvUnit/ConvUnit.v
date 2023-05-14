`timescale 1ns / 1ps

module ConvUnit # (
    parameter           MAC_IN_NUM              =   9                                    ,
    parameter           MAC_OUT_NUM             =   18                                   ,
    parameter           APM_COL_NUM             =   MAC_OUT_NUM / 2                      ,//9
    parameter           APM_ROW_NUM             =   MAC_IN_NUM                           ,//9
    parameter           DATA_WIDTH              =   8                                    ,
    parameter           WEIGHT_WIDTH            =   8                                    ,
    parameter           BIAS_WIDTH              =   16                                   ,
    parameter           MULT_PIPELINE_STAGE     =   2                                    
)
(
    input   wire                clk                                                         ,
    input   wire                rstn                                                        ,

//data path 
    input   wire    [MAC_IN_NUM*DATA_WIDTH-1:0]                 MAC_data_in                 ,
    input   wire                                                MAC_data_valid_in           ,

    input   wire    [MAC_IN_NUM*WEIGHT_WIDTH*MAC_OUT_NUM-1:0]   MAC_weight_in               ,
    input   wire                                                MAC_weight_valid_in         ,

    input   wire    [BIAS_WIDTH*MAC_OUT_NUM-1:0]                MAC_bias_in                 ,

    output  wire    [MAC_OUT_NUM*DATA_WIDTH-1:0]                MAC_data_out                ,
    output  wire                                                MAC_data_valid_out          ,
  
    
//control path 
    input   wire    [2:0]                                       current_state               ,
    output  wire                                                state_rst              
);

    wire                adder_rst    ;
    wire    [4-1:0]     MAC_scale_in ;

    NPUCore NPUCore_inst(
        .clk                    (clk                ),
        .rstn                   (rstn               ),
        .MAC_data_in            (MAC_data_in        ),
        .MAC_data_valid_in      (MAC_data_valid_in  ),
        .MAC_weight_in          (MAC_weight_in      ),
        .MAC_weight_valid_in    (MAC_weight_valid_in),
        .MAC_bias_in            (MAC_bias_in        ),
        .MAC_scale_in           (MAC_scale_in       ),
        .MAC_data_out           (MAC_data_out       ),
        .MAC_data_valid_out     (MAC_data_valid_out ),
        .adder_rst              (adder_rst          )            
    );


    ConvCtrl ConvCtrl_inst(
        .clk          (clk          ),
        .rstn         (rstn         ),
        .current_state(current_state),
        .state_end    (state_rst    ),
        .adder_rst    (adder_rst    ),
        .scale_in     (MAC_scale_in )
    );

endmodule