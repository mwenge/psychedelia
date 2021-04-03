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
a17 = $17
a18 = $18
a19 = $19
a1A = $1A
a1B = $1B
a1C = $1C
a21 = $21
aAE = $AE
aC4 = $C4
aC5 = $C5
aC6 = $C6
aCC = $CC
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
;
; **** FIELDS **** 
;
f0340 = $0340
f0360 = $0360
f1E00 = $1E00
f1EE4 = $1EE4
f1FE3 = $1FE3
f96E4 = $96E4
f97E3 = $97E3
fC8C3 = $C8C3
fCAA0 = $CAA0
fE199 = $E199
;
; **** ABSOLUTE ADRESSES **** 
;
a028D = $028D
a0291 = $0291
a0315 = $0315
a20AE = $20AE
;
; **** POINTERS **** 
;
p07D0 = $07D0
p1FEC = $1FEC
p9600 = $9600
;
; **** PREDEFINED LABELS **** 
;
RAM_CINV = $0314
VICCR5 = $9005
VICCRF = $900F
VIA1IER = $911E
VIA1PA2 = $911F
VIA2PB = $9120
VIA2DDRB = $9122
ROM_IRQ = $EABF

        * = $1001

        .BYTE $0B,$10,$0A,$00,$9E,$34,$31,$31
        .BYTE $32,$00,$00,$00,$01,$D5,$02
        LDA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDA #$02
        STA VIA1IER  ;$911E - interrupt enable register (IER)
        LDA #$F0
        STA VICCR5   ;$9005 - screen map & character map address
        STA a13
        LDA #>p9600
        STA aFC
        LDA #<p9600
        STA aFB
        LDX #$00
b102B   LDA aFC
        STA f0360,X
        LDA aFB
        STA f0340,X
        CLC 
        ADC #$16
        STA aFB
        LDA aFC
        ADC #$00
        STA aFC
        INX 
        CPX #$19
        BNE b102B
        LDA #$80
        STA a0291
        JMP j12E5

j104D   LDX #$00
a1050   =*+$01
b104F   LDA #$CF
        STA f1E00,X
        STA f1EE4,X
        LDA #$00
        STA p9600,X
        STA f96E4,X
        DEX 
        BNE b104F
        RTS 

f1063   .BYTE $08,$00,$38,$01,$39,$02,$3A,$03
        .BYTE $3B,$04,$3C,$05,$3D,$06,$3E,$07
s1073   LDX a03
        LDA f0340,X
        STA a05
        LDA f0360,X
        STA a06
        LDY a02
b1081   RTS 

s1082   LDA a02
        AND #$80
        BNE b1081
        LDA a02
        CMP #$16
        BPL b1081
        LDA a03
        AND #$80
        BNE b1081
        LDA a03
        CMP #$16
        BPL b1081
        JSR s1073
        LDA a17
        BNE b10BE
        LDA (p05),Y
        AND #$07
        LDX #$00
b10A7   CMP f14C7,X
        BEQ b10B1
        INX 
        CPX #$08
        BNE b10A7
b10B1   TXA 
        STA aFD
        LDX a04
        INX 
        CPX aFD
        BEQ b10BE
        BPL b10BE
        RTS 

b10BE   LDX a04
        LDA f14C7,X
        STA (p05),Y
        RTS 

s10C6   JSR s1185
        LDY #$00
        LDA a04
        CMP #$07
        BNE b10D2
        RTS 

b10D2   LDA #$07
        STA a117B
        LDA a02
        STA a08
        LDA a03
        STA a09
        LDX a14D1
        LDA f14D2,X
        STA a0D
        LDA f14DA,X
        STA a0E
        LDA f14E2,X
        STA a10
        LDA f14EA,X
        STA a11
