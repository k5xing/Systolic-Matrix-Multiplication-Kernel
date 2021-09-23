#!/bin/zsh

use_board=$1
if [[ $use_board == "" ]]; then
  use_board=0;
fi

rpt_file=overlay/tutorial/tutorial.runs/impl_1/tutorial_wrapper_timing_summary_routed.rpt
rpt_opt_file=overlay/tutorial/tutorial.runs/impl_1/tutorial_wrapper_timing_summary_postroute_physopted.rpt

make clean

# force FMAX as 100 MHz
sed -i "s/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {.*}/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100}/" overlay/tutorial.tcl

make vivado M=4 N=4 TIMEOUT=1
cat ${rpt_file} | grep clk_fpga_0 | head -n 2 > timing1.txt
ftarget1=`cat timing1.txt | head -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f5`
slack1=`cat timing1.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`

if [[ -f ${rpt_opt_file} ]] then
    cat ${rpt_opt_file} | grep clk_fpga_0 | head -n 2 > timing1o.txt
    ftarget1o=`cat timing1o.txt | head -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f5`
    slack1o=`cat timing1o.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`
    
    if (( $slack1o > $slack1 )) then
        slack1=${slack1o}
    fi
fi

board1=0
if (( $use_board > 0 )); then
  make board M=4 N=4 | tee board.4.4.txt
  board1=`cat board.4.4.txt | grep "Thank Mr. Goose" | wc -l`
fi

if (( $use_board <= 0 || $board1 == 0 )); then
  make test-mm-post-par M=4 N=4 | tee board.4.4.txt
  board1=`cat board.4.4.txt | grep "Thank Mr. Goose" | wc -l`
fi

make clean

sed -i "s/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {.*}/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100}/" overlay/tutorial.tcl

make vivado M=8 N=4 TIMEOUT=1
cat ${rpt_file} | grep clk_fpga_0 | head -n 2 > timing2.txt
ftarget2=`cat timing2.txt | head -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f5`
slack2=`cat timing2.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`

if [[ -f ${rpt_opt_file} ]] then
    cat ${rpt_opt_file} | grep clk_fpga_0 | head -n 2 > timing2o.txt
    ftarget2o=`cat timing2o.txt | head -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f5`
    slack2o=`cat timing2o.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`
    
    if (( $slack2o > $slack2 )) then
        slack2=${slack2o}
    fi
fi

board2=0
if (( $use_board > 0 )); then
  make board M=8 N=4 | tee board.8.4.txt
  board2=`cat board.8.4.txt | grep "Thank Mr. Goose" | wc -l`
fi

if (( $use_board <= 0 || $board2 == 0 )); then
  make test-mm-post-par M=8 N=4 | tee board.8.4.txt
  board2=`cat board.8.4.txt | grep "Thank Mr. Goose" | wc -l`
fi

if (( $board1 > 0 && $slack1 > 0 )); then board1=20; else board1=0; fi
if (( $board2 > 0 && $slack2 > 0 )); then board2=15; else board2=0; fi

board=`expr $board1 + $board2`
echo -n "$board," >> grade.csv
