// Self composition of two RSA modules with p, q as high security inputs
module top #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                start,

    // 1st copy 
    input  [  WIDTH-1:0] in1_1,
    input  [  WIDTH-1:0] in2_1,

    // 2nd copy
    input  [  WIDTH-1:0] in1_2,
    input  [  WIDTH-1:0] in2_2,

    // output
    output [2*WIDTH-1:0] out_1,
    output [2*WIDTH-1:0] out_2,

    output               finish_1,
    output               finish_2

    
);

Mult mult1(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .in1(in1_1),
    .in2(in2_1),
    // output
    .out(out_1),
    .finish(finish_1)
);

Mult mult2(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .in1(in1_2),
    .in2(in2_2),
    // output
    .out(out_2),
    .finish(finish_2)
);

endmodule