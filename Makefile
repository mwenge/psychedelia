.PHONY: all clean run

D64_IMAGE = "bin/psychedelia.d64"
D64_ORIG_IMAGE = "orig/psychedelia.d64"
X64 = x64
X64SC = x64sc
C1541 = c1541

all: clean d64 run
original: clean d64_orig run_orig

psychedelia.prg: src/psychedelia.asm
	64tass -Wall --cbm-prg -Wno-implied-reg -o bin/psychedelia.prg -L bin/list-co1.txt -l bin/labels.txt src/psychedelia.asm
	md5sum bin/psychedelia.prg orig/psychedelia-crack-removed.prg

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

run_orig: d64
	$(X64) -verbose -moncommands bin/labels.txt $(D64_ORIG_IMAGE)

run: d64

clean:
	-rm $(D64_IMAGE) $(D64_ORIG_IMAGE) $(D64_HOKUTO_IMAGE)
	-rm bin/psychedelia.prg
	-rm bin/*.txt
