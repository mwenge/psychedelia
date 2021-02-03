import sys
import os
from ATPC import *

if len(sys.argv) < 2:
    print("No filename given")
    exit()

fn = sys.argv[1]
if not os.path.isfile(fn):
    print(fn + " does not exist")
    exit()

def addPetsciiLine(l):
    if ".BYTE" not in l:
        return l
    hasPetscii = "$C" in l or "$A" in l or "$D" in l
    if not hasPetscii:
        return l

    prefix, middle = l.split(".BYTE ")
    if ";" in middle:
        middle, suffix = middle.split(";")
    bytes = [chr(int(b.replace("$",""), 16)) for b in middle.strip().split(',')]
    asc = ''.join([chr(b) for b in pet_to_asc_s(bytes)])
    return prefix + "; '" + asc + "'\n" + l

f = open(fn, 'r')
ls = f.readlines()
f.close()
    
o = open(fn, 'w')
for l in ls:
    o.write(addPetsciiLine(l))
    


