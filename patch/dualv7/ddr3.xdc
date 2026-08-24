# CLOCK_DEDICATED_ROUTE: external MMCM (clk_wiz_0) to MIG internal PLL
# crosses CMT columns; BACKBONE route insufficient.
# Using wildcard to cover both pre- and post-opt net names.
set_property CLOCK_DEDICATED_ROUTE FALSE     [get_nets -quiet -hierarchical -filter {NAME =~ *ddr3_sys_clk*}]

# DRC severity downgrades for ports not wired on S2C DualV7 board
# sdio_*, rs232_uart_ctsn/rtsn, fan_en: exist in BD but no board pin
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
set_property SEVERITY {Warning} [get_drc_checks CFGBVS-1]
set_property SEVERITY {Warning} [get_drc_checks CFGBVS-2]
