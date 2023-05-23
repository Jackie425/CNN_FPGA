`timescale 1ns / 1ps

module BiasMemoryTop # (
    parameter       BIAS_CHANNEL_WIDTH      =       288             ,
    parameter       RD_ADDR_DEPTH           =       9               
)
(
    input  wire             clk                                     ,//system clk 100M
    input  wire             rstn                                    ,

//data path
    output wire     [BIAS_CHANNEL_WIDTH-1:0]    BiasMem_data_out    ,
    output wire                                 BiasMem_valid_out   ,

//control path
    input  wire     [2:0]                       current_state       ,
    output wire                                 state_rst           ,
    //*************************************************
    input  wire    [RD_ADDR_DEPTH-1:0]          addr_rd             ,
    input  wire                                 bias_out_valid
//*************************************************
);

//control path inner
//*************************************************
/*
    wire    [RD_ADDR_DEPTH-1:0]         addr_rd;
    wire    [BIAS_CHANNEL_WIDTH-1:0]    data_rd;
    */
//*************************************************
//BiasDRM ROM IP Block 
   BiasDRM #(
        .BIAS_CHANNEL_WIDTH(BIAS_CHANNEL_WIDTH),
        .RD_ADDR_DEPTH     (RD_ADDR_DEPTH     )
   )
   BiasDRM_inst(
        .clk    (clk),
        .rstn   (rstn),
        .addr_rd(addr_rd),
        .data_rd(data_rd)
   );

//Weight Control Unit
   //*************************************************
   /*
    BiasCtrl #(
        .RD_ADDR_DEPTH(RD_ADDR_DEPTH)
    )
    BiasCtrl_inst(
        .clk              (clk),
        .rstn             (rstn),
        .current_state    (current_state),
        .state_rst        (state_rst),
        .BiasMem_valid_out(BiasMem_valid_out),
        .addr_rd          (addr_rd),
        .bias_out_valid   (bias_out_valid)
    );
*/
//*************************************************
//output mux
    assign BiasMem_data_out = bias_out_valid ? data_rd : 288'b0;


endmodule