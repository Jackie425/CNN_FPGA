`timescale 1ns / 1ps

module ReLU(
    input       [15:0]      A  ,
    output      [15:0]      B   
);

    assign B = A[15] == 1'b0 ? A : 16'b0;

endmodule