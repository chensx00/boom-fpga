先直接把board/dualv7复制过去

然后把boom-stop软连接过去

然后在根目录下面用root_changes.patch，在ethernet/verilog-ethernet下面用ethernet_verilog-ethernet_changes.patch，在rocket-chip下面用rocket-chip_changes.patch

---


根据boom-fpga-dev/patch中的内容，帮我生成一个打上补丁的命令，你不要运行命令，生成命令我自己运行

  Thought for 1m 48s, searched for 2 patterns, read 1 file, listed 3 directories, ran 1 shell command

Let me quickly verify in a throwaway /tmp repo that git apply handles the gitlink/submodule hunks in these patches (delete gitlink → add symlink, and -dirty submodule lines), so the command I give you is correct:

  Thought for 14s, ran 1 shell command

The first test failed only because my temp gitlinks had no checkout directories. Let me retest with real directories present (as in the actual repo):

  Thought for 45s, listed 1 directory, ran 2 shell commands

已确认 patch/ 目录里有 3 个 git 格式补丁，且目标仓库与补丁里的路径对得上（root_changes.patch 指向 vivado-risc-v-dev/ 根目录，因为其中的 bootrom/、patches/、sdc/、vivado.tcl、子模块条目都在这个仓库下）。我还在 /tmp 里用临时仓库验证过：git apply 能正确处理补丁里的子模块 commit 改动（-dirty 行）和"删除 gitlink → 新增符号链接"的组合，且当前仓库的 3 个子模块 commit 与补丁的旧值完全一致，可以直接打。

打补丁命令

建议先做一次试打（不修改任何文件）：

git -C /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/vivado-risc-v-dev apply --check /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/patch/root_changes.patch

git -C /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/vivado-risc-v-dev/ethernet/verilog-ethernet apply --check /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/patch/ethernet_verilog-ethernet_changes.patch

git -C /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/vivado-risc-v-dev/rocket-chip apply --check /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/patch/rocket-chip_changes.patch

确认 --check 无报错后，正式打补丁（按 README 的顺序：根目录 → ethernet → rocket-chip）：

git -C /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/vivado-risc-v-dev apply /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/patch/root_changes.patch

git -C /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/vivado-risc-v-dev/ethernet/verilog-ethernet apply /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/patch/ethernet_verilog-ethernet_changes.patch

git -C /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/vivado-risc-v-dev/rocket-chip apply /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/patch/rocket-chip_changes.patch

两点提醒

1. 符号链接指向别人机器的路径：root_changes.patch 会把 generators/riscv-boom 从子模块替换成符号链接，指向 /home/chenxuyin/workspace/dualv7/boom-perf-dev/（原作者机器上的绝对路径，在你机器上不存在）。打完补丁后需要把它改指向你自己的目录，例如：
ln -sfn /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/boom-dev /home/chenshixuan/workload/my_boom_fpga/boom-fpga-v7/vivado-risc-v-dev/generators/riscv-boom
1. （具体指向哪个目录请按你实际的环境决定。）
2. README 里还有两步不是补丁：patch/README.md 还提到"先把 board/dualv7 复制过去、再把 boom-stop 软链接过去"。这两步涉及的文件不在 patch/ 目录里（本地仓库里也没有 dualv7 板级目录），所以没有包含在命令中——如果你需要，告诉我 dualv7 板级文件的来源位置，我再帮你补这两步的命令。

✻ Worked for 3m 28s

※ recap: You asked for commands to apply the three patches in boom-fpga-v7/patch; I generated the git apply commands targeting vivado-risc-v-dev, its rocket-chip, and ethernet/verilog-ethernet. Next: run the three commands (with --check first if desired), then repoint the riscv-boom symlink. (disable recaps in /config)

❯ 你帮我执行一下这些命令，会报错，然后你解决一下

  Thought for 2m 21s, ran 2 shell commands

部分文件被标记为删除，我需要先看这些 hunk 的实际内容来判断发生了什么：

  Thought for 1m 18s, searched for 1 pattern, ran 1 shell command

明白了。现在的局面是：

