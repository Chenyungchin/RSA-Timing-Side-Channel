@@ -0,0 +1,65 @@
//~ `New testbench
`timescale  1ns / 1ps
`define CYCLE 10.0

module CheckPrime_tb;

// ================= clk generation =====================
reg clk = 1;
always #(`CYCLE/2) clk = ~clk;

// ================= rst_n =====================
reg rst_n;
initial begin
    rst_n  =  0;
    @(posedge clk) rst_n = 1;
end

// =============== instantiate DUT ====================
// Inputs
reg   [ 7:0]  num;
reg           start;

// Outputs
wire         IsPrime;
wire         finish;
wire         AssumePrime;

CheckPrime  checkprime0 (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .start                   ( start                    ),
    .num                     ( num                      ),
    .IsPrime                 ( IsPrime                  ),
    .finish                  ( finish                   ),
    .AssumePrime             ( AssumePrime            )
);

// ================== test sequence ====================
// sample answer: 7 is prime
initial begin
    start = 0;
    num = 0;
    @(posedge clk);
    start = 1;
    num = 7;
    @(posedge clk);
    start = 0;
    num = 0;
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
    $dumpfile("CheckPrime_tb.vcd");
    $dumpvars(0, CheckPrime_tb);
end

endmodule