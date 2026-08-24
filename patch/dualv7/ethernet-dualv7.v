module ethernet_dualv7 (
    input  wire        reset,
    input  wire        clock,        // from BD system clock (logic_clk)

    // AXIS TX (from ethernet.v)
    input  wire [7:0]  tx_axis_tdata,
    input  wire [0:0]  tx_axis_tkeep,
    input  wire        tx_axis_tvalid,
    output wire        tx_axis_tready,
    input  wire        tx_axis_tlast,
    input  wire        tx_axis_tuser,

    // AXIS RX (to ethernet.v)
    output wire [7:0]  rx_axis_tdata,
    output wire [0:0]  rx_axis_tkeep,
    output wire        rx_axis_tvalid,
    input  wire        rx_axis_tready,
    output wire        rx_axis_tlast,
    output wire        rx_axis_tuser,

    output wire [15:0] status_vector,

    // MII board signals (PHY clocks are inputs)
    input  wire        phy_tx_clk,   // 25MHz from PHY, AR26
    input  wire        phy_rx_clk,   // 25MHz from PHY, AT23
    output wire [3:0]  mii_txd,
    output wire        mii_tx_en,
    input  wire [3:0]  mii_rxd,
    input  wire        mii_rx_dv,
    input  wire        mii_rx_er,
    // col/crs not connected to eth_mac_mii_fifo (half-duplex unused)
    input  wire        mii_col,
    input  wire        mii_crs
);

wire tx_error_underflow;
wire tx_fifo_overflow;
wire tx_fifo_bad_frame;
wire tx_fifo_good_frame;
wire rx_error_bad_frame;
wire rx_error_bad_fcs;
wire rx_fifo_overflow;
wire rx_fifo_bad_frame;
wire rx_fifo_good_frame;

assign status_vector[15:11] = 5'b0;
assign status_vector[10:9]  = 2'b01;
assign status_vector[8]     = rx_fifo_good_frame;
assign status_vector[7]     = rx_fifo_bad_frame;
assign status_vector[6]     = rx_fifo_overflow;
assign status_vector[5]     = rx_error_bad_fcs;
assign status_vector[4]     = rx_error_bad_frame;
assign status_vector[3]     = tx_error_underflow;
assign status_vector[2]     = tx_fifo_good_frame;
assign status_vector[1]     = tx_fifo_bad_frame;
assign status_vector[0]     = tx_fifo_overflow;

eth_mac_mii_fifo #(
    .TARGET("XILINX"),
    .CLOCK_INPUT_STYLE("BUFG"),
    .AXIS_DATA_WIDTH(8),
    .ENABLE_PADDING(1),
    .MIN_FRAME_LENGTH(64),
    .TX_FIFO_DEPTH(4096),
    .TX_FRAME_FIFO(1),
    .RX_FIFO_DEPTH(16384),
    .RX_FRAME_FIFO(1),
    .RX_DROP_BAD_FRAME(0),
    .RX_DROP_WHEN_FULL(1)
)
eth_mac_inst (
    .rst(reset),
    .logic_clk(clock),
    .logic_rst(reset),

    .tx_axis_tdata(tx_axis_tdata),
    .tx_axis_tkeep(tx_axis_tkeep),
    .tx_axis_tvalid(tx_axis_tvalid),
    .tx_axis_tready(tx_axis_tready),
    .tx_axis_tlast(tx_axis_tlast),
    .tx_axis_tuser(tx_axis_tuser),

    .rx_axis_tdata(rx_axis_tdata),
    .rx_axis_tkeep(rx_axis_tkeep),
    .rx_axis_tvalid(rx_axis_tvalid),
    .rx_axis_tready(rx_axis_tready),
    .rx_axis_tlast(rx_axis_tlast),
    .rx_axis_tuser(rx_axis_tuser),

    .mii_rx_clk(phy_rx_clk),
    .mii_rxd(mii_rxd),
    .mii_rx_dv(mii_rx_dv),
    .mii_rx_er(mii_rx_er),
    .mii_tx_clk(phy_tx_clk),
    .mii_txd(mii_txd),
    .mii_tx_en(mii_tx_en),
    .mii_tx_er(),

    .tx_error_underflow(tx_error_underflow),
    .tx_fifo_overflow(tx_fifo_overflow),
    .tx_fifo_bad_frame(tx_fifo_bad_frame),
    .tx_fifo_good_frame(tx_fifo_good_frame),
    .rx_error_bad_frame(rx_error_bad_frame),
    .rx_error_bad_fcs(rx_error_bad_fcs),
    .rx_fifo_overflow(rx_fifo_overflow),
    .rx_fifo_bad_frame(rx_fifo_bad_frame),
    .rx_fifo_good_frame(rx_fifo_good_frame),

    .cfg_ifg(8'd12),
    .cfg_tx_enable(1'b1),
    .cfg_rx_enable(1'b1)
);

endmodule
