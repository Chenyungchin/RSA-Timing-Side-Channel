//~ `New testbench
`timescale  1ns / 1ps
`define CYCLE 10.0

module gcd_tb;

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
reg   [7:0]  a;
reg   [7:0]  b;
reg          start;

// Outputs
wire  [7:0]  gcd;
wire  finish                              ;

gcd  gcd0 (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .start                   ( start                    ),
    .a                       ( a            [7:0]       ),
    .b                       ( b            [7:0]       ),
    .gcd                     ( gcd          [7:0]       ),
    .finish                  ( finish                   )
);

// ================== test sequence ====================
initial begin
    start = 0;
    a = 0;
    b = 0;
    @(posedge clk);
    start = 1;
    a = 34;
    b = 12;
    @(posedge clk);
    start = 0;
    a = 0;
    b = 0;
end

// ================== time out ==========================
initial begin
    # (10000 * `CYCLE);
    $display("\n\033[1;31m=============================================");
	$display("           Simulation Time Out!      ");
	$display("=============================================\033[0m");
	$finish;
end

initial begin
    $dumpfile("gcd_tb.vcd");
    $dumpvars(0, gcd_tb);
end

endmodule