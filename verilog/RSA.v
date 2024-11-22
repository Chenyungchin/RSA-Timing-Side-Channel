module RSA #(parameter WIDTH = 8)(
    // input
    input              clk,
    input              rst_n,
    input  [WIDTH-1:0] p, // prime number 1
    input  [WIDTH-1:0] q, // prime number 2
    input  [WIDTH-1:0] m, // decrypted message
    input              KeyGenStart,
    // output
    output [WIDTH-1:0] m_decrypted, // decrypted message
    output             finish

    
);

wire KeyGenFinish, EncryptFinish;
wire [  WIDTH-1:0] e; // public key
wire [2*WIDTH-1:0] d; // private key (d = e^-1 mod (p-1)*(q-1))
wire [2*WIDTH-1:0] n; // modulus (p*q)
wire [  WIDTH-1:0] c; // encrypted message



KeyGen keygen0(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(KeyGenStart),
    .p(p), // prime number 1
    .q(q), // prime number 2
    // output
    .e(e), // public key
    .d(d), // private key
    .n(n), // modulus (p*q)
    .finish(KeyGenFinish)
);

RSA_encrypt rsa_encrypt0( // (c = m^e mod n)
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(KeyGenFinish),
    .m(m), // original message
    .e(e), // public key
    .n(n), // modulus (p*q)
    // output
    .c(c), // encrypted message
    .finish(EncryptFinish)
);

RSA_decrypt rsa_decrypt0( // (m = c^d mod n)
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(EncryptFinish),
    .c(c), // encrypted message
    .d(d), // private key
    .n(n), // modulus (p*q)
    // output
    .m_decrypted(m_decrypted), // decrypted message
    .finish(finish)
);


endmodule