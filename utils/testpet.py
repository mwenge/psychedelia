import sys
import os
from ATPC import *

line = "       .BYTE $A0,$D4,$C8,$C5,$A0,$D4,$D7,$C9       ; $1249:     "
def addPetsciiLine(l):
    if ".BYTE" not in l:
        return l
    if "$C" not in l:
        return l
    if "$D" not in l:
        return l
    prefix, suffix = l.split(".BYTE ")
    middle, suffix = suffix.split(";")
    bytes = [chr(int(b.replace("$",""), 16)) for b in middle.strip().split(',')]
    asc = ''.join([chr(b) for b in pet_to_asc_s(bytes)])
    return prefix + "; '" + asc + "'"

print(line)
print(addPetsciiLine(line))
