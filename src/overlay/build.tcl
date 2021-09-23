set_param general.maxThreads 4
# allow Vivado to go crazy on Deathstar and use up 16/32 threads possible

source size.tcl
source tutorial.tcl
add_files -norecurse [make_wrapper -files [get_files "[current_bd_design].bd"] -top]
read_xdc lab4.xdc
source lab4.tcl
update_compile_order -fileset sources_1
set_property top tutorial_wrapper [current_fileset]
update_compile_order -fileset sources_1
check_ip_cache -clear_output_repo
launch_runs synth_1 -jobs 4
if {$TIMEOUT} {
	wait_on_run -timeout 25 synth_1
} else {
	wait_on_run -timeout 120 synth_1
}
launch_runs impl_1 -to_step write_bitstream -jobs 4
if {$TIMEOUT} {
	wait_on_run -timeout 25 impl_1
} else {
	wait_on_run -timeout 120 impl_1
}
file copy -force tutorial/tutorial.runs/impl_1/tutorial_wrapper.bit tutorial.bit
file copy -force tutorial/tutorial.srcs/sources_1/bd/tutorial/hw_handoff/tutorial.hwh tutorial.hwh
file copy -force tutorial/tutorial.runs/impl_1/tutorial_wrapper.bit tutorial_${M}_${N1}_${N2}.bit
file copy -force tutorial/tutorial.srcs/sources_1/bd/tutorial/hw_handoff/tutorial.hwh tutorial_${M}_${N1}_${N2}.hwh
close_project
exit