b10F6   LDA a08
        CLC 
        ADC (p0D),Y
        STA a02
        LDA a09
        CLC 
        ADC (p10),Y
        STA a03
        TYA 
        PHA 
        JSR s1185
        PLA 
        TAY 
        INY 
        LDA (p0D),Y
        CMP #$55
        BNE b10F6
        DEC a117B
        LDA a117B
        CMP a04
        BEQ b1124
        CMP #$01
        BEQ b1124
        INY 
        JMP b10F6

b1124   LDA a08
        STA a02
        LDA a09
        STA a03
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
a117B   .BYTE $01
a117D   =*+$01
s117C   LDA fE199,X
        INC a117D
        RTS 

        .BYTE $00,$00
s1185   LDA a02
        PHA 
        LDA a03
        PHA 
        JSR s1082
        LDA a14
        BNE b119A
b1192   PLA 
        STA a03
        PLA 
        STA a02
        RTS 

        .BYTE $60
b119A   CMP #$03
        BEQ b11CC
        LDA #$15
        SEC 
        SBC a02
        STA a02
        LDY a14
        CPY #$02
        BEQ b11D6
        JSR s1082
        LDA a14
        CMP #$01
        BEQ b1192
        LDA #$15
        SEC 
        SBC a03
        STA a03
        JSR s1082
j11BE   PLA 
        TAY 
        PLA 
        STA a02
        TYA 
        PHA 
        JSR s1082
        PLA 
        STA a03
        RTS 

b11CC   LDA #$15
        SEC 
        SBC a03
        STA a03
        JMP j11BE

b11D6   LDA #$15
        SEC 
        SBC a03
        STA a03
        JSR s1082
        PLA 
        STA a03
        PLA 
        STA a02
        RTS 

f11E7   .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$FF
f1207   .BYTE $0E,$0D,$0C,$0B,$0A,$09,$08,$07
        .BYTE $06,$05,$04,$03,$02,$01,$00,$15
        .BYTE $14,$06,$05,$04,$03,$02,$01,$00
        .BYTE $15,$14,$13,$12,$11,$10,$0F,$00
f1227   .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
f1247   .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$00
f1267   .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$00
f1287   .BYTE $04,$04,$04,$04,$04,$04,$04,$04
        .BYTE $04,$04,$04,$04,$04,$04,$04,$04
        .BYTE $04,$04,$04,$04,$04,$04,$04,$04
        .BYTE $04,$04,$04,$04,$04,$04,$04,$00
f12A7   .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$00
s12C7   LDX #$00
        LDA #$FF
b12CB   STA f1227,X
        INX 
        CPX #$20
        BNE b12CB
        LDA #$00
        STA a12
        STA a0F
        STA a13
        STA a17
        LDA #$01
        STA a15
        STA a1AE6
        RTS 

j12E5   JSR s1363
        JSR s1AE7
        JSR s12C7
        JSR s17A3
        JSR s1363
j12F4   INC a1362
        LDA aC5
        CMP #$17
        BNE b130F
b12FD   LDA aC5
        CMP #$40
        BNE b12FD
b1303   LDA aC5
        CMP #$17
        BNE b1303
b1309   LDA aC5
        CMP #$40
        BNE b1309
b130F   LDA a1AE6
        BEQ b1317
        JSR s1AE7
b1317   LDA a1362
        CMP a14C0
        BNE b1324
        LDA #$00
        STA a1362
b1324   LDX a1362
        LDA f1227,X
        CMP #$FF
        BNE b1333
        STX a13
        JMP j12F4

b1333   STA a04
        DEC f1267,X
        BNE b135F
        LDA f1247,X
        STA f1267,X
        LDA f11E7,X
        STA a02
        LDA f1207,X
        STA a03
        LDA f1287,X
        STA a14D1
        LDA f12A7,X
        STA a14
        TXA 
        PHA 
        JSR s10C6
        PLA 
        TAX 
        DEC f1227,X
b135F   JMP j12F4

a1362   .BYTE $19
s1363   SEI 
        LDA #<p137A
        STA RAM_CINV
        LDA #>p137A
        STA a0315
        LDA #$0A
        STA a14B8
        STA a14B9
        CLI 
        RTS 

