source size.tcl
vlib work
vlog -sv mm_tb.sv mm.sv mem_read_A.sv mem_read_B.sv s2mm.sv mm2s.sv mem_write.sv systolic.sv
vlog pe.v pipe.sv counter.v control.v mem.v 
vsim -novopt -GM=$M -GN1=${N1} -GN2=${N2} mm_tb
log -r /*
add wave sim:/mm_tb/*
config wave -signalnamewidth 1
run 10250 ns
