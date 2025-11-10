/*
	Simple testbench for tt_um_b2nch_DreiMann_top.
*/

`timescale 1ns / 1ns

//`include "tt_um_b2nch_DreiMann_top.v"
//`include "dice_generator.v"
//`include "dice_controller.v"
//`include "seven_seg_decoder.v"
//`include "display_logic.v"
//`include "debounce.v"

module tt_um_b2nch_DreiMann_top_tb;

	// Inputs
	reg [7:0] ui_in = 8'd0;  // buttons + switch
	reg [7:0] uio_in = 8'd0;
	reg ena = 1'b1;
	reg clk = 1'b0;
	reg rst_n = 1'b0;         // active low reset

	// Outputs
	wire [7:0] uo_out;
	wire [7:0] uio_out;
	wire [7:0] uio_oe;

	// DUT
	tt_um_b2nch_DreiMann_top dut (
		.ui_in(ui_in),
		.uo_out(uo_out),
		.uio_in(uio_in),
		.uio_out(uio_out),
		.uio_oe(uio_oe),
		.ena(ena),
		.clk(clk),
		.rst_n(rst_n)
	);

	// Clock: 10 ns period
	/* verilator lint_off STMTDLY */
	always #5 clk = ~clk;
	/* verilator lint_on STMTDLY */

	initial begin
		$dumpfile("tt_um_b2nch_DreiMann_top_tb.vcd");
		$dumpvars(0, tt_um_b2nch_DreiMann_top_tb);

		// Apply reset
		rst_n = 1'b0;
		#20;
		rst_n = 1'b1;

		// Wait a few clock cycles
		#50;

		// Press button 1 to roll first dice
		ui_in[0] = 1'b1;
		#1000000;
		ui_in[0] = 1'b0;

		// Wait for debounce + clock
		#1000000;

		// Press button 2 to roll second dice
		ui_in[1] = 1'b1;
		#1000000;
		ui_in[1] = 1'b0;
		
		#300000000;
		ui_in[0] = 1'b1;
		ui_in[1] = 1'b1;
		#1000000;
		ui_in[0] = 1'b0;
		ui_in[1] = 1'b0;
		
		#30000000
		ui_in[1] = 1'b1;
		#1000000;
		ui_in[0] = 1'b1;
		#1000000;
		ui_in[0] = 1'b0;
		#1000000;
		ui_in[1] = 1'b0;

		// Wait a few cycles for display to update
		#80000000;

		// Switch to common cathode
		ui_in[2] = 1'b1;
		#20000;

		// Roll again for both dice
		ui_in[0] = 1'b1;
		ui_in[1] = 1'b1;
		#1000000;
		ui_in[0] = 1'b0;
		ui_in[1] = 1'b0;

		#10000 $finish;
	end

endmodule

