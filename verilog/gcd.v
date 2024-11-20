module gcd #(parameter WIDTH = 8) (
    // input 
    input                    clk,
    input                    rst_n,
    input                    start,
    input      [2*WIDTH-1:0] a, // bigger one
    input      [2*WIDTH-1:0] b, // smaller one
    // output
    output reg [2*WIDTH-1:0] gcd,
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

// ================== Sequential Logic ==================
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state       <= IDLE;
        dividend    <= 0;
        divisor     <= 0;
        DivideStart <= 0;
        gcd         <= 0;
        finish      <= 0;
    end else begin
        state       <= state_nxt;
        dividend    <= dividend_nxt;
        divisor     <= divisor_nxt;
        DivideStart <= DivideStart_nxt;
        gcd         <= gcd_nxt;
        finish      <= finish_nxt;
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