a1378   .BYTE $01,$00
p137A   DEC a1378
        BEQ b1382
        JMP j1494

b1382   LDA #$00
        STA a0C
        LDA a14BF
        STA a1378
        JSR s14AB
        JSR s1B88
        LDA a21
        AND #$03
        CMP #$03
        BEQ b13BF
        CMP #$02
        BEQ b13A4
        INC a14B9
        INC a14B9
b13A4   DEC a14B9
        LDA a14B9
        CMP #$FF
        BNE b13B6
        LDA #$15
        STA a14B9
        JMP b13BF

b13B6   CMP #$16
        BNE b13BF
        LDA #$00
        STA a14B9
b13BF   LDA a21
        AND #$0C
        CMP #$0C
        BEQ b13EC
        CMP #$08
        BEQ b13D1
        INC a14B8
        INC a14B8
b13D1   DEC a14B8
        LDA a14B8
        CMP #$FF
        BNE b13E3
        LDA #$15
        STA a14B8
        JMP b13EC

b13E3   CMP #$16
        BNE b13EC
        LDA #$00
        STA a14B8
b13EC   LDA a21
        AND #$80
        BEQ b13FA
        LDA #$00
        STA a14BB
        JMP j148D

b13FA   LDA a14BC
        BEQ b140A
        LDA a14BB
        BEQ b1407
        JMP j148D

b1407   INC a14BB
b140A   LDA a1BC4
        BEQ b1417
        DEC a1BC4
        BEQ b1417
        JMP j142B

b1417   DEC a1984
        BEQ b141F
        JMP j148D

b141F   LDA a14C1
        STA a1984
        LDA a14C5
        STA a1BC4
j142B   INC a14BA
        LDA a14BA
        CMP a14C0
        BNE b143B
        LDA #$00
        STA a14BA
b143B   TAX 
        LDA f1227,X
        CMP #$FF
        BEQ b1455
        LDA a13
        AND a14CF
        BEQ j148D
        TAX 
        LDA f1227,X
        CMP #$FF
        BNE j148D
        STX a14BA
b1455   LDA a14B8
        STA f11E7,X
        LDA a14B9
        STA f1207,X
        LDA a14D0
        BEQ b1474
        LDA #$19
        SEC 
        SBC a14B9
        ORA #$80
        STA f1227,X
        JMP j147F

b1474   LDA a14C6
        STA f1227,X
        LDA a0F
        STA f1287,X
j147F   LDA a14BE
        STA f1247,X
        STA f1267,X
        LDA a15
        STA f12A7,X
j148D   LDA #$01
        STA a0C
        JSR s14AB
j1494   JSR s15EE
        JMP ROM_IRQ  ;$EABF - IRQ interrupt handler

s149A   LDX a14B9
        LDA f0340,X
        STA a0A
        LDA f0360,X
        STA a0B
        LDY a14B8
b14AA   RTS 

s14AB   LDA a1BC5
        BNE b14AA
        JSR s149A
        LDA a0C
        STA (p0A),Y
        RTS 

a14B8   .BYTE $0F
a14B9   .BYTE $12
a14BA   .BYTE $10
a14BB   .BYTE $00
a14BC   .BYTE $00
f14BD   .BYTE $00
a14BE   .BYTE $0C
a14BF   .BYTE $02
a14C0   .BYTE $1F
a14C1   .BYTE $01
a14C2   .BYTE $07,$07,$04
a14C5   .BYTE $01
a14C6   .BYTE $07
f14C7   .BYTE $00,$06,$02,$03,$04,$05,$07,$01
a14CF   .BYTE $00
a14D0   .BYTE $00
a14D1   .BYTE $04
f14D2   .BYTE $2D,$F2,$22,$66,$82,$B6,$FD,$4D
f14DA   .BYTE $11,$14,$15,$15,$15,$15,$16,$17
f14E2   .BYTE $54,$0A,$44,$74,$9C,$D2,$25,$6D
f14EA   .BYTE $11,$15,$15,$15,$15,$15,$17,$17
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
s15EE   LDA a1983
        BEQ b15F6
        JMP j1854

