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
    input  wire                                 adder_rst           ,
    input  wire     [2:0]                       current_state       ,
    output wire                                 state_rst           
);

//control path inner
    wire    [RD_ADDR_DEPTH-1:0]     addr_rd;
    
//BiasDRM ROM IP Block 
    DRM_ROM_W288_A512 DRM_ROM_W288_A512_inst (
        .addr(addr_rd),          // input [8:0]
        .clk(clk),            // input
        .clk_en(1'b1),      // input
        .rst(~rstn),            // input
        .rd_data(rd_data)     // output [287:0]
      );

//Weight Control Unit
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

//output mux
    assign BiasMem_data_out = bias_out_valid ? rd_data : 288'b0;

endmodule