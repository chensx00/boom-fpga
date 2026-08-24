# Clock Constraints 100MHz
set_property PACKAGE_PIN L4 [get_ports sys_diff_clock_clk_p]
set_property IOSTANDARD DIFF_HSTL_II_18 [get_ports sys_diff_clock_clk_p]
set_property PACKAGE_PIN L3 [get_ports sys_diff_clock_clk_n]
set_property IOSTANDARD DIFF_HSTL_II_18 [get_ports sys_diff_clock_clk_n]

create_clock -period 10 -name pclk1_p [get_ports sys_diff_clock_clk_p]

# Reset Constraints
# SW1 (AP31) is Active Low
set_property PACKAGE_PIN AP31 [get_ports reset]
set_property IOSTANDARD LVCMOS18 [get_ports reset]
set_property PULLUP TRUE [get_ports reset]

# GPIO LEDs, active-high (019x temporary)
set_property PACKAGE_PIN AH44 [get_ports {leds[0]}]
set_property PACKAGE_PIN AH43 [get_ports {leds[1]}]
set_property PACKAGE_PIN AL40 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds[0] leds[1] leds[2]}]
