# chipyard1.13.0 BOOM + BOOM-Stop 上板流程 

## 介绍

一套支持 chipyard1.13.0版本上 riscv-boom V3 处理器的 genesys2 开发板测试框架.

## 项目结构

- boom-dev: 基于 chipyard 1.13.0 版本下的 riscv-boom V3 代码修改的添加性能计数器的 riscv-boom V3 版本.

- boom_stop: 目前使用 boom_stop/example 来编译 FPGA 上 BOOM 运行的测试程序, 支持输出 boom-dev 中定义的各类性能计数器.

- vivado-risc-v-dev: 支持 boom 进行上板验证的全套外围工具.

## 贡献者

- 陈克发 MPRC23级硕士:
  - https://github.com/chensx00/vivado-risc-v-boom 的 57ce6e3, a3793b3 和 f08637c 提交基于陈克发的原仓库 https://github.com/ckf104/vivado-risc-v/commits/update-boom/ 中的 3adca8d 提交以及之前的提交进行修改.
  - https://github.com/chensx00/boom-perf-dev.git 的 f63d22b 基于陈克发的原仓库 https://github.com/ckf104/boom-dev.git 中的 81836ff 提交以及之前的提交进行修改.

- 崔宏伟 MPRC17级博士:
  - https://github.com/Shuiliusheng/boom_stop.git
  - 提供了 boom 性能计数器的早期版本以及一系列配套测试工具

## 环境配置

该文档目前添加了 vivado, java11, firtool 工具的安装和支持

~~~bash
# WORK_SPACE 设置为项目根目录
export WORK_SPACE=$(pwd)
~~~


### vivado

若使用实验室的 23 服务器, 服务器内 vivado 版本为 2021.1. 可以跳过该部分文档.

首先下载 vivado, 建议版本2021.1~2025.1. (本文档验证2025.1 版本 vivado 通过全流程)

vivado 的 license 可以在实验室 23 服务器中的 `~/.flexlmrc` 找到路径, vivado 需要该 license 来支持 genesys2 开发板.

~~~bash
cd $WORK_SPACE
mkdir -p $WORK_SPACE/lib
cd $WORK_SPACE/lib
mv your_license_in_23server/LICENSE_FOR_ISE_VIVADO.lic ./
export XILINXD_LICENSE_FILE=$WORK_SPACE/lib
~~~

如果安装的 vivado 找不到 genesys2 的 boardfile, 需要下载并手动安装到 vivado 的根目录中:
~~~bash
git clone https://github.com/Digilent/vivado-boards.git
# 将 vivado-boards/new/board_files/genesys2 复制到vivado目录中
cp -r vivado-boards/new/board_files/genesys2 \
      your_vivado_root//Vivado/2025.1/data/boards/board_files/
~~~

### java11

若使用实验室的 23 服务器, 服务器内 java 版本为 11. 可以跳过该部分文档.

~~~bash
cd $WORK_SPACE
mkdir -p $WORK_SPACE/lib
cd $WORK_SPACE/lib
wget https://aka.ms/download-jdk/microsoft-jdk-11.0.31-linux-x64.tar.gz
tar -zxvf microsoft-jdk-11.0.31-linux-x64.tar.gz
JAVA_DIR=$WORK_SPACE/lib/jdk-11.0.31+11
export JAVA_HOME="$JAVA_DIR"
export PATH="$JAVA_DIR/bin:$PATH"
~~~


### firtool

~~~bash
cd $WORK_SPACE
mkdir -p $WORK_SPACE/lib
cd $WORK_SPACE/lib
wget https://github.com/llvm/circt/releases/download/firtool-1.62.0/firrtl-bin-linux-x64.tar.gz
tar -zxvf firrtl-bin-linux-x64.tar.gz
export FIRRTL=$WORK_SPACE/lib/firtool-1.62.0/bin/firtool
~~~

## 生成比特流步骤

首先环境配置完毕

### 比特流生成

~~~bash
cd $WORK_SPACE
# 拉取子仓库
git submodule update --init

cd vivado-risc-v-dev
make update-submodules SKIP_SOFT=1
cd $WORK_SPACE

# 将 vivado-risc-v-dev 的 boom 代码切换为 添加了 boom-dev 代码(你需要测试的 boom 代码)
mv vivado-risc-v-dev/generators/riscv-boom vivado-risc-v-dev/generators/riscv-boom.back
ln -s ../../boom-dev/ ./vivado-risc-v-dev/generators/riscv-boom
# 软链接删除方式
# rm vivado-risc-v-dev/generators/riscv-boom # 不要用 rm -r !

# 启用你自己的 vivado 环境
source /your_vivado_root/Vivado/settings64.sh
# source /home/chenshixuan/sw/Xilinx/2025.1/Vivado/settings64.sh

# 开始生成比特流
cd $WORK_SPACE/vivado-risc-v-dev
make CONFIG=Rocket64x1 BOARD=genesys2 bitstream -j512
~~~

### 其他命令

比特流的生成目录
~~~bash
cp $WORK_SPACE/vivado-risc-v-dev/workspace/Rocket64x1/vivado-genesys2-riscv/genesys2-riscv.runs/impl_1/riscv_wrapper.bit $WORK_SPACE/my_bitstream.bit
~~~

完全清理工作目录
~~~bash
rm -rf $WORK_SPACE/vivado-risc-v-dev/workspace/Rocket64x1
~~~

## 测试程序编译

`boom_stop/example`内有详细说明.

