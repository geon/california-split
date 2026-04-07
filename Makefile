temp_info_path := temp.info
unpacker_finaltap_path := finaltap-prgs/a/005-1000-19FF.prg
unpacker_info_path := da65-info/a-005-1000-19FF.prg.info
unpacker_disassembly_path := disassembly/unpacker.s
$(unpacker_disassembly_path): $(unpacker_finaltap_path) $(unpacker_info_path)
	cat "$(unpacker_info_path)" da65-info/c64-hardware.info > "$(temp_info_path)"
	da65 --hexoffs --comments 2 --info "$(temp_info_path)" -o $(unpacker_disassembly_path) $(unpacker_finaltap_path)
	rm "$(temp_info_path)"
