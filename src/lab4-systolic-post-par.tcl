source size.tcl

create_project -force lab4 ./lab4_vivado -part xc7z020clg400-1
set_property board_part www.digilentinc.com:pynq-z1:part0:1.0 [current_project]

add_files pipe.sv pe.v counter.v control.v systolic.sv

update_compile_order -fileset sources_1
set_property top systolic [current_fileset]

# CAUTION: M and N are ignored for this unfortunately
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-generic M=4 -generic N=4 -mode out_of_context} -objects [get_runs synth_1]

launch_runs synth_1 -jobs 4
wait_on_run synth_1

launch_runs impl_1 -jobs 4
wait_on_run impl_1

open_run impl_1 -name impl_1
write_verilog -force -mode timesim -sdf_anno true -sdf_file post-par.sdf post-par.v
write_sdf -force post-par.sdf

exit
