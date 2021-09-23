#!/bin/zsh

ftarget1=`cat timing1.txt | head -n 1 | tr -s " " | cut -d" " -f5`
slack1=`cat timing1.txt | tail -n 1 | tr -s " " | cut -d" " -f2`

make board M=4 N=4 | tee board.4.4.txt
board1=`cat board.4.4.txt | grep "Thank Mr. Goose" | wc -l`

ftarget2=`cat timing2.txt | head -n 1 | tr -s " " | cut -d" " -f5`
slack2=`cat timing2.txt | tail -n 1 | tr -s " " | cut -d" " -f2`

make board M=8 N=4 | tee board.8.4.txt
board2=`cat board.8.4.txt | grep "Thank Mr. Goose" | wc -l`

if (( $board1 > 0 && $slack1 > 0 )); then board1=20; else board1=0; fi
if (( $board2 > 0 && $slack2 > 0 )); then board2=15; else board2=0; fi

board=`expr $board1 + $board2`
echo -n "$board," > grade_b.csv