b15F6   LDA a12
        BEQ b15FE
        DEC a12
        BNE b160B
b15FE   LDA aC5
        CMP #$40
        BNE b160C
        LDA #$00
        STA a12
        JSR s1B59
b160B   RTS 

b160C   LDY a16FC
        STY a12
        LDY a028D
        STY a1A38
        CMP #$20
        BNE b1624
        INC a0F
        LDA a0F
        AND #$07
        STA a0F
        RTS 

b1624   CMP #$29
        BNE b164C
        INC a15
        LDA a15
        CMP #$05
        BNE b1634
        LDA #$00
        STA a15
b1634   ASL 
        ASL 
        ASL 
        TAY 
        JSR s17A3
        LDX #$00
b163D   LDA f17C4,Y
        STA f178D,X
        INY 
        INX 
        CPX #$08
        BNE b163D
        JMP j17B1

b164C   CMP #$12
        BNE b1656
        LDA #$01
        STA a1983
        RTS 

b1656   CMP #$22
        BNE b1660
        LDA #$02
        STA a1983
        RTS 

b1660   CMP #$23
        BNE b166A
        LDA #$03
        STA a1983
        RTS 

b166A   CMP #$0D
        BNE b1674
        LDA #$04
        STA a1983
        RTS 

b1674   CMP #$2B
        BNE b1682
        LDA #$01
        STA a1A
        LDA #$05
        STA a1983
        RTS 

b1682   CMP #$32
        BNE b16A9
        LDA a14CF
        EOR #$FF
        STA a14CF
        AND #$01
        ASL 
        ASL 
        ASL 
        TAY 
        JSR s17A3
        LDX #$00
b1699   LDA f19DD,Y
        STA f178D,X
        INY 
        INX 
        CPX #$08
        BNE b1699
        JMP j17B1

        RTS 

b16A9   LDX #$00
b16AB   CMP f1063,X
        BEQ b16B8
        INX 
        CPX #$10
        BNE b16AB
        JMP j16BB

b16B8   JMP j19ED

j16BB   CMP #$34
        BNE b16C5
        LDA #$08
        STA a1983
        RTS 

b16C5   CMP #$0E
        BNE b16CF
        LDA #$09
        STA a1983
        RTS 

b16CF   CMP #$36
        BNE b16EE
        INC a1B03
        LDA a1B03
        AND #$0F
        TAY 
        LDA f1B04,Y
        LDX #$00
b16E1   STA f1E00,X
        STA f1EE4,X
        DEX 
        BNE b16E1
        STA a1050
        RTS 

b16EE   CMP #$11
        BNE b16FB
        LDA a1B14
        EOR #$01
        STA a1B14
        RTS 

b16FB   RTS 

a16FC   .BYTE $10,$01,$01,$FF,$FF,$55,$02,$02
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
f178C   .BYTE $55
f178D   .BYTE $20,$20,$20,$20,$20,$20
a1793   .BYTE $20
a1794   .BYTE $20
f1795   .BYTE $20,$20,$20,$20,$20,$20,$20,$20
        .BYTE $20,$20,$20,$20,$20,$20
s17A3   LDX #$16
b17A5   LDA #$20
        STA f178C,X
        STA f1FE3,X
        DEX 
        BNE b17A5
        RTS 

j17B1   LDX #$16
b17B3   LDA f178C,X
        AND #$3F
        STA f1FE3,X
        LDA #$03
        STA f97E3,X
        DEX 
        BNE b17B3
        RTS 

