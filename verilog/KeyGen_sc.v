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

    // output
    output [  WIDTH-1:0] e_1, // public key 1
    output [  WIDTH-1:0] e_2, // public key 2
    output [2*WIDTH-1:0] d_1, // private key 1
    output [2*WIDTH-1:0] d_2, // private key 2
    output [2*WIDTH-1:0] n_1, // modulus 1
    output [2*WIDTH-1:0] n_2, // modulus 2

    output               finish_1,
    output               finish_2

    
);

KeyGen keygen1(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(KeyGenStart),
    .p(p_1), // prime number 1
    .q(q_1), // prime number 2
    // output
    .e(e_1), // public key
    .d(d_1), // private key
    .n(n_1), // modulus (p*q)
    .finish(finish_1)
);

KeyGen keygen2(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(KeyGenStart),
    .p(p_2), // prime number 1
    .q(q_2), // prime number 2
    // output
    .e(e_2), // public key
    .d(d_2), // private key
    .n(n_2), // modulus (p*q)
    .finish(finish_2)
);


reg assumePrime_p1;
reg assumePrime_q1;
reg assumePrime_p2;
reg assumePrime_q2;

reg finish_p1;
reg finish_q1;
reg finish_p2;
reg finish_q2;

reg assumePrime_p1;
reg assumePrime_q1;
reg assumePrime_p2;
reg assumePrime_q2;

CheckPrime_comb check_p1(
        .num(p_1),
        .start(KeyGenStart),
        .assumePrime(assumePrime_p1)
);

CheckPrime_comb check_q1(
        .num(q_1),
        .start(KeyGenStart),
        .assumePrime(assumePrime_q1)
);

CheckPrime_comb check_p2(
        .num(p_2),
        .start(KeyGenStart),
        .assumePrime(assumePrime_p2)
);

CheckPrime_comb check_q2(
        .num(q_2),
        .start(KeyGenStart),
        .assumePrime(assumePrime_q2)
);

endmodule