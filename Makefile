all: disassembly/half-pipe.s

temp_info_path := $(shell mktemp)
disassembly/%.s: Makefile unpacked-prgs/%.prg da65-info/%.info
	cat $(word 3, $^) da65-info/c64-hardware.info da65-info/players.info > $(temp_info_path)
	mkdir -p $(dir $@)
	da65 --hexoffs --comments 2 --info $(temp_info_path) -o $@ $(word 2, $^)
	rm $(temp_info_path)

.PRECIOUS: da65-info/%.info
da65-info/%.info:
	echo 'GLOBAL { INPUTOFFS 2; STARTADDR $$$(shell tools/prg-load-address unpacked-prgs/$(basename $(notdir $@)).prg); };' > $@

# As per table in 005-1000-19FF.prg at $0705 (Relocated -$1000 at runtime.)
unpack_from_address_menu := A195
unpack_from_address_half-pipe := 3A3F
unpack_from_address_foot-bag := 404E
unpack_from_address_surfing := 4C2D
unpack_from_address_skating := 6294
unpack_from_address_bmx := 2E2C
unpack_from_address_flying-disc := 6D37
unpack_from_address_title-screen := CBE0

unpacked-prgs/%.prg: Makefile tools/unpack-prg
	mkdir -p $(dir $@)
	tools/unpack-prg finaltap-prgs/$(notdir $@) $@ $(unpack_from_address_$(basename $(notdir $@)))

tools/unpack-prg:
tools/prg-load-address:

.PHONY: clean
clean:
	rm -r disassembly
	rm -r unpacked-prgs
	rm tools/unpack-prg
	rm tools/prg-load-address
