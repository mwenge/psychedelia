;
; **** ZP ABSOLUTE ADRESSES **** 
;
a02 = $02
a03 = $03
a04 = $04
a05 = $05
a06 = $06
a08 = $08
a09 = $09
a0A = $0A
a0B = $0B
a0C = $0C
a0D = $0D
a0E = $0E
a0F = $0F
a10 = $10
a11 = $11
a12 = $12
a13 = $13
a14 = $14
a15 = $15
a16 = $16
a17 = $17
a18 = $18
a19 = $19
a1A = $1A
a1B = $1B
a1C = $1C
a1D = $1D
a1E = $1E
a1F = $1F
a20 = $20
a21 = $21
a22 = $22
a23 = $23
a24 = $24
a25 = $25
a26 = $26
a27 = $27
a33 = $33
a60 = $60
a61 = $61
a62 = $62
a63 = $63
a64 = $64
a65 = $65
a66 = $66
a67 = $67
a68 = $68
aC6 = $C6
aEC = $EC
aFB = $FB
aFC = $FC
aFD = $FD
;
; **** ZP POINTERS **** 
;
p05 = $05
p0A = $0A
p0D = $0D
p10 = $10
p18 = $18
p1B = $1B
p1D = $1D
p1F = $1F
p22 = $22
p63 = $63
pFB = $FB
;
; **** FIELDS **** 
;
f0060 = $0060
f0200 = $0200
f0300 = $0300
f03BD = $03BD
f0900 = $0900
f0A00 = $0A00
f0AC0 = $0AC0
f0BBF = $0BBF
f0C00 = $0C00
f0D00 = $0D00
f0E00 = $0E00
f0EC0 = $0EC0
f0FBF = $0FBF
fA199 = $A199
;
; **** ABSOLUTE ADRESSES **** 
;
a028D = $028D
a0291 = $0291
a0314 = $0314
a0315 = $0315
a03F7 = $03F7
a03FA = $03FA
a0FC6 = $0FC6
a0FC7 = $0FC7
a0FC8 = $0FC8
a0FD1 = $0FD1
a3801 = $3801
a3FFF = $3FFF
aC058 = $C058
aC059 = $C059
aC05A = $C05A
aC05B = $C05B
aC063 = $C063
aFF08 = $FF08
;
; **** POINTERS **** 
;
p01FF = $01FF
p0800 = $0800
p0C13 = $0C13
p0FD0 = $0FD0
p3800 = $3800
;
; **** EXTERNAL JUMPS **** 
;
e034A = $034A
e035B = $035B
e0371 = $0371
e0386 = $0386
eCE0E = $CE0E
eFD6A = $FD6A
eFDED = $FDED

        * = $1001

        .BYTE $0B,$10,$0A,$00,$9E,$34,$31,$31
        .BYTE $32,$00,$00,$00,$00,$00,$00
        LDA #$00
        STA $FF15    ;Background color register
        STA $FF19    ;Color register #4
        STA a13      ;CHANNL  Flag: INPUT prompt
        LDA #>p0800
        STA aFC      ;XoN     Char to send for a x-on (RS232)
        LDA #<p0800
        STA aFB      ;CURBNK  Current bank configuration
        LDX #$00
b1024   LDA aFC      ;XoN     Char to send for a x-on (RS232)
        STA f1067,X
        LDA aFB      ;CURBNK  Current bank configuration
        STA f1049,X
        CLC 
        ADC #$28
        STA aFB      ;CURBNK  Current bank configuration
        LDA aFC      ;XoN     Char to send for a x-on (RS232)
        ADC #$00
        STA aFC      ;XoN     Char to send for a x-on (RS232)
        INX 
        CPX #$19
        BNE b1024
        LDA #$80
        STA a0291
        JSR s2286
        JMP j1417

f1049   .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00
f1067   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$BF,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00
j1085   LDX #$00
a1088   =*+$01
b1087   LDA #$CF
        STA f0C00,X  ;TEDSCN  TED character pointers
        STA f0D00,X
        STA f0E00,X
        STA f0EC0,X
        LDA #$00
        STA p0800,X  ;TEDATR  TED attribute bytes
        STA f0900,X
        STA f0A00,X
        STA f0AC0,X
        DEX 
        BNE b1087
        RTS 

f10A7   .BYTE $34,$38,$3B,$08,$0B,$10,$13,$18
        .BYTE $1B,$20,$23,$30,$33,$2B,$28,$00
s10B7   LDX a03      ;ZPVEC1  Temp (renumber)
        LDA f1049,X
        STA a05      ;ZPVEC2  Temp (renumber)
        LDA f1067,X
        STA a06
        LDY a02      ;SRCHTK  Token 'search' looks for (run-time stack)
b10C5   RTS 

s10C6   LDA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        AND #$80
        BNE b10C5
        LDA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        CMP #$28
        BPL b10C5
        LDA a03      ;ZPVEC1  Temp (renumber)
        AND #$80
        BNE b10C5
        LDA a03      ;ZPVEC1  Temp (renumber)
        CMP #$18
        BPL b10C5
        JSR s10B7
        LDA a17
        BNE b1100
        LDA (p05),Y  ;ZPVEC2  Temp (renumber)
        LDX #$00
b10E9   CMP f1647,X
        BEQ b10F3
        INX 
        CPX #$08
        BNE b10E9
b10F3   TXA 
        STA aFD      ;XoFF    Char to send for a x-off (RS232)
        LDX a04
        INX 
        CPX aFD      ;XoFF    Char to send for a x-off (RS232)
        BEQ b1100
        BPL b1100
        RTS 

b1100   LDX a04
        LDA f1647,X
        STA (p05),Y  ;ZPVEC2  Temp (renumber)
        RTS 

s1108   JSR s11C7
        LDY #$00
        LDA a04
        CMP #$07
        BNE b1114
        RTS 

b1114   LDA #$07
        STA a11BD
        LDA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        STA a08      ;ENDCHR  Flag: scan for quote at end of string
        LDA a03      ;ZPVEC1  Temp (renumber)
        STA a09      ;TRMPOS  Screen column from last TAB
        LDX a1651
        LDA f1652,X
        STA a0D      ;VALTYP  Data type: $FF = string   $00 = numeric
        LDA f1662,X
        STA a0E      ;INTFLG  Data type: $80 = integer, $00 = floating
        LDA f1672,X
        STA a10      ;SUBFLG  Flag: subscript ref / user function coll
        LDA f1682,X
        STA a11      ;INPFLG  Flag: $00 = INPUT, $43 = GET, $98 = READ
b1138   LDA a08      ;ENDCHR  Flag: scan for quote at end of string
        CLC 
        ADC (p0D),Y  ;VALTYP  Data type: $FF = string   $00 = numeric
        STA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        LDA a09      ;TRMPOS  Screen column from last TAB
        CLC 
        ADC (p10),Y  ;SUBFLG  Flag: subscript ref / user function coll
        STA a03      ;ZPVEC1  Temp (renumber)
        TYA 
        PHA 
        JSR s11C7
        PLA 
        TAY 
        INY 
        LDA (p0D),Y  ;VALTYP  Data type: $FF = string   $00 = numeric
        CMP #$55
        BNE b1138
        DEC a11BD
        LDA a11BD
        CMP a04
        BEQ b1166
        CMP #$01
        BEQ b1166
        INY 
        JMP b1138

b1166   LDA a08      ;ENDCHR  Flag: scan for quote at end of string
        STA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        LDA a09      ;TRMPOS  Screen column from last TAB
        STA a03      ;ZPVEC1  Temp (renumber)
        RTS 

        .BYTE $00,$01,$01,$01,$00,$FF,$FF,$FF
        .BYTE $55,$00,$02,$00,$FE,$55,$00,$03
        .BYTE $00,$FD,$55,$00,$04,$00,$FC,$55
        .BYTE $FF,$01,$05,$05,$01,$FF,$FB,$FB
        .BYTE $55,$00,$07,$00,$F9,$55,$55,$FF
        .BYTE $FF,$00,$01,$01,$01,$00,$FF,$55
        .BYTE $FE,$00,$02,$00,$55,$FD,$00,$03
        .BYTE $00,$55,$FC,$00,$04,$00,$55,$FB
        .BYTE $FB,$FF,$01,$05,$05,$01,$FF,$55
        .BYTE $F9,$00,$07,$00,$55,$55
a11BD   .BYTE $00
a11BF   =*+$01
s11BE   LDA fA199,X
        INC a11BF
        RTS 

        BRK #$00
s11C7   LDA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        PHA 
        LDA a03      ;ZPVEC1  Temp (renumber)
        PHA 
        JSR s10C6
        LDA a14      ;LINNUM  Temp: integer value
        BNE b11DC
b11D4   PLA 
        STA a03      ;ZPVEC1  Temp (renumber)
        PLA 
        STA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        RTS 

        RTS 

b11DC   CMP #$03
        BEQ b120E
        LDA #$27
        SEC 
        SBC a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        STA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        LDY a14      ;LINNUM  Temp: integer value
        CPY #$02
        BEQ b1218
        JSR s10C6
        LDA a14      ;LINNUM  Temp: integer value
        CMP #$01
        BEQ b11D4
        LDA #$17
        SEC 
        SBC a03      ;ZPVEC1  Temp (renumber)
        STA a03      ;ZPVEC1  Temp (renumber)
        JSR s10C6
j1200   PLA 
        TAY 
        PLA 
        STA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        TYA 
        PHA 
        JSR s10C6
        PLA 
        STA a03      ;ZPVEC1  Temp (renumber)
        RTS 

b120E   LDA #$17
        SEC 
        SBC a03      ;ZPVEC1  Temp (renumber)
        STA a03      ;ZPVEC1  Temp (renumber)
        JMP j1200

b1218   LDA #$17
        SEC 
        SBC a03      ;ZPVEC1  Temp (renumber)
        STA a03      ;ZPVEC1  Temp (renumber)
        JSR s10C6
        PLA 
        STA a03      ;ZPVEC1  Temp (renumber)
        PLA 
        STA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        RTS 

f1229   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$FB
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
f1269   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$FD
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
f12A9   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
f12E9   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
f1329   .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
f1369   .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
f13A9   .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
s13E9   LDX #$00
        TXA 
b13EC   STA f1229,X
        STA f1269,X
        LDA #$FF
        STA f12A9,X
        LDA #$00
        STA f12E9,X
        STA f1329,X
        STA f1369,X
        STA f13A9,X
        INX 
        CPX #$40
        BNE b13EC
        STA a12      ;TANSGN  Flag TAN siqn / comparison result
        STA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        STA a13      ;CHANNL  Flag: INPUT prompt
        STA a17
        LDA #$01
        STA a15
        RTS 

j1417   JSR s14AD
        LDX #$00
        TXA 
