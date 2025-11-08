module debounce (
    input  wire clk,
    input  wire rst_n,
    input  wire btn_in,
    output reg  btn_pressed
);
  reg [15:0] cnt;
  reg btn_sync, btn_last;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      btn_sync <= 0;
      btn_last <= 0;
      cnt <= 0;
      btn_pressed <= 0;
    end else begin
      btn_sync <= btn_in;
      if (btn_sync != btn_last) begin
        cnt <= 0;
      end else if (cnt < 16'hFFFF) begin
        cnt <= cnt + 1;
      end
      if (cnt == 16'hFFFE)
        btn_pressed <= btn_sync;
      btn_last <= btn_sync;
    end
  end
endmodule
