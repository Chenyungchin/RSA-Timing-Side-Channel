analyze -sv -f verilog/files.f
elaborate -top top

clock clk 
reset !rst_n

prove -all

exit