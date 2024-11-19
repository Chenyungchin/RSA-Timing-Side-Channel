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

// tmp
assign e = 0;
assign finish = 0;

endmodule