vlib work
vlog -sv +define+XIL_TIMING pe_tb.sv
vlog post-par.v 
vlog -novopt +define+XIL_TIMING /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/FDRE.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT1.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT2.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT6.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT4.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT3.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/LUT5.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/CARRY4.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/DSP48E1.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/GND.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/VCC.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/RAMD32.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/unisims/RAMS32.v /opt/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v
vsim -novopt work.glbl pe_tb 
log -r /*
add wave sim:/pe_tb/pe_inst/*
config wave -signalnamewidth 1
run 200000000 ps
