`timescale 1ns / 1ps

module row_buffer_8_dual # (
    parameter BUFF_LEN = 320-2,
    parameter DEPTH    = 512
)
(
    input   wire            clk             ,
    input   wire            rstn            ,
    //buff_len reg
    input   wire    [8:0]   buff_len_ctrl   ,//320 80 40 20 10
    input   wire            buff_len_rst    ,
    //data path
    input   wire    [7:0]   din_0           ,
    input   wire    [7:0]   din_1           ,
    output  wire    [7:0]   dout_0          ,
    output  wire    [7:0]   dout_1          

);

    reg     [8:0]   addr_in;
    reg     [8:0]   addr_out;
    
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            addr_in  <= 9'd320 - 2 - 1;
            addr_out <= 0;
        end else if(buff_len_rst) begin
            addr_in  <= buff_len_ctrl - 1;
            addr_out <= 0;
        end else if(addr_in == DEPTH - 1) begin
            addr_in  <= 0;
            addr_out <= addr_out + 1;
        end else if(addr_out == DEPTH - 1) begin
            addr_in  <= addr_in + 1;
            addr_out <= 0;
        end else begin
            addr_in  <= addr_in  + 1;
            addr_out <= addr_out + 1;
        end
    end
    

    shift_mem_8_dual shift_mem_inst (
        .wr_data({din_0,din_1}),        // input [15:0]
        .wr_addr(addr_in),        // input [8:0]
        .wr_en(wr_en),            // input
        .wr_clk(clk),          // input
        .wr_clk_en(1'b1),    // input
        .wr_rst(~rstn),          // input
        .rd_addr(addr_out),        // input [8:0]
        .rd_data({dout_0,dout_1}),        // output [15:0]
        .rd_clk(clk),          // input
        .rd_clk_en(1'b1),    // input
        .rd_rst(~rstn)           // input
    );

endmodule