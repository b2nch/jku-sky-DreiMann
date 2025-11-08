module dice_generator (
    input  wire clk,
    input  wire rst_n,
    output reg [2:0] value  // Wertebereich 1–6
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      value <= 3'd1;
    else if (value == 3'd6)
      value <= 3'd1;
    else
      value <= value + 3'd1;
  end
endmodule