b141D   STA s14AD,X
        INX 
        CPX #$10
        BNE b141D
        JSR s1F18
        JSR s13E9
        JSR s19F9
j142E   INC a14A9
        LDA a27      ;RESMOH  
        CMP #$35
        BNE b1449
b1437   LDA a27      ;RESMOH  
        CMP #$40
        BNE b1437
b143D   LDA a27      ;RESMOH  
        CMP #$35
        BNE b143D
b1443   LDA a27      ;RESMOH  
        CMP #$40
        BNE b1443
b1449   LDA a1F17
        BEQ b1458
        CMP #$17
        BNE b1455
        JMP j2473

b1455   JSR s1F18
b1458   LDA a14A9
        CMP a1640
        BNE b1465
        LDA #$00
        STA a14A9
b1465   LDX a14A9
        LDA f12A9,X
        CMP #$FF
        BNE b1474
        STX a13      ;CHANNL  Flag: INPUT prompt
        JMP j142E

b1474   STA a04
        DEC f1329,X
        BNE b14A6
        LDA f12E9,X
        STA f1329,X
        LDA f1229,X
        STA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        LDA f1269,X
        STA a03      ;ZPVEC1  Temp (renumber)
        LDA f1369,X
        STA a1651
        LDA f13A9,X
        STA a14      ;LINNUM  Temp: integer value
        LDA a04
        AND #$80
        BNE b14AA
        TXA 
        PHA 
        JSR s1108
        PLA 
        TAX 
        DEC f12A9,X
b14A6   JMP j142E

a14A9   .BYTE $00
b14AA   JMP j1AEA

s14AD   SEI 
        LDA #<p14C4
        STA a0314    ;CINV    IRQ Ram Vector
        LDA #>p14C4
        STA a0315
        LDA #$0A
        STA a1638
        STA a1639
        CLI 
        RTS 

a14C2   .BYTE $02,$00
p14C4   DEC a25F8
        BEQ b14CC
        JMP eCE0E

b14CC   LDA #$02
        STA a25F8
        LDA a21E7
        BEQ b14E4
        DEC a21E7
        BNE b14E4
        LDA a1644
        STA a21E7
        JSR s2171
b14E4   DEC a14C2
        BEQ b14EC
        JMP j15FE

b14EC   LDA #$00
        STA a0C      ;DIMFLG  Flag: Default Array DIMension
        LDA a163F
        STA a14C2
        JSR s162B
        JSR s236A
        LDA a21
        AND #$03
        CMP #$03
        BEQ b1529
        CMP #$02
        BEQ b150E
        INC a1639
        INC a1639
b150E   DEC a1639
        LDA a1639
        CMP #$FF
        BNE b1520
        LDA #$17
        STA a1639
        JMP b1529

b1520   CMP #$18
        BNE b1529
        LDA #$00
        STA a1639
b1529   LDA a21
        AND #$0C
        CMP #$0C
        BEQ b1556
        CMP #$08
        BEQ b153B
        INC a1638
        INC a1638
b153B   DEC a1638
        LDA a1638
        CMP #$FF
        BNE b154D
        LDA #$27
        STA a1638
        JMP b1556

b154D   CMP #$28
        BNE b1556
        LDA #$00
        STA a1638
b1556   LDA a21
        AND #$40
        BEQ b1564
        LDA #$00
        STA a163B
        JMP j15F7

b1564   LDA a163C
        BEQ b1574
        LDA a163B
        BEQ b1571
        JMP j15F7

b1571   INC a163B
b1574   LDA a2239
        BEQ b1581
        DEC a2239
        BEQ b1581
        JMP j1595

b1581   DEC a1D2A
        BEQ b1589
        JMP j15F7

b1589   LDA a1641
        STA a1D2A
        LDA a1645
        STA a2239
j1595   INC a163A
        LDA a163A
        CMP a1640
        BNE b15A5
        LDA #$00
        STA a163A
b15A5   TAX 
        LDA f12A9,X
        CMP #$FF
        BEQ b15BF
        LDA a13      ;CHANNL  Flag: INPUT prompt
        AND a164F
        BEQ j15F7
        TAX 
        LDA f12A9,X
        CMP #$FF
        BNE j15F7
        STX a163A
b15BF   LDA a1638
        STA f1229,X
        LDA a1639
        STA f1269,X
        LDA a1650
        BEQ b15DE
        LDA #$19
        SEC 
        SBC a1639
        ORA #$80
        STA f12A9,X
        JMP j15E9

b15DE   LDA a1646
        STA f12A9,X
        LDA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        STA f1369,X
j15E9   LDA a163E
        STA f12E9,X
        STA f1329,X
        LDA a15
        STA f13A9,X
j15F7   LDA #$41
        STA a0C      ;DIMFLG  Flag: Default Array DIMension
        JSR s162B
j15FE   LDA aEC      ;KEYTAB  Key scan table indirect
        LDX #$03
b1602   CMP f25FA,X
        BEQ b160A
        DEX 
        BNE b1602
b160A   LDA f25FE,X
        STA a1E68
        LDA #$00
        STA aEC      ;KEYTAB  Key scan table indirect
        JSR s178E
        JMP eCE0E

s161A   LDX a1639
        LDA f1049,X
        STA a0A      ;VERCK   Flag: 0 = load 1 - verify
        LDA f1067,X
        STA a0B      ;COUNT   Input buffer pointer / No. of subsctipts
        LDY a1638
b162A   RTS 

s162B   LDA a2403
        BNE b162A
        JSR s161A
        LDA a0C      ;DIMFLG  Flag: Default Array DIMension
        STA (p0A),Y  ;VERCK   Flag: 0 = load 1 - verify
        RTS 

a1638   .BYTE $0A
a1639   .BYTE $0A
a163A   .BYTE $00
a163B   .BYTE $00
a163C   .BYTE $00
f163D   .BYTE $00
a163E   .BYTE $0C
a163F   .BYTE $02
a1640   .BYTE $1F
a1641   .BYTE $01
a1642   .BYTE $01
a1643   .BYTE $07
a1644   .BYTE $04
a1645   .BYTE $01
a1646   .BYTE $07
f1647   .BYTE $00,$26,$22,$24,$25,$23,$47,$71
a164F   .BYTE $FF
a1650   .BYTE $00
a1651   .BYTE $05
f1652   .BYTE $6F,$92,$C2,$06,$22,$56,$41,$91
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
f1662   .BYTE $11,$16,$16,$17,$17,$17,$19,$19
f166A   .BYTE $30,$31,$32,$33,$34,$35,$36,$37
f1672   .BYTE $96,$AA,$E4,$14,$3C,$72,$69,$B1
        .BYTE $80,$80,$80,$80,$80,$80,$80,$80
f1682   .BYTE $11,$16,$16,$17,$17,$17,$19,$19
        .BYTE $30,$31,$32,$33,$34,$35,$36,$37
        .BYTE $00,$55,$01,$02,$55,$01,$02,$03
        .BYTE $55,$01,$02,$03,$04,$55,$00,$00
        .BYTE $00,$55,$FF,$FE,$55,$FF,$55,$55
        .BYTE $FF,$55,$FF,$FE,$55,$00,$00,$00
        .BYTE $55,$01,$02,$03,$04,$55,$01,$02
        .BYTE $03,$55,$01,$02,$55,$00,$55,$55
        .BYTE $00,$FF,$00,$55,$00,$00,$55,$01
        .BYTE $02,$03,$00,$01,$02,$03,$55,$04
        .BYTE $05,$06,$04,$00,$01,$02,$55,$04
        .BYTE $00,$04,$00,$04,$55,$FF,$03,$55
        .BYTE $00,$55,$FF,$00,$01,$55,$02,$03
        .BYTE $55,$03,$03,$03,$04,$04,$04,$04
        .BYTE $55,$03,$02,$03,$04,$05,$05,$05
        .BYTE $55,$05,$06,$06,$07,$07,$55,$07
        .BYTE $07,$55,$00,$55,$FF,$55,$00,$55
        .BYTE $02,$55,$01,$55,$FD,$55,$FE,$55
        .BYTE $00,$55,$FF,$55,$FE,$55,$FF,$55
        .BYTE $02,$55,$01,$55,$FC,$55,$00,$55
        .BYTE $00,$01,$FF,$55,$00,$55,$00,$01
        .BYTE $02,$FE,$FF,$55,$00,$03,$FD,$55
        .BYTE $00,$04,$FC,$55,$00,$06,$FA,$55
        .BYTE $00,$55,$FF,$00,$00,$55,$00,$55
        .BYTE $FE,$FF,$00,$00,$FF,$55,$FD,$01
        .BYTE $01,$55,$FC,$02,$02,$55,$FA,$04
        .BYTE $04,$55,$00,$55,$FF,$01,$55,$FE
        .BYTE $02,$55,$FD,$03,$55,$FC,$04,$FC
        .BYTE $FC,$04,$04,$55,$FB,$05,$55,$FA
        .BYTE $06,$FA,$FA,$06,$06,$55,$00,$55
        .BYTE $01,$FF,$55,$FE,$02,$55,$03,$FD
        .BYTE $55,$FC,$04,$FF,$01,$FF,$01,$55
        .BYTE $05,$FB,$55,$FA,$06,$FE,$02,$FE
        .BYTE $02,$55,$00,$55
s178E   LDA a1D29
        BEQ b1796
        JMP j1BCD

b1796   LDA a12      ;TANSGN  Flag TAN siqn / comparison result
        BEQ b179E
        DEC a12      ;TANSGN  Flag TAN siqn / comparison result
        BNE b17AB
b179E   LDA a27      ;RESMOH  
        CMP #$40
        BNE b17AC
        LDA #$00
        STA a12      ;TANSGN  Flag TAN siqn / comparison result
        JSR s25B6
b17AB   RTS 

b17AC   LDY a1E68
        BEQ b17AB
        LDY a1940
        STY a12      ;TANSGN  Flag TAN siqn / comparison result
        CMP #$3C
        BNE b17E4
        INC a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        LDA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        AND #$0F
        STA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        AND #$08
        BEQ b17C9
        JMP j2536

b17C9   JSR s19F9
        LDA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        LDX #$00
b17D5   LDA f1A1A,Y
        STA f19D1,X
        INY 
        INX 
        CPX #$10
        BNE b17D5
        JMP j1A07

b17E4   CMP #$0D
        BNE b180D
        INC a15
        LDA a15
        CMP #$05
        BNE b17F4
        LDA #$00
        STA a15
b17F4   ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR s19F9
        LDX #$00
b17FE   LDA f1A9A,Y
        STA f19D1,X
        INY 
        INX 
        CPX #$10
        BNE b17FE
        JMP j1A07

b180D   CMP #$2A
        BNE b1832
        LDA a1650
        EOR #$01
        STA a1650
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR s19F9
        LDX #$00
