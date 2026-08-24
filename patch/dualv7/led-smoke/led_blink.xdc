set_property PACKAGE_PIN L4 [get_ports s2cclk_1_p]
set_property PACKAGE_PIN L3 [get_ports s2cclk_1_n]
set_property IOSTANDARD DIFF_HSTL_II_18 [get_ports s2cclk_1_p]
set_property IOSTANDARD DIFF_HSTL_II_18 [get_ports s2cclk_1_n]
create_clock -period 10.000 -name s2cclk_1 [get_ports s2cclk_1_p]

set_property PACKAGE_PIN AP31 [get_ports reset_sw1]
set_property IOSTANDARD LVCMOS18 [get_ports reset_sw1]
set_property PULLUP TRUE [get_ports reset_sw1]

set_property PACKAGE_PIN AH44 [get_ports led0]
set_property PACKAGE_PIN AH43 [get_ports led1]
set_property PACKAGE_PIN AL40 [get_ports led2]
set_property IOSTANDARD LVCMOS18 [get_ports {led0 led1 led2}]

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
