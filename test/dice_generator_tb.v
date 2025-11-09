/*
	Simple testbench for dice_generator.
*/

`timescale 1ns / 1ns // time unit / time precision

//`include "../src/dice_generator.v"  // optional if included via compile flags

module dice_generator_tb;

	// Inputs
	reg clk   = 1'b0;
	reg rst_n = 1'b0; // Active low reset

	// Outputs
	wire [2:0] value;

	// Device Under Test (DUT)
	dice_generator dut (
		.clk(clk),
		.rst_n(rst_n),
		.value(value)
	);

	// Generate clock: 10 ns period
	/* verilator lint_off STMTDLY */
	always #5 clk = ~clk; // toggle every 5 ns
	/* verilator lint_on STMTDLY */

	initial begin
		$dumpfile("dice_generator_tb.vcd");
		$dumpvars(0, dice_generator_tb);

		// Simulation sequence
		$display("=== Starting dice_generator test ===");

		// Initial reset
		rst_n = 1'b0;
		#20; // hold reset low for 20 ns
		rst_n = 1'b1;
		$display("[%0t ns] Reset released", $time);

		// Run for some cycles
		repeat (20) begin
			#10; // wait one clock period
			$display("[%0t ns] value = %0d", $time, value);
		end

		// End simulation
		$display("=== Test complete ===");
		#50 $finish;
	end

endmodule
