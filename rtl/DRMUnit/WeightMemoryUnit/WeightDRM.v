`timescale 1ns / 1ps

module WeightDRM #(
    parameter   DATA_IN_WIDTH               =   324                 ,
    parameter   DATA_OUT_WIDTH              =   1296                ,
    parameter   DRM_NUM                     =   9                   ,
    parameter   WR_ADDR_DEPTH               =   10                  ,
    parameter   RD_ADDR_DEPTH               =   8      
)
(
    input   wire    wr_clk                                      ,
    input   wire    rd_clk                                      ,
    input   wire    rstn                                        ,
//channel in
    input   wire    [DATA_IN_WIDTH-1:0]     WeightDRM_data_wr   ,
    input   wire                            WeightDRM_valid_wr  ,
    input   wire    [WR_ADDR_DEPTH-1:0]     WeightDRM_addr_wr   ,
//channel out
    output  wire    [DATA_OUT_WIDTH-1:0]    WeightDRM_data_rd   ,
    output  wire    [RD_ADDR_DEPTH-1:0]     WeightDRM_addr_rd

);

generate
    genvar i;
    for(i = 0 ; i < DRM_NUM ; i = i + 1) begin:WeightDRMArray
        DRM_WR36_RD144 DRM_WR36_RD144_inst (
            .wr_data(WeightDRM_data_wr[(i*36)+:36]),        // input [35:0]
            .wr_addr(WeightDRM_addr_wr),        // input [9:0]
            .wr_en(WeightDRM_valid_wr),            // input
            .wr_clk(wr_clk),          // input
            .wr_clk_en(1'b1),    // input
            .wr_rst(~rstn),          // input
            .rd_addr(WeightDRM_addr_rd),        // input [7:0]
            .rd_data(WeightDRM_data_rd[(i*144)+:144]),        // output [143:0]
            .rd_clk(rd_clk),          // input
            .rd_clk_en(1'b1),    // input
            .rd_rst(~rstn)           // input
        );
    end
endgenerate


endmodule