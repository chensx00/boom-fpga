# DualV7 SD Card (TF Card via J8 sub-card, MMC1 interface)
# IO standard: LVCMOS18 (Bank 11/12, consistent with all board I/O)

set_property PACKAGE_PIN AT37 [get_ports {sdio_clk}]
set_property PACKAGE_PIN AT38 [get_ports {sdio_cmd}]
set_property PACKAGE_PIN BA43 [get_ports {sdio_dat[0]}]
set_property PACKAGE_PIN AY43 [get_ports {sdio_dat[1]}]
set_property PACKAGE_PIN AW44 [get_ports {sdio_dat[2]}]
set_property PACKAGE_PIN AW43 [get_ports {sdio_dat[3]}]
set_property PACKAGE_PIN BA39 [get_ports {sdio_cd}]

set_property IOSTANDARD LVCMOS18 [get_ports {sdio_clk}]
set_property IOSTANDARD LVCMOS18 [get_ports {sdio_cmd}]
set_property IOSTANDARD LVCMOS18 [get_ports {sdio_dat[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sdio_cd}]

set_property IOB TRUE [get_ports {sdio_clk}]
set_property IOB TRUE [get_ports {sdio_cmd}]
set_property IOB TRUE [get_ports {sdio_dat[*]}]
set_property PULLUP TRUE [get_ports {sdio_cd}]
