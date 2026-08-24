// SPDX-License-Identifier: BSD-2-Clause
// @file warm_reset_pulse.v
// @date 2026-05-20
// @brief Self-clearing warm reset pulse generator
//        Generates a ~100us reset pulse on rising edge of trigger.
//        PULSE_CYCLES=10000 @ 100MHz = 100us (covers MMCM relock <50us)

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_out RST" *)
(* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)

module warm_reset_pulse (
    input  wire clk,
    input  wire trigger,
    output wire reset_out
);

    parameter PULSE_CYCLES = 10000;

    reg [13:0] counter;
    reg        active;
    reg        trigger_d;

    always @(posedge clk) begin
        trigger_d <= trigger;
        if (trigger && !trigger_d && !active) begin
            active   <= 1'b1;
            counter  <= 0;
        end else if (active) begin
            if (counter < PULSE_CYCLES - 1) begin
                counter <= counter + 1;
            end else begin
                active  <= 1'b0;
                counter <= 0;
            end
        end
    end

    assign reset_out = active;

endmodule
