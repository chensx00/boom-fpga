#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# BOOM-FPGA environment
# 执行：source ./load_env.sh
# ------------------------------------------------------------------------------

export WORK_SPACE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Vivado license
export XILINXD_LICENSE_FILE=$WORK_SPACE/lib

# Java 11
JAVA_DIR=$WORK_SPACE/lib/jdk-11.0.31+11
export JAVA_HOME="$JAVA_DIR"
export PATH="$JAVA_DIR/bin:$PATH"

# firtool
export FIRRTL=$WORK_SPACE/lib/firtool-1.62.0/bin/firtool

# Vivado 2023.2
VIVADO_ENV="${VIVADO_ENV="${VIVADO_ENV:-$WORK_SPACE/../source_vivado2023_2.sh}"}"

if [ -f "$VIVADO_ENV" ]; then
    source "$VIVADO_ENV"
else
    echo "[warn] Vivado environment script not found: $VIVADO_ENV"
fi

# RISC-V bare-metal toolchain
export RISCV=$WORK_SPACE/vivado-risc-v-dev/workspace/gcc/riscv
export PATH="$RISCV/bin:$PATH"

# ------------------------------------------------------------------------------
# Check environment
# ------------------------------------------------------------------------------

echo "[env] WORK_SPACE=$WORK_SPACE"
echo "[env] XILINXD_LICENSE_FILE=$XILINXD_LICENSE_FILE"
echo "[env] JAVA_HOME=$JAVA_HOME"
echo "[env] FIRRTL=$FIRRTL"
echo "[env] RISCV=$RISCV"
echo "[env] java=$(which java 2>/dev/null || echo not-found)"
echo "[env] vivado=$(which vivado 2>/dev/null || echo not-found)"
echo "[env] riscv64-unknown-elf-gcc=$(which riscv64-unknown-elf-gcc 2>/dev/null || echo not-found)"
echo "[env] riscv64-unknown-elf-g++=$(which riscv64-unknown-elf-g++ 2>/dev/null || echo not-found)"