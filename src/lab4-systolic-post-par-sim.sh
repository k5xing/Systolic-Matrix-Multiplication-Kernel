#!/bin/zsh

M=$1
N1=$2
N2=$3

xvlog -sv -d XIL_TIMING dut_tb.sv mem_read_A.sv mem_read_B.sv pipe_tb.sv
xvlog post-par.v 
xvlog /opt/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v

xelab --generic_top M=${M} --generic_top N1=${N1} --generic_top N2=${N2} -debug typical -maxdelay -L secureip -L simprims_ver -transport_int_delays -pulse_r 0 -pulse_int_r 0 -pulse_e 0 -pulse_int_e 0 glbl dut_tb -s dut_tb
xsim dut_tb -tclbatch xsim.tcl
