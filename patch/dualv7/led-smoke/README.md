# DualV7 LED smoke test

This is a standalone Vivado smoke test for the S2C Dual Virtex-7 TAI LM
board. It does not use Rocket, DDR, UART, SDIO, or Ethernet.

Validated result from task 018x:

- Part: `xc7v2000tflg1925-1`
- Clock: `s2cclk_1_p/n`, 100 MHz, pins `L4`/`L3`
- Reset: SW1, pin `AP31`, active-low
- LEDs: `AH44`, `AH43`, `AL40`, active-high
- Timing: WNS `+8.473 ns`, WHS `+0.205 ns`, WPWS `+4.650 ns`
- DRC: 0 errors

Build on the synthesis server:

```sh
source /tools/Xilinx/2025.1/Vivado/settings64.sh
export XILINXD_LICENSE_FILE=/home/zzx/vivado/Xilinx_lic/vivado_lic2037.lic
cd ~/vivado-risc-v/board/dualv7/led-smoke
vivado -mode batch -source build.tcl
```

The bitstream is generated at:

```text
led_blink.runs/impl_1/led_blink.bit
```
