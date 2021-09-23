xvlog control.v
xvlog counter.v
xvlog -sv control_tb.sv
xelab -debug typical control_tb --generic_top "N1=$2" -generic_top "N2=$3" -generic_top "M=$4" -s control_tb

if (( $1 > 0 )) then
    xsim control_tb -gui -t xsim-gui.tcl
else
    xsim control_tb -t xsim.tcl
fi
