`timescale 1ns / 1ps
// up_counter.v
module up_counter
#(parameter WIDTH = 8)
(
    input  wire                 clk,
    input  wire                 rst,    // active-high synchronous reset
    input  wire                 en,     // enable counting
    output reg  [WIDTH-1:0]     count
);

    always @(posedge clk) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (en)
            count <= count + 1'b1;
    end

endmodule
