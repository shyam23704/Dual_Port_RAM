`timescale 1ns/1ps

//==============================================================================
// Testbench for Top-level Memory System
//
// This testbench verifies the operation of the memory system consisting of:
// - Up counter driving ROM addresses  
// - Down counter driving RAM read addresses
// - ROM-to-RAM data transfer
// - Addition of ROM and RAM outputs
//==============================================================================

module tb_top_memory_system;

    // Clock and control signals
    reg clk;
    reg rst;
    reg en;

    // Output signals from DUT
    wire [7:0] up_addr;
    wire [7:0] down_addr;
    wire [7:0] rom_out;
    wire [7:0] ram_out;
    wire [7:0] sum_out;

    //==========================================================================
    // Device Under Test (DUT) Instantiation
    //==========================================================================
    top DUT (
        .clk      (clk),
        .rst      (rst),
        .en       (en),
        .up_addr  (up_addr),
        .down_addr(down_addr),
        .rom_out  (rom_out),
        .ram_out  (ram_out),
        .sum_out  (sum_out)
    );

    //==========================================================================
    // Clock Generation: 100 MHz (10ns period)
    //==========================================================================
    initial clk = 0;
    always #5 clk = ~clk;

    //==========================================================================
    // Test Stimulus
    //==========================================================================
    initial begin
        // Initialize signals
        rst = 1;
        en  = 0;

        // Hold reset for several clock cycles to ensure proper initialization
        repeat(5) @(posedge clk);
        
        // Release reset and enable counters
        rst = 0;
        @(posedge clk);
        en = 1;

        // Run simulation for enough cycles to see pattern development
        // Need at least 64 cycles to fill RAM, plus more to see read patterns
        repeat(150) @(posedge clk);

        // Test disable functionality
        $display("\n--- Testing Enable/Disable ---");
        en = 0;
        repeat(10) @(posedge clk);
        
        en = 1;
        repeat(20) @(posedge clk);

        $display("\n--- Simulation Complete ---");
        
        // End-of-Test Summary
        $display("\n==============================================================================");
        $display("Test Summary:");
        $display("- Total active cycles: %0d", cycle_count);
        $display("- Final up_addr: %0d", up_addr);
        $display("- Final down_addr: %0d", down_addr);
        $display("- Final ROM output: %0d", rom_out);
        $display("- Final RAM output: %0d", ram_out);
        $display("- Final sum: %0d", sum_out);
        $display("==============================================================================");
        
        $finish;
    end

    //==========================================================================
    // Monitoring and Display
    //==========================================================================
    initial begin
        $display("==============================================================================");
        $display("Memory System Testbench");
        $display("==============================================================================");
        $display("Time | UP | DOWN | ROM | RAM | SUM");
        $display("-----|----|----- |-----|-----|-----|");
        
        // Monitor with more detailed information
        $monitor("%4t | %3d | %4d | %3d | %3d | %3d",
                 $time, up_addr, down_addr, rom_out, ram_out, sum_out);
    end

    //==========================================================================
    // VCD Dump for Waveform Viewing
    //==========================================================================
    initial begin
        $dumpfile("tb_top_memory_system.vcd");
        $dumpvars(0, tb_top_memory_system);
    end

    //==========================================================================
    // Additional Analysis - Track RAM Write Pattern
    //==========================================================================
    reg [15:0] cycle_count;
    
    initial cycle_count = 0;
    
    always @(posedge clk) begin
        if (!rst && en) begin
            cycle_count <= cycle_count + 1;
            
            // Display key milestones
            if (cycle_count == 1)
                $display("--- Starting counter operation ---");
            if (cycle_count == 64)
                $display("--- RAM should be fully populated (64 writes) ---");
            if (cycle_count == 128)
                $display("--- Second pass through RAM addresses ---");
        end else if (rst) begin
            cycle_count <= 0;
        end
    end

endmodule
