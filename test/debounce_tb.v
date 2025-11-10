`timescale 1ns / 1ns

//`include "button_debounce.v"

module debounce_tb;

    // Inputs
    reg clk = 0;
    reg rst_n = 0;
    reg btn_in = 0;

    // Outputs
    wire btn_pressed;

    // DUT (Device Under Test)
    debounce uut (
        .clk(clk),
        .rst_n(rst_n),
        .btn_in(btn_in),
        .btn_pressed(btn_pressed)
    );

    // Clock: 10ns period = 100 MHz
    always #5 clk = ~clk;

    // Simulation setup
    initial begin
        $dumpfile("debounce_tb.vcd");
        $dumpvars(0, debounce_tb);

        // --- Reset phase ---
        rst_n = 0;
        #20;
        rst_n = 1;
        #20;

        // --- Test 1: No press ---
        $display("TEST 1: Kein Tastendruck, Ausgang bleibt 0");
        #100;

        // --- Test 2: Simuliere Prellen beim Tastendruck ---
        $display("TEST 2: Taster prellt -> Ausgang soll NUR EINEN Impuls liefern");

        // Simuliere schnelles Prellen (schnelles Wechseln)
        btn_in = 1;
        #10;
        btn_in = 0;
        #5;
        btn_in = 1;
        #5;
        btn_in = 0; 
        #5;
        btn_in = 1;
        #50;   // Jetzt gedrückt und stabil
        #1000000;

        // --- Test 3: Loslassen des Tasters mit Prellen ---
        $display("TEST 3: Taster loslassen mit Prellen");

        btn_in = 0; #10;
        btn_in = 1; #5;
        btn_in = 0; #5;
        btn_in = 1; #5;
        btn_in = 0; #50;   // stabil losgelassen
        #200;

        // --- Test 4: Mehrere stabile Tastendrücke ---
        $display("TEST 4: Mehrere stabile Drücke nacheinander");

        repeat (3) begin
            btn_in = 1;
            #150;  // stabil gedrückt
            btn_in = 0;
            #150;  // stabil losgelassen
        end

        #200;
        $finish;
    end

endmodule

