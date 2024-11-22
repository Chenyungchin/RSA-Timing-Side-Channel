// Self composition of two RSA modules with p, q as high security inputs
module top #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                KeyGenStart,

    // 1st copy prime numbers
    input  [  WIDTH-1:0] p_1, // prime number 1
    input  [  WIDTH-1:0] q_1, // prime number 2

    // 2nd copy prime numbers
    input  [  WIDTH-1:0] p_2, // prime number 1
    input  [  WIDTH-1:0] q_2, // prime number 2

    input  [2*WIDTH-1:0] m, // decrypted message
    // output
    output [2*WIDTH-1:0] m_decrypted_1, // decrypted message
    output [2*WIDTH-1:0] m_decrypted_2, // decrypted message

    output               finish_1,
    output               finish_2

    
);


RSA rsa1(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .p(p_1), // prime number 1
    .q(q_1), // prime number 2
    .m(m), // original message
    .KeyGenStart(KeyGenStart),
    // output
    .m_decrypted(m_decrypted_1), // decrypted message
    .finish(finish_1)
);

RSA rsa2(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .p(p_2), // prime number 1
    .q(q_2), // prime number 2
    .m(m), // original message
    .KeyGenStart(KeyGenStart),
    // output
    .m_decrypted(m_decrypted_2), // decrypted message
    .finish(finish_2)
);


endmodule