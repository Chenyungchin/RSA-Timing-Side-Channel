analyze -sv -f verilog/files.f
elaborate -top RSA

clock clk 
reset ~rst_n

check_spv -create -from {p q} -to finish

prove -all

exit