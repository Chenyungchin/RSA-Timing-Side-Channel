module Mult #(parameter WIDTH = 8) (
    // input
    input                    clk,
    input                    rst_n,
    input                    start,
    input      [  WIDTH-1:0] in1,
    input      [  WIDTH-1:0] in2,
    // output
    output reg [2*WIDTH-1:0] out,
    output reg               finish
);

// state
parameter IDLE = 0;
parameter CALC = 1;

// wire and reg
reg [  WIDTH-1: 0] cnt, cnt_nxt;
reg [2*WIDTH-1: 0] out_nxt;
reg [        2: 0] state, state_nxt;
reg                finish_nxt;
reg [  WIDTH-1: 0] in1_reg, in2_reg, in1_nxt, in2_nxt;

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
    in1_nxt = in1_reg;
    in2_nxt = in2_reg;
    if (state == IDLE && start) begin
        in1_nxt = in1;
        in2_nxt = in2;
    end
end

// output
always @(*) begin
    if (state == IDLE) begin
        out_nxt = 0;
    end else begin
        if (in1_reg[cnt]) out_nxt = out + (in2_reg << cnt);
        else          out_nxt = out;
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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state   <= IDLE;
        cnt     <= 0;
        out     <= 0;
        finish  <= 0;
        in1_reg <= 0;
        in2_reg <= 0;
    end else begin
        state   <= state_nxt;
        cnt     <= cnt_nxt;
        out     <= out_nxt;
        finish  <= finish_nxt;
        in1_reg <= in1_nxt;
        in2_reg <= in2_nxt;
    end
end



endmodule