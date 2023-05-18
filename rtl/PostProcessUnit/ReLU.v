`timescale 1ns / 1ps

module ReLU(
    input       [7:0]      A  ,
    output      [7:0]      B   
);

    assign B = A[7] == 1'b0 ? A : 8'b0;

endmodule