b1823   LDA f1B45,Y
        STA f19D1,X
        INY 
        INX 
        CPX #$10
        BNE b1823
        JMP j1A07

b1832   CMP #$12
        BNE b183C
        LDA #$01
        STA a1D29
        RTS 

b183C   CMP #$14
        BNE b1846
        LDA #$02
        STA a1D29
        RTS 

b1846   CMP #$1C
        BNE b1850
        LDA #$03
        STA a1D29
        RTS 

b1850   CMP #$29
        BNE b185A
        LDA #$04
        STA a1D29
        RTS 

b185A   CMP #$1D
        BNE b1868
        LDA #$01
        STA a1A
        LDA #$05
        STA a1D29
        RTS 

b1868   CMP #$16
        BNE b1890
        LDA a164F
        EOR #$FF
        STA a164F
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR s19F9
        LDX #$00
b1880   LDA f1DDB,Y
        STA f19D1,X
        INY 
        INX 
        CPX #$10
        BNE b1880
        JMP j1A07

        RTS 

b1890   LDX #$00
b1892   CMP f10A7,X
        BEQ b189F
        INX 
        CPX #$10
        BNE b1892
        JMP j18A2

b189F   JMP j1DFB

j18A2   CMP #$09
        BNE b18AC
        LDA #$06
        STA a1D29
        RTS 

b18AC   LDX #$00
b18AE   CMP f1F90,X
        BEQ b18BB
        INX 
        CPX #$04
        BNE b18AE
        JMP j18CC

b18BB   STX a1F34
        LDA a2110
        BNE j18CC
        LDA #$80
        STA a1D29
        JSR s1F35
        RTS 

j18CC   CMP #$3E
        BNE b18E8
        LDA a2110
        BNE b18DD
        LDA #$80
        STA a1D29
        JMP j2111

b18DD   LDA #$00
        STA a2110
        STA a21E7
        JMP j21F8

b18E8   CMP #$1F
        BNE b18F2
        LDA #$07
        STA a1D29
        RTS 

b18F2   CMP #$26
        BNE b18FC
        LDA #$08
        STA a1D29
        RTS 

b18FC   CMP #$31
        BNE b1906
        LDA #$09
        STA a1D29
        RTS 

b1906   CMP #$11
        BNE b190D
        JMP j223A

b190D   CMP #$2E
        BNE b1932
        INC a2560
        LDA a2560
        AND #$0F
        TAY 
        LDA f2561,Y
        LDX #$00
b191F   STA f0C00,X  ;TEDSCN  TED character pointers
        STA f0D00,X
        STA f0E00,X
        STA f0EC0,X
        DEX 
        BNE b191F
        STA a1088
        RTS 

b1932   CMP #$0A
        BNE b193F
        LDA a2571
        EOR #$01
        STA a2571
        RTS 

b193F   RTS 

a1940   .BYTE $10,$01,$01,$FF,$FF,$55,$02,$02
        .BYTE $FE,$FE,$55,$01,$03,$03,$01,$FF
        .BYTE $FD,$FD,$FF,$55,$03,$03,$FD,$FD
        .BYTE $55,$04,$04,$FC,$FC,$55,$03,$05
        .BYTE $05,$03,$FD,$FB,$FB,$FD,$55,$00
        .BYTE $55,$FF,$01,$01,$FF,$55,$FE,$02
        .BYTE $02,$FE,$55,$FD,$FF,$01,$03,$03
        .BYTE $01,$FF,$FD,$55,$FD,$03,$03,$FD
        .BYTE $55,$FC,$04,$04,$FC,$55,$FB,$FD
        .BYTE $03,$05,$05,$03,$FD,$FB,$55,$00
        .BYTE $55,$00,$01,$00,$FF,$55,$00,$02
        .BYTE $00,$FE,$55,$00,$03,$00,$FD,$55
        .BYTE $00,$04,$00,$FC,$55,$00,$05,$00
        .BYTE $FB,$55,$00,$06,$00,$FA,$55,$00
        .BYTE $55,$FF,$00,$01,$00,$55,$FE,$00
        .BYTE $02,$00,$55,$FD,$00,$03,$00,$55
        .BYTE $FC,$00,$04,$00,$55,$FB,$00,$05
        .BYTE $00,$55,$FA,$00,$06,$00,$55,$00
f19D0   .BYTE $55
f19D1   .BYTE $55,$00,$55,$FF,$FF,$FF
a19D7   .BYTE $FF
a19D8   .BYTE $FF
a19D9   .BYTE $FF,$FF,$FF,$FF,$FF
a19DE   .BYTE $FF,$FF,$FF
f19E1   .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF ;ISC $FFFF,X
s19F9   LDX #$28
b19FB   LDA #$20
        STA f19D0,X
        STA f0FBF,X
        DEX 
        BNE b19FB
        RTS 

j1A07   LDX #$28
b1A09   LDA f19D0,X
        AND #$3F
        STA f0FBF,X
        LDA #$5C
        STA f0BBF,X
        DEX 
        BNE b1A09
        RTS 

f1A1A   .BYTE $D3,$D4,$C1,$D2,$A0,$CF,$CE,$C5
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $D4,$C8,$C5,$A0,$D4,$D7,$C9,$D3
        .BYTE $D4,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $CC,$C1,$A0,$CC,$CC,$C1,$CD,$C9
        .BYTE $D4,$C1,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $D3,$D4,$C1,$D2,$A0,$D4,$D7,$CF
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $C4,$C5,$CC,$D4,$CF,$C9,$C4,$D3
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $C4,$C9,$C6,$C6,$D5,$D3,$C5,$C4
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $CD,$D5,$CC,$D4,$C9,$C3,$D2,$CF
        .BYTE $D3,$D3,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $D0,$D5,$CC,$D3,$C1,$D2,$A0,$A0
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
f1A9A   .BYTE $CE,$CF,$A0,$D3,$D9,$CD,$CD,$C5
        .BYTE $D4,$D2,$D9,$A0,$A0,$A0,$A0,$A0
        .BYTE $D9,$AD,$C1,$D8,$C9,$D3,$A0,$D3
        .BYTE $D9,$CD,$CD,$C5,$D4,$D2,$D9,$A0
        .BYTE $D8,$AD,$D9,$A0,$D3,$D9,$CD,$CD
        .BYTE $C5,$D4,$D2,$D9,$A0,$A0,$A0,$A0
        .BYTE $D8,$AD,$C1,$D8,$C9,$D3,$A0,$D3
        .BYTE $D9,$CD,$CD,$C5,$D4,$D2,$D9,$A0
        .BYTE $D1,$D5,$C1,$C4,$A0,$D3,$D9,$CD
        .BYTE $CD,$C5,$D4,$D2,$D9,$A0,$A0,$A0
j1AEA   .BYTE $A5,$04,$29,$7F,$85,$16
        LDA #$19
        SEC 
        SBC a16      ;TEMPPT  Pointer: temporary string stack
        STA a03      ;ZPVEC1  Temp (renumber)
        DEC a03      ;ZPVEC1  Temp (renumber)
        LDA #$00
        STA a04
        LDA #$01
        STA a17
        JSR s11C7
        INC a03      ;ZPVEC1  Temp (renumber)
        LDA #$00
        STA a17
        LDA a1643
        EOR #$07
        STA a04
b1B11   JSR s11C7
        INC a03      ;ZPVEC1  Temp (renumber)
        INC a04
        LDA a04
        CMP #$08
        BNE b1B23
        JMP j1B2B

        INC a04
b1B23   STA a04
        LDA a03      ;ZPVEC1  Temp (renumber)
        CMP #$19
        BNE b1B11
j1B2B   LDX a14A9
        DEC f12A9,X
        LDA f12A9,X
        CMP #$80
        BEQ b1B3B
        JMP j142E

b1B3B   LDA #$FF
        STA f12A9,X
        STX a13      ;CHANNL  Flag: INPUT prompt
        JMP j142E

f1B45   .BYTE $CC,$C9,$CE,$C5,$A0,$CD,$CF,$C4
        .BYTE $C5,$BA,$A0,$CF,$C6,$C6,$A0,$A0
        .BYTE $CC,$C9,$CE,$C5,$A0,$CD,$CF,$C4
        .BYTE $C5,$BA,$A0,$CF,$CE,$A0,$A0,$A0
j1B65   LDA a19      ;TEMPST  Stack for temporary strings
        PHA 
        CLC 
        ADC #$FC
        STA a19      ;TEMPST  Stack for temporary strings
        LDY #$00
b1B6F   LDA f1DCC,Y
        STA (p18),Y
        INY 
        CPY #$10
        BNE b1B6F
        PLA 
        STA a19      ;TEMPST  Stack for temporary strings
        LDA #$00
        STA a1BBA
        STA a1BBC
        STA a1BBD
        LDA a1BBB
        BEQ b1BB8
b1B8C   LDA a1BBD
b1B8F   CLC 
        ADC a1BB9
        STA a1BBD
        LDX a1BBD
        LDY a1BBA
        LDA f1BBE,X
        STA (p18),Y
        CPX #$08
        BNE b1BAD
        LDA #$00
        STA a1BBD
        INC a1BBA
b1BAD   INC a1BBC
        LDA a1BBC
        CMP a1BBB
        BNE b1B8C
b1BB8   RTS 

a1BBA   =*+$01
a1BB9   BNE b1B8F
a1BBB   RTS 

a1BBC   .BYTE $FF
a1BBD   .BYTE $FF
f1BBE   .BYTE $20,$65,$74,$75,$61,$F6,$EA,$E7
        .BYTE $A0
b1BC7   LDA #$00
        STA a1D29
b1BCC   RTS 

j1BCD   LDY a1E68
        BEQ b1BCC
        AND #$80
        BEQ b1BD9
        JMP j1F96

b1BD9   LDA a12      ;TANSGN  Flag TAN siqn / comparison result
        BEQ b1BE2
        DEC a12      ;TANSGN  Flag TAN siqn / comparison result
        JMP j1C8F

b1BE2   LDA a27      ;RESMOH  
        CMP #$40
        BNE b1BEB
        JMP j1C8F

b1BEB   LDA #$05
        STA a12      ;TANSGN  Flag TAN siqn / comparison result
        LDA a1D29
        CMP #$05
        BEQ b1BFA
        CMP #$03
        BNE b1C24
b1BFA   LDX #$00
b1BFC   LDA f12A9,X
        CMP #$FF
        BNE b1BC7
        INX 
        CPX a1640
        BNE b1BFC
        LDA a21E7
        BNE b1BC7
        LDA a231A
        CMP #$02
        BEQ b1BC7
        LDA a2571
        BNE b1BC7
        LDA #$FF
        STA a1F17
        LDA #$00
        STA a163A
