module RSA_decrypt #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                start,
    input  [2*WIDTH-1:0] c, // encrypted message
    input  [2*WIDTH-1:0] d, // private key
    input  [2*WIDTH-1:0] n, // modulus (p*q)
    // output
    output [2*WIDTH-1:0] m_decrypted, // decrypted message
    output reg           finish
);

// state
parameter IDLE = 0;
parameter CALC = 1;

// ========= wire and reg ==========
reg  [2*WIDTH-1: 0] cnt, cnt_nxt;
reg  [        2: 0] state, state_nxt;

reg  [2*WIDTH-1: 0] c_reg, c_nxt;
reg  [2*WIDTH-1: 0] d_reg, d_nxt;
reg  [2*WIDTH-1: 0] n_reg, n_nxt;

reg  [2*WIDTH-1: 0] m_decrypted_reg, m_decrypted_nxt;

// for mult
reg                MultStart, MultStart_nxt;
wire [4*WIDTH-1:0] MultOut;
wire               MultFinish;

// for divide
wire [4*WIDTH-1:0] remainder;
wire               DivideFinish;

// for finish
reg                finish_nxt;

// ========= assignment ========
assign m_decrypted = m_decrypted_reg;


// state transition
always @(*) begin
    state_nxt = state;
    if (state == IDLE) begin
        if (start) begin
            state_nxt = CALC;
        end
    end else begin
        if (DivideFinish && cnt == d_reg - 1) begin
            state_nxt = IDLE;
        end
    end 
end

// read input to register
always @(*) begin
    c_nxt = c_reg;
    d_nxt = d_reg;
    n_nxt = n_reg;
    if (state == IDLE && start) begin
        c_nxt = c;
        d_nxt = d;
        n_nxt = n;
    end
end

// cnt 
always @(*) begin
    cnt_nxt = cnt;
    if (state == IDLE) begin
        cnt_nxt = 0;
    end else begin
        if (DivideFinish) begin
            if (cnt < d_reg) begin
                cnt_nxt = cnt + 1;
            end
            else begin
                cnt_nxt = 0;
            end
        end
    end
end

// finish
always @(*) begin
    finish_nxt = 0;
    if (state == CALC && DivideFinish && cnt == d_reg - 1) begin
        finish_nxt = 1;
    end
end

// m_decrypted
always @(*) begin
    if (state == IDLE) begin
        m_decrypted_nxt = 1;
    end else begin
        if (DivideFinish) begin
            m_decrypted_nxt = remainder[2*WIDTH-1: 0];
        end
    end
end



// MultStart
always @(*) begin
    MultStart_nxt = 0;
    if (state == IDLE && start) begin
        MultStart_nxt = 1;
    end else if (state == CALC && DivideFinish && cnt < d_reg - 1) begin
        MultStart_nxt = 1;
    end
end



// ========= Sequential Logic =========
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state            <= IDLE;
        cnt              <= 0;
        finish           <= 0;
        c_reg            <= 0;
        d_reg            <= 0;
        n_reg            <= 0;
        m_decrypted_reg  <= 1;
        MultStart        <= 0;
    end else begin
        state            <= state_nxt;
        cnt              <= cnt_nxt;
        finish           <= finish_nxt;
        c_reg            <= c_nxt;
        d_reg            <= d_nxt;
        n_reg            <= n_nxt;
        m_decrypted_reg  <= m_decrypted_nxt;
        MultStart        <= MultStart_nxt;
    end
end

// ========= module instantiation =========
// mult
Mult #(.WIDTH(2*WIDTH)) mult0(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(MultStart),
    .in1(m_decrypted_reg),
    .in2(c_reg),
    // output
    .out(MultOut),
    .finish(MultFinish)
);

// divide
Divide #(.WIDTH(4*WIDTH)) divide0(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(MultFinish),
    .dividend(MultOut),
    .divisor({{2*WIDTH{1'b0}}, n_reg}),
    // output
    .quotient(),
    .remainder(remainder),
    .finish(DivideFinish)
);

endmodule