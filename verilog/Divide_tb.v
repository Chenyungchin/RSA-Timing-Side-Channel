//~ `New testbench
`timescale  1ns / 1ps
`define CYCLE 10.0

module Divide_tb;

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
reg   [7:0]  dividend;
reg   [7:0]  divisor;
reg          start;

// Outputs
wire  [7:0]  quotient;
wire  [7:0]  remainder;
wire  finish                              ;

Divide  div0 (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .start                   ( start                    ),
    .dividend                ( dividend     [7:0]       ),
    .divisor                 ( divisor      [7:0]       ),
    .quotient                ( quotient     [7:0]       ),
    .remainder               ( remainder    [7:0]       ),
    .finish                  ( finish                   )
);

// ================== test sequence ====================
initial begin
    start = 0;
    dividend = 0;
    divisor = 0;
    @(posedge clk);
    start = 1;
    dividend = 34;
    divisor = 12;
    @(posedge clk);
    start = 0;
    dividend = 0;
    divisor = 0;
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
    $dumpfile("Divide_tb.vcd");
    $dumpvars(0, Divide_tb);
end

endmodule