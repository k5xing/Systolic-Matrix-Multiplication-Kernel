xvlog control.v counter.v pe.v mem.v
xvlog -sv mm_tb.sv pipe.sv systolic.sv mem_read_A.sv mem_read_B.sv pipe_tb.sv mm.sv s2mm.sv mm2s.sv mem_write.sv
xelab -debug typical mm_tb --generic_top "M=$1" --generic_top "N1=$2" --generic_top "N2=$3" -s mm_tb

xsim mm_tb -t xsim.tcl
