add_files ../mm_axi.v ../mm.sv ../mem_read_A.sv ../mem_read_B.sv ../systolic.sv ../counter.v ../control.v ../pe.v ../mem_write.sv ../pipe.sv ../s2mm.sv ../mm2s.sv ../mem.v

set_property source_mgmt_mode All [current_project]
update_compile_order -fileset sources_1
