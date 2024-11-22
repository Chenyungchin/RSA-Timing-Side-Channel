@@ -0,0 +1,65 @@
//~ `New testbench
`timescale  1ns / 1ps
`define CYCLE 10.0

module CheckPrime_comb_tb;

// =============== instantiate DUT ====================
// Inputs
reg   [ 7:0]  num;
wire         AssumePrime;

CheckPrime_comb  checkprime0 (
    .num                     ( num                      ),
    .AssumePrime             ( AssumePrime            )
);

// ================== test sequence ====================
// sample answer: 7 is prime
initial begin
    num = 7;
end

// ================== time out ==========================
initial begin
    # (50000 * `CYCLE);
    $display("\n\033[1;31m=============================================");
	$display("           Simulation Time Out!      ");
	$display("=============================================\033[0m");
	$finish;
end

initial begin
    $dumpfile("CheckPrime_comb_tb.vcd");
    $dumpvars(0, CheckPrime_comb_tb);
end

endmodule