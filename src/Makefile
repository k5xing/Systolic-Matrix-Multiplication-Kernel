FIRST ?= 0
USE_BOARD ?= 0
TIMEOUT ?= 1

# Set N1=N2=N if those are not provided 
N1 ?= $N
N2 ?= $N

lint:
	verilator -GM=6 -GN1=3 -GN2=3 -Wall -Wno-DECLFILENAME -Wno-width --lint-only systolic.sv
	verilator -Wall -Wno-DECLFILENAME -Wno-width --lint-only counter.v
	verilator -Wall -Wno-DECLFILENAME -Wno-width --lint-only control.v
	verilator -Wall -Wno-DECLFILENAME -Wno-width --lint-only pe.v

lab4a: lab4.pdf

lab4.pdf: lab4.dot
	neato -n -l shapes.ps lab4.dot | gvpr -c -fnbb.g | neato -n -Tps -l shapes.ps > lab4.ps && ps2pdf lab4.ps && pdfcrop lab4.pdf && mv lab4-crop.pdf lab4.pdf

modelsim:
	python make_mem.py $M ${N1} ${N2}
	echo "set M $M" > size.tcl
	echo "set N1 ${N1}" >> size.tcl
	echo "set N2 ${N2}" >> size.tcl
	vsim -do lab4-sim.tcl

xsim:
	python make_mem.py $M ${N1} ${N2}
	zsh lab4-sim.sh $M ${N1} ${N2} 1

test:
	python make_mem.py $M ${N1} ${N2}
	echo "set M $M" > size.tcl
	echo "set N1 ${N1}" >> size.tcl
	echo "set N2 ${N2}" >> size.tcl
	vsim -c -do lab4-sim.tcl
	python test.py ${N1} ${N2} > result.$M.${N1}.${N2}.txt
	cat result.$M.${N1}.${N2}.txt

test-xsim:
	python make_mem.py $M ${N1} ${N2}
	echo "set M $M" > size.tcl
	echo "set N1 ${N1}" >> size.tcl
	echo "set N2 ${N2}" >> size.tcl
	zsh lab4-sim.sh $M ${N1} ${N2} 0
	python test.py ${N1} ${N2} > result.$M.${N1}.${N2}.txt
	cat result.$M.${N1}.${N2}.txt

vivado:	
	rm -rf vivado*
	rm -rf overlay/tutorial
	echo "set M $M" > overlay/size.tcl
	echo "set N1 ${N1}" >> overlay/size.tcl
	echo "set N2 ${N2}" >> overlay/size.tcl
	echo "set TIMEOUT ${TIMEOUT}" >> overlay/size.tcl
	cd overlay && vivado -mode tcl -source build.tcl

test-mm:
	make clean
	echo "set M $M" > size.tcl
	echo "set N1 ${N1}" >> size.tcl
	echo "set N2 ${N2}" >> size.tcl
	python make_mem.py $M ${N1} ${N2}
	zsh lab4-mm-sim.sh $M ${N1} ${N2}
	python test.py ${N1} ${N2} > result.$M.${N1}.${N2}.txt
	cat result.$M.${N1}.${N2}.txt

test-mm-post-synth:
	make clean
	echo "set M $M" > size.tcl
	echo "set N1 ${N1}" >> size.tcl
	echo "set N2 ${N2}" >> size.tcl
	echo "set TIMEOUT ${TIMEOUT}" >> size.tcl
	vivado -mode tcl -source lab4-mm-post-synth.tcl
	python make_mem.py $M ${N1} ${N2} 
	zsh lab4-mm-post-synth-sim.sh $M ${N1} ${N2} # hardcoded for synthesis
	python test.py ${N1} ${N2}

test-mm-post-par:
	make clean
	echo "set M $M" > size.tcl
	echo "set N1 ${N1}" >> size.tcl
	echo "set N2 ${N2}" >> size.tcl
	echo "set TIMEOUT ${TIMEOUT}" >> size.tcl
	vivado -mode tcl -source lab4-mm-post-par.tcl
	python make_mem.py $M ${N1} ${N2}
	zsh lab4-mm-post-par-sim.sh $M ${N1} ${N2} # hardcoded for synthesis
	python test.py ${N1} ${N2} > result_pp.$M.${N1}.${N2}.txt
	cat result_pp.$M.${N1}.${N2}.txt

test-pe:
	make clean
	echo "set FIRST ${FIRST}" > first_pe.tcl
	vsim -c -do lab4-pe-sim.tcl
	python3 test_pe.py ${FIRST}

test-pe-xsim:
	make clean
	zsh lab4-pe-sim.sh 0 ${FIRST}
	python3 test_pe.py ${FIRST}

test-control:
	make clean
	echo "set M $M" > control_args.tcl
	echo "set N1 ${N1}" >> control_args.tcl
	echo "set N2 ${N2}" >> control_args.tcl
	vsim -c -do lab4-control-sim.tcl
	python test_control.py ${N1} ${N2} $M > result_control.$M.${N1}.${N2}.txt
	cat result_control.$M.${N1}.${N2}.txt
	rm -rf result_control.$M.${N1}.${N2}.txt

test-control-xsim:
	make clean
	zsh lab4-control-sim.sh 0 ${N1} ${N2} $M
	python test_control.py ${N1} ${N2} ${M} > result_control.$M.${N1}.${N2}.txt
	cat result_control.$M.${N1}.${N2}.txt
	rm -rf result_control.$M.${N1}.${N2}.txt

sim-control-modelsim:
	make clean
	echo "set M $M" > control_args.tcl
	echo "set N1 ${N1}" >> control_args.tcl
	echo "set N2 ${N2}" >> control_args.tcl
	vsim -do lab4-control-sim.tcl

sim-control-xsim:
	make clean
	echo "set M $M" > control_args.tcl
	echo "set N1 ${N1}" >> control_args.tcl
	echo "set N2 ${N2}" >> control_args.tcl
	zsh lab4-control-sim.sh 1

modelsim-pe:
	make clean
	echo "set FIRST ${FIRST}" > first_pe.tcl
	vsim -do lab4-pe-sim.tcl

modelsim-pe-xsim:
	make clean
	zsh lab4-pe-sim.sh 1 ${FIRST}

board:
	scp lab4-board.py xilinx@192.168.2.99:~/
	cp overlay/tutorial_${M}_${N1}_${N2}.bit overlay/tutorial.bit
	cp overlay/tutorial_${M}_${N1}_${N2}.hwh overlay/tutorial.hwh
	scp overlay/tutorial.* xilinx@192.168.2.99:~/
	ssh -tt xilinx@192.168.2.99 "echo xilinx | sudo -S python3.6 lab4-board.py $M ${N1} ${N2}"
	ssh -tt xilinx@192.168.2.99 "rm -Rf tutorial.*"

grade_a:
	./grade.sh

prep_b:
	./prep_board.sh

grade_b:
	./grade_board_fast.sh

prep_c:
	./prep_bonus.sh

grade_c:
	./grade_bonus_fast.sh

clean:
	rm -Rf a.out vivado.* overlay/*.log overlay/*.jou overlay/tutorial overlay/.Xil transcript *.vcd vsim.wlf *.log *.jou .Xil overlay/NA bram_only* work *.pb *.wdb xsim.dir webtalk*
