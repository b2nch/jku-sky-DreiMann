`timescale 1ns / 1ns

`include "dice_generator.v"

module dice_controller_tb;

    // Inputs
    reg clk = 0;
    reg rst_n = 0;
    reg roll_btn = 0;

    // Outputs
    wire [2:0] dice_val;      // From generator
    wire [2:0] stored_value;  // From controller
    wire rolled;

    // Instantiate dice_generator
    dice_generator gen (
        .clk(clk),
        .rst_n(rst_n),
        .value(dice_val)
    );

    // Instantiate dice_controller
    dice_controller dc (
        .clk(clk),
        .rst_n(rst_n),
        .roll_btn(roll_btn),
        .running_value(dice_val),
        .stored_value(stored_value),
        .rolled(rolled)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 ns period

    initial begin
        $dumpfile("dice_controller_tb.vcd");
        $dumpvars(0, dice_controller_tb);

        // Apply reset
        rst_n = 0;
        #10;
        rst_n = 1;

        // Wait a few clocks
        #20;

        // First button press: latch current dice value
        roll_btn = 1;
        #10;
        roll_btn = 0;
        #20;

        // Second button press: latch next dice value
        roll_btn = 1;
        #10;
        roll_btn = 0;
        #20;

        // Hold button multiple clocks: should only latch once
        roll_btn = 1;
        #30;
        roll_btn = 0;

        // Wait a few cycles
        #50;

        $finish;
    end

endmodule