b1C24   LDA #>p0FD0
        STA a19      ;TEMPST  Stack for temporary strings
        LDA #<p0FD0
        STA a18
        LDX a1D29
        LDA a27      ;RESMOH  
        CMP #$2C
        BNE b1C46
        INC f163D,X
        LDA f163D,X
        CMP f1D0B,X
        BNE b1C58
        DEC f163D,X
        JMP b1C58

b1C46   CMP #$2F
        BNE b1C58
        DEC f163D,X
        LDA f163D,X
        CMP f1D15,X
        BNE b1C58
        INC f163D,X
b1C58   CPX #$05
        BNE b1C89
        JSR s1C65
        STA f1647,Y
        JMP b1C89

s1C65   LDA a1642
        CLC 
        ROR 
        ROR 
        ROR 
        AND #$0F
        TAX 
        LDY a1A
        LDA f1DCC,X
        STA f25FA
        LDA a1642
        AND #$07
        ASL 
        ASL 
        ASL 
        ASL 
        AND #$70
        ORA f25FA
        STA $FF19    ;Color register #4
        RTS 

b1C89   JSR j1C8F
        JMP j1CE8

j1C8F   LDA #>p0FD0
        STA a19      ;TEMPST  Stack for temporary strings
        LDA #<p0FD0
        STA a18
        LDX a1D29
        CPX #$05
        BNE b1CA4
        JSR s1C65
        LDX a1D29
b1CA4   LDA f1D1F,X
        STA a1BB9
        LDA f163D,X
        STA a1BBB
        TXA 
        PHA 
        LDA a1F33
        BNE b1CBF
        LDA #$01
        STA a1F33
        JSR s19F9
b1CBF   PLA 
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        LDX #$00
b1CC7   LDA f1D2B,Y
        STA f19D1,X
        INY 
        INX 
        CPX #$10
        BNE b1CC7
        LDA a1D29
        CMP #$05
        BNE b1CE2
        LDA #$30
        CLC 
        ADC a1A
        STA a19D8
b1CE2   JSR j1A07
        JMP j1B65

j1CE8   LDA a27      ;RESMOH  
        CMP #$01
        BEQ b1CEF
        RTS 

b1CEF   LDA a1D29
        CMP #$05
        BNE b1CFF
        INC a1A
        LDA a1A
        CMP #$08
        BEQ b1CFF
        RTS 

b1CFF   LDA #$00
        STA a1D29
        STA a1F33
        STA $FF19    ;Color register #4
        RTS 

f1D0B   .BYTE $00,$40,$08,$40,$10,$78,$08,$20
        .BYTE $10,$08
f1D15   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f1D1F   .BYTE $00,$01,$08,$01,$04,$01,$08,$02
        .BYTE $04,$08
a1D29   .BYTE $00
a1D2A   .BYTE $01
f1D2B   .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $D3,$CD,$CF,$CF,$D4,$C8,$C9,$CE
        .BYTE $C7,$A0,$C4,$C5,$CC,$C1,$D9,$BA
        .BYTE $C3,$D5,$D2,$D3,$CF,$D2,$A0,$D3
        .BYTE $D0,$C5,$C5,$C4,$A0,$A0,$A0,$BA
        .BYTE $C2,$D5,$C6,$C6,$C5,$D2,$A0,$CC
        .BYTE $C5,$CE,$C7,$D4,$C8,$A0,$A0,$BA
        .BYTE $D0,$D5,$CC,$D3,$C5,$A0,$D3,$D0
        .BYTE $C5,$C5,$C4,$A0,$A0,$A0,$A0,$BA
        .BYTE $C3,$CF,$CC,$CF,$D5,$D2,$A0,$B0
        .BYTE $A0,$D3,$C5,$D4,$A0,$A0,$A0,$BA
        .BYTE $D7,$C9,$C4,$D4,$C8,$A0,$CF,$C6
        .BYTE $A0,$CC,$C9,$CE,$C5,$A0,$A0,$BA
        .BYTE $D3,$C5,$D1,$D5,$C5,$CE,$C3,$C5
        .BYTE $D2,$A0,$D3,$D0,$C5,$C5,$C4,$BA
        .BYTE $D0,$D5,$CC,$D3,$C5,$A0,$D7,$C9
        .BYTE $C4,$D4,$C8,$A0,$A0,$A0,$A0,$BA
        .BYTE $C2,$C1,$D3,$C5,$A0,$CC,$C5,$D6
        .BYTE $C5,$CC,$A0,$A0,$A0,$A0,$A0,$BA
        .BYTE $00
f1DCC   .BYTE $06,$02,$04,$05,$03,$07,$01,$08
        .BYTE $09,$0A,$0B,$0C,$0D,$0E,$0F
f1DDB   .BYTE $D4,$D2,$C1,$C3,$CB,$C9,$CE,$C7
        .BYTE $BA,$A0,$CF,$C6,$C6,$A0,$A0,$A0
        .BYTE $D4,$D2,$C1,$C3,$CB,$C9,$CE,$C7
        .BYTE $BA,$A0,$CF,$CE,$A0,$A0,$A0,$A0
j1DFB   LDA a1E68
        AND #$04
        BEQ b1E05
        JMP j241D

b1E05   TXA 
        PHA 
        JSR s19F9
        LDX #$00
b1E0C   LDA f1E38,X
        STA f19D1,X
        INX 
        CPX #$10
        BNE b1E0C
        PLA 
        PHA 
        TAX 
        BEQ b1E31
b1E1C   INC a19D9
        LDA a19D9
        CMP #$BA
        BNE b1E2E
        LDA #$30
        STA a19D9
        INC a19D8
b1E2E   DEX 
        BNE b1E1C
b1E31   JMP j1E69

j1E34   JSR j1A07
        RTS 

f1E38   .BYTE $D0,$D2,$C5,$D3,$C5,$D4,$A0,$B0
        .BYTE $B0,$A0,$A0,$A0,$A0,$A0
f1E46   .BYTE $A0,$BA
f1E48   .BYTE $A0,$C1,$C3,$D4,$C9,$D6,$C1,$D4
        .BYTE $C5,$C4,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $A0,$C4,$C1,$D4,$C1,$A0,$D3,$D4
        .BYTE $CF,$D2,$C5,$C4,$A0,$A0,$A0,$A0
a1E68   .BYTE $00
j1E69   LDA a1E68
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        LDX #$00
b1E75   LDA f1E48,Y
        STA f19E1,X
        INY 
        INX 
        CPX #$10
        BNE b1E75
        LDA a1E68
        AND #$01
        BNE b1E8B
        JMP j1EAB

b1E8B   PLA 
        TAX 
        JSR s1EF0
        LDY #$00
        LDX #$00
b1E94   LDA f163D,X
        STA (p1B),Y
        INY 
        INX 
        CPX #$15
        BNE b1E94
        LDA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        STA (p1B),Y
        INY 
        LDA a15
        STA (p1B),Y
        JMP j1E34

j1EAB   PLA 
        TAX 
        JSR s1EF0
        LDY #$03
        LDA (p1B),Y
        CMP a1640
        BEQ b1EBF
        JSR s1F0C
        JMP j1ED3

b1EBF   LDX #$00
        LDY #$07
b1EC3   LDA (p1B),Y
        CMP f1647,X
        BNE j1ED3
        INY 
        INX 
        CPX #$08
        BNE b1EC3
        JMP j1ED3

j1ED3   LDA #$FF
        STA a1F17
        LDY #$00
b1EDA   LDA (p1B),Y
        STA f163D,Y
        INY 
        CPY #$15
        BNE b1EDA
        LDA (p1B),Y
        STA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        INY 
        LDA (p1B),Y
        STA a15
        JMP j1E34

s1EF0   LDA #>p2800
        STA a1C
        LDA #<p2800
        STA a1B
        TXA 
        BEQ b1F0B
b1EFB   LDA a1B
        CLC 
        ADC #$20
        STA a1B
        LDA a1C
        ADC #$00
        STA a1C
        DEX 
        BNE b1EFB
b1F0B   RTS 

s1F0C   LDA #$FF
        STA a1F17
        LDA #$00
        STA a163A
        RTS 

a1F17   .BYTE $00
s1F18   LDA #$00
        STA a14A9
        STA a13      ;CHANNL  Flag: INPUT prompt
        LDX #$00
        LDA #$FF
b1F23   STA f12A9,X
        INX 
        CPX #$40
        BNE b1F23
        LDA #$00
        STA a1F17
        JMP j1085

a1F33   .BYTE $00
a1F34   .BYTE $00
s1F35   JSR s19F9
        LDA a1E68
        AND #$01
        BEQ b1F4F
        LDX #$00
b1F41   LDA f1F80,X
        STA f19D1,X
        INX 
        CPX #$10
        BNE b1F41
        JSR j1A07
b1F4F   LDA #$2A
        STA a1E
        LDX a1F34
        LDA f1F7C,X
        STA a1D
        LDA a1E68
        AND #$01
        BEQ b1F74
        LDA #$10
        STA a1F94
        LDY #$00
        LDA a15
        STA (p1D),Y
        LDA a163E
        INY 
        STA (p1D),Y
        RTS 

b1F74   LDA #$FF
        STA a2110
        JMP j2087

f1F7C   .BYTE $00,$20,$40
        .BYTE $60
f1F80   .BYTE $C4,$C1,$D4,$C1,$BA,$A0,$B0,$B0
        .BYTE $B0,$A0,$C6,$D2,$C5,$C5,$A0,$A0
f1F90   .BYTE $04,$05,$06,$03
a1F94   .BYTE $05,$60
j1F96   LDA a1D29
        CMP #$83
        BNE b1FA0
        JMP j24A8

b1FA0   CMP #$84
        BNE b1FA4
b1FA4   LDA #$30
        STA a19D7
        STA a19D8
        STA a19D9
        LDX a1F94
        BNE b1FB7
        JMP j205B

b1FB7   INC a19D9
        LDA a19D9
        CMP #$3A
        BNE b1FD8
        LDA #$30
        STA a19D9
        INC a19D8
        LDA a19D8
        CMP #$3A
        BNE b1FD8
        LDA #$30
        STA a19D8
        INC a19D7
b1FD8   DEX 
        BNE b1FB7
        JSR s2074
        LDA a2073
        BEQ b1FF0
        LDA a27      ;RESMOH  
        CMP #$40
        BEQ b1FEA
        RTS 

b1FEA   LDA #$00
        STA a2073
b1FEF   RTS 

b1FF0   LDA a27      ;RESMOH  
        CMP #$40
        BEQ b1FEF
        LDX #$01
        STX a2073
        CMP #$34
        BEQ b202C
        CMP #$01
        BEQ j205B
        CMP #$3C
        BNE b202B
        JSR s2074
        LDA a1F94
        STA a2236
        LDA a1D
        STA a2237
        LDA a1E
        STA a2238
        LDA #$00
        STA a1D29
        STA a2073
        STA a2110
        LDY #$02
        LDA #$FF
        STA (p1D),Y
