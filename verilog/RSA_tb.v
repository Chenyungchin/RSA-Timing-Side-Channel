//~ `New testbench
`timescale  1ns / 1ps
`define CYCLE 10.0

module RSA_tb;

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
reg   [ 7:0]  p, q;
reg   [15:0]  m;
reg           start;

// Outputs
wire [15:0]  m_decrypted;
wire         finish;

RSA  rsa0 (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .KeyGenStart             ( start                    ),
    .p                       ( p                        ),
    .q                       ( q                        ),
    .m                       ( m                        ),
    .m_decrypted             ( m_decrypted              ),
    .finish                  ( finish                   )
);

// ================== test sequence ====================
// sample answer: m_decrypted = 89
initial begin
    start = 0;
    p = 0;
    q = 0;
    m = 0;
    @(posedge clk);
    start = 1;
    p = 53;
    q = 59;
    m = 89;
    @(posedge clk);
    start = 0;
    p = 0;
    q = 0;
    m = 0;
end

// ================== time out ==========================
initial begin
    # (500000 * `CYCLE);
    $display("\n\033[1;31m=============================================");
	$display("           Simulation Time Out!      ");
	$display("=============================================\033[0m");
	$finish;
end

initial begin
    $dumpfile("RSA_tb.vcd");
    $dumpvars(0, RSA_tb);
end

endmodule