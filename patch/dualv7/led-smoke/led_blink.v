module led_blink(
    input wire s2cclk_1_p,
    input wire s2cclk_1_n,
    input wire reset_sw1,
    output wire led0,
    output wire led1,
    output wire led2
);
    wire clk_in;
    wire clk;
    wire reset = ~reset_sw1;
    reg [26:0] counter = 27'd0;

    IBUFDS #(
        .DIFF_TERM("FALSE"),
        .IBUF_LOW_PWR("TRUE"),
        .IOSTANDARD("DIFF_HSTL_II_18")
    ) clk_ibufds (
        .I(s2cclk_1_p),
        .IB(s2cclk_1_n),
        .O(clk_in)
    );

    BUFG clk_bufg (
        .I(clk_in),
        .O(clk)
    );

    always @(posedge clk) begin
        if (reset) begin
            counter <= 27'd0;
        end else begin
            counter <= counter + 27'd1;
        end
    end

    assign led0 = counter[24];
    assign led1 = counter[25];
    assign led2 = counter[26];
endmodule
