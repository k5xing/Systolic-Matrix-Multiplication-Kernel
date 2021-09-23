#!/bin/zsh

rpt_file=overlay/tutorial/tutorial.runs/impl_1/tutorial_wrapper_timing_summary_routed.rpt
rpt_opt_file=overlay/tutorial/tutorial.runs/impl_1/tutorial_wrapper_timing_summary_postroute_physopted.rpt

make clean

# force FMAX as 100 MHz
sed -i "s/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {.*}/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100}/" overlay/tutorial.tcl

make vivado M=4 N1=4 N2=4 TIMEOUT=1
cat ${rpt_file} | grep clk_fpga_0 | head -n 2 > timing1.txt
slack1=`cat timing1.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`

if [[ -f ${rpt_opt_file} ]] then
    cat ${rpt_opt_file} | grep clk_fpga_0 | head -n 2 > timing1o.txt
    slack1o=`cat timing1o.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`
    
    if (( $slack1o > $slack1 )) then
        mv timing1o.txt timing1.txt
    fi
fi

make clean

sed -i "s/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {.*}/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100}/" overlay/tutorial.tcl

make vivado M=8 N1=4 N2=4 TIMEOUT=1
cat ${rpt_file} | grep clk_fpga_0 | head -n 2 > timing2.txt
slack2=`cat timing2.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`

if [[ -f ${rpt_opt_file} ]] then
    cat ${rpt_opt_file} | grep clk_fpga_0 | head -n 2 > timing2o.txt
    slack2o=`cat timing2o.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`
    
    if (( $slack2o > $slack2 )) then
        mv timing2o.txt timing2.txt
    fi
fi
