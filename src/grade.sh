#!/bin/zsh

DIR=~
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/dut_tb.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/mm_tb.sv .
cp $DIR/Dropbox/Teaching/2021/ece327/labs-admin/lab4-sol/pe_tb.sv .
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

make clean
lint1=`verilator -GM=6 -GN1=3 -GN2=3 -Wall -Wno-DECLFILENAME -Wno-width --lint-only systolic.sv pe.v --top-module systolic 2>&1 | grep Error | wc -l`
#lint2=`verilator -Wall -Wno-DECLFILENAME -Wno-width --lint-only pe.v 2>&1 | grep Error | wc -l`
lint2=`./lint_modules.pl pe.v 2>&1 | grep Error | wc -l`
lint3=`verilator -Wall -Wno-DECLFILENAME -Wno-width --lint-only counter.v 2>&1 | grep Error | wc -l`
lint4=`verilator -Wall -Wno-DECLFILENAME -Wno-width --lint-only control.v 2>&1 | grep Error | wc -l`

make test-xsim M=4 N=4
sim1=`cat result.4.4.4.txt | grep "Thank Mr. Goose" | wc -l`
make clean
make test-xsim M=8 N=4
sim2=`cat result.8.4.4.txt | grep "Thank Mr. Goose" | wc -l`
make clean

if (( $sim1 > 0 )); then sim1=15; else sim1=0; fi
if (( $sim2 > 0 )); then sim2=15; else sim2=0; fi
if (( $lint1 > 0 )); then lint1=0; else lint1=2; fi
if (( $lint2 > 0 )); then lint2=0; else lint2=1; fi
if (( $lint3 > 0 )); then lint3=0; else lint3=1; fi
if (( $lint4 > 0 )); then lint4=0; else lint4=1; fi

sim=`expr $sim1 + $sim2`
lint=`expr $lint1 + $lint2 + $lint3 + $lint4`
echo -n "$sim,$lint," > grade_a.csv
