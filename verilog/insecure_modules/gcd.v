module gcd #(parameter WIDTH = 8) (
    // input 
    input                    clk,
    input                    rst_n,
    input                    start,
    input      [2*WIDTH-1:0] a, // bigger one
    input      [2*WIDTH-1:0] b, // smaller one
    // output
    output reg [2*WIDTH-1:0] gcd,
    output     [2*WIDTH-1:0] s, // s*a + t*b = gcd(a, b)
    output     [2*WIDTH-1:0] t,
    output reg               finish
);

// parameter
parameter IDLE = 0;
parameter CALC = 1;

// wire and reg
reg  [        2: 0] state, state_nxt;
reg  [2*WIDTH-1: 0] dividend, dividend_nxt;
reg  [2*WIDTH-1: 0] divisor, divisor_nxt;
wire [2*WIDTH-1: 0] quotient, remainder;
reg                DivideStart, DivideStart_nxt;
wire               DivideFinish;

reg  [2*WIDTH-1: 0] gcd_nxt;
reg                finish_nxt;

// extended gcd
reg  [2*WIDTH-1: 0] s1, s2, s3, t1, t2, t3;
reg  [2*WIDTH-1: 0] s1_nxt, s2_nxt, s3_nxt, t1_nxt, t2_nxt, t3_nxt;
reg  [2*WIDTH-1: 0] cnt, cnt_nxt;

// assignment 
assign s = s2;
assign t = t2;

// state transition
always @(*) begin
    state_nxt = state;
    if (state == IDLE && start) begin
        state_nxt = CALC;
    end else if (state == CALC && DivideFinish && remainder == 0) begin
        state_nxt = IDLE;
    end
end

// DivideStart
always @(*) begin
    DivideStart_nxt = 1'b0;
    if (state == IDLE && start) begin
        DivideStart_nxt = 1'b1;
    end else if (state == CALC && DivideFinish && remainder != 0) begin
        DivideStart_nxt = 1'b1;
    end
end

// dividend and divisor
always @(*) begin
    dividend_nxt = dividend;
    divisor_nxt = divisor;
    if (state == IDLE && start) begin
        dividend_nxt = a;
        divisor_nxt = b;
    end else if (state == CALC && DivideFinish && remainder != 0) begin
        dividend_nxt = divisor;
        divisor_nxt = remainder;
    end else if (state == CALC && DivideFinish && remainder == 0) begin
        dividend_nxt = 0;
        divisor_nxt = 0;
    end
end

// gcd and finish
always @(*) begin
    gcd_nxt = 0;
    finish_nxt = 1'b0;
    if (state == CALC && DivideFinish && remainder == 0) begin
        gcd_nxt = divisor;
        finish_nxt = 1'b1;
    end
end

// === extended gcd ===
always @(*) begin
    cnt_nxt = cnt;
    if (state == CALC && DivideFinish && remainder != 0) cnt_nxt = cnt + 1;
    else if (state == CALC && DivideFinish && remainder == 0) cnt_nxt = 0;
end

always @(*) begin
    s1_nxt = s1;
    s2_nxt = s2;
    s3_nxt = s3;
    t1_nxt = t1;
    t2_nxt = t2;
    t3_nxt = t3;
    if (state == CALC && DivideFinish) begin
        if (cnt == 0) begin
            s1_nxt = 1;
            s2_nxt = 0;
            s3_nxt = 1;
            t1_nxt = 0;
            t2_nxt = 1;
            t3_nxt = -quotient;
        end
        else begin
            s1_nxt = s2;
            s2_nxt = s3;
            s3_nxt = s2 - quotient * s3;
            t1_nxt = t2;
            t2_nxt = t3;
            t3_nxt = t2 - quotient * t3;
        end
    end
end

// ================== Sequential Logic ==================
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state       <= IDLE;
        dividend    <= 0;
        divisor     <= 0;
        DivideStart <= 0;
        gcd         <= 0;
        finish      <= 0;
        cnt         <= 0;
    end else begin
        state       <= state_nxt;
        dividend    <= dividend_nxt;
        divisor     <= divisor_nxt;
        DivideStart <= DivideStart_nxt;
        gcd         <= gcd_nxt;
        finish      <= finish_nxt;
        cnt         <= cnt_nxt;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        s1 <= 0;
        s2 <= 0;
        s3 <= 0;
        t1 <= 0;
        t2 <= 0;
        t3 <= 0;
    end else begin
        s1 <= s1_nxt;
        s2 <= s2_nxt;
        s3 <= s3_nxt;
        t1 <= t1_nxt;
        t2 <= t2_nxt;
        t3 <= t3_nxt;
    end
end
// instantiate Divide module
Divide #(.WIDTH(2*WIDTH)) divide0(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(DivideStart),
    .dividend(dividend),
    .divisor(divisor),
    // output
    .quotient(quotient),
    .remainder(remainder),
    .finish(DivideFinish)
);

endmodule