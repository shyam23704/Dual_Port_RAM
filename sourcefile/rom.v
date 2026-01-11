module rom(
    input  [7:0] addr,
    output [7:0] data
);
    reg [7:0] mem [0:255];
    initial $readmemh("rom_data.mem", mem);
    assign data = mem[addr];
endmodule
