.PHONY: all clean run

XVIC = xvic
XVIC_IMAGE = "bin/psychedelia-vic20.prg"
C16_IMAGE = "bin/psychedelia-c16.prg"
LISTING_IMAGE = "bin/psychedelia-listing.prg"
D64_IMAGE = "bin/psychedelia.d64"
D64_ORIG_IMAGE = "orig/psychedelia.d64"
X64 = x64
X64SC = x64sc
XPLUS4 = xplus4
C1541 = c1541
XATARI_IMAGE = "bin/colourspace.xex"
XATARI = atari800

all: clean d64 run
original: clean d64_orig run_orig

psychedelia.prg: src/c64/psychedelia.asm
	64tass -Wall --cbm-prg -Wno-implied-reg -o bin/psychedelia.prg -L bin/list-co1.txt -l bin/labels.txt src/c64/psychedelia.asm
	echo "4b67db818f0203829595d58a5f613d37  bin/psychedelia.prg" | md5sum -c

colourspace.xex: src/atari800/colourspace.asm
	64tass -Wall -Wno-implied-reg --atari-xex -o bin/colourspace.xex -L bin/list-co1.txt -l bin/labels.txt src/atari800/colourspace.asm
	# the original xex file has an incorrect end-byte which we need to patch here.
	dd if=bin/patch-atari-end-byte.bin of=bin/colourspace.xex bs=1 seek=4 count=1 conv=notrunc
	echo "fb1bd1446b5af7526ab12f44a542cdd3  bin/colourspace.xex" | md5sum -c

colourspace_nodemo.xex: src/atari800/colourspace.asm
	patch src/atari800/colourspace.asm -o src/atari800/colourspace_nodemo.asm < disable_demo.patch
	64tass -Wall -Wno-implied-reg --atari-xex -o bin/colourspace.xex -L bin/list-co1.txt -l bin/labels.txt src/atari800/colourspace_nodemo.asm
	# the original xex file has an incorrect end-byte which we need to patch here.
	dd if=bin/patch-atari-end-byte.bin of=bin/colourspace.xex bs=1 seek=4 count=1 conv=notrunc
	echo "97a88fc31017f4de2b1106bd5bc66d5b  bin/colourspace.xex" | md5sum -c

psychedelia-vic20.prg: src/vic20/psychedelia.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/psychedelia-vic20.prg -L bin/list-co1.txt -l bin/labels.txt src/vic20/psychedelia.asm
	md5sum bin/psychedelia-vic20.prg orig/psychedelia-vic20.prg

psychedelia-vic20-demo.prg: src/vic20/psychedelia-demo.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/psychedelia-vic20-demo.prg src/vic20/psychedelia-demo.asm

psychedelia-c16.prg: src/c16/psychedelia.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/psychedelia-c16.prg -L bin/list-co1.txt -l bin/labels.txt src/c16/psychedelia.asm
	md5sum bin/psychedelia-c16.prg orig/psychedelia-c16.prg

psychedelia-listing.prg: src/listing/psychedelia.asm
	64tass -Wall --cbm-prg -Wno-implied-reg -o bin/psychedelia-listing.prg -L bin/list-co1.txt -l bin/labels.txt src/listing/psychedelia.asm
	echo "c039056f04a93e16658b904733609ed2  bin/psychedelia-listing.prg" | md5sum -c

d64: psychedelia.prg
	$(C1541) -format "psychedelia,rq" d64 $(D64_IMAGE)
	$(C1541) $(D64_IMAGE) -write bin/psychedelia.prg "psychedelia"
	$(C1541) $(D64_IMAGE) -list

d64_orig:
	$(C1541) -format "psychedelia,rq" d64 $(D64_ORIG_IMAGE)
	$(C1541) $(D64_ORIG_IMAGE) -write orig/psychedelia.prg "psychedelia"
	$(C1541) $(D64_ORIG_IMAGE) -list

run: d64
	$(X64) -verbose $(D64_IMAGE)

runlisting: psychedelia-listing.prg
	$(X64) -verbose $(LISTING_IMAGE)

runvic: psychedelia-vic20.prg
	$(XVIC) -verbose $(XVIC_IMAGE)

runc16: psychedelia-c16.prg
	$(XPLUS4) -verbose $(C16_IMAGE)

run_orig: d64
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

runatari: colourspace.xex
	$(XATARI) -win-height 800 -win-width 1200 $(XATARI_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/psychedelia.prg
	-rm bin/*.txt
