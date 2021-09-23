#!/bin/zsh

DIR=~
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/dut_tb.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/mm_tb.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/pipe.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/mm.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/mm_axi.v .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/mem_read_A.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/mem_read_B.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/mem_write.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/s2mm.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/mm2s.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/pipe_tb.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/*.tcl .
cp -f $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/*.sh .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/*.mem .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/*.py .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/*.pl .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/overlay/sources.tcl overlay
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/overlay/build.tcl overlay
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/overlay/tutorial.tcl overlay

rpt_file=overlay/tutorial/tutorial.runs/impl_1/tutorial_wrapper_timing_summary_routed.rpt
rpt_opt_file=overlay/tutorial/tutorial.runs/impl_1/tutorial_wrapper_timing_summary_postroute_physopted.rpt

make clean

touch design.txt
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

make vivado M=${N1} N1=${N1} N2=${N2} TIMEOUT=0
cat ${rpt_file} | grep clk_fpga_0 | head -n 2 > timing_bonus.txt
slackb=`cat timing_bonus.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`

if [[ -f ${rpt_opt_file} ]] then
    cat ${rpt_opt_file} | grep clk_fpga_0 | head -n 2 > timing_bonuso.txt
    slackbo=`cat timing_bonuso.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`
    
    if (( $slackbo > $slackb )) then
        mv timing_bonuso.txt timing_bonus.txt
    fi
fi
