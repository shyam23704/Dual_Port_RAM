`timescale 1ns / 1ps
// dpram.v
module dpram
#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 6
)
(
    input  wire [DATA_WIDTH-1:0] data,
    input  wire [ADDR_WIDTH-1:0] read_addr,
    input  wire [ADDR_WIDTH-1:0] write_addr,
    input  wire                 we,
    input  wire                 read_clock,
    input  wire                 write_clock,
    input  wire                 rst,      // Active-high reset
    output reg  [DATA_WIDTH-1:0] q
);

    // Force BRAM inference
    (* ram_style = "block" *) reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];

    integer i;
    initial begin
        // initialize to zeros for simulation clarity
        for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1)
            ram[i] = {DATA_WIDTH{1'b0}};
    end

    // Write port (synchronous to write_clock)
    always @(posedge write_clock) begin
    if (rst)
        ; // do nothing on reset
    else if (we)
        ram[write_addr] <= data;
    end


    // Read port (synchronous to read_clock)
    always @(posedge read_clock) begin
        if (rst)
            q <= {DATA_WIDTH{1'b0}};  // Clear output on reset
        else
            q <= ram[read_addr];
    end

endmodule
