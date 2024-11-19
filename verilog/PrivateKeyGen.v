module PrivateKeyGen #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                start,
    input  [  WIDTH-1:0] p, // prime number 1
    input  [  WIDTH-1:0] q, // prime number 2
    input  [  WIDTH-1:0] e, // public key
    // output
    output [2*WIDTH-1:0] d, // private key (d = e^-1 mod (p-1)*(q-1))
    output [2*WIDTH-1:0] n, // modulus (p*q)
    output               finish
);

// tmp
assign d = 0;
assign n = 0;
assign finish = 0;

endmodule