create_project -force lab4 ./lab4_vivado -part xc7z020clg400-1
set_property board_part www.digilentinc.com:pynq-z1:part0:1.0 [current_project]

add_files pe.v
add_files pe.xdc

update_compile_order -fileset sources_1
set_property top pe [current_fileset]

set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]
set_property generic "D_W=8 D_W_ACC=16" [current_fileset]

launch_runs synth_1 -jobs 4
wait_on_run synth_1

open_run synth_1 -name synth_1
write_verilog -force -mode funcsim post-synth.v

exit
