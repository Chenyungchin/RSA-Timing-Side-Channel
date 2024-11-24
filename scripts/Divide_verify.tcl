analyze -sv -f verilog/Divide.f
elaborate -top top

clock clk 
reset ~rst_n


assume {dividend_1 != dividend_2 && divisor_1 != divisor_2};

assert -name information_flow {finish_1 == finish_2};

set_engine_mode {B Ht Mp}

set_prove_time_limit 86400s

prove -property information_flow

get_property_info information_flow -list status
get_property_info information_flow -list time
get_property_info information_flow -list engine
get_property_info information_flow -list trace_length
get_property_info information_flow -list proof_effort
get_property_info information_flow -list min_length

set result [get_property_info information_flow -list status]

if { $result != "cex" } {
    exit
}

visualize -violation -property information_flow

visualize -get_value dividend_1 -radix 10
visualize -get_value divisor_1 -radix 10
visualize -get_value dividend_2 -radix 10
visualize -get_value divisor_2 -radix 10

visualize -get_value finish_1 -radix 2
visualize -get_value finish_2 -radix 2

exit