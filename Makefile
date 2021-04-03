.PHONY: all clean run

XVIC = xvic
XVIC_IMAGE = "bin/psychedelia-vic20.prg"
D64_IMAGE = "bin/psychedelia.d64"
D64_ORIG_IMAGE = "orig/psychedelia.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541
XATARI_IMAGE = "bin/colourspace.xex"
XATARI = atari800

all: clean d64 run
original: clean d64_orig run_orig

psychedelia.prg: src/psychedelia.asm
	64tass -Wall --cbm-prg -Wno-implied-reg -o bin/psychedelia.prg -L bin/list-co1.txt -l bin/labels.txt src/psychedelia.asm
	md5sum bin/psychedelia.prg orig/psychedelia-crack-removed.prg

colourspace.xex: src/atari800/colourspace.asm
	64tass -Wall -Wno-implied-reg --atari-xex -o bin/colourspace.xex -L bin/list-co1.txt -l bin/labels.txt src/atari800/colourspace.asm
	# the original xex file has an incorrect end-byte which we need to patch here.
	dd if=bin/patch-atari-end-byte.bin of=bin/colourspace.xex bs=1 seek=4 count=1 conv=notrunc
	md5sum bin/colourspace.xex orig/colourspace.xex

psychedelia-vic20.prg: src/vic20/psychedelia.asm
	64tass -Wall -Wno-implied-reg --cbm-prg -o bin/psychedelia-vic20.prg -L bin/list-co1.txt -l bin/labels.txt src/vic20/psychedelia.asm
	md5sum bin/psychedelia-vic20.prg orig/psychedelia-vic20.prg

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

runvic: gridrunner-vic20.prg
	$(XVIC) -verbose $(XVIC_IMAGE)

run_orig: d64
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

runatari: colourspace.xex
	$(XATARI) -win-height 800 -win-width 1200 $(XATARI_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/psychedelia.prg
	-rm bin/*.txt
