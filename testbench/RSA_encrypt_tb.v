//~ `New testbench
`timescale  1ns / 1ps
`define CYCLE 10.0

module RSA_encrypt_tb;

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
reg   [15:0]  m;
reg   [ 7:0]  e;
reg   [15:0]  n;
reg           start;

// Outputs
wire [15:0]  c;
wire         finish;

RSA_encrypt  rsa_encrypt0 (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .start                   ( start                    ),
    .m                       ( m                        ),
    .e                       ( e                        ),
    .n                       ( n                        ),
    .c                       ( c                        ),
    .finish                  ( finish                   )
);

// ================== test sequence ====================
// sample answer: c = 1394
initial begin
    start = 0;
    m = 0;
    e = 0;
    n = 0;
    @(posedge clk);
    start = 1;
    m = 89;
    e = 3;
    n = 3127;
    @(posedge clk);
    start = 0;
    m = 0;
    e = 0;
    n = 0;
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
    $dumpfile("RSA_encrypt_tb.vcd");
    $dumpvars(0, RSA_encrypt_tb);
end

endmodule