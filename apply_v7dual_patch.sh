#!/bin/bash
WORK_SPACE="${WORK_SPACE:-/home/chenshixuan/workload/my_boom_fpga/boom-fpga-dev}"
cd "$WORK_SPACE/vivado-risc-v-dev"

[ -L "generators/riscv-boom" ] && echo "✓ riscv-boom -> $(readlink generators/riscv-boom)" || echo "✗ riscv-boom isn't linked"

cd .
git apply --check "$WORK_SPACE/patch/root_changes.patch" >/dev/null 2>&1
git apply "$WORK_SPACE/patch/root_changes.patch" >/dev/null 2>&1
echo "✓ root_changes.patch"

cd ethernet/verilog-ethernet
git apply --check "$WORK_SPACE/patch/ethernet_verilog-ethernet_changes.patch" >/dev/null 2>&1
git apply "$WORK_SPACE/patch/ethernet_verilog-ethernet_changes.patch" >/dev/null 2>&1
echo "✓ ethernet_verilog-ethernet_changes.patch"

cd "$WORK_SPACE/vivado-risc-v-dev/rocket-chip"
git apply --check "$WORK_SPACE/patch/rocket-chip_changes.patch" >/dev/null 2>&1
git apply "$WORK_SPACE/patch/rocket-chip_changes.patch" >/dev/null 2>&1
echo "✓ rocket-chip_changes.patch"

cp -r "$WORK_SPACE/patch/dualv7" "$WORK_SPACE/vivado-risc-v-dev/board/"
echo "✓ dualv7 dir copied to board/"