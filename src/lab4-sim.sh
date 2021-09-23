xvlog control.v counter.v pe.v
xvlog -sv dut_tb.sv pipe.sv systolic.sv mem_read_A.sv mem_read_B.sv pipe_tb.sv
xelab -debug typical dut_tb --generic_top "M=$1" -generic_top "N1=$2" -generic_top "N2=$3" -s dut_tb

if (( $4 > 0 )) then
    xsim dut_tb -gui -t xsim-gui.tcl
else
    xsim dut_tb -t xsim.tcl
fi
