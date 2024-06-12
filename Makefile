build: hex_out.hex bin_out.bin

dump: bin_out.bin
	hexdump -C bin_out.bin

hex_out.hex: input.asm
	PATH=$PATH:/home/seyf/vasm/bin
	vasmz80_oldstyle -Fihex -dotdir input.asm -o hex_out.hex

bin_out.bin: input.asm
	PATH=$PATH:/home/seyf/vasm/bin
	vasmz80_oldstyle -Fbin -dotdir input.asm -o bin_out.bin

clean: 
	rm -f hex_out.hex
	rm -f bin_out.bin
	rm -f memory_flash.h
