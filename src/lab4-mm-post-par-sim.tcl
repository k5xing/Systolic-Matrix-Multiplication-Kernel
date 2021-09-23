source size.tcl
vlib work
vlog -sv +define+XIL_TIMING mm_tb.sv
vlog post-par.v 
vlog -novopt +define+XIL_TIMING /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/FDRE.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT1.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT2.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT6.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT4.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT3.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT5.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/CARRY4.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/DSP48E1.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/GND.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/VCC.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/RAMD32.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/RAMS32.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v
vsim -GM=$M -GN=4 -novopt work.glbl mm_tb 
log -r /*
add wave sim:/mm_tb/*
config wave -signalnamewidth 1
run 200000000 ps
