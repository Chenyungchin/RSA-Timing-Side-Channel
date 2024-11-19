//~ `New testbench
`timescale  1ns / 1ps

module RSA_tb;

// parameter Parameters
parameter PERIOD  = 10;
parameter WIDTH   = 8;

// parameter Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [WIDTH-1:0]  p                       = 0 ;
reg   [WIDTH-1:0]  q                       = 0 ;
reg   [WIDTH-1:0]  m                       = 0 ;
reg   KeyGenStart                          = 0 ;

// parameter Outputs
wire  [WIDTH-1:0]  m_decrypted             ;
wire  finish                               ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end


RSA rsa0 (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .p                       ( p            [WIDTH-1:0] ),
    .q                       ( q            [WIDTH-1:0] ),
    .m                       ( m            [WIDTH-1:0] ),
    .KeyGenStart             ( KeyGenStart              ),

    .m_decrypted             ( m_decrypted  [WIDTH-1:0] ),
    .finish                  ( finish                   )
);

initial
begin
    $dumpfile("RSA_tb.vcd");
    $dumpvars(0, RSA_tb);
    #(PERIOD*1000);
    $finish;
end

endmodule