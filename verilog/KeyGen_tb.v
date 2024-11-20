//~ `New testbench
`timescale  1ns / 1ps
`define CYCLE 10.0

module KeyGen_tb;

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
reg   [7:0]  p;
reg   [7:0]  q;
reg          start;

// Outputs
wire  [7:0]  e;
wire         finish;

KeyGen  keygen0 (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .start                   ( start                    ),
    .p                       ( p                        ),
    .q                       ( q                        ),
    .e                       ( e                        ),
    .finish                  ( finish                   )
);

// ================== test sequence ====================
initial begin
    start = 0;
    p = 0;
    q = 0;
    @(posedge clk);
    start = 1;
    p = 34;
    q = 12;
    @(posedge clk);
    start = 0;
    p = 0;
    q = 0;
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
    $dumpfile("KeyGen_tb.vcd");
    $dumpvars(0, KeyGen_tb);
end

endmodule