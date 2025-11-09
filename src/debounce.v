module debounce (
    input  wire clk,
    input  wire rst_n,
    input  wire btn_in,
    output reg  btn_pressed
);
  reg [7:0] cnt;
  reg btn_sync, btn_last, btn_stable, btn_stable_last;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      btn_sync        <= 0;
      btn_last        <= 0;
      btn_stable      <= 0;
      btn_stable_last <= 0;
      cnt             <= 0;
      btn_pressed     <= 0;
    end else begin
      // input synchronizer
      btn_sync <= btn_in;

      // reset counter if signal changed
      if (btn_sync != btn_last)
        cnt <= 0;
      else if (cnt < 8'hFF)
        cnt <= cnt + 1;

      // update stable button state when counter maxed out
      if (cnt >= 8'hFA)
        btn_stable <= btn_sync;

      // detect rising edge of the *debounced* signal
      btn_pressed <= (btn_stable & ~btn_stable_last);

      // update histories
      btn_stable_last <= btn_stable;
      btn_last        <= btn_sync;
    end
  end
endmodule

