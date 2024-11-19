module RSA_encrypt #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                start,
    input  [  WIDTH-1:0] m, // original message
    input  [  WIDTH-1:0] e, // public key
    input  [2*WIDTH-1:0] n, // modulus (p*q)
    // output
    output [  WIDTH-1:0] c, // encrypted message
    output               finish
);

// tmp
assign c = 0;
assign finish = 0;

endmodule