- .gitignore、bootrom/bootrom.c 已成功打上
- generators/riscv-boom 处致命错误：该子模块目录有实际文件（非空），git apply 无法删除它并创建符号链接
- 致命错误之后的部分文件（patches/*、sdc/、vivado.tcl）被异常删除，仓库处于损坏状态

修复思路：先把仓库恢复到干净状态，再用 git submodule deinit 清掉 generators/riscv-boom 的检出内容（它很干净，commit 为 18c48bb4，随时可恢复），然后重新打补丁。

  Thought for 5s, ran 1 shell command

仓库已恢复干净。现在处理 generators/riscv-boom 子模块：

  Thought for 4s, ran 1 shell command

子模块检出已清除（留下一个空目录，git apply 可以删除空目录）。重新打 root 补丁：

  Thought for 7s, ran 1 shell command

✅ root_changes.patch 打成功了。剩余两个 warning 是 -dirty 子模块条目的提示，无影响（那两个子模块检出会保留，正是我们需要的）。继续打另外两个补丁：

  Thought for 7s, ran 1 shell command

两个补丁都打上了（exit=0，rocket-chip 的 warning 同样是嵌套子模块 cde/diplomacy 的 -dirty 条目，无害）。最后验证三个仓库的最终状态:

  Thought for 44s, listed 1 directory, ran 2 shell commands

意外发现：符号链接指向的 /home/chenxuyin/workspace/dualv7/boom-perf-dev/ 在这台机器上居然存在（可能是原作者共享目录或已复制过来）。验证一下它是否可访问：

  Thought for 30s, listed 1 directory

全部完成，三个补丁都已成功打上，报错已解决。总结如下：

遇到的问题与解决
无法删除目录创建链接，致命错误退出。更糟的是，失败中断导致补丁后半部分的文件（patches/*、sdc/axi_sdc_controller.v、vivado.tcl）被异常删除，仓库处于损坏状态。

解决步骤：
1. git checkout -- . 把仓库恢复到干净状态（恢复了被误删的文件）
2. git submodule deinit -f generators/riscv-boom 清除子模块检出内容（它原本很干净，commit 18c48bb4，以后随时可用 git submodule update --init 恢复）
3. 重新打三个补丁，全部成功

最终验证结果

vivado-risc-v-dev（root_changes.patch）：
- ✅ .gitignore、bootrom/bootrom.c、patches/*(5个)、sdc/axi_sdc_controller.v、vivado.tcl 均已修改
- ✅ generators/riscv-boom 已变成符号链接（T typechange，符合补丁意图）
- ✅ ethernet/verilog-ethernet、rocket-chip 子模块显示为 dirty（m）—— 正好对应补丁里 -dirty 标记，状态一致

ethernet/verilog-ethernet：✅ rtl/rgmii_phy_if.v 已修改

rocket-chip：✅ DMI.scala、DebugTransport.scala、Periphery.scala 已修改

两个说明

1. 那些 "unable to rmdir" warning 是正常的，可以忽略——它们是子模块 gitlink 条目的提示，子模块检出本来就要保留。
2. 符号链接居然不用改：补丁把 generators/riscv-boom 指向 /home/chenxuyin/workspace/dualv7/boom-perf-dev/，我原本以为这是原作者机器上的死路径，但验证后发现这台机器上这个目录真实存在且内容完整（Chipyard 结构），所以链接是有效的。

另外提醒：patch/README.md 里还有两步手动操作不在补丁里——复制 board/dualv7 和软链接 boom-stop。我查了 /home/chenxuyin/workspace/dualv7/ 下没有 board/ 目录，如果你要做这两步，告诉我 dualv7 板级文件的来源位置，我帮你补命令。

✻ Sautéed for 5m 48s

※ recap: 三个补丁已全部成功打到 vivado-risc-v-dev 及其 rocket-chip、verilog-ethernet 子模块，报错已修复，符号链接目标有效。下一步：如需执行 README 里的 board/dualv7 复制和 boom-stop 软链接，请告知 dualv7 板级文件位置。 (disable recaps in /config)