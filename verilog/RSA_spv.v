module RSA_spv #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                KeyGenStart,
    input  [  WIDTH-1:0] p, // prime number 1
    input  [  WIDTH-1:0] q, // prime number 2
    input  [2*WIDTH-1:0] m, // decrypted message
    // output
    output [2*WIDTH-1:0] m_decrypted, // decrypted message
    output               finish

    
);

wire KeyGenFinish, EncryptFinish;
reg  EncryptStart, DecryptStart;
wire [  WIDTH-1:0] e; // public key
wire [2*WIDTH-1:0] d; // private key (d = e^-1 mod (p-1)*(q-1))
wire [2*WIDTH-1:0] n; // modulus (p*q)
wire [2*WIDTH-1:0] c; // encrypted message

reg  [2*WIDTH-1:0] m_reg, m_nxt;
reg  [  WIDTH-1:0] e_reg, e_nxt;
reg  [2*WIDTH-1:0] d_reg, d_nxt;
reg  [2*WIDTH-1:0] n_reg, n_nxt;
reg  [2*WIDTH-1:0] c_reg, c_nxt;

// read input
always @(*) begin
    m_nxt = m_reg;
    e_nxt = e_reg;
    d_nxt = d_reg;
    n_nxt = n_reg;
    c_nxt = c_reg;
    if (KeyGenStart) begin
        m_nxt = m;
    end
    if (KeyGenFinish) begin
        e_nxt = e;
        d_nxt = d;
        n_nxt = n;
    end
    if (EncryptFinish) begin
        c_nxt = c;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        m_reg <= 0;
        e_reg <= 0;
        d_reg <= 0;
        n_reg <= 0;
        c_reg <= 0;
    end else begin
        m_reg <= m_nxt;
        e_reg <= e_nxt;
        d_reg <= d_nxt;
        n_reg <= n_nxt;
        c_reg <= c_nxt;
    end
end

// start signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        EncryptStart <= 0;
        DecryptStart <= 0;
    end else begin
        EncryptStart <= KeyGenFinish;
        DecryptStart <= EncryptFinish;
    end
end

// module instantiation

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
    .start(EncryptStart),
    .m(m_reg), // original message
    .e(e_reg), // public key
    .n(n_reg), // modulus (p*q)
    // output
    .c(c), // encrypted message
    .finish(EncryptFinish)
);

RSA_decrypt rsa_decrypt0( // (m = c^d mod n)
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(DecryptStart),
    .c(c_reg), // encrypted message
    .d(d_reg), // private key
    .n(n_reg), // modulus (p*q)
    // output
    .m_decrypted(m_decrypted), // decrypted message
    .finish(finish)
);


reg assumePrime_p;
reg assumePrime_q;

CheckPrime_comb check_p(
        .num(p),
        .AssumePrime(assumePrime_p)
);

CheckPrime_comb check_q(
        .num(q),
        .AssumePrime(assumePrime_q)
);


endmodule