b202B   RTS 

b202C   LDY #$02
        LDA a028D
        AND #$01
        BEQ b203A
        LDA #$C0
        JMP j203D

b203A   LDA a1638
j203D   STA (p1D),Y
        LDA a1639
        INY 
        STA (p1D),Y
        LDA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        INY 
        STA (p1D),Y
        LDA a1D
        CLC 
        ADC #$03
        STA a1D
        LDA a1E
        ADC #$00
        STA a1E
        DEC a1F94
        RTS 

j205B   JSR s2074
        LDA #$FF
        LDY #$02
        STA (p1D),Y
        LDA #$00
        STA a1D29
        STA a2073
        STA a2236
        STA a2110
        RTS 

a2073   .BYTE $00
s2074   LDA a19D7
        STA a0FC6
        LDA a19D8
        STA a0FC7
        LDA a19D9
        STA a0FC8
        RTS 

j2087   LDA #$00
        STA a1D29
        TAY 
        LDA (p1D),Y
        STA a210F
        INY 
        LDA (p1D),Y
        STA a210E
j2098   LDY #$02
        INC a163A
        LDA a163A
        CMP a1640
        BNE b20AA
        LDA #$00
        STA a163A
b20AA   LDX a163A
        LDA f12A9,X
        CMP #$FF
        BEQ b20C6
        LDA a13      ;CHANNL  Flag: INPUT prompt
        AND a164F
        BEQ b20F0
        STA a163A
        TAX 
        LDA f12A9,X
        CMP #$FF
        BNE b20F0
b20C6   LDA a1646
        STA f12A9,X
        LDA (p1D),Y
        CMP #$C0
        BEQ b20F0
        STA f1229,X
        INY 
        LDA (p1D),Y
        STA f1269,X
        INY 
        LDA (p1D),Y
        STA f1369,X
        LDA a210E
        STA f12E9,X
        STA f1329,X
        LDA a210F
        STA f13A9,X
b20F0   LDA a1D
        CLC 
        ADC #$03
        STA a1D
        LDA a1E
        ADC #$00
        STA a1E
        LDY #$02
        LDA (p1D),Y
        CMP #$FF
        BEQ b2108
        JMP j2098

b2108   LDA #$00
        STA a2110
        RTS 

a210E   .BYTE $00
a210F   .BYTE $00
a2110   .BYTE $00
j2111   LDA #>p2B00
        STA a1E
        LDA #<p2B00
        STA a1D
        LDA #$FF
        STA a2110
        LDA a1E68
        AND #$01
        BNE b2134
        LDA a1644
        STA a21E7
        LDA #$00
        STA a1D29
        JSR j21F8
        RTS 

b2134   LDA a2236
        BEQ b214C
        LDA a2236
        STA a1F94
        LDA a2237
        STA a1D
        LDA a2238
        STA a1E
        JMP j215D

b214C   LDA #$FF
        STA a1F94
        LDA a15
        LDY #$00
        STA (p1D),Y
        LDA a163E
        INY 
        STA (p1D),Y
j215D   JSR s19F9
        LDX #$00
b2162   LDA f21E8,X
        STA f19D1,X
        INX 
        CPX #$10
        BNE b2162
        JSR j1A07
        RTS 

s2171   INC a163A
        LDA a163A
        CMP a1640
        BNE b2181
        LDA #$00
        STA a163A
b2181   TAX 
        LDA f12A9,X
        CMP #$FF
        BEQ b2198
        LDA a13      ;CHANNL  Flag: INPUT prompt
        AND a164F
        BEQ b21C8
        TAX 
        LDA f12A9,X
        CMP #$FF
        BNE b21C8
b2198   LDY #$02
        LDA (p1D),Y
        CMP #$C0
        BEQ b21C8
        LDA a1646
        STA f12A9,X
        LDA a2B01
        STA f12E9,X
        STA f1329,X
        LDA p2B00
        STA f13A9,X
        LDY #$02
        LDA (p1D),Y
        STA f1229,X
        INY 
        LDA (p1D),Y
        STA f1269,X
        INY 
        LDA (p1D),Y
        STA f1369,X
b21C8   LDA a1D
        CLC 
        ADC #$03
        STA a1D
        LDA a1E
        ADC #$00
        STA a1E
        LDY #$02
        LDA (p1D),Y
        CMP #$FF
        BEQ b21DE
        RTS 

b21DE   LDA #<p2B00
        STA a1D
        LDA #>p2B00
        STA a1E
        RTS 

a21E7   .BYTE $00
f21E8   .BYTE $D3,$C5,$D1,$D5,$BA,$A0,$B0,$B0
        .BYTE $B0,$A0,$C6,$D2,$C5,$C5,$A0,$A0
j21F8   LDA a2110
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR s19F9
        LDX #$00
b2207   LDA f2216,Y
        STA f19D1,X
        INY 
        INX 
        CPX #$10
        BNE b2207
        JMP j1A07

f2216   .BYTE $D3,$C5,$D1,$D5,$C5,$CE,$C3,$C5
        .BYTE $D2,$A0,$CF,$C6,$C6,$A0,$A0,$A0
        .BYTE $D3,$C5,$D1,$D5,$C5,$CE,$C3,$C5
        .BYTE $D2,$A0,$CF,$CE,$A0,$A0,$A0,$A0
a2236   .BYTE $00
a2237   .BYTE $00
a2238   .BYTE $00
a2239   .BYTE $00
j223A   LDA #>p3800
        STA a20
        LDA #<p3800
        STA a1F
        LDA #$01
        STA a23FF
        LDA a1E68
        AND #$01
        STA a1E68
        LDA a231A
        ORA a1E68
        EOR #$02
        STA a231A
        AND #$02
        BNE b2261
        JMP j22ED

b2261   LDA a231A
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR s19F9
        LDX #$00
b2270   LDA f22CD,Y
        STA f19D1,X
        INY 
        INX 
        CPX #$10
        BNE b2270
        JSR j1A07
        LDA a231A
        CMP #$03
        BNE b22B4
s2286   LDA #<p3800
        STA aFB      ;CURBNK  Current bank configuration
        LDA #>p3800
        STA aFC      ;XoN     Char to send for a x-on (RS232)
        LDY #$00
        TYA 
        LDX #$08
b2293   STA (pFB),Y  ;CURBNK  Current bank configuration
        DEY 
        BNE b2293
        INC aFC      ;XoN     Char to send for a x-on (RS232)
        DEX 
        BNE b2293
        LDA #<p01FF
        STA p3800
        LDA #>p01FF
        STA a3801
        LDA a1638
        STA a2400
        LDA a1639
        STA a2401
        RTS 

b22B4   LDA #$00
        STA a0C      ;DIMFLG  Flag: Default Array DIMension
        JSR s162B
        LDA a2400
        STA a1638
        LDA a2401
        STA a1639
        LDA #$FF
        STA a2403
        RTS 

f22CD   .BYTE $D0,$CC,$C1,$D9,$C9,$CE,$C7,$A0
        .BYTE $C2,$C1,$C3,$CB,$AE,$AE,$AE,$AE
        .BYTE $D2,$C5,$C3,$CF,$D2,$C4,$C9,$CE
        .BYTE $C7,$AE,$AE,$AE,$AE,$AE,$AE,$AE
j22ED   LDA #$00
        STA a231A
        STA $FF19    ;Color register #4
        STA a2403
        TAY 
        JSR s19F9
b22FC   LDA f230A,Y
        STA f19D1,Y
        INY 
        CPY #$10
        BNE b22FC
        JMP j1A07

f230A   .BYTE $D3,$D4,$CF,$D0,$D0,$C5,$C4,$A0
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
a231A   .BYTE $00
j231B   LDA a21
        STA a21
        LDY #$00
        CMP (p1F),Y
        BEQ b235D
b2325   LDA a1F
        CLC 
        ADC #$02
        STA a1F
        LDA a20
        ADC #$00
        STA a20
        CMP #$40
        BNE b233E
        LDA #$00
        STA a3FFF
        JMP j22ED

b233E   LDY #$01
        TYA 
        STA (p1F),Y
        LDA a21
        DEY 
        STA (p1F),Y
        LDA a20
        SEC 
        SBC #$30
        CLC 
        ROR 
        CLC 
        ROR 
        CLC 
        ROR 
        CLC 
        ROR 
        TAX 
        LDA f1DCC,X
        STA $FF19    ;Color register #4
        RTS 

b235D   INY 
        LDA (p1F),Y
        CLC 
        ADC #$01
        STA (p1F),Y
        CMP #$FF
        BEQ b2325
        RTS 

s236A   LDX #$00
b236C   STX aFF08
        LDA aFF08
        STX aFF08
        CMP aFF08
        BNE b236C
        LDY a2571
        BNE b238D
        STA a21
        LDA a1E68
        BNE b238D
        LDA #$40
        STA a27      ;RESMOH  
        JMP j239A

b238D   LDA aC6      ;SFDX    Flag: shift mode for print
        STA a27      ;RESMOH  
        LDY a2571
        BNE b23A9
        LDA #$FF
        STA a21
j239A   LDA a231A
        BEQ b23A9
        CMP #$03
        BNE b23A6
        JMP j231B

b23A6   JMP j23B2

b23A9   LDA a2571
        BEQ b23B1
        JMP j2574

b23B1   RTS 

j23B2   DEC a23FF
        BEQ b23BE
        LDY #$00
        LDA (p1F),Y
        STA a21
        RTS 

b23BE   LDA a1F
        CLC 
        ADC #$02
        STA a1F
        LDA a20
        ADC #$00
        STA a20
        CMP #$80
        BEQ b23DE
        LDY #$01
        LDA (p1F),Y
        BEQ b23DE
        STA a23FF
        DEY 
        LDA (p1F),Y
        STA a21
        RTS 

b23DE   LDA #>p3800
        STA a20
        LDA #<p3800
        STA a1F
        LDA #$01
        STA a23FF
        LDA #$00
        STA a0C      ;DIMFLG  Flag: Default Array DIMension
        JSR s162B
        LDA a2400
        STA a1638
        LDA a2401
        STA a1639
        RTS 

a23FF   .BYTE $00
a2400   .BYTE $0C
a2401   .BYTE $0C
a2402   .BYTE $00
a2403   .BYTE $00
f2404   .BYTE $C4,$C5,$C6,$C9,$CE,$C5,$A0,$C1
        .BYTE $CC,$CC,$A0,$CC,$C5,$D6,$C5,$CC
        .BYTE $A0,$B2,$A0,$D0,$C9,$D8,$C5,$CC
        .BYTE $D3
j241D   TXA 
        AND #$08
        BEQ b2423
        RTS 

