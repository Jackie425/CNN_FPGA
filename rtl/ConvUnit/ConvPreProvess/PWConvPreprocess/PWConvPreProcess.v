`timescale 1ns / 1ps

module PWConvPreProcess # (
    parameter       DATA_WIDTH      =   8                           ,
    parameter       IN_CHANNEL      =   9                           ,
    parameter       OUT_CHANNEL     =   18                          ,
    parameter       TOTAL_IN_WIDTH  =   DATA_WIDTH * OUT_CHANNEL    ,
    parameter       TOTAL_PW_WIDTH  =   DATA_WIDTH * IN_CHANNEL
)
(
    input  wire                                 clk             ,
    input  wire                                 rstn            ,
    input  wire     [TOTAL_IN_WIDTH-1:0]        data_in         ,
    output reg      [TOTAL_PW_WIDTH-1:0]        data_out
);

    reg                     cnt ;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt <= 1'b0;
        end else begin
            cnt <= ~cnt;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data_out <= data_in[71:0];
        end else if(cnt == 1'b0) begin
            data_out <= data_in[71:0];
        end else begin
            data_out <= data_in[143:72];
        end
    end

endmodule