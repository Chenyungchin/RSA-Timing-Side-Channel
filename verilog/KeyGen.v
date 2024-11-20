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
parameter DONE = 3;

reg [2:0] state, state_nxt;

endmodule