//~ `New testbench
`timescale  1ns / 100ps
`define CYCLE 10.0

module RSA_decrypt_tb;

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
reg   [15:0]  c, d;
reg   [15:0]  n;
reg           start;

// Outputs
wire [15:0]  m_decrypted;
wire         finish;

RSA_decrypt  rsa_decrypt0 (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .start                   ( start                    ),
    .c                       ( c                        ),
    .d                       ( d                        ),
    .n                       ( n                        ),
    .m_decrypted             ( m_decrypted              ),
    .finish                  ( finish                   )
);

// ================== test sequence ====================
// sample answer: m_decrypted = 89
initial begin
    start = 0;
    c = 0;
    d = 0;
    n = 0;
    @(posedge clk);
    start = 1;
    c = 1394;
    d = 2011;
    n = 3127;
    @(posedge clk);
    start = 0;
    c = 0;
    d = 0;
    n = 0;
end

// ================== time out ==========================
initial begin
    # (5000000 * `CYCLE);
    $display("\n\033[1;31m=============================================");
	$display("           Simulation Time Out!      ");
	$display("=============================================\033[0m");
	$finish;
end

initial begin
    $dumpfile("RSA_decrypt_tb.vcd");
    $dumpvars(0, RSA_decrypt_tb);
end

endmodule