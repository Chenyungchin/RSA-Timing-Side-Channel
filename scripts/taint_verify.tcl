analyze -sv {flattened/RSA_t_verify.v verilog/CheckPrime_comb.v}
elaborate -top RSA_taint

clock clk 
reset ~rst_n

assume {p!=q};

assume {KeyGenStart |-> (assumePrime_p && assumePrime_q)};

assume {~clk__t && ~rst_n__t && ~KeyGenStart__t && p__t==8'b1 && q__t==8'b1 && m__t==8'b0};

assert -name information_flow {~finish__t};

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

visualize -get_value p -radix 10
visualize -get_value p__t -radix 2
visualize -get_value q -radix 10
visualize -get_value q__t -radix 2

visualize -get_value m -radix 2

visualize -get_value start KeyGenStart-radix 2

visualize -get_value finish -radix 2
visualize -get_value finish__t -radix 2

exit