`timescale 1ns / 1ps

module WeightMemoryUnit # (
    parameter       DDR_RD_WIDTH            =   256          ,
    parameter       WEIGHT_CHANNEL_WIDTH    =   1296
)
(
    input  wire             clk                                     ,
    input  wire             rstn                                    ,
//data path
    input  wire     [DDR_RD_WIDTH-1:0]          DDR_data_in         ,
    input  wire                                 DDR_valid_in        ,

    output wire     [WEIGHT_CHANNEL_WIDTH-1:0]  WeightMem_data_out  ,
    output wire                                 WeightMem_valid_out ,

//control path
    input  wire     [2:0]                       current_state       ,
    output wire                                 state_rst           
);

endmodule