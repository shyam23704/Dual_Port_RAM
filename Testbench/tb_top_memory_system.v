`timescale 1ns/1ps

//==============================================================================
// Testbench for Top-level Memory System (Two-Clock, ROM-controlled WEA)
//==============================================================================

module tb_top_memory_system;

    //==========================================================================
    // Clock and control signals
    //==========================================================================

    reg clk_write;
    reg clk_read;
    reg rst;
    reg en_up;
    reg en_down;

    // DUT outputs
    wire [7:0] up_addr;
    wire [7:0] down_addr;
    wire [7:0] rom_out;
    wire [7:0] ram_out;
    wire [7:0] sum_out;

    //==========================================================================
    // DUT instantiation
    //==========================================================================

    top uut (
        .clk_write (clk_write),
        .clk_read  (clk_read),
        .rst       (rst),
        .en_up     (en_up),
        .en_down   (en_down),
        .up_addr   (up_addr),
        .down_addr (down_addr),
        .rom_out   (rom_out),
        .ram_out   (ram_out),
        .sum_out   (sum_out),
        .we_reg    (we_reg)
    );

    //==========================================================================
    // Clock generation (different frequencies)
    //==========================================================================

    // Write clock: 10 ns period (100 MHz)
    initial clk_write = 1'b0;
    always #5 clk_write = ~clk_write;

    // Read clock: 16 ns period (~62.5 MHz)
    initial clk_read = 1'b0;
    always #8 clk_read = ~clk_read;

    //==========================================================================
    // Reset and enable sequence
    //==========================================================================

    initial begin
        rst     = 1'b1;
        en_up   = 1'b0;
        en_down = 1'b0;

        // Hold reset for some time
        #40;
        rst     = 1'b0;

        // Enable counters after reset
        #20;
        en_up   = 1'b1;
        en_down = 1'b1;
    end

    //==========================================================================
    // Monitoring and simulation control
    //==========================================================================

    integer write_cycle_count;

    // Count write-side cycles (for milestones)
    always @(posedge clk_write or posedge rst) begin
        if (rst) begin
            write_cycle_count <= 0;
        end else if (en_up) begin
            write_cycle_count <= write_cycle_count + 1;

            if (write_cycle_count == 1)
                $display("[%0t] --- Starting counter operation ---", $time);
            if (write_cycle_count == 64)
                $display("[%0t] --- RAM should be fully populated (64 writes) ---", $time);
            if (write_cycle_count == 128)
                $display("[%0t] --- Second pass through RAM addresses (write side) ---", $time);
        end
    end

    // Simple status display on read clock
    always @(posedge clk_read) begin
        if (!rst && en_down) begin
            $display("[%0t] wr_addr=%0d rd_addr=%0d ROM=%02h RAM=%02h SUM=%02h WE=%0d",
                     $time,
                     up_addr[7:0], down_addr[7:0],
                     rom_out, ram_out, sum_out,we_reg);
        end
    end

    // VCD dump for waveform viewing
    initial begin
        $dumpfile("tb_top_memory_system.vcd");
        $dumpvars(0, tb_top_memory_system);
    end

    // End simulation after some time
    initial begin
        #50000000;   // run long enough to see multiple fill/drain cycles
        $display("Simulation finished.");
        $finish;
    end

endmodule
