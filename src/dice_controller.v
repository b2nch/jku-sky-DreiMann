module dice_controller (
    input  wire clk,
    input  wire rst_n,
    input  wire roll_btn,
    input  wire [2:0] running_value,
    output reg  [2:0] stored_value,
    output reg        rolled
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      stored_value <= 0;
      rolled <= 0;
    end else if (roll_btn) begin
      stored_value <= running_value;
      rolled <= 1;
    end
  end
endmodule
