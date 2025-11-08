module display_logic (
    input  wire clk,
    input  wire rst_n,
    input  wire [2:0] dice1,
    input  wire [2:0] dice2,
    input  wire rolled1,   // vom dice_controller
    input  wire rolled2,
    output reg  [3:0] digit,
    output reg  [1:0] pattern
);
    reg rolled1_flag, rolled2_flag;
    reg [2:0] last_dice1, last_dice2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled1_flag <= 0;
            rolled2_flag <= 0;
            last_dice1 <= 3'd0;
            last_dice2 <= 3'd0;
            digit <= 4'd0;
            pattern <= 2'd3; // mittlerer Strich
        end else begin
            // interne Flags setzen, wenn dice_controller gerade gedrückt wurde
            if (rolled1) rolled1_flag <= 1'b1;
            if (rolled2) rolled2_flag <= 1'b1;

            // Update nur, wenn beide Flags gesetzt und Würfelwerte sich geändert haben
            if (rolled1_flag & rolled2_flag) begin

                if (dice1 == dice2) begin
                    digit <= {1'b0, dice1};
                    pattern <= 2'd0;
                end else if ((dice1==3'd1 && dice2==3'd2) || (dice1==3'd2 && dice2==3'd1)) begin
                    pattern <= 2'd1; // alle an
                end else if ((dice1==3'd3 && dice2!=3'd3) || (dice2==3'd3 && dice1!=3'd3)) begin
                    pattern <= 2'd2; // horizontale Striche
                end else begin
                    pattern <= 2'd3; // mittlerer Strich
                end

                // interne Flags zurücksetzen
                rolled1_flag <= 0;
                rolled2_flag <= 0;
            end
        end
    end
endmodule

