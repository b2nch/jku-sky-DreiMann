module seven_seg_decoder (
    input  wire [3:0] digit,      // Zahl 0–9 oder Spezialcode
    input  wire [1:0] pattern,    // 0=normale Zahl, 1=alle an, 2=horizontale Striche, 3=mittlerer Strich
    input  wire       common_cathode, // 1 = CC, 0 = CA (default)
    output reg  [6:0] seg          // a,b,c,d,e,f,g
);
  reg [6:0] pattern_raw;

  always @(*) begin
    case (pattern)
      2'd1: pattern_raw = 7'b0000000; // alle an (alle Segmente leuchten)
      2'd2: pattern_raw = 7'b1000001; // horizontale Segmente (a, g, d)
      2'd3: pattern_raw = 7'b1111110; // nur mittlerer Strich (g)
      default: begin
        case (digit)
          4'd0: pattern_raw = 7'b0000001;
          4'd1: pattern_raw = 7'b1001111;
          4'd2: pattern_raw = 7'b0010010;
          4'd3: pattern_raw = 7'b0000110;
          4'd4: pattern_raw = 7'b1001100;
          4'd5: pattern_raw = 7'b0100100;
          4'd6: pattern_raw = 7'b0100000;
          4'd7: pattern_raw = 7'b0001111;
          4'd8: pattern_raw = 7'b0000000;
          4'd9: pattern_raw = 7'b0000100;
          default: pattern_raw = 7'b1111111; // aus
        endcase
      end
    endcase

    if (common_cathode)
      seg = ~pattern_raw;  // 1 = leuchtet
    else
      seg = pattern_raw;   // 0 = leuchtet
  end
endmodule
