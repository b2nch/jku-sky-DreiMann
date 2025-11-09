/*
	Simple testbench for seven_seg_decoder.
*/

`timescale 1ns / 1ns // time unit / time precision

//`include "../src/seven_seg_decoder.v" // optional if included via compile flags

module seven_seg_decoder_tb;

	// Inputs
	reg [3:0] digit = 4'd0;
	reg [1:0] pattern = 2'd0;
	reg       common_cathode = 1'b0; // default: common anode (0)

	// Outputs
	wire [6:0] seg;

	// Device Under Test (DUT)
	seven_seg_decoder dut (
		.digit(digit),
		.pattern(pattern),
		.common_cathode(common_cathode),
		.seg(seg)
	);

	initial begin
		$dumpfile("seven_seg_decoder_tb.vcd");
		$dumpvars(0, seven_seg_decoder_tb);

		$display("=== Starting seven_seg_decoder test ===");

		// Test normal digits 0–9
		pattern = 2'd0; // normal mode
		common_cathode = 1'b0; // common anode
		repeat (10) begin
			#10 digit = digit + 1;
			$display("[%0t ns] digit=%0d, pattern=%0d, CC=%b, seg=%b",
				$time, digit, pattern, common_cathode, seg);
		end

		// Test special pattern: all segments on
		#10 pattern = 2'd1; digit = 4'd8;
		$display("[%0t ns] pattern=ALL ON, seg=%b", $time, seg);

		// Test special pattern: horizontal bars (a, g, d)
		#10 pattern = 2'd2;
		$display("[%0t ns] pattern=HORIZONTAL, seg=%b", $time, seg);

		// Test special pattern: middle bar only
		#10 pattern = 2'd3;
		$display("[%0t ns] pattern=MIDDLE, seg=%b", $time, seg);

		// Switch to common cathode mode (invert)
		#10 common_cathode = 1'b1; pattern = 2'd0; digit = 4'd5;
		$display("[%0t ns] CC mode, digit=5, seg=%b", $time, seg);

		// Test "all on" pattern in common cathode mode
		#10 pattern = 2'd1;
		$display("[%0t ns] CC mode, pattern=ALL ON, seg=%b", $time, seg);

		$display("=== Test complete ===");
		#50 $finish;
	end

endmodule

