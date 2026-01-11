`timescale 1ns / 1ps

module down_counter
#(parameter WIDTH=8)
(
    input clk,
    input en,
    input rst,
    output reg [WIDTH-1:0] count
);
    always @(posedge clk) begin
        if (rst)
            count <= {WIDTH{1'b1}};  // start from max value (FF)
        else if (en)
            count <= count - 1;
    end
endmodule
