source size.tcl
vlib work
vlog -sv dut_tb.sv pipe_tb.sv pipe.sv systolic.sv mem_read_A.sv mem_read_B.sv
vlog counter.v pe.v control.v
vsim -novopt -GM=$M -GN1=${N1} -GN2=${N2} dut_tb
log -r /*
add wave sim:/dut_tb/systolic_dut/*
config wave -signalnamewidth 1
run 10250 ns
