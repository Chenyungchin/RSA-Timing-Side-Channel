// Self composition of two RSA modules with p, q as high security inputs
module top #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                start,

    input  [2*WIDTH-1:0] a_1,
    input  [2*WIDTH-1:0] a_2,
    input  [2*WIDTH-1:0] b_1,
    input  [2*WIDTH-1:0] b_2,

    // output
    output [2*WIDTH-1:0] gcd_1,
    output [2*WIDTH-1:0] gcd_2,
    output [2*WIDTH-1:0] s_1,
    output [2*WIDTH-1:0] s_2,
    output [2*WIDTH-1:0] t_1,
    output [2*WIDTH-1:0] t_2,

    output               finish_1,
    output               finish_2

    
);

gcd gcd_block_1(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(a_1),
    .b(b_1),
    // output
    .gcd(gcd_1),
    .s(s_1),
    .t(t_1),
    .finish(finish_1)
);

gcd gcd_block_2(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(a_2),
    .b(b_2),
    // output
    .gcd(gcd_2),
    .s(s_2),
    .t(t_2),
    .finish(finish_2)
);

endmodule