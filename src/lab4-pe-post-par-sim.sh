#!/bin/zsh

DBG=$1

xvlog -sv -d XIL_TIMING pe_tb.sv
xvlog post-par.v 
xvlog /opt/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v

xelab -debug typical -maxdelay -L secureip -L simprims_ver -transport_int_delays -pulse_r 0 -pulse_int_r 0 -pulse_e 0 -pulse_int_e 0 glbl pe_tb -s pe_tb
if (($DBG > 0)) then
  xsim pe_tb -g -tclbatch xsim-gui.tcl
else
  xsim pe_tb -tclbatch xsim.tcl
fi