f17C4   .BYTE $CE,$CF,$A0,$D3,$D9,$CD,$A0,$A0
        .BYTE $D9,$AD,$D3,$D9,$CD,$A0,$A0,$A0
        .BYTE $D8,$AD,$D9,$A0,$D3,$D9,$CD,$A0
        .BYTE $D8,$AD,$D3,$D9,$CD,$A0,$A0,$A0
        .BYTE $D1,$D5,$C1,$C4,$A0,$D3,$D9,$CD
j17EC   LDA a19
        PHA 
        CLC 
        ADC #$78
        STA a19
        LDY #$00
b17F6   LDA f19D6,Y
        STA (p18),Y
        INY 
        CPY #$08
        BNE b17F6
        PLA 
        STA a19
        LDA #$00
        STA a1841
        STA a1843
        STA a1844
        LDA a1842
        BEQ b183F
b1813   LDA a1844
        CLC 
        ADC a1840
        STA a1844
        LDX a1844
        LDY a1841
        LDA f1845,X
        STA (p18),Y
        CPX #$08
        BNE b1834
        LDA #$00
        STA a1844
        INC a1841
b1834   INC a1843
        LDA a1843
        CMP a1842
        BNE b1813
b183F   RTS 

a1840   .BYTE $08
a1841   .BYTE $02
a1842   .BYTE $02
a1843   .BYTE $02
a1844   .BYTE $00
f1845   .BYTE $20,$65,$74,$75,$61,$F6,$EA,$E7
        .BYTE $A0
b184E   LDA #$00
        STA a1983
        RTS 

j1854   LDA a12
        BEQ b185D
        DEC a12
        JMP j18DC

b185D   LDA aC5
        CMP #$40
        BNE b1866
        JMP j18DC

b1866   LDA #$04
        STA a12
        LDA a1983
        CMP #$05
        BEQ b1875
        CMP #$03
        BNE b1893
b1875   LDX #$00
b1877   LDA f1227,X
        CMP #$FF
        BNE b184E
        INX 
        CPX a14C0
        BNE b1877
        LDA a1B14
        BNE b184E
        LDA #$FF
        STA a1AE6
        LDA #$00
        STA a14BA
b1893   LDA #>p07D0
        STA a19
        LDA #<p07D0
        STA a18
        LDX a1983
        LDA aC5
        CMP #$25
        BNE b18B5
        INC f14BD,X
        LDA f14BD,X
        CMP f1965,X
        BNE b18C7
        DEC f14BD,X
        JMP b18C7

b18B5   CMP #$1D
        BNE b18C7
        DEC f14BD,X
        LDA f14BD,X
        CMP f196F,X
        BNE b18C7
        INC f14BD,X
b18C7   CPX #$05
        BNE b18D6
        LDX a14C2
        LDY a1A
        LDA f19D5,X
        STA f14C7,Y
b18D6   JSR j18DC
        JMP j1945

j18DC   LDA #>p1FEC
        STA a19
        LDA #<p1FEC
        STA a18
        LDX a1983
        CPX #$05
        BNE b1902
        LDX a1A
        LDA f14C7,X
        LDY #$00
b18F2   CMP f19D5,Y
        BEQ b18FC
        INY 
        CPY #$10
        BNE b18F2
b18FC   STY a14C2
        LDX a1983
b1902   LDA f1979,X
        STA a1840
        LDA f14BD,X
        STA a1842
        TXA 
        PHA 
        LDA a1B02
        BNE b191D
        LDA #$01
        STA a1B02
        JSR s17A3
b191D   PLA 
        ASL 
        ASL 
        ASL 
        TAY 
        LDX #$00
b1924   LDA f1985,Y
        STA f178D,X
        INY 
        INX 
        CPX #$08
        BNE b1924
        LDA a1983
        CMP #$05
        BNE b193F
        LDA #$30
        CLC 
        ADC a1A
        STA a1794
b193F   JSR j17B1
        JMP j17EC

j1945   LDA aC5
        CMP #$0F
        BEQ b194C
        RTS 

b194C   LDA a1983
        CMP #$05
        BNE b195C
        INC a1A
        LDA a1A
        CMP #$08
        BEQ b195C
        RTS 

