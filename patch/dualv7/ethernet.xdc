# MII Ethernet - KSZ8081 PHY
set_property PACKAGE_PIN AU27 [get_ports mii_tx_en]
set_property PACKAGE_PIN BA25 [get_ports {mii_txd[0]}]
set_property PACKAGE_PIN AY25 [get_ports {mii_txd[1]}]
set_property PACKAGE_PIN BB27 [get_ports {mii_txd[2]}]
set_property PACKAGE_PIN BB26 [get_ports {mii_txd[3]}]
set_property PACKAGE_PIN AR26 [get_ports phy_tx_clk]
set_property PACKAGE_PIN AT23 [get_ports phy_rx_clk]
set_property PACKAGE_PIN AU25 [get_ports mii_rx_dv]
set_property PACKAGE_PIN BC28 [get_ports mii_rx_er]
set_property PACKAGE_PIN AT25 [get_ports {mii_rxd[0]}]
set_property PACKAGE_PIN AR25 [get_ports {mii_rxd[1]}]
set_property PACKAGE_PIN AY27 [get_ports {mii_rxd[2]}]
set_property PACKAGE_PIN AY26 [get_ports {mii_rxd[3]}]
set_property PACKAGE_PIN BA24 [get_ports mii_crs]
set_property PACKAGE_PIN BB25 [get_ports mii_col]
set_property PACKAGE_PIN AP23 [get_ports eth_mdio_data]
set_property PACKAGE_PIN AL23 [get_ports eth_mdio_clock]
set_property PACKAGE_PIN BA18 [get_ports eth_mdio_reset]

set_property IOSTANDARD LVCMOS18 [get_ports mii_tx_en]
set_property IOSTANDARD LVCMOS18 [get_ports {mii_txd[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports phy_tx_clk]
set_property IOSTANDARD LVCMOS18 [get_ports phy_rx_clk]
set_property IOSTANDARD LVCMOS18 [get_ports mii_rx_dv]
set_property IOSTANDARD LVCMOS18 [get_ports mii_rx_er]
set_property IOSTANDARD LVCMOS18 [get_ports {mii_rxd[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports mii_crs]
set_property IOSTANDARD LVCMOS18 [get_ports mii_col]
set_property IOSTANDARD LVCMOS18 [get_ports eth_mdio_data]
set_property IOSTANDARD LVCMOS18 [get_ports eth_mdio_clock]
set_property IOSTANDARD LVCMOS18 [get_ports eth_mdio_reset]

# PHY clock constraints (25MHz = 40ns period)
create_clock -period 40.000 -name phy_tx_clk [get_ports phy_tx_clk]
create_clock -period 40.000 -name phy_rx_clk [get_ports phy_rx_clk]

# MII input/output delays
set_input_delay -clock phy_rx_clk -max 30.0 \
    [get_ports {mii_rxd[*] mii_rx_dv mii_rx_er}]
set_input_delay -clock phy_rx_clk -min -3.0 \
    [get_ports {mii_rxd[*] mii_rx_dv mii_rx_er}]
set_output_delay -clock phy_tx_clk -max 15.0 \
    [get_ports {mii_txd[*] mii_tx_en}]
set_output_delay -clock phy_tx_clk -min -3.0 \
    [get_ports {mii_txd[*] mii_tx_en}]
set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks *clk_out1*] \
    -group [get_clocks -include_generated_clocks phy_tx_clk] \
    -group [get_clocks -include_generated_clocks phy_rx_clk]
