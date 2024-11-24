// Self composition of two RSA modules with p, q as high security inputs
module top #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                start,

    // 1st copy 
    input  [  WIDTH-1:0] dividend_1,
    input  [  WIDTH-1:0] dividend_2,

    // 2nd copy
    input  [  WIDTH-1:0] divisor_1,
    input  [  WIDTH-1:0] divisor_2,

    // output
    output [  WIDTH-1:0] quotient_1,
    output [  WIDTH-1:0] quotient_2,
    output [  WIDTH-1:0] remainder_1,
    output [  WIDTH-1:0] remainder_2,

    output               finish_1,
    output               finish_2

    
);

Divide divide1(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .dividend(dividend_1),  
    .divisor(divisor_1),
    // output
    .quotient(quotient_1),
    .remainder(remainder_1),
    .finish(finish_1)
);

Divide divide2(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .dividend(dividend_2),  
    .divisor(divisor_2),
    // output
    .quotient(quotient_2),
    .remainder(remainder_2),
    .finish(finish_2)
);

endmodule