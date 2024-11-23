module KeyGen #(parameter WIDTH = 8)(
    // input
    input                    clk,
    input                    rst_n,
    input                    start,
    input      [  WIDTH-1:0] p, // prime number 1
    input      [  WIDTH-1:0] q, // prime number 2
    // output
    output reg [  WIDTH-1:0] e, // public key
    output reg [2*WIDTH-1:0] d, // private key (is t (mod phi))
    output reg [2*WIDTH-1:0] n, // modulus (p*q)
    output reg               finish
);

// step1: calculate phi = (p-1)*(q-1)
// step2: starting from e = 3, find the first e that is coprime with phi

// reg and wire
wire [2*WIDTH-1:0] phi_out;
wire [2*WIDTH-1:0] n_out;
wire               MultPhiFinish, MultNFinish;
wire               gcdFinish;

reg  [2*WIDTH-1:0] phi;
reg                gcdStart, gcdStart_nxt;

wire [2*WIDTH-1:0] gcd;
wire [2*WIDTH-1:0] s, t;

// gcdStart
always @(*) begin
    gcdStart_nxt = 1'b0;
    if (MultPhiFinish) begin
        gcdStart_nxt = 1'b1;
    end else if (gcdFinish && gcd != 1) begin
        gcdStart_nxt = 1'b1;
    end
end

// ========= Sequential Logic =========
// phi
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phi <= 0;
    end else begin
        if (MultPhiFinish) phi <= phi_out;
        else               phi <= phi;
    end
end

// n
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        n <= 0;
    end else begin
        if (MultNFinish) n <= n_out;
        else             n <= n;
    end
end

// finish
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        finish <= 0;
    end else begin
        if (gcdFinish) begin
            if (gcd == 1) finish <= 1;
            else          finish <= 0;
        end else begin
            finish <= 0;
        end
    end
end

// e
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        e <= 3; // the minimum possible value for e
    end else begin
        if (start) begin
            e <= e;
        end else if (gcdFinish) begin
            if (gcd == 1) e <= e;
            else          e <= e + 2;
        end else begin
            e <= e;
        end

    end
end

// d
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        d <= 0;
    end else begin
        if (gcdFinish && gcd == 1) begin
            if ($signed(t) < 0) d <= t + phi;
            else                d <= t;
        end else begin
            d <= 0;
        end
    end
end

// others
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gcdStart <= 0;
    end else begin
        gcdStart <= gcdStart_nxt;
    end
end

// =========== Module Instantiation ===========

// instantiate Mult module
Mult #(.WIDTH(WIDTH)) mult_phi(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .in1(p-1'b1),
    .in2(q-1'b1),
    // output
    .out(phi_out),
    .finish(MultPhiFinish)
);

Mult #(.WIDTH(WIDTH)) mult_n(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .in1(p),
    .in2(q),
    // output
    .out(n_out),
    .finish(MultNFinish)
);

// instantiate gcd module
gcd #(.WIDTH(WIDTH)) gcd0(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(gcdStart),
    .a(phi),
    .b({{WIDTH{1'b0}}, e}),
    // output
    .gcd(gcd),
    .s(s),
    .t(t),
    .finish(gcdFinish)
);

endmodule