# https://forums.xilinx.com/t5/Simulation-and-Verification/global-signal-logging/td-p/793979 
create_wave_config; add_wave [get_objects -r]; set_property needs_save false [current_wave_config]
run 1000000ns
exit
