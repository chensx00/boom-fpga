// SPDX-License-Identifier: BSD-2-Clause
// @file soc_clk_bufgmux.v
// @date 2026-05-21
// @brief Simple 2:1 BUFGMUX for soc_clk profile (10/20MHz)

module soc_clk_bufgmux (
    input  wire clk_in0,
    input  wire clk_in1,
    input  wire sel,
    output wire clk_out
);
    BUFGMUX #(.CLK_SEL_TYPE("SYNC"))
        u_mux (.O(clk_out), .I0(clk_in0), .I1(clk_in1), .S(sel));
endmodule
