// SPDX-License-Identifier: BSD-2-Clause
// @file soc_clk_mux.v
// @date 2026-05-21
// @brief 7-to-1 BUFGMUX_1 tree for soc_clk profile selection
//        Uses BUFGMUX_1 to allow non-adjacent BUFG placement
//        on multi-SLR xc7v2000t

module soc_clk_mux (
    input  wire clk_in0,
    input  wire clk_in1,
    input  wire clk_in2,
    input  wire clk_in3,
    input  wire clk_in4,
    input  wire clk_in5,
    input  wire clk_in6,
    input  wire [2:0] sel,
    output wire clk_out
);

    wire clk_l1_0, clk_l1_1, clk_l1_2, clk_l1_3;
    wire clk_l2_0, clk_l2_1;

    BUFGMUX_1 #(.CLK_SEL_TYPE("ASYNC"))
        u_l1_0 (.O(clk_l1_0), .I0(clk_in0), .I1(clk_in1), .S(sel[0]));
    BUFGMUX_1 #(.CLK_SEL_TYPE("ASYNC"))
        u_l1_1 (.O(clk_l1_1), .I0(clk_in2), .I1(clk_in3), .S(sel[0]));
    BUFGMUX_1 #(.CLK_SEL_TYPE("ASYNC"))
        u_l1_2 (.O(clk_l1_2), .I0(clk_in4), .I1(clk_in5), .S(sel[0]));
    BUFGMUX_1 #(.CLK_SEL_TYPE("ASYNC"))
        u_l1_3 (.O(clk_l1_3), .I0(clk_in6), .I1(1'b0),    .S(sel[0]));

    BUFGMUX_1 #(.CLK_SEL_TYPE("ASYNC"))
        u_l2_0 (.O(clk_l2_0), .I0(clk_l1_0), .I1(clk_l1_1), .S(sel[1]));
    BUFGMUX_1 #(.CLK_SEL_TYPE("ASYNC"))
        u_l2_1 (.O(clk_l2_1), .I0(clk_l1_2), .I1(clk_l1_3), .S(sel[1]));

    BUFGMUX_1 #(.CLK_SEL_TYPE("ASYNC"))
        u_l3_0 (.O(clk_out),   .I0(clk_l2_0), .I1(clk_l2_1), .S(sel[2]));

endmodule
