create_project led_blink . -part xc7v2000tflg1925-1 -force
add_files led_blink.v
add_files -fileset constrs_1 led_blink.xdc
set_property top led_blink [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

open_run impl_1
report_timing_summary -file timing_summary.rpt
report_drc -file drc.rpt
write_checkpoint -force led_blink_routed.dcp
