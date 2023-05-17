`timescale 1ns / 1ps

module WidthConverterTestbench();

reg             clk;
reg             rstn;
reg     [255:0] data_in;
reg             valid_in;

wire    [323:0] data_out;
wire            valid_out;

reg             i;

GTP_GRS GRS_INST (
    .GRS_N(1'b1)
  );

initial begin
    rstn = 1'b0;
    #200;
    rstn = 1'b1;
end

always begin
    clk <= 1'b1;
    #10;
    clk <= 1'b0;
    #10;
end

WidthConverter dut(
    .clk      (clk),
    .rstn     (rstn),
    .data_in  (data_in),
    .valid_in (valid_in),
    .data_out (data_out),
    .valid_out(valid_out)
);

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        data_in <= 256'b0;
        valid_in <= 1'b0;
        i <= 1'b0;
    end else if(i)begin
        data_in <= data_in;
        valid_in <= 1'b0;
        i <= 1'b0;
    end else begin
        data_in <= data_in + 1'b1;
        valid_in <= 1'b1;
        i <= 1'b1;
    end
        
end
endmodule