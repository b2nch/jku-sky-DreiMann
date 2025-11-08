module dice_controller (
    input  wire clk,
    input  wire rst_n,
    input  wire roll_btn,
    input  wire [2:0] running_value,
    output reg  [2:0] stored_value,
    output reg        rolled
);

    reg roll_btn_d; // delayed version of button

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_value <= 3'd0;
            rolled <= 1'b0;
            roll_btn_d <= 1'b0;
        end else begin
            roll_btn_d <= roll_btn; // remember previous button state

            // detect falling edge: button was high, now low
            if (roll_btn_d & ~roll_btn) begin
                stored_value <= running_value;
                rolled <= 1'b1;
            end else begin
                rolled <= 1'b0; // only high for one clock
            end
        end
    end
endmodule