b2423   LDA #$83
        STA a1D29
        LDA #$00
        STA a22      ;INDEX1  Utility pointer area
        STA a2403
        LDA f166A,X
        STA a23
        TXA 
        CLC 
        ADC #$08
        STA a2402
        JSR s19F9
        LDX #$00
b2440   LDA f2404,X
        STA f19D1,X
        INX 
        CPX #$19
        BNE b2440
        JSR j1A07
        LDA #$06
        STA a25
        LDY #$00
        TYA 
        STA (p22),Y  ;INDEX1  Utility pointer area
        INY 
        LDA #$55
        STA (p22),Y  ;INDEX1  Utility pointer area
        LDY #$81
        STA (p22),Y  ;INDEX1  Utility pointer area
        DEY 
        LDA #$00
        STA (p22),Y  ;INDEX1  Utility pointer area
        LDA #$07
        STA a24      ;INDEX2  Utility pointer area
        LDA #$01
        STA a26      ;RESHO   
        LDA #$17
        STA a1F17
        RTS 

j2473   LDA #<p0C13
        STA a1638
        LDA #>p0C13
        STA a1639
        JSR s1F18
b2480   LDA a2402
        STA a1651
        LDA a25
        STA a04
        LDA #$00
        STA a14      ;LINNUM  Temp: integer value
        LDA #<p0C13
        STA a02      ;SRCHTK  Token 'search' looks for (run-time stack)
        LDA #>p0C13
        STA a03      ;ZPVEC1  Temp (renumber)
        JSR s1108
        LDA a25
        BNE b2480
        JSR s1F18
        LDA #$00
        STA a1F17
        JMP j142E

j24A8   LDA a2073
        BEQ b24BA
        LDA a27      ;RESMOH  
        CMP #$40
        BEQ b24B4
        RTS 

b24B4   LDA #$00
        STA a2073
b24B9   RTS 

b24BA   LDA a27      ;RESMOH  
        CMP #$40
        BEQ b24B9
        LDA #$FF
        STA a2073
        LDA a27      ;RESMOH  
        CMP #$01
        BEQ b24CE
        JMP j2507

b24CE   INC a26      ;RESHO   
        LDA #$00
        LDY a26      ;RESHO   
        STA (p22),Y  ;INDEX1  Utility pointer area
        PHA 
        TYA 
        CLC 
        ADC #$80
        TAY 
        PLA 
        STA (p22),Y  ;INDEX1  Utility pointer area
        INY 
        LDA #$55
        STA (p22),Y  ;INDEX1  Utility pointer area
        LDY a26      ;RESHO   
        INY 
        STA (p22),Y  ;INDEX1  Utility pointer area
        STY a26      ;RESHO   
        LDA #$07
        STA a24      ;INDEX2  Utility pointer area
        DEC a25
        BEQ b24FE
        LDA a25
        EOR #$07
        CLC 
        ADC #$31
        STA a0FD1
        RTS 

b24FE   LDA #$00
        STA a1D29
        JSR s19F9
b2506   RTS 

j2507   CMP #$34
        BNE b2506
        LDY a26      ;RESHO   
        LDA a1638
        SEC 
        SBC #$13
        STA (p22),Y  ;INDEX1  Utility pointer area
        INY 
        LDA #$55
        STA (p22),Y  ;INDEX1  Utility pointer area
        STY a26      ;RESHO   
        TYA 
        CLC 
        ADC #$7F
        TAY 
        LDA a1639
        SEC 
        SBC #$0C
        STA (p22),Y  ;INDEX1  Utility pointer area
        INY 
        LDA #$55
        STA (p22),Y  ;INDEX1  Utility pointer area
        DEC a24      ;INDEX2  Utility pointer area
        BEQ b2533
        RTS 

b2533   JMP b24CE

j2536   JSR s19F9
        LDX #$00
b253B   LDA f2553,X
        STA f19D1,X
        INX 
        CPX #$0E
        BNE b253B
        LDA a0F      ;DORES   Flag: DATA scan/LIST quote/garbage coll
        AND #$07
        CLC 
        ADC #$30
        STA a19DE
        JMP j1A07

f2553   .BYTE $D5,$D3,$C5,$D2,$A0,$D3,$C8,$C1
        .BYTE $D0,$C5,$A0,$A3,$B0
a2560   .BYTE $00
f2561   .BYTE $CF,$51,$53,$5A,$5B,$5F,$57,$7F
        .BYTE $56,$61,$4F,$66,$6C,$EC,$A0,$2A
a2571   .BYTE $00
a2572   .BYTE $01
a2573   .BYTE $40
j2574   DEC a2572
        BEQ b257A
        RTS 

b257A   JSR s11BE
        AND #$1F
        ORA #$01
        STA a2572
        LDA a2573
        EOR #$40
        STA a2573
        JSR s11BE
        AND #$0F
        ORA a2573
        EOR #$4F
        STA a21
        DEC a25F6
        BEQ b259E
        RTS 

b259E   JSR s11BE
        AND #$07
        ADC #$20
        STA a25F6
        JSR s11BE
        AND #$0F
        TAX 
        LDA #$00
        STA a1E68
        JMP b1E05

s25B6   LDA a2571
        BNE b25BE
        JMP s19F9

b25BE   LDX #$00
b25C0   LDA f25CE,X
        STA f19D1,X
        INX 
        CPX #$28
        BNE b25C0
        JMP j1A07

f25CE   .BYTE $D0,$D3,$D9,$C3,$C8,$C5,$C4,$C5
        .BYTE $CC,$C9,$C1,$A0,$C3,$D2,$C5,$C1
        .BYTE $D4,$C5,$C4,$A0,$C2,$D9,$A0,$CA
        .BYTE $C5,$C6,$C6,$A0,$A8,$D9,$C1,$CB
        .BYTE $A9,$A0,$CD,$C9,$CE,$D4,$C5,$D2
a25F6   .BYTE $20,$00
a25F8   .BYTE $02,$20
f25FA   .BYTE $00,$67,$A8,$E9
f25FE   .BYTE $00,$01,$02,$04,$01,$02,$04,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$28,$1E,$E0,$32,$A2,$00
        .BYTE $8E,$F9,$03,$8E,$F6,$03
b261C   LDA f1E46,X
        STA f0300,X  ;IERROR  Indirect Error (Output Error in .X)
        INX 
        CPX #$CF
        BCC b261C
        LDA #$03
        STA a03FA
        STA a03F7    ;INPQUE  RS-232 input queue
        JMP s1F18

        LDA #$8D
        JSR eFDED
        LDA #$A4
        STA a33      ;FRFTOP  Pointer: bottom of string storage
        LDX #$00
        JSR e0371
        STA a63      ;FACMOH  
        STX a64      ;FACMO   
        LDX #$06
        JSR e0371
        STA a60      ;EXPSGN  
        STX a61      ;FACEXP  Floating-point accumulator #1: exponent
        LDX #$0C
        JSR e0371
        STA a62      ;FACHO   Floating accum. #1: mantissa
        JSR e035B
        LDY #$00
        STY a65      ;FACLo   
b265B   LDA f0060,Y  ;EXPSGN  
        JSR e034A
        INY 
        CPY #$03
        BCC b265B
        LDY #$00
b2668   LDA (p63),Y  ;FACMOH  
        JSR e034A
        INY 
        BNE b2668
        INC a64      ;FACMO   
        DEC a62      ;FACHO   Floating accum. #1: mantissa
        BNE b2668
        LDA a65      ;FACLo   
        JSR e034A
        RTS 

        STA a66      ;FACSGN  Floating accum. #1: sign
        EOR a65      ;FACLo   
        STA a65      ;FACLo   
        LDX #$08
b2684   LSR a66      ;FACSGN  Floating accum. #1: sign
        JSR e035B
        DEX 
        BNE b2684
        RTS 

        BCC b2694
        LDA aC05B
        BCS b2697
b2694   LDA aC05A
b2697   LDA aC059
b269A   BIT aC063
        BPL b269A
        LDA aC058
        RTS 

        LDY #$06
b26A5   LDA f03BD,X
        JSR eFDED
        INX 
        DEY 
        BNE b26A5
        STY a67      ;SGNFLG  Pointer: series evaluation constant
        STY a68      ;BITS    Floating accum. #1: overflow digit
        JSR eFD6A
        LDY #$00
        DEX 
        BMI b26EA
        LDA f0200,X
        SEC 
        SBC #$B0
        CMP #$0A
        BCC b26C8
        SEC 
        SBC #$07
b26C8   CPY #$00
        BEQ b26D8
        CPY #$02
        BEQ b26E1
        ASL 
        ASL 
        ASL 
        ASL 
        CPY #$03
        BEQ b26E1
b26D8   CLC 
        ADC a67      ;SGNFLG  Pointer: series evaluation constant
        STA a67      ;SGNFLG  Pointer: series evaluation constant
        INY 
        JMP e0386

b26E1   CLC 
        ADC a68      ;BITS    Floating accum. #1: overflow digit
        STA a68      ;BITS    Floating accum. #1: overflow digit
        INY 
        JMP e0386

b26EA   LDA a67      ;SGNFLG  Pointer: series evaluation constant
        LDX a68      ;BITS    Floating accum. #1: overflow digit
        RTS 

        .BYTE $D3,$D4,$D2,$D4,$BA,$A0,$C4,$C5
        .BYTE $D3,$D4,$BA,$A0,$CE,$D0,$C7,$D3
        .BYTE $BA,$A0,$00,$85,$24,$A0,$00,$B9
        .BYTE $28,$1F,$99,$28,$02,$C8,$C0,$D8
        .BYTE $D0,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$22,$0F,$22
        .BYTE $0E,$22,$0D,$22,$0C,$22,$0B,$22
        .BYTE $0A,$22,$09,$22,$08,$22,$07,$22
        .BYTE $06,$22,$05,$22,$04,$22,$03,$22
        .BYTE $02,$22,$01,$22,$00,$21,$0F,$21
        .BYTE $0E,$21,$0D,$21,$0C,$21,$0B,$21
        .BYTE $0A,$21,$09,$21,$08,$21,$07,$21
        .BYTE $06,$21,$05,$21,$04,$21,$03,$21
        .BYTE $02,$21,$01,$21,$00,$20,$0F,$20
        .BYTE $0E,$20,$0D,$20,$0C,$20,$0B,$20
        .BYTE $0A,$20,$09,$20,$08,$20,$07,$20
        .BYTE $06,$20,$05,$20,$04,$20,$03,$20
        .BYTE $02,$20,$01,$20,$00,$1F,$0F,$1F
        .BYTE $0E,$1F,$0D,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $FF
