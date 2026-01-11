`timescale 1ns / 1ps
// adder.v
module adder
#(parameter WIDTH = 8)
(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] sum
);

    assign sum = a + b;   // unsigned add, wraps on overflow

endmodule
