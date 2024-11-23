// Self composition of two RSA modules with p, q as high security inputs
module RSA_sc #(parameter WIDTH = 8)(
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


reg assumePrime_p1;
reg assumePrime_q1;
reg assumePrime_p2;
reg assumePrime_q2;

// CheckPrime check_p1(
//     // input
//     .clk(clk),
//     .rst_n(rst_n),
//     .start(1'b1), 
//     .num(p_1),
//     // output
//     .IsPrime(isPrime_p1),
//     .finish(finish_p1),
//     .assumePrime(assumePrime_p1)
// );

// CheckPrime check_q1(
//     // input
//     .clk(clk),
//     .rst_n(rst_n),
//     .start(1'b1), 
//     .num(q_1),
//     // output
//     .IsPrime(isPrime_q1),
//     .finish(finish_q1),
//     .assumePrime(assumePrime_q1)
// );

// CheckPrime check_p2(
//     // input
//     .clk(clk),
//     .rst_n(rst_n),
//     .start(1'b1), 
//     .num(p_2),
//     // output
//     .IsPrime(isPrime_p2),
//     .finish(finish_p2),
//     .assumePrime(assumePrime_p2)
// );

// CheckPrime check_q2(
//     // input
//     .clk(clk),
//     .rst_n(rst_n),
//     .start(1'b1), 
//     .num(q_2),
//     // output
//     .IsPrime(isPrime_q2),
//     .finish(finish_q2),
//     .assumePrime(assumePrime_q2)
// );

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