b195C   LDA #$00
        STA a1983
        STA a1B02
        RTS 

f1965   .BYTE $00,$40,$08,$20,$10,$08,$08,$20
        .BYTE $10,$08
f196F   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f1979   .BYTE $00,$01,$08,$01,$04,$08,$08,$02
        .BYTE $04,$08
a1983   .BYTE $00
a1984   .BYTE $01
f1985   .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $C4,$C5,$CC,$C1,$D9,$BA,$A0,$A0
        .BYTE $C3,$D3,$D0,$C5,$C5,$C4,$BA,$A0
        .BYTE $C2,$CC,$C5,$CE,$C7,$D4,$C8,$BA
        .BYTE $D0,$D3,$D0,$C5,$C5,$C4,$BA,$A0
        .BYTE $C3,$CF,$CC,$CF,$D5,$D2,$A0,$B0
        .BYTE $CC,$D7,$C9,$C4,$D4,$C8,$BA,$A0
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $D0,$D7,$C9,$C4,$D4,$C8,$BA,$A0
        .BYTE $C2,$C1,$D3,$C5,$BA,$A0,$A0,$A0
f19D5   .BYTE $00
f19D6   .BYTE $06,$02,$04,$05,$03,$07,$01
f19DD   .BYTE $D4,$D2,$AE,$CF,$C6,$C6,$A0,$A0
        .BYTE $D4,$D2,$AE,$CF,$CE,$A0,$A0,$A0
j19ED   TXA 
        PHA 
        JSR s17A3
        LDX #$00
b19F4   LDA f1A20,X
        STA f178D,X
        INX 
        CPX #$08
        BNE b19F4
        PLA 
        PHA 
        TAX 
        BEQ b1A19
b1A04   INC a1794
        LDA a1794
        CMP #$BA
        BNE b1A16
        LDA #$30
        STA a1794
        INC a1793
b1A16   DEX 
        BNE b1A04
b1A19   JMP j1A39

j1A1C   JSR j17B1
        RTS 

f1A20   .BYTE $D0,$D2,$C5,$D3,$C5,$D4,$B0,$B0
f1A28   .BYTE $A0,$C1,$C3,$D4,$C9,$D6,$C5,$A0
        .BYTE $A0,$D3,$C5,$D4,$A0,$D5,$D0,$A0
a1A38   .BYTE $00
j1A39   LDA a1A38
        AND #$01
        ASL 
        ASL 
        ASL 
        TAY 
        LDX #$00
b1A44   LDA f1A28,Y
        STA f1795,X
        INY 
        INX 
        CPX #$08
        BNE b1A44
        LDA a1A38
        AND #$01
        BNE b1A5A
        JMP j1A7A

b1A5A   PLA 
        TAX 
        JSR s1ABF
        LDY #$00
        LDX #$00
b1A63   LDA f14BD,X
        STA (p1B),Y
        INY 
        INX 
        CPX #$15
        BNE b1A63
        LDA a0F
        STA (p1B),Y
        INY 
        LDA a15
        STA (p1B),Y
        JMP j1A1C

j1A7A   PLA 
        TAX 
        JSR s1ABF
        LDY #$03
        LDA (p1B),Y
        CMP a14C0
        BEQ b1A8E
        JSR s1ADB
        JMP j1AA2

b1A8E   LDX #$00
        LDY #$07
b1A92   LDA (p1B),Y
        CMP f14C7,X
        BNE j1AA2
        INY 
        INX 
        CPX #$08
        BNE b1A92
        JMP j1AA2

j1AA2   LDA #$FF
        STA a1AE6
        LDY #$00
b1AA9   LDA (p1B),Y
        STA f14BD,Y
        INY 
        CPY #$15
        BNE b1AA9
        LDA (p1B),Y
        STA a0F
        INY 
        LDA (p1B),Y
        STA a15
        JMP j1A1C

