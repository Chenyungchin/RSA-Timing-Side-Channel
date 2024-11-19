module RSA_decrypt #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                start,
    input  [  WIDTH-1:0] c, // encrypted message
    input  [2*WIDTH-1:0] d, // public key
    input  [2*WIDTH-1:0] n, // modulus (p*q)
    // output
    output [  WIDTH-1:0] m_decrypted, // decrypted message
    output               finish
);

// tmp
assign m_decrypted = 0;
assign finish = 0;

endmodule