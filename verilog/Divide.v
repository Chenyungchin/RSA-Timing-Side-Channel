module Divide #(parameter WIDTH = 8) (
    // input
    input                    clk,
    input                    rst_n,
    input                    start,
    input      [  WIDTH-1:0] dividend, // bigger one
    input      [  WIDTH-1:0] divisor,  // smaller one
    // output
    output     [  WIDTH-1:0] quotient,
    output     [  WIDTH-1:0] remainder,
    output reg               finish
);

// state
parameter IDLE = 0;
parameter CALC = 1;

// wire and reg
reg [  WIDTH-1: 0] cnt, cnt_nxt;
reg [2*WIDTH-1: 0] accumulator, accumulator_nxt;
reg [        2: 0] state, state_nxt;
reg                finish_nxt;
reg [  WIDTH-1: 0] dividend_reg, divisor_reg, dividend_nxt, divisor_nxt;

// assign
assign quotient = accumulator[WIDTH-1: 0];
assign remainder = accumulator[2*WIDTH-1: WIDTH];

// state transition
always @(*) begin
    state_nxt = state;
    if (state == IDLE) begin
        if (start) begin
            state_nxt = CALC;
        end
    end else begin
        if (cnt == WIDTH-1) begin
            state_nxt = IDLE;
        end
    end 
end

// read input to register
always @(*) begin
    dividend_nxt = dividend_reg;
    divisor_nxt = divisor_reg;
    if (state == IDLE && start) begin
        dividend_nxt = dividend;
        divisor_nxt = divisor;
    end
end

// accumulator
always @(*) begin
    if (state == IDLE) begin
        accumulator_nxt = 0;
        if (start) begin
            accumulator_nxt[WIDTH-1: 0] = dividend; // should be fetched from input
        end
    end else begin // state == CALC
        if ($unsigned(accumulator[2*WIDTH-2: WIDTH-1] >= $unsigned(divisor_reg))) begin
            accumulator_nxt[2*WIDTH-1: WIDTH] = accumulator[2*WIDTH-2: WIDTH-1] - divisor_reg;
            accumulator_nxt[WIDTH-1: 1] = accumulator[WIDTH-2: 0];
            accumulator_nxt[0] = 1;
        end else begin
            accumulator_nxt[2*WIDTH-1: WIDTH] = accumulator[2*WIDTH-2: WIDTH-1];
            accumulator_nxt[WIDTH-1: 1] = accumulator[WIDTH-2: 0];
            accumulator_nxt[0] = 0;
        end
    end
end

// count
always @(*) begin
    finish_nxt = 0;
    if (state == IDLE) begin
        cnt_nxt = 0;
    end else begin
        if (cnt == WIDTH-1) begin
            cnt_nxt = 0;
            finish_nxt = 1;
        end 
        else begin
            cnt_nxt = cnt + 1;
        end
    end
end

always @(posedge clk or negedge !rst_n) begin
    if (!rst_n) begin
        state        <= IDLE;
        cnt          <= 0;
        finish       <= 0;
        dividend_reg <= 0;
        divisor_reg  <= 0;
        accumulator  <= 0;
    end else begin 
        state        <= state_nxt;
        cnt          <= cnt_nxt;
        finish       <= finish_nxt;
        dividend_reg <= dividend_nxt;
        divisor_reg  <= divisor_nxt;
        accumulator  <= accumulator_nxt;
    end
end



endmodule