s1ABF   LDA #>p1C00
        STA a1C
        LDA #<p1C00
        STA a1B
        TXA 
        BEQ b1ADA
b1ACA   LDA a1B
        CLC 
        ADC #$20
        STA a1B
        LDA a1C
        ADC #$00
        STA a1C
        DEX 
        BNE b1ACA
b1ADA   RTS 

s1ADB   LDA #$FF
        STA a1AE6
        LDA #$00
        STA a14BA
        RTS 

a1AE6   .BYTE $00
s1AE7   LDA #$00
        STA a1362
        STA a13
        LDX #$00
        LDA #$FF
b1AF2   STA f1227,X
        INX 
        CPX #$20
        BNE b1AF2
        LDA #$00
        STA a1AE6
        JMP j104D

a1B02   .BYTE $00
a1B03   .BYTE $10
f1B04   .BYTE $CF,$51,$53,$5A,$5B,$5F,$57,$7F
        .BYTE $56,$61,$4F,$66,$6C,$EC,$A0,$2A
a1B14   .BYTE $00
a1B15   .BYTE $01
a1B16   .BYTE $80
j1B17   DEC a1B15
        BEQ b1B1D
        RTS 

b1B1D   JSR s117C
        AND #$1F
        ORA #$01
        STA a1B15
        LDA a1B16
        EOR #$80
        STA a1B16
        JSR s117C
        AND #$0F
        ORA a1B16
        EOR #$8F
        STA a21
        DEC a1B87
        BEQ b1B41
        RTS 

b1B41   JSR s117C
        AND #$07
b1B46   ADC #$20
        STA a1B87
        JSR s117C
        AND #$0F
        TAX 
        LDA #$00
        STA a1A38
        JMP j19ED

s1B59   LDA a1B14
        BNE b1B61
        JMP s17A3

b1B61   LDX #$00
b1B63   LDA f1B71,X
        STA f178D,X
        INX 
        CPX #$16
        BNE b1B63
        JMP j17B1

f1B71   BNE b1B46
        CMP fC8C3,Y
        CMP aC4
        CMP aCC
        CMP #$C1
        LDY #$C2
        CMP fCAA0,Y
        CMP aC6
        DEC aAE
a1B87   =*+$02
        LDX a20AE
s1B88   LDA a1B14
        BEQ b1B90
        JMP j1B17

b1B90   LDX #$7F
        STX VIA2DDRB ;$9122 - data direction register for port b
b1B95   LDY VIA2PB   ;$9120 - port b I/O register
        CPY VIA2PB   ;$9120 - port b I/O register
        BNE b1B95
        LDX #$FF
        STX VIA2DDRB ;$9122 - data direction register for port b
        LDX #$F7
        STX VIA2PB   ;$9120 - port b I/O register
b1BA7   LDA VIA1PA2  ;$911F - mirror of VIA1PA1 (CA1 & CA2 unaffected)
        CMP VIA1PA2  ;$911F - mirror of VIA1PA1 (CA1 & CA2 unaffected)
        BNE b1BA7
        PHA 
        AND #$1C
        LSR 
        CPY #$80
        BCC b1BB9
        ORA #$10
b1BB9   TAY 
        PLA 
        AND #$20
        CMP #$20
        TYA 
        ROR 
        STA a21
        RTS 

a1BC4   .BYTE $01
a1BC5   .BYTE $00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$4B
p1C00   .BYTE $00,$0C,$02,$1F,$01,$01,$07,$04
        .BYTE $01,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$FF,$00,$05,$00,$01,$0F
        .BYTE $F0,$0F,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$0C,$02,$1F,$01,$03,$07,$04
        .BYTE $01,$07,$00,$02,$04,$06,$05,$06
        .BYTE $02,$04,$FF,$00,$01,$01,$04,$8F
        .BYTE $70,$0F,$FF,$00,$FF,$00,$DF,$00
        .BYTE $00,$0C,$02,$1F,$01,$01,$07,$04
        .BYTE $01,$07,$00,$06,$03,$05,$07,$03
        .BYTE $05,$06,$FF,$00,$05,$05,$01,$6F
        .BYTE $D0,$2F,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$0C,$01,$1F,$01,$03,$07,$04
        .BYTE $02,$07,$00,$02,$04,$03,$06,$05
        .BYTE $07,$04,$FF,$00,$03,$03,$02,$1F
        .BYTE $F0,$0F,$BF,$00,$FF,$00,$FA,$20
        .BYTE $00,$0C,$02,$1F,$01,$07,$07,$04
        .BYTE $01,$07,$00,$06,$02,$03,$04,$05
        .BYTE $07,$01,$00,$00,$04,$04,$01,$00
        .BYTE $FF,$00,$D0,$4F,$70,$4F,$70,$1F
        .BYTE $00,$0C,$03,$1F,$01,$06,$07,$04
        .BYTE $02,$07,$00,$02,$04,$06,$03,$02
        .BYTE $04,$07,$00,$00,$06,$06,$03,$00
        .BYTE $FF,$00,$E0,$0F,$F0,$0F,$F0,$07
        .BYTE $00,$07,$02,$1F,$01,$07,$07,$04
        .BYTE $01,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$FF,$00,$07,$07,$00,$40
        .BYTE $FF,$00,$D0,$0F,$D0,$8F,$F0,$0F
        .BYTE $00,$07,$01,$1F,$02,$06,$07,$04
        .BYTE $01,$07,$00,$04,$02,$06,$02,$05
        .BYTE $03,$07,$00,$00,$07,$07,$01,$00
        .BYTE $FF,$00,$D0,$8F,$60,$4F,$F5,$8F
        .BYTE $00,$0A,$01,$1F,$03,$07,$07,$04
        .BYTE $01,$03,$00,$02,$07,$06,$05,$03
        .BYTE $07,$01,$FF,$00,$04,$04,$04,$0F
        .BYTE $C0,$2F,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$0A,$02,$1F,$04,$07,$07,$04
        .BYTE $05,$07,$00,$02,$07,$06,$04,$07
        .BYTE $03,$01,$FF,$00,$05,$05,$04,$0F
        .BYTE $F0,$0F,$FF,$00,$FF,$00,$FF,$00
        .BYTE $00,$0C,$02,$1F,$01,$06,$07,$04
        .BYTE $01,$07,$00,$02,$04,$06,$06,$04
        .BYTE $02,$07,$FF,$00,$07,$07,$02,$02
        .BYTE $FE,$00,$F6,$16,$FC,$0F,$FD,$01
        .BYTE $00,$0C,$01,$1F,$02,$01,$07,$04
        .BYTE $01,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$FF,$00,$03,$03,$04,$0F
        .BYTE $70,$0F,$FF,$00,$FF,$00,$FA,$00
        .BYTE $00,$0C,$01,$1F,$08,$01,$07,$04
        .BYTE $05,$07,$00,$06,$02,$03,$07,$04
        .BYTE $02,$06,$FF,$00,$03,$03,$04,$00
        .BYTE $FF,$00,$F0,$0F,$F0,$8F,$D0,$0F
        .BYTE $00,$07,$01,$1F,$08,$01,$07,$04
        .BYTE $01,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$FF,$00,$04,$04,$04,$00
        .BYTE $FF,$00,$F0,$0F,$F0,$4F,$50,$4F
        .BYTE $00,$0C,$01,$1F,$03,$01,$07,$04
        .BYTE $02,$07,$00,$06,$03,$05,$07,$03
        .BYTE $05,$06,$FF,$00,$07,$07,$02,$00
        .BYTE $FF,$10,$D0,$4F,$E0,$9F,$70,$2F
        .BYTE $00,$07,$01,$07,$01,$01,$07,$04
        .BYTE $01,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$FF,$00,$04,$04,$04,$00
        .BYTE $FF,$00,$F0,$8F,$F0,$8F,$F5
