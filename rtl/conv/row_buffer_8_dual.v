`timescale 1ns / 1ps

module row_buffer_8_dual # (
    parameter BUFF_LEN = 320-2,
    parameter DEPTH    = 1024
)
(
    input   wire            clk     ,
    input   wire            rstn    ,
    input   wire    [7:0]   din_0   ,
    input   wire    [7:0]   din_1   ,
    output  wire    [7:0]   dout_0  ,
    output  wire    [7:0]   dout_1
);

    reg     [9:0]   addr_in;
    reg     [9:0]   addr_out;
    always@(posedge clk or negedge rstn)
    begin
        if(!rstn)
        begin
            addr_in  <= BUFF_LEN - 1;
            addr_out <= 0;
        end
        else if(addr_in == DEPTH - 1)
        begin
            addr_in  <= 0;
            addr_out <= addr_out + 1;
        end
        else if(addr_out == DEPTH - 1)
        begin
            addr_in  <= addr_in + 1;
            addr_out <= 0;
        end
        else
        begin
            addr_in  <= addr_in  + 1;
            addr_out <= addr_out + 1;
        end
    end
    
    //no output reg, 16bits 1024 depth
    shift_mem_8_dual shift_mem_inst(
        .clka(clk),
        .addra(addr_in),
        .dina({din_0,din_1}),
        .wea(1'b1),
        .clkb(clk),
        .addrb(addr_out),
        .doutb({dout_0,dout_1})
    );

endmodule