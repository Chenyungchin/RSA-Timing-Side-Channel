module KeyGen #(parameter WIDTH = 8)(
    // input
    input               clk,
    input              rst_n,
    input              start,
    input  [WIDTH-1:0] p, // prime number 1
    input  [WIDTH-1:0] q, // prime number 2
    // output
    output [WIDTH-1:0] e, // public key
    output             finish
);

// step1: calculate phi = (p-1)*(q-1)
// step2: starting from e = 3, find the first e that is coprime with phi

parameter IDLE = 0;
parameter CALC_PHI = 1;
parameter FIND_E = 2;

// reg and wire
reg  [        2:0] state, state_nxt;
wire [2*WIDTH-1:0] phi_out;
wire               MultFinish;
wire               DivideFinish;

reg  [2*WIDTH-1:0] phi;

// instantiate Mult module
Mult #(.WIDTH(WIDTH)) mult0(
    // input
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .in1(p-1'b1),
    .in2(q-1'b1),
    // output
    .out(phi_out),
    .finish(MultFinish)
);


// ========= Sequential Logic =========
// phi
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phi <= 0;
    end else begin
        if (MultFinish) phi <= phi_out;
        else            phi <= phi;
    end
end

endmodule