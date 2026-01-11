`timescale 1ns / 1ps

//==============================================================================
// Top-level Memory System Module
//
// This module implements a memory system consisting of:
// - Up counter generating ROM addresses (0 to 255)
// - Down counter generating RAM read addresses (255 down to 0)
// - ROM (256 x 8) storing initial data
// - Dual-port RAM (64 x 8) for data storage
// - Adder combining ROM and RAM outputs
//
// Data Flow:
// 1. Up counter addresses ROM, data is read from ROM
// 2. ROM data is written to RAM at address (up_addr % 64)
// 3. Down counter reads from RAM at address (down_addr % 64)  
// 4. Adder combines current ROM output with RAM output
//==============================================================================

module top (
    input  wire        clk,           // System clock
    input  wire        rst,           // Active-high synchronous reset
    input  wire        en,            // Enable for both counters
    
    // Debug/Monitor outputs
    output wire [7:0]  up_addr,       // Up counter output (ROM address)
    output wire [7:0]  down_addr,     // Down counter output 
    output wire [7:0]  rom_out,       // ROM data output
    output wire [7:0]  ram_out,       // RAM data output
    output wire [7:0]  sum_out        // Adder output (ROM + RAM)
);

    //==========================================================================
    // Internal Signals
    //==========================================================================
    
    // RAM address signals
    wire [5:0] ram_wr_addr;           // RAM write address (6-bit)
    wire [5:0] ram_rd_addr;           // RAM read address (6-bit)
    
    // Pipeline registers for better timing
    reg  [7:0] rom_out_reg;           // Registered ROM output
    reg  [7:0] ram_out_reg;           // Registered RAM output for adder
    reg        we_reg;                // Registered write enable
    
    //==========================================================================
    // Address Counters
    //==========================================================================
    
    // Up Counter: Generates ROM addresses (0 → 255 → 0...)
    up_counter #(
        .WIDTH(8)
    ) u_up_counter (
        .clk    (clk),
        .rst    (rst),
        .en     (en),
        .count  (up_addr)
    );

    // Down Counter: Generates RAM read addresses (255 → 0 → 255...)
    down_counter #(
        .WIDTH(8)
    ) u_down_counter (
        .clk    (clk),
        .rst    (rst), 
        .en     (en),
        .count  (down_addr)
    );

    //==========================================================================
    // Memory Blocks
    //==========================================================================
    
    // ROM: 256 x 8 bit memory with preloaded data
    rom u_rom (
        .addr   (up_addr),
        .data   (rom_out)
    );

    // Dual-Port RAM: 64 x 8 bit memory
    // Write port: Stores ROM data at (up_addr % 64)
    // Read port: Reads data at (down_addr % 64)
    assign ram_wr_addr = up_addr[5:0];    // Use lower 6 bits for 64-entry RAM
    assign ram_rd_addr = down_addr[5:0];  // Use lower 6 bits for 64-entry RAM
    
    dpram #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(6)
    ) u_dpram (
        .data        (rom_out_reg),       // Write ROM data (registered)
        .read_addr   (ram_rd_addr),       // Read address from down counter
        .write_addr  (ram_wr_addr),       // Write address from up counter
        .we          (we_reg),            // Write enable (registered)
        .read_clock  (clk),               // Read clock
        .write_clock (clk),               // Write clock  
        .rst         (rst),               // Reset
        .q           (ram_out)            // Data output
    );

    //==========================================================================
    // Pipeline Registers for Timing Optimization
    //==========================================================================
    
    always @(posedge clk) begin
        if (rst) begin
            rom_out_reg  <= 8'h00;
            ram_out_reg  <= 8'h00;
            we_reg       <= 1'b0;
        end else begin
            rom_out_reg  <= rom_out;      // Register ROM output for RAM write
            ram_out_reg  <= ram_out;      // Register RAM output for adder
            we_reg       <= en;           // Write enable follows counter enable
        end
    end

    //==========================================================================
    // Arithmetic Logic
    //==========================================================================
    
    // Adder: Combines ROM and RAM outputs
    adder #(
        .WIDTH(8)
    ) u_adder (
        .a      (rom_out),        // Current ROM output
        .b      (ram_out_reg),    // Registered RAM output 
        .sum    (sum_out)         // Sum output
    );

endmodule
