#!/bin/zsh

M=$1
N1=$2
N2=$3

xvlog -sv -d XIL_TIMING mm_tb.sv
xvlog post-synth.v 
xvlog -d XIL_TIMING /opt/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v
xelab --generic_top M=${M} --generic_top N1=${N1} --generic_top N2=${N2} -debug typical -maxdelay -L secureip -L simprims_ver -transport_int_delays -pulse_r 0 -pulse_int_r 0 glbl mm_tb -s mm_tb
xsim mm_tb -tclbatch xsim.tcl
