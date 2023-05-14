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
    input   wire                clk                         ,
    input   wire                rstn                        ,
//state_top
    input   wire    [2:0]       current_state               ,
    output  wire                state_rst                   , 
//control_signal_inner     
    output  wire                adder_rst                   ,
    output  wire    [3:0]       scale_in                    
);
    
endmodule