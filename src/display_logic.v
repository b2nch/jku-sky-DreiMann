module display_logic (
    input  wire [2:0] dice1,
    input  wire [2:0] dice2,
    input  wire rolled1,
    input  wire rolled2,
    output reg  [3:0] digit,
    output reg  [1:0] pattern
);
  wire both_rolled = rolled1 & rolled2;

  always @(*) begin
    digit   = 4'd0;
    pattern = 2'd0;

    if (!both_rolled) begin
      pattern = 2'd3;  // nur mittlerer Strich während Warten
    end else if (dice1 == dice2) begin
      digit   = {1'b0, dice1};  // <-- sauber auf 4 Bit erweitern
      pattern = 2'd0; // normale Zahl
    end else if ((dice1 == 3'd1 && dice2 == 3'd2) || (dice1 == 3'd2 && dice2 == 3'd1)) begin
      pattern = 2'd1; // alle an
    end else if ((dice1 == 3'd3 && dice2 != 3'd3) || (dice2 == 3'd3 && dice1 != 3'd3)) begin
      pattern = 2'd2; // horizontale Striche
    end else begin
      pattern = 2'd3; // mittlerer Strich
    end
  end
endmodule