p2800   .BYTE $00,$0C,$01,$1F,$03,$10,$07,$04
        .BYTE $01,$07,$00,$2B,$4B,$6B,$74,$54
        .BYTE $34,$04,$FF,$00,$0B,$0B,$04,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$0B,$02,$1C,$01,$0B,$07,$09
        .BYTE $01,$07,$00,$57,$27,$25,$45,$46
        .BYTE $16,$32,$FF,$00,$01,$01,$04,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$0B,$02,$28,$01,$20,$07,$0B
        .BYTE $01,$07,$00,$16,$36,$56,$73,$53
        .BYTE $43,$03,$FF,$00,$05,$05,$01,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$0B,$01,$28,$02,$67,$07,$08
        .BYTE $04,$07,$00,$17,$47,$4A,$5A,$3D
        .BYTE $5D,$7D,$FF,$00,$03,$03,$02,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$EA,$10
        .BYTE $00,$0C,$01,$2B,$01,$01,$07,$08
        .BYTE $01,$07,$00,$02,$42,$62,$72,$66
        .BYTE $36,$16,$00,$00,$01,$01,$01,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$05,$02,$2B,$01,$08,$07,$0C
        .BYTE $01,$07,$00,$25,$55,$75,$77,$47
        .BYTE $27,$02,$00,$00,$0C,$0C,$04,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$F7
        .BYTE $00,$0F,$02,$3F,$01,$68,$07,$0F
        .BYTE $01,$07,$00,$0D,$3B,$4B,$4D,$7D
        .BYTE $3E,$0E,$FF,$00,$03,$03,$04,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$0B,$01,$1C,$02,$50,$07,$09
        .BYTE $01,$07,$00,$0E,$4E,$6E,$5D,$3D
        .BYTE $3B,$0B,$00,$00,$07,$07,$01,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$15,$EF
        .BYTE $00,$04,$01,$28,$02,$01,$07,$0A
        .BYTE $01,$07,$00,$07,$37,$57,$55,$75
        .BYTE $46,$16,$FF,$00,$04,$04,$03,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$0C,$02,$1F,$01,$37,$07,$0C
        .BYTE $01,$07,$00,$16,$12,$14,$35,$43
        .BYTE $57,$71,$FF,$00,$00,$00,$01,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$08,$01,$15,$05,$37,$07,$08
        .BYTE $01,$07,$00,$03,$13,$43,$53,$63
        .BYTE $73,$71,$FF,$00,$07,$07,$04,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$08,$01,$06,$01,$66,$07,$08
        .BYTE $01,$07,$00,$57,$77,$6B,$3B,$0D
        .BYTE $4D,$6D,$FF,$00,$08,$08,$04,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$EA,$10
        .BYTE $00,$0C,$02,$1F,$01,$68,$07,$09
        .BYTE $01,$07,$00,$16,$46,$66,$76,$46
        .BYTE $26,$0E,$FF,$00,$0E,$0E,$04,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$0C,$02,$1F,$01,$40,$07,$09
        .BYTE $01,$07,$00,$08,$38,$68,$79,$59
        .BYTE $39,$09,$00,$00,$04,$04,$02,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$0C,$02,$2B,$01,$07,$07,$08
        .BYTE $01,$07,$00,$04,$54,$74,$75,$45
        .BYTE $25,$76,$FF,$00,$09,$09,$03,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
        .BYTE $00,$05,$01,$27,$02,$10,$07,$08
        .BYTE $01,$07,$00,$16,$46,$76,$74,$44
        .BYTE $34,$04,$00,$01,$07,$07,$04,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$15,$EF
        .BYTE $01,$05,$0B,$05,$07,$0B,$12,$07
        .BYTE $FF,$13,$07,$04,$0B,$07,$FF,$00
        .BYTE $FF,$21,$06,$00,$06,$01,$06,$41
        .BYTE $FF,$00,$06,$01,$06,$01,$06,$00
        .BYTE $01,$05,$09,$06,$08,$09,$06,$08
        .BYTE $0D,$13,$08,$0D,$13,$08,$21,$0A
        .BYTE $08,$21,$0A,$08,$FF,$40,$00,$6B
        .BYTE $04,$41,$FF,$00,$FF,$00,$FF,$00
        .BYTE $04,$05,$14,$0B,$01,$16,$09,$01
        .BYTE $17,$07,$01,$19,$04,$01,$1B,$01
        .BYTE $01,$FF,$06,$01,$02,$05,$02,$41
        .BYTE $00,$00,$06,$02,$BD,$00,$BF,$00
        .BYTE $02,$05,$12,$0B,$00,$0F,$09,$00
        .BYTE $0D,$04,$00,$05,$03,$00,$FF,$0A
        .BYTE $00,$0E,$0C,$00,$10,$0E,$00,$12
        .BYTE $10,$00,$14,$12,$00,$16,$14,$00
        .BYTE $18,$16,$00,$FF,$00,$BD,$00,$BD
        .BYTE $81,$BD,$81,$FF,$00,$BD,$F1,$FF
        .BYTE $00,$28,$81,$FF,$81,$AE,$83,$AE
        .BYTE $00,$FF,$81,$EE,$81,$AC,$C1,$BD
        .BYTE $C1,$24,$81,$FF,$C1,$FF,$00,$EE
        .BYTE $81,$BF,$85,$AE,$81,$EC,$E1,$BF
        .BYTE $83,$37,$00,$EE,$81,$BF,$C3,$2E
        .BYTE $81,$2E,$00,$FF,$00,$FF,$00,$FD
        .BYTE $05,$DC,$02,$EE,$81,$EC,$C7,$0C
        .BYTE $00,$68,$81,$EC,$03,$EE,$81,$EE
        .BYTE $85,$62,$81,$EE,$01,$EC,$87,$EA
        .BYTE $85,$FD,$83,$CD,$42,$EF,$00,$FF
        .BYTE $00,$28,$02,$EA,$81,$BD,$85,$BF
        .BYTE $81,$FF,$85,$EE,$00,$BF,$87,$BF
        .BYTE $00,$EE,$87,$FF,$81,$FF,$A7,$FE
        .BYTE $01,$FF,$80,$EE,$FD,$FF,$FF,$FF
