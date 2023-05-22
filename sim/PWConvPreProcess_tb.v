`timescale 1ns / 1ps

module PWConvPreProcess_tb();

reg             clk;
reg             rstn;
reg     [143:0] data_in;

wire    [71:0] data_out;

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

PWConvPreProcess PWConvPreProcess_dut (
    .clk (clk ),
    .rstn (rstn ),
    .data_in (data_in ),
    .data_out  ( data_out)
  );

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        data_in <= 144'b1;
    end else begin
        data_in <= data_in + 1'b1;
    end
        
end
endmodule
