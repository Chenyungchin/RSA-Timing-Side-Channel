module RSA_encrypt #(parameter WIDTH = 8)(
    // input
    input                clk,
    input                rst_n,
    input                start,
    input  [2*WIDTH-1:0] m, // original message
    input  [  WIDTH-1:0] e, // public key
    input  [2*WIDTH-1:0] n, // modulus (p*q)
    // output
    output [2*WIDTH-1:0] c, // encrypted message
    output reg           finish
);

// state
parameter IDLE = 0;
parameter CALC = 1;

// ========= wire and reg ==========
reg  [2*WIDTH-1: 0] cnt, cnt_nxt;
reg  [        2: 0] state, state_nxt;

reg  [2*WIDTH-1: 0] m_reg, m_nxt;
reg  [  WIDTH-1: 0] e_reg, e_nxt;
reg  [2*WIDTH-1: 0] n_reg, n_nxt;

reg  [2*WIDTH-1: 0] c_reg, c_nxt;

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
assign c = c_reg;


// state transition
always @(*) begin
    state_nxt = state;
    if (state == IDLE) begin
        if (start) begin
            state_nxt = CALC;
        end
    end else begin
        if (DivideFinish && cnt == e_reg - 1) begin
            state_nxt = IDLE;
        end
    end 
end

// read input to register
always @(*) begin
    m_nxt = m_reg;
    e_nxt = e_reg;
    n_nxt = n_reg;
    if (state == IDLE && start) begin
        m_nxt = m;
        e_nxt = e;
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
            if (cnt < e_reg) begin
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
    if (state == CALC && DivideFinish && cnt == e_reg - 1) begin
        finish_nxt = 1;
    end
end

// c
always @(*) begin
    c_nxt = 1;
    if (state == IDLE) begin
        c_nxt = 1;
    end else begin
        if (DivideFinish) begin
            c_nxt = remainder[2*WIDTH-1: 0];
        end
    end
end



// MultStart
always @(*) begin
    MultStart_nxt = 0;
    if (state == IDLE && start) begin
        MultStart_nxt = 1;
    end else if (state == CALC && DivideFinish && cnt < e_reg - 1) begin
        MultStart_nxt = 1;
    end
end



// ========= Sequential Logic =========
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state     <= IDLE;
        cnt       <= 0;
        finish    <= 0;
        m_reg     <= 0;
        e_reg     <= 0;
        n_reg     <= 0;
        c_reg     <= 1;
        MultStart <= 0;
    end else begin
        state     <= state_nxt;
        cnt       <= cnt_nxt;
        finish    <= finish_nxt;
        m_reg     <= m_nxt;
        e_reg     <= e_nxt;
        n_reg     <= n_nxt;
        c_reg     <= c_nxt;
        MultStart <= MultStart_nxt;
    end
end

// ========= module instantiation =========
// mult
Mult #(.WIDTH(2*WIDTH)) mult0(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(MultStart),
    .in1(c_reg),
    .in2(m_reg),
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