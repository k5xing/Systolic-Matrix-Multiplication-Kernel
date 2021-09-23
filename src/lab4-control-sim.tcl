source control_args.tcl
vlib work
vlog -sv control_tb.sv
vlog control.v counter.v
vsim -novopt -GN1=$N1 -GN2=$N2 -GM=$M control_tb
log -r /*
add wave sim:/control_tb/control_inst/*
config wave -signalnamewidth 1
run 1000 ns
