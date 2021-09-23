#!/bin/zsh

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

ftargetb=`cat timing_bonus.txt | head -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f5`
slackb=`cat timing_bonus.txt | tail -n 1 | sed "s/\ \+/\ /g" | cut -d" " -f2`

make test-mm-post-par M=${N1} N1=${N1} N2=${N2} | tee board.bonus.txt
boardb=`cat board.bonus.txt | grep "Thank Mr. Goose" | wc -l`

score=`echo "sqrt(${N1} * ${N2}) * $ftargetb" | bc`
# provide a small 0.075ns timing margin to account for tool noise
positiveslack=`echo "$slackb + 0.075 > 0" | bc -l`

# TODO: replace 3834 with the largest score in that term
if (( $boardb > 0 && $positiveslack > 0 )); then boardb=`echo "15 + 15*($score-400)/(3834-400)" | bc`; else boardb=0; fi

board=`expr $boardb`
echo "$board," > grade_c.csv

