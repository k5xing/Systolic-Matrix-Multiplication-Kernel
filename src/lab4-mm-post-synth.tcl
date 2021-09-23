create_project -force lab4 ./lab4_vivado -part xc7z020clg400-1
set_property board_part www.digilentinc.com:pynq-z1:part0:1.0 [current_project]

add_files mm.sv pipe.sv pe.v counter.v control.v systolic.sv mem_read_A.sv mem_read_B.sv mem_write.sv s2mm.sv mm2s.sv mem.v

source size.tcl

update_compile_order -fileset sources_1
set_property top mm [current_fileset]

set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]
set_property generic "M=$M N1=${N1} N2=${N2}" [current_fileset]

launch_runs synth_1 -jobs 4
wait_on_run synth_1

open_run synth_1 -name synth_1
write_verilog -force -mode funcsim post-synth.v

exit
