`timescale 1ns / 1ns

//`include "display_logic.v"

module display_logic_tb;

    // Inputs
    reg clk = 0;
    reg rst_n = 0;
    reg [2:0] dice1 = 3'd1;
    reg [2:0] dice2 = 3'd1;
    reg rolled1 = 0;
    reg rolled2 = 0;

    // Outputs
    wire [3:0] digit;
    wire [1:0] pattern;

    // DUT
    display_logic uut (
        .clk(clk),
        .rst_n(rst_n),
        .dice1(dice1),
        .dice2(dice2),
        .rolled1(rolled1),
        .rolled2(rolled2),
        .digit(digit),
        .pattern(pattern)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 ns period

    initial begin
        $dumpfile("display_logic_tb.vcd");
        $dumpvars(0, display_logic_tb);

        // Reset system
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;

        // --- Test 1: roll only dice1, should NOT update display ---
        dice1 = 3'd4;
        rolled1 = 1;
        #10 rolled1 = 0;
        #20;

        // --- Test 2: now roll both dice, should update display ---
        dice2 = 3'd4;
        rolled2 = 1;
        #10 rolled2 = 0;
        #20;

        // --- Test 3: roll only dice2 multiple times, no update ---
        dice2 = 3'd6;
        rolled2 = 1;
        #10 rolled2 = 0;
        #20;
        dice2 = 3'd2;
        rolled2 = 1;
        #10 rolled2 = 0;
        #20;

        // --- Test 4: now roll both dice again, update expected ---
        dice1 = 3'd3;
        rolled1 = 1;
        #10 rolled1 = 0;
        dice2 = 3'd5;
        rolled2 = 1;
        #10 rolled2 = 0;
        #30;

        // --- Test 5: special case 21 (dice1=1, dice2=2) ---
        dice1 = 3'd1;
        rolled1 = 1;
        #10 rolled1 = 0;
        dice2 = 3'd2;
        rolled2 = 1;
        #10 rolled2 = 0;
        #30;

        // --- Test 6: special case both 3 (should display "3") ---
        dice1 = 3'd3;
        rolled1 = 1;
        #10 rolled1 = 0;
        dice2 = 3'd3;
        rolled2 = 1;
        #10 rolled2 = 0;
        #30;

        // --- Done ---
        $finish;
    end

endmodule

