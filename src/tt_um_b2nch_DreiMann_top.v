/*
 * Copyright (c) 2024 Benjamin Lehner
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none


`include "dice_generator.v"
`include "dice_controller.v"
`include "seven_seg_decoder.v"
`include "display_logic.v"
`include "debounce.v"

module tt_um_b2nch_DreiMann_top (
    input  wire [7:0] ui_in,    // Eingänge (Buttons, Switches)
    output wire [7:0] uo_out,   // Ausgänge (7-Segment Display)
    input  wire [7:0] uio_in,   // ungenutzt
    output wire [7:0] uio_out,  // ungenutzt
    output wire [7:0] uio_oe,   // ungenutzt
    input  wire       ena,      // Enable (immer 1)
    input  wire       clk,      // Clock
    input  wire       rst_n     // Aktiv Low Reset (0 = Reset gedrückt)
);

  // Unbenutzte IOs
  assign uio_out = 0;
  assign uio_oe  = 0;

  // Eingänge
  wire btn1      = ui_in[0]; // Würfel 1 Taster
  wire btn2      = ui_in[1]; // Würfel 2 Taster
  wire cc_switch = ui_in[2]; // 1 = Common Cathode, 0/float = Common Anode

  // Laufende Würfelgeneratoren
  wire [2:0] dice_val1, dice_val2;
  dice_generator gen1 (.clk(clk), .rst_n(rst_n), .value(dice_val1));
  dice_generator gen2 (.clk(clk), .rst_n(rst_n), .value(dice_val2));

  // Entprellung
  wire btn1_db, btn2_db;
  debounce db1 (.clk(clk), .rst_n(rst_n), .btn_in(btn1), .btn_pressed(btn1_db));
  debounce db2 (.clk(clk), .rst_n(rst_n), .btn_in(btn2), .btn_pressed(btn2_db));

  // Würfel-Steuerung
  wire [2:0] stored1, stored2;
  wire rolled1, rolled2;

  dice_controller dc1 (
    .clk(clk),
    .rst_n(rst_n),
    .roll_btn(btn1_db),
    .running_value(dice_val1),
    .stored_value(stored1),
    .rolled(rolled1)
  );

  dice_controller dc2 (
    .clk(clk),
    .rst_n(rst_n),
    .roll_btn(btn2_db),
    .running_value(dice_val2),
    .stored_value(stored2),
    .rolled(rolled2)
  );

  // Anzeige-Logik
  // Anzeige-Logik Signale
  wire [3:0] digit;
  wire [1:0] pattern;

  display_logic disp (
    .clk(clk),
    .rst_n(rst_n),
    .dice1(stored1),
    .dice2(stored2),
    .rolled1(rolled1),
    .rolled2(rolled2),
    .digit(digit),
    .pattern(pattern)
  );

  // 7-Segment-Decoder (Umschaltbar zwischen CA/CC)
  wire [6:0] seg;
  seven_seg_decoder segdec (
      .digit(digit),
      .pattern(pattern),
      .common_cathode(cc_switch),
      .seg(seg)
  );

  // Ausgabe auf Pins
  assign uo_out[6:0] = seg;
  assign uo_out[7]   = 1'b0; // DP (Punkt) bleibt aus

  // Unused Inputs verhindern Warnungen
  wire _unused = &{ena, uio_in, ui_in[7:3], 1'b0};

endmodule

