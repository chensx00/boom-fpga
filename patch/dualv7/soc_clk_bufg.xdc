# 076x: Allow sub-optimal BUFG-BUFG cascade for soc_clk_mux
# 7 BUFGMUX 3-level tree cannot all be placed adjacent on 7-series
# This is acceptable for experimental bit
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets -of [get_pins \
  soc_clk_mux_0/inst/u_l1_0/O \
  soc_clk_mux_0/inst/u_l1_1/O \
  soc_clk_mux_0/inst/u_l1_2/O \
  soc_clk_mux_0/inst/u_l1_3/O \
  soc_clk_mux_0/inst/u_l2_0/O \
  soc_clk_mux_0/inst/u_l2_1/O \
  ]]
