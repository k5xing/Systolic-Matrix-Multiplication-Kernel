xvlog pe.v
xvlog -sv pe_tb.sv
xelab -debug typical pe_tb --generic_top "FIRST=$2" -s pe_tb

if (( $1 > 0 )) then
    xsim pe_tb -gui -t xsim-gui.tcl
else
    xsim pe_tb -t xsim.tcl
fi
