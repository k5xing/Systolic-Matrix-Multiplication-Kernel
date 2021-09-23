#!/bin/zsh

use_board=$1
if [[ $use_board == "" ]]; then
  use_board=0;
fi

rpt_file=overlay/tutorial/tutorial.runs/impl_1/tutorial_wrapper_timing_summary_routed.rpt
rpt_opt_file=overlay/tutorial/tutorial.runs/impl_1/tutorial_wrapper_timing_summary_postroute_physopted.rpt

make clean

touch design.txt
# because students still insist on editing files outside Docker!
fromdos design.txt
# for students who forgot to push design.txt
echo "" >> design.txt
echo "N1: 4" >> design.txt
echo "N2: 4" >> design.txt
echo "FMAX: 100" >> design.txt

N1=`cat design.txt | grep N1 | head -n 1 | cut -d":" -f2 | sed "s/ //g"`
N2=`cat design.txt | grep N2 | head -n 1 | cut -d":" -f2 | sed "s/ //g"`
FMAX=`cat design.txt | grep FMAX | head -n 1 | cut -d":" -f2 | sed "s/ //g"`

# force FMAX as 100 MHz
sed -i "s/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {.*}/CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {$FMAX}/" overlay/tutorial.tcl

make vivado M=${N1}1 N1=${N1} N2=${N2} TIMEOUT=0
cat ${rpt_file} | grep clk_fpga_0 | head -n 2 > timing_bonus.txt
ftargetb=`cat timing_bonus.txt | head -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f5`
slackb=`cat timing_bonus.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`

if [[ -f ${rpt_opt_file} ]] then
    cat ${rpt_opt_file} | grep clk_fpga_0 | head -n 2 > timing_bonuso.txt
    ftargetbo=`cat timing_bonuso.txt | head -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f5`
    slackbo=`cat timing_bonuso.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`
    
    if (( $slackbo > $slackb )) then
        slackb=${slackbo}
    fi
fi

boardb=0
if (( $use_board > 0 )); then
  make board M=${N1} N1=${N1} N2=${N2} | tee board.bonus.txt
  boardb=`cat board.bonus.txt | grep "Thank Mr. Goose" | wc -l`
fi

if (( $use_board <= 0 || $boardb == 0 )); then
  make test-mm-post-par M=${N1} N1=${N1} N2=${N2} | tee board.bonus.txt
  boardb=`cat board.bonus.txt | grep "Thank Mr. Goose" | wc -l`
fi

score=`echo "sqrt(${N1} * ${N2}) * $ftargetb" | bc`
# provide a small 0.075ns timing margin to account for tool noise
positiveslack=`echo "$slackb + 0.075 > 0" | bc -l`

# TODO: replace 3834 with the largest score in that term
if [[ $boardb > 0 && $positiveslack > 0 ]]; then boardb=`echo "15 + 15*($score-400)/(3834-400)" | bc`; else boardb=0; fi

board=`expr $boardb`
echo "$board," >> grade.csv