p2B00   .BYTE $01
a2B01   .BYTE $05,$05,$03,$07,$08,$05,$07,$0B
        .BYTE $0A,$07,$10,$0F,$07,$12,$14,$07
        .BYTE $18,$14,$07,$1C,$14,$07,$21,$14
        .BYTE $07,$21,$0E,$07,$21,$0A,$07,$21
        .BYTE $04,$07,$21,$00,$07,$12,$0B,$07
        .BYTE $12,$0B,$07,$12,$0B,$07,$12,$0B
        .BYTE $07,$12,$0B,$07,$FF,$00,$6B,$04
        .BYTE $C1,$FF,$00,$FF,$00,$FF,$00,$42
        .BYTE $02,$AE,$01,$00,$07,$1C,$80,$FF
        .BYTE $05,$06,$01,$02,$07,$02,$05,$00
        .BYTE $85,$06,$01,$02,$05,$02,$41,$00
        .BYTE $00,$06,$03,$BD,$00,$BF,$00,$BF
        .BYTE $C5,$BF,$01,$00,$42,$02,$40,$00
        .BYTE $40,$06,$01,$FF,$00,$02,$40,$FF
        .BYTE $05,$02,$00,$00,$00,$00,$01,$20
        .BYTE $00,$8D,$01,$00,$00,$00,$00,$00
        .BYTE $BD,$00,$BD,$00,$BD,$40,$BD,$81
        .BYTE $BD,$81,$FF,$00,$FF,$F1,$FF,$00
        .BYTE $20,$81,$FF,$81,$AE,$C3,$EE,$00
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$FD,$D1
        .BYTE $24,$81,$FF,$C1,$FF,$00,$AE,$81
        .BYTE $FF,$C5,$EE,$41,$EC,$E1,$FF,$C3
        .BYTE $37,$00,$EE,$C1,$BF,$C3,$AE,$C1
        .BYTE $AE,$00,$FF,$00,$FF,$00,$FD,$05
        .BYTE $DD,$03,$EE,$85,$EC,$C7,$4C,$00
        .BYTE $60,$81,$EC,$87,$EE,$81,$EE,$8D
        .BYTE $62,$85,$EE,$85,$EE,$87,$EA,$85
        .BYTE $FD,$83,$ED,$42,$EF,$00,$FF,$40
        .BYTE $28,$02,$EE,$C1,$BD,$85,$FF,$81
        .BYTE $FF,$85,$EE,$00,$FF,$A7,$BF,$00
        .BYTE $EE,$87,$FF,$81,$FF,$A7,$FE,$01
        .BYTE $FF,$00,$EE,$FD,$FF,$FF,$FF,$FF
        .BYTE $00,$F7,$00,$FF,$00,$BF,$40,$46
        .BYTE $00,$06,$00,$FF,$00,$06,$00,$FF
        .BYTE $01,$06,$00,$06,$01,$06,$41,$FF
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46
        .BYTE $00,$06,$01,$2A,$41,$02,$00,$04
        .BYTE $6A,$FF,$41,$06,$40,$00,$4B,$04
        .BYTE $89,$FF,$00,$FF,$00,$FF,$00,$42
        .BYTE $02,$BF,$01,$00,$07,$1C,$00,$FF
        .BYTE $05,$06,$01,$02,$07,$02,$05,$00
        .BYTE $05,$06,$01,$02,$05,$02,$01,$00
        .BYTE $00,$06,$02,$BD,$00,$BF,$00,$FF
        .BYTE $C5,$BF,$01,$00,$42,$02,$40,$00
        .BYTE $40,$06,$01,$FF,$00,$02,$40,$FF
        .BYTE $45,$02,$00,$00,$00,$02,$01,$24
        .BYTE $00,$05,$01,$00,$00,$00,$00,$00
        .BYTE $BD,$00,$B9,$00,$BD,$40,$BD,$81
        .BYTE $BD,$81,$FF,$00,$FD,$F1,$FF,$00
        .BYTE $20,$81,$FF,$C1,$AE,$83,$EE,$00
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$BD,$C1
        .BYTE $24,$C1,$FF,$C1,$FF,$00,$EE,$81
        .BYTE $FD,$C5,$EE,$C1,$EC,$E1,$FF,$C3
        .BYTE $37,$00,$EE,$C1,$BF,$C3,$AE,$C1
        .BYTE $AE,$00,$FF,$00,$FF,$00,$FD,$81
        .BYTE $DD,$03,$EA,$81,$EC,$C7,$CC,$00
        .BYTE $60,$81,$EC,$83,$EE,$81,$EE,$85
        .BYTE $62,$81,$EE,$81,$EE,$87,$EA,$85
        .BYTE $FD,$83,$ED,$42,$EF,$00,$FF,$00
        .BYTE $28,$02,$EE,$81,$FD,$85,$FF,$81
        .BYTE $FF,$85,$EE,$00,$FD,$85,$FF,$00
        .BYTE $EE,$87,$FF,$81,$FF,$A7,$FF,$01
        .BYTE $FF,$80,$EE,$FD,$FF,$FF,$FF,$FF
        .BYTE $00,$F7,$00,$FF,$00,$BF,$40,$06
        .BYTE $00,$06,$00,$FF,$00,$06,$00,$FF
        .BYTE $21,$06,$00,$06,$01,$06,$01,$BF
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46
        .BYTE $00,$06,$01,$2A,$01,$02,$00,$04
        .BYTE $62,$FF,$01,$06,$40,$00,$6B,$04
        .BYTE $91,$BF,$00,$FF,$00,$FF,$00,$42
        .BYTE $02,$BF,$01,$00,$07,$1C,$80,$FF
        .BYTE $25,$06,$01,$02,$07,$02,$05,$00
        .BYTE $85,$06,$01,$02,$05,$02,$01,$00
        .BYTE $00,$06,$03,$BD,$00,$BF,$00,$BF
        .BYTE $C5,$BF,$01,$00,$42,$02,$40,$00
        .BYTE $00,$06,$01,$FF,$00,$02,$40,$FF
        .BYTE $05,$02,$00,$00,$00,$00,$01,$20
        .BYTE $00,$8D,$01,$00,$00,$00,$00,$00
        .BYTE $BD,$00,$B9,$00,$BD,$40,$BD,$81
        .BYTE $BD,$81,$FF,$00,$BF,$F9,$FF,$00
        .BYTE $28,$81,$FF,$81,$AE,$83,$AE,$00
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$BD,$A1
        .BYTE $24,$C1,$FF,$C1,$FF,$00,$AE,$81
        .BYTE $BF,$C5,$EE,$C1,$EC,$E1,$BF,$83
        .BYTE $3F,$00,$EE,$C1,$BF,$E3,$AE,$C1
        .BYTE $AE,$20,$FF,$00,$FF,$00,$BD,$05
        .BYTE $DD,$03,$EA,$81,$EC,$C7,$4C,$00
        .BYTE $68,$81,$EC,$87,$EE,$81,$EE,$AD
        .BYTE $62,$85,$EE,$81,$EE,$87,$EA,$85
        .BYTE $FD,$83,$EC,$42,$EF,$00,$FF,$00
        .BYTE $28,$02,$EE,$81,$BD,$A5,$BF,$81
        .BYTE $BF,$85,$EE,$00,$BF,$AF,$BF,$00
        .BYTE $EC,$87,$FF,$81,$FF,$A7,$EE,$01
        .BYTE $FF,$80,$EE,$FD,$FF,$FF,$FF,$FF
        .BYTE $00,$F7,$00,$FF,$00,$BF,$40,$46
        .BYTE $00,$06,$00,$FF,$00,$06,$00,$FF
        .BYTE $A1,$06,$00,$06,$01,$06,$41,$FF
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46
        .BYTE $00,$06,$81,$2A,$01,$02,$00,$04
        .BYTE $62,$FF,$41,$06,$40,$00,$6B,$04
        .BYTE $B1,$FB,$00,$FF,$00,$FF,$00,$42
        .BYTE $02,$B6,$01,$00,$07,$1C,$80,$FF
        .BYTE $25,$06,$01,$02,$07,$02,$05,$00
        .BYTE $85,$06,$01,$02,$05,$02,$01,$00
        .BYTE $00,$06,$03,$BD,$00,$BF,$00,$BF
        .BYTE $C5,$BF,$01,$00,$42,$02,$40,$00
        .BYTE $40,$06,$01,$FF,$00,$02,$40,$FF
        .BYTE $45,$02,$00,$02,$00,$00,$01,$A0
        .BYTE $00,$8F,$01,$00,$00,$00,$00,$00
        .BYTE $BD,$00,$BD,$00,$BD,$40,$BD,$81
        .BYTE $BD,$81,$FF,$00,$FD,$F1,$FF,$00
        .BYTE $20,$81,$FF,$81,$AC,$83,$EE,$00
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$BD,$C1
        .BYTE $24,$C1,$FF,$C1,$FF,$00,$EE,$81
        .BYTE $FD,$C5,$AE,$C1,$EC,$E1,$BF,$C3
        .BYTE $3F,$00,$EE,$C1,$BF,$C3,$AE,$C1
        .BYTE $EE,$00,$FF,$00,$FF,$00,$FD,$85
        .BYTE $DD,$03,$EE,$85,$EC,$C7,$CC,$00
        .BYTE $E8,$81,$EC,$87,$EE,$81,$EE,$8D
        .BYTE $62,$81,$EE,$81,$EE,$87,$EA,$85
        .BYTE $FD,$83,$CC,$42,$EF,$00,$FF,$00
        .BYTE $28,$02,$EE,$C1,$FD,$85,$FF,$81
        .BYTE $FF,$85,$EE,$00,$FD,$85,$BF,$00
        .BYTE $EE,$87,$FF,$81,$FF,$87,$FE,$01
        .BYTE $FF,$80,$EE,$FD,$FF,$FF,$FF,$FF
        .BYTE $00,$F7,$00,$FF,$00,$BF,$40,$46
        .BYTE $00,$06,$00,$FF,$00,$06,$00,$FF
        .BYTE $11,$06,$00,$06,$01,$06,$41,$FF
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46
        .BYTE $00,$06,$01,$AB,$41,$02,$00,$04
        .BYTE $62,$FF,$41,$06,$40,$00,$6B,$04
        .BYTE $91,$FF,$00,$FF,$00,$FF,$00,$42
        .BYTE $02,$27,$01,$00,$07,$1C,$00,$FF
        .BYTE $25,$06,$05,$02,$07,$02,$05,$00
        .BYTE $05,$06,$01,$02,$05,$02,$41,$00
        .BYTE $00,$06,$03,$BD,$00,$BF,$00,$BD
        .BYTE $C5,$BF,$01,$00,$42,$02,$41,$00
        .BYTE $40,$06,$01,$FF,$00,$02,$41,$FF
        .BYTE $45,$02,$00,$00,$00,$00,$01,$24
        .BYTE $00,$0D,$01,$00,$00,$00,$00,$00
        .BYTE $BD,$00,$FD,$00,$FD,$40,$BD,$81
        .BYTE $BD,$81,$FF,$00,$FF,$F1,$FF,$00
        .BYTE $20,$81,$FF,$81,$AE,$C3,$EE,$00
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$FD,$81
        .BYTE $24,$C1,$FF,$C1,$FF,$00,$EE,$81
        .BYTE $FF,$C5,$EE,$41,$EC,$E1,$FF,$C3
        .BYTE $37,$00,$EE,$C1,$BF,$C3,$A6,$C1
        .BYTE $A6,$00,$FF,$00,$FF,$00,$BF,$05
        .BYTE $FD,$03,$EA,$85,$EC,$C7,$DD,$00
        .BYTE $60,$81,$EC,$87,$EE,$81,$EE,$85
        .BYTE $62,$81,$EE,$81,$EE,$87,$EA,$85
        .BYTE $FD,$83,$EC,$40,$EF,$00,$FF,$00
        .BYTE $28,$02,$EA,$C1,$AC,$85,$BF,$81
        .BYTE $FF,$85,$EE,$00,$FF,$C7,$BF,$00
        .BYTE $EE,$87,$FF,$81,$FF,$87,$FE,$01
        .BYTE $FF,$00,$EE,$FD,$FF,$FF,$FF,$00
        .BYTE $00,$00,$FF,$FE,$FD,$01,$02,$55
        .BYTE $00,$03,$55,$00,$00,$00,$00,$00
        .BYTE $55,$00,$FF,$FE,$FC,$FB,$FC,$01
        .BYTE $02,$55,$00,$04,$05,$04,$FF,$01
        .BYTE $55,$00,$FD,$FB,$03,$05,$02,$FE
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $FF,$FE,$01,$02,$03,$01,$02,$55
        .BYTE $00,$03,$55,$00,$01,$02,$03,$04
        .BYTE $55,$00,$FE,$FE,$FF,$01,$03,$FE
        .BYTE $FE,$55,$00,$FF,$01,$03,$04,$04
        .BYTE $55,$00,$FF,$00,$FF,$00,$04,$04
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$FF,$01,$55,$00,$FE,$02,$55
        .BYTE $00,$00,$FA,$06,$03,$FD,$55,$00
        .BYTE $FD,$03,$FB,$05,$55,$00,$00,$00
        .BYTE $55,$00,$00,$FC,$04,$03,$FD,$55
        .BYTE $00,$55,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $FF,$01,$01,$55,$00,$01,$01,$55
        .BYTE $00,$FC,$FF,$FF,$05,$05,$55,$00
        .BYTE $FD,$FD,$02,$02,$55,$00,$05,$FD
        .BYTE $55,$00,$FE,$02,$02,$02,$02,$55
        .BYTE $00,$55,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $55,$00,$FD,$03,$55,$00,$F9,$07
        .BYTE $55,$00,$FB,$05,$55,$00,$00,$55
        .BYTE $00,$00,$55,$00,$55,$FE,$02,$55
        .BYTE $00,$55,$55,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $55,$00,$00,$00,$55,$00,$00,$00
        .BYTE $55,$00,$FD,$FD,$55,$00,$FB,$55
        .BYTE $00,$04,$55,$00,$55,$FC,$FC,$55
        .BYTE $00,$55,$55,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $01,$01,$02,$55,$00,$00,$01,$02
        .BYTE $02,$55,$00,$00,$00,$02,$55,$00
        .BYTE $FF,$FE,$55,$00,$FE,$FE,$55,$00
        .BYTE $FD,$FE,$55,$00,$55,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $FF,$00,$00,$55,$00,$01,$01,$01
        .BYTE $02,$55,$00,$02,$03,$03,$55,$00
        .BYTE $01,$00,$55,$00,$FF,$FE,$55,$00
        .BYTE $FF,$FF,$55,$00,$55,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$ED,$14,$55,$00,$F2,$0F
        .BYTE $55,$00,$00,$55,$00,$00,$55,$00
        .BYTE $00,$55,$00,$00,$FF,$01,$55,$00
        .BYTE $55,$02,$55,$00,$FC,$FD,$03,$04
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $0B,$F4,$00,$00,$55,$00,$00,$00
        .BYTE $55,$00,$F9,$55,$00,$FC,$55,$00
        .BYTE $FE,$55,$00,$FF,$00,$00,$55,$00
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$01,$01,$55,$00,$FF,$FF,$FE
        .BYTE $55,$00,$FD,$FC,$FB,$55,$00,$FD
        .BYTE $FE,$FF,$55,$00,$00,$01,$02,$55
        .BYTE $00,$03,$04,$55,$00,$55,$00
