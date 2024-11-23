analyze -sv -f verilog/KeyGen.f
elaborate -top top

clock clk 
reset ~rst_n


assume {p_1 != q_1 && p_2 != q_2};

assume {assumePrime_p1 && assumePrime_q1 && assumePrime_p2 && assumePrime_q2};

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

visualize -get_value p_1 -radix 10
visualize -get_value q_1 -radix 10
visualize -get_value p_2 -radix 10
visualize -get_value q_2 -radix 10

visualize -get_value finish_1 -radix 2
visualize -get_value finish_2 -radix 2

exit