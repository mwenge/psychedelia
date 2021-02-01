;
; **** ZP FIELDS **** 
;
f04 = $04
;
; **** ZP ABSOLUTE ADRESSES **** 
;
a02 = $02
a03 = $03
a04 = $04
a05 = $05
a06 = $06
a07 = $07
a08 = $08
a09 = $09
a0A = $0A
a0B = $0B
a0C = $0C
a0D = $0D
a0E = $0E
currentPatternElement = $0F
a10 = $10
a11 = $11
a12 = $12
a13 = $13
a14 = $14
currentSymmetrySetting = $15
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
lastJoystickInput = $21
a22 = $22
a23 = $23
a24 = $24
a25 = $25
a26 = $26
aA0 = $A0
aBA = $BA
aC4 = $C4
lastKeyPressed = $C5
aC6 = $C6
aCE = $CE
aFB = $FB
aFC = $FC
aFD = $FD
aFE = $FE
aFF = $FF
;
; **** ZP POINTERS **** 
;
p01 = $01
p05 = $05
p07 = $07
p0A = $0A
p0C = $0C
p0D = $0D
p10 = $10
p18 = $18
p1B = $1B
p1D = $1D
p1F = $1F
p22 = $22
pFB = $FB
pFD = $FD
;
; **** FIELDS **** 
;
SCREEN_RAM  = $0400
fA0A0 = $A0A0
COLOR_RAM = $D800
fE199 = $E199
;
; **** ABSOLUTE ADRESSES **** 
;
a0286 = $0286
shiftKey = $028D
a0291 = $0291
a0314 = $0314
a0315 = $0315
a0318 = $0318
a0319 = $0319
a07C6 = $07C6
a07C7 = $07C7
a07C8 = $07C8
a07D1 = $07D1
a7FFF = $7FFF
aC300 = $C300
aC301 = $C301
aC4CF = $C4CF
aCEC9 = $CEC9
;
; **** POINTERS **** 
;
p01FF = $01FF
pC000 = $C000
;
; **** EXTERNAL JUMPS **** 
;
eEA31 = $EA31
;
; **** PREDEFINED LABELS **** 
;
ROM_IOINIT = $FF84
ROM_READST = $FFB7
ROM_SETLFS = $FFBA
ROM_SETNAM = $FFBD
ROM_LOAD = $FFD5
ROM_SAVE = $FFD8
ROM_CLALL = $FFE7

        * = $0801

;-----------------------------------------------------------
; Start program at InitializeProgram (SYS 2064)
;-----------------------------------------------------------
        ; 'A2064'
        .BYTE $0B,$08,$C1,$07,$9E,$32,$30,$36,$34 ; SYS 2064
        .BYTE $00,$00,$00,$F9
        .BYTE $02,$F9    ;JAM 
;-------------------------------
; InitializeProgram
;-------------------------------
InitializeProgram
        ; Set border and background to black
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0

        JSR CopyDataFrom2000ToC000

        STA a13

        ; Create a Hi/Lo pointer to $D800
        LDA #$D8
        STA aFC
        LDA #$00
        STA aFB

        ; Populate a jump table of hi/lo ptrs with $D800,
        ; $D828, $D850 etc.
        LDX #$00
b0827   LDA aFC
        STA jumpTableHiPtrArray,X
        LDA aFB
        STA jumpTableLoPtrArray,X
        CLC 
        ADC #$28
        STA aFB
        LDA aFC
        ADC #$00
        STA aFC
        INX 
        CPX #$19
        BNE b0827

        LDA #$80
        STA a0291
        LDA #$15
        STA $D018    ;VIC Memory Control Register
        JSR ROM_IOINIT ;$FF84 - initialize CIA & IRQ             
        JSR InitializeDynamicStorage
        JMP LaunchPsychedelia

jumpTableLoPtrArray
      .BYTE $00,$00,$00,$00,$00                 ; $0851:               
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00     ; $0859:               
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00     ; $0861:               
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00     ; $0869:               
      .BYTE $00
jumpTableHiPtrArray
      .BYTE $00,$00,$00,$00,$00,$00,$BF     ; $0871:               
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00     ; $0879:               
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00     ; $0881:               
      .BYTE $00,$00,$00,$00,$00,$00,$00     ; $0889:               

;-------------------------------
; InitializeScreenWithInitCharacter
;-------------------------------
InitializeScreenWithInitCharacter 
        LDX #$00 

currentPixel = *+$01
b0892   LDA #$CF
        STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02C0,X
        LDA #$00
        STA COLOR_RAM + $0000,X
        STA COLOR_RAM + $0100,X
        STA COLOR_RAM + $0200,X
        STA COLOR_RAM + $02C0,X
        DEX 
        BNE b0892
        RTS 

presetKeyCodes
        .BYTE $39,$38,$3B,$08,$0B,$10,$13,$18
        .BYTE $1B,$20,$23,$28,$2B,$30,$33,$00

;-------------------------------
; LookUpJumpTable
;-------------------------------
LookUpJumpTable   
        LDX a03
        LDA jumpTableLoPtrArray,X
        STA a05
        LDA jumpTableHiPtrArray,X
        STA a06
        LDY a02
b08D0   RTS 

;-------------------------------
; s08D1
;-------------------------------
s08D1   
        LDA a02
        AND #$80
        BNE b08D0
        LDA a02
        CMP #$28
        BPL b08D0
        LDA a03
        AND #$80
        BNE b08D0
        LDA a03
        CMP #$18
        BPL b08D0
        JSR LookUpJumpTable
        LDA a17
        BNE b090D
        LDA (p05),Y
        AND #$0F

        LDX #$00
b08F6   CMP f0E48,X
        BEQ b0900
        INX 
        CPX #$08
        BNE b08F6

b0900   TXA 
        STA aFD
        LDX a04
        INX 
        CPX aFD
        BEQ b090D
        BPL b090D
        RTS 

b090D   LDX a04
        LDA f0E48,X
        STA (p05),Y
        RTS 

;-------------------------------
; s0915
;-------------------------------
s0915   
        JSR s09D4
        LDY #$00
        LDA a04
        CMP #$07
        BNE b0921
        RTS 

b0921   LDA #$07
        STA a09CA
        LDA a02
        STA a08
        LDA a03
        STA a09
        LDX a0E52
        LDA f0E53,X
        STA a0D
        LDA f0E63,X
        STA a0E
        LDA f0E73,X
        STA a10
        LDA f0E83,X
        STA a11
b0945   LDA a08
        CLC 
        ADC (p0D),Y
        STA a02
        LDA a09
        CLC 
        ADC (p10),Y
        STA a03
        TYA 
        PHA 
        JSR s09D4
        PLA 
        TAY 
        INY 
        LDA (p0D),Y
        CMP #$55
        BNE b0945
        DEC a09CA
        LDA a09CA
        CMP a04
        BEQ b0973
        CMP #$01
        BEQ b0973
        INY 
        JMP b0945

b0973   LDA a08
        STA a02
        LDA a09
        STA a03
        RTS 

; Redundant data?
        .BYTE $00,$01,$01,$01,$00                   ; $0979:       
        .BYTE $FF,$FF,$FF,$55,$00,$02,$00,$FE       ; $0981:       
        .BYTE $55,$00,$03,$00,$FD,$55,$00,$04       ; $0989:       
        .BYTE $00,$FC,$55,$FF,$01,$05,$05,$01       ; $0991:       
        .BYTE $FF,$FB,$FB,$55,$00,$07,$00,$F9       ; $0999:       
        .BYTE $55,$55,$FF,$FF,$00,$01,$01,$01       ; $09A1:       
        .BYTE $00,$FF,$55,$FE,$00,$02,$00,$55       ; $09A9:       
        .BYTE $FD,$00,$03,$00,$55,$FC,$00,$04       ; $09B1:       
        .BYTE $00,$55,$FB,$FB,$FF,$01,$05,$05       ; $09B9:       
        .BYTE $01,$FF,$55,$F9,$00,$07,$00,$55       ; $09C1:       
        .BYTE $55

a09CA   .BYTE $00

a09CC   =*+$01
;-------------------------------
; s09CB
;-------------------------------
s09CB   
        LDA fE199,X
        INC a09CC
        RTS 

        BRK #$00
;-------------------------------
; s09D4
;-------------------------------
s09D4   
        LDA a02
        PHA 
        LDA a03
        PHA 
        JSR s08D1
        LDA a14
        BNE b09E9
b09E1   PLA 
        STA a03
        PLA 
        STA a02
        RTS 

        RTS 

b09E9   CMP #$03
        BEQ b0A1B
        LDA #$27
        SEC 
        SBC a02
        STA a02
        LDY a14
        CPY #$02
        BEQ b0A25
        JSR s08D1
        LDA a14
        CMP #$01
        BEQ b09E1
        LDA #$17
        SEC 
        SBC a03
        STA a03
        JSR s08D1
;-------------------------------
; j0A0D
;-------------------------------
j0A0D    
        PLA 
        TAY 
        PLA 
        STA a02
        TYA 
        PHA 
        JSR s08D1
        PLA 
        STA a03
        RTS 

b0A1B   LDA #$17
        SEC 
        SBC a03
        STA a03
        JMP j0A0D

b0A25   LDA #$17
        SEC 
        SBC a03
        STA a03
        JSR s08D1
        PLA 
        STA a03
        PLA 
        STA a02
        RTS 

f0A36
       .BYTE $00,$00,$FF      ; $0A31:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A39:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A41:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$FF      ; $0A49:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A51:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A59:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A61:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A69:  
       .BYTE $00,$00,$00,$00,$00
f0A76
       .BYTE $00,$00,$FD      ; $0A71:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A79:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A81:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A89:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A91:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0A99:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AA1:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AA9:  
       .BYTE $00,$00,$00,$00,$00
f0AB6
       .BYTE $00,$00,$00      ; $0AB1:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AB9:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AC1:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AC9:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AD1:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AD9:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AE1:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AE9:  
       .BYTE $00,$00,$00,$00,$00
f0AF6
       .BYTE $00,$00,$00      ; $0AF1:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0AF9:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00      ; $0B01:  
       .BYTE $00,$00,$00,$00,$00,$00,$00,$FF      ; $0B09:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B11:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B19:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B21:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B29:  
       .BYTE $FF,$FF,$FF,$FF,$FF
f0B36
       .BYTE $FF,$FF,$FF      ; $0B31:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B39:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B41:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B49:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B51:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B59:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B61:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B69:  
       .BYTE $FF,$FF,$FF,$FF,$FF
f0B76
       .BYTE $FF,$FF,$FF      ; $0B71:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B79:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B81:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B89:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B91:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0B99:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BA1:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BA9:  
       .BYTE $FF,$FF,$FF,$FF,$FF
f0BB6
       .BYTE $FF,$FF,$FF      ; $0BB1:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BB9:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BC1:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BC9:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BD1:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BD9:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BE1:  
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF      ; $0BE9:  
       .BYTE $FF,$FF,$FF,$FF,$FF                  ; $0BF1:  

;-------------------------------
; s0BF6
;-------------------------------
s0BF6
        LDX #$00
        TXA 
b0BF9   STA f0A36,X
        STA f0A76,X
        LDA #$FF
        STA f0AB6,X
        LDA #$00
        STA f0AF6,X
        STA f0B36,X
        STA f0B76,X
        STA f0BB6,X
        INX 
p0C13   CPX #$40
        BNE b0BF9
        STA a12
        STA currentPatternElement
        STA a13
        STA a17
        LDA #$01
        STA currentSymmetrySetting
        RTS 

;-------------------------------
; LaunchPsychedelia
;-------------------------------
LaunchPsychedelia    
        JSR SetUpInterruptHandlers

        LDX #$10
b0C29   TXA 
        STA SetUpInterruptHandlers,X
        DEX 
        BNE b0C29

        JSR s171F
        JSR s0BF6
        JSR ClearLastLineOfScreen
;-------------------------------
; j0C39
;-------------------------------
j0C39    
        INC a0CBB
        LDA lastKeyPressed
        CMP #$02
        BNE b0C54
b0C42   LDA lastKeyPressed
        CMP #$40
        BNE b0C42
b0C48   LDA lastKeyPressed
        CMP #$02
        BNE b0C48
b0C4E   LDA lastKeyPressed
        CMP #$40
        BNE b0C4E
b0C54   LDA a171E
        BEQ b0C6A
        CMP #$17
        BNE b0C60
        JMP j1C5B

b0C60   CMP #$18
        BNE b0C67
        JMP j1D63

b0C67   JSR s171F
b0C6A   LDA a0CBB
        CMP a0E41
        BNE b0C77
        LDA #$00
        STA a0CBB
b0C77   LDX a0CBB
        LDA f0AB6,X
        CMP #$FF
        BNE b0C86
        STX a13
        JMP j0C39

b0C86   STA a04
        DEC f0B36,X
        BNE b0CB8
        LDA f0AF6,X
        STA f0B36,X
        LDA f0A36,X
        STA a02
        LDA f0A76,X
        STA a03
        LDA f0B76,X
        STA a0E52
        LDA f0BB6,X
        STA a14
        LDA a04
        AND #$80
        BNE b0CBC
        TXA 
        PHA 
        JSR s0915
        PLA 
        TAX 
        DEC f0AB6,X
b0CB8   JMP j0C39

a0CBB   .BYTE $00
b0CBC
        JMP j130A
;-------------------------------
; SetUpInterruptHandlers
;-------------------------------
SetUpInterruptHandlers
        SEI
        LDA #<MainInterruptHandler
        STA a0314    ;IRQ
        LDA #>MainInterruptHandler
        STA a0315    ;IRQ

        LDA #$0A
        STA a0E39
        STA jumpTableIndex

        LDA #$01
        STA $D015    ;Sprite display Enable
        STA $D027    ;Sprite 0 Color
        LDA #<NMIInterruptHandler
        STA a0318    ;NMI
        LDA #>NMIInterruptHandler
        STA a0319    ;NMI
        CLI 
        RTS 

a0CE6   .BYTE $02,$00
;-------------------------------
; MainInterruptHandler
;-------------------------------
MainInterruptHandler
        LDA a19F8
        BEQ b0CFB
        DEC a19F8
        BNE b0CFB
        LDA a0E45
        STA a19F8
        JSR s1982
b0CFB   DEC a0CE6
        BEQ b0D03
        JMP JumpToCheckKeyboardInput

b0D03   LDA #$00
        STA a0C
        LDA a0E40
        STA a0CE6
        JSR UpdateJumpTable
        JSR GetJoystickInput
        LDA lastJoystickInput
        AND #$03
        CMP #$03
        BEQ b0D40
        CMP #$02
        BEQ b0D25
        INC jumpTableIndex
        INC jumpTableIndex
b0D25   DEC jumpTableIndex
        LDA jumpTableIndex
        CMP #$FF
        BNE b0D37
        LDA #$17
        STA jumpTableIndex
        JMP b0D40

b0D37   CMP #$18
        BNE b0D40
        LDA #$00
        STA jumpTableIndex
b0D40   LDA lastJoystickInput
        AND #$0C
        CMP #$0C
        BEQ b0D6D
        CMP #$08
        BEQ b0D52
        INC a0E39
        INC a0E39
b0D52   DEC a0E39
        LDA a0E39
        CMP #$FF
        BNE b0D64
        LDA #$27
        STA a0E39
        JMP b0D6D

b0D64   CMP #$28
        BNE b0D6D
        LDA #$00
        STA a0E39
b0D6D   LDA lastJoystickInput
        AND #$10
        BEQ b0D7B
        LDA #$00
        STA a0E3C
        JMP j0E0E

b0D7B   LDA a0E3D
        BEQ b0D8B
        LDA a0E3C
        BEQ b0D88
        JMP j0E0E

b0D88   INC a0E3C
b0D8B   LDA a1A4A
        BEQ b0D98
        DEC a1A4A
        BEQ b0D98
        JMP j0DAC

b0D98   DEC a1531
        BEQ b0DA0
        JMP j0E0E

b0DA0   LDA a0E42
        STA a1531
        LDA a0E46
        STA a1A4A
;-------------------------------
; j0DAC
;-------------------------------
j0DAC    
        INC a0E3B
        LDA a0E3B
        CMP a0E41
        BNE b0DBC
        LDA #$00
        STA a0E3B
b0DBC   TAX 
        LDA f0AB6,X
        CMP #$FF
        BEQ b0DD6
        LDA a13
        AND trackingActivated
        BEQ j0E0E
        TAX 
        LDA f0AB6,X
        CMP #$FF
        BNE j0E0E
        STX a0E3B
b0DD6   LDA a0E39
        STA f0A36,X
        LDA jumpTableIndex
        STA f0A76,X
        LDA lineModeActivated
        BEQ b0DF5
        LDA #$19
        SEC 
        SBC jumpTableIndex
        ORA #$80
        STA f0AB6,X
        JMP j0E00

b0DF5   LDA a0E47
        STA f0AB6,X
        LDA currentPatternElement
        STA f0B76,X
;-------------------------------
; j0E00
;-------------------------------
j0E00    
        LDA a0E3F
a0E03   STA f0AF6,X
        STA f0B36,X
        LDA currentSymmetrySetting
        STA f0BB6,X
;-------------------------------
; j0E0E
;-------------------------------
j0E0E    
        LDA #$01
        STA a0C
        JSR UpdateJumpTable
;-------------------------------
; JumpToCheckKeyboardInput
;-------------------------------
JumpToCheckKeyboardInput    
        JSR CheckKeyboardInput
        JMP eEA31

;-------------------------------
; LookUpJumpTable2
;-------------------------------
LookUpJumpTable2   
        LDX jumpTableIndex
        LDA jumpTableLoPtrArray,X
        STA a0A
        LDA jumpTableHiPtrArray,X
        STA a0B
        LDY a0E39
b0E2B   RTS 

;-------------------------------
; UpdateJumpTable
;-------------------------------
UpdateJumpTable   
        LDA a1BEB
        BNE b0E2B
        JSR LookUpJumpTable2
        LDA a0C
        STA (p0A),Y
        RTS 


a0E39   
       .BYTE $0A
jumpTableIndex   
       .BYTE $0A
a0E3B   
       .BYTE $00
a0E3C   
       .BYTE $00
a0E3D   
       .BYTE $00
f0E3E   
       .BYTE $00
a0E3F   
       .BYTE $0C
a0E40   
       .BYTE $02          ; $0E39:          
a0E41   
       .BYTE $1F
a0E42   
       .BYTE $01
a0E43   
       .BYTE $01
a0E44   
       .BYTE $07
a0E45   
       .BYTE $04
a0E46   
       .BYTE $01
a0E47   
       .BYTE $07
f0E48   
       .BYTE $00          ; $0E41:          
       .BYTE $06
       .BYTE $02
       .BYTE $04
       .BYTE $05
       .BYTE $03
       .BYTE $07
       .BYTE $01
trackingActivated   
       .BYTE $FF          ; $0E49:          
lineModeActivated   
       .BYTE $00
a0E52   
       .BYTE $05
f0E53   
       .BYTE $7C
       .BYTE $93
       ; 'C'
       .BYTE $C3
       .BYTE $07
       .BYTE $23
       .BYTE $57          ; $0E51:          
       .BYTE $61,$B1,$00,$00,$00,$00,$00,$00          ; $0E59:          
       .BYTE $00,$00
f0E63   
       .BYTE $09,$0E,$0E,$0F,$0F,$0F,$11,$11
f0E6B   
       ; 'HIJKLMNO'
       .BYTE $C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF
f0E73   
       .BYTE $A3,$AB,$E5,$15,$3D,$73,$89,$D1
       .BYTE $80,$80,$80,$80,$80,$80,$80,$80
f0E83   
       .BYTE $09,$0E,$0E,$0F,$0F,$0F          ; $0E81:          
       ; 'HIJKLM'
       .BYTE $11,$11,$C8,$C9,$CA,$CB,$CC,$CD          ; $0E89:          
       .BYTE $CE,$CF,$00,$55,$01,$02,$55,$01          ; $0E91:          
       .BYTE $02,$03,$55,$01,$02,$03,$04,$55          ; $0E99:          
       .BYTE $00,$00,$00,$55,$FF,$FE,$55,$FF          ; $0EA1:          
       .BYTE $55,$55,$FF,$55,$FF,$FE,$55,$00          ; $0EA9:          
       .BYTE $00,$00,$55,$01,$02,$03,$04,$55          ; $0EB1:          
       .BYTE $01,$02,$03,$55,$01,$02,$55,$00          ; $0EB9:          
       .BYTE $55,$55,$00,$FF,$00,$55,$00,$00          ; $0EC1:          
       .BYTE $55,$01,$02,$03,$00,$01,$02,$03          ; $0EC9:          
       .BYTE $55,$04,$05,$06,$04,$00,$01,$02          ; $0ED1:          
       .BYTE $55,$04,$00,$04,$00,$04,$55,$FF          ; $0ED9:          
       .BYTE $03,$55,$00,$55,$FF,$00,$01,$55          ; $0EE1:          
       .BYTE $02,$03,$55,$03,$03,$03,$04
f0EF0   
       .BYTE $04          ; $0EE9:          
       .BYTE $04,$04,$55,$03,$02,$03,$04,$05          ; $0EF1:          
       .BYTE $05,$05,$55,$05,$06,$06,$07,$07          ; $0EF9:          
       .BYTE $55,$07,$07,$55,$00,$55,$FF,$55          ; $0F01:          
       .BYTE $00,$55,$02,$55,$01
a0F0E   
       .BYTE $55,$FD,$55          ; $0F09:          
       .BYTE $FE,$55,$00,$55,$FF,$55,$FE,$55          ; $0F11:          
       .BYTE $FF,$55,$02,$55,$01,$55,$FC,$55          ; $0F19:          
       .BYTE $00,$55,$00,$01,$FF,$55,$00,$55          ; $0F21:          
       .BYTE $00,$01,$02,$FE,$FF,$55,$00,$03          ; $0F29:          
       .BYTE $FD,$55,$00,$04,$FC,$55,$00,$06          ; $0F31:          
       .BYTE $FA,$55,$00,$55,$FF,$00,$00,$55          ; $0F39:          
       .BYTE $00,$55,$FE,$FF,$00,$00,$FF,$55          ; $0F41:          
       .BYTE $FD,$01,$01,$55,$FC,$02,$02,$55          ; $0F49:          
       .BYTE $FA,$04,$04,$55,$00,$55,$FF,$01          ; $0F51:          
       .BYTE $55,$FE,$02,$55,$FD,$03,$55,$FC          ; $0F59:          
       .BYTE $04,$FC,$FC,$04,$04,$55,$FB,$05          ; $0F61:          
       .BYTE $55,$FA,$06,$FA,$FA,$06,$06,$55          ; $0F69:          
       .BYTE $00,$55,$01,$FF,$55,$FE,$02,$55          ; $0F71:          
       .BYTE $03,$FD,$55,$FC,$04,$FF,$01,$FF          ; $0F79:          
       .BYTE $01,$55,$05,$FB,$55,$FA,$06,$FE          ; $0F81:          
       .BYTE $02,$FE,$02,$55,$00,$55                  ; $0F89:          


;-------------------------------
; CheckKeyboardInput
;-------------------------------
CheckKeyboardInput   
        LDA selectedVariables
        BEQ b0F97
        JMP j13ED

b0F97   LDA a12
        BEQ b0F9F
        DEC a12
        BNE b0FAC
b0F9F   LDA lastKeyPressed
        CMP #$40
        BNE b0FAD
        LDA #$00
        STA a12
        JSR DisplayDemoModeMessage
b0FAC   RTS 

b0FAD   LDY a1160
        STY a12
        LDY shiftKey
        STY shiftPressed

        CMP #$3C ; Space pressed?
        BNE b0FE6

        ;---------------------------------------------------------------------
        ; Space pressed. Selects a new pattern element. " There are eight permanent ones,
        ; and eight you can define for yourself (more on this later!). The latter eight
        ; are all set up when you load, so you can always choose from 16 shapes."
        ;---------------------------------------------------------------------
        INC currentPatternElement
        LDA currentPatternElement
        AND #$0F
        STA currentPatternElement
        AND #$08
        BEQ b0FCB
        JMP GetCustomPatternElement

b0FCB   JSR ClearLastLineOfScreen
        LDA currentPatternElement
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 

        LDX #$00
b0FD7   LDA txtPresetPatternNames,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE b0FD7
        JMP WriteLastLineBufferToScreen
        ; Returns

b0FE6   CMP #$0D ; 'S' pressed.
        BNE b101E

        ;---------------------------------------------------------------------
        ; 'S' pressed. "This changes the 'symmetry'. The pattern gets reflected
        ; in various planes, or not at all according to the setting."
        ;---------------------------------------------------------------------
        LDA shiftPressed
        AND #$01
        BEQ b0FF9
        LDA a1EAA
        BNE b0FF9
        ; Shift + S pressed, save.
        JMP PromptToSave
        ; Returns

        ; Just 'S' pressed.
        ; Briefly display the new symmetry setting on the bottom of the screen.
b0FF9   INC currentSymmetrySetting
        LDA currentSymmetrySetting
        CMP #$05
        BNE b1005
        LDA #$00
        STA currentSymmetrySetting
b1005   ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR ClearLastLineOfScreen

        ; currentSymmetrySetting is in Y
        LDX #$00
b100F   LDA txtSymmetrySettingDescriptions,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE b100F

        JMP WriteLastLineBufferToScreen
        ;Returns

b101E   CMP #$2A ; 'L' pressed?
        BNE b1052

        LDA a1EAA
        BNE b1031
        LDA shiftPressed
        AND #$01
        BEQ b1031
        ; Shift + L pressed. Display load message
        JMP DisplayLoadOrAbort

        ;---------------------------------------------------------------------
        ; 'L' pressed. Turn line mode on or off.
        ;---------------------------------------------------------------------
b1031   LDA lineModeActivated
        EOR #$01
        STA lineModeActivated
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 

        ; Briefly display the new linemode setting on the bottom of the screen.
        JSR ClearLastLineOfScreen
        LDX #$00
b1043   LDA lineModeSettingDescriptions,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE b1043
        JMP WriteLastLineBufferToScreen
        ; Returns

b1052   CMP #$12 ; 'D' pressed?
        BNE b105C
        LDA #$01
        STA selectedVariables
        RTS 

b105C   CMP #$14 ; C pressed?
        BNE b1066
        ; C pressed.
        LDA #$02
        STA selectedVariables
        RTS 

b1066   CMP #$1C ; B pressed?
        BNE b1070
        ; B pressed.
        LDA #$03
        STA selectedVariables
        RTS 

b1070   CMP #$29 ; P pressed
        BNE b107A
        ; P pressed.
        LDA #$04
        STA selectedVariables
        RTS 

b107A   CMP #$1D ; H pressed.
        BNE b1088
        ; H pressed.
        LDA #$01
        STA a1A
        LDA #$05
        STA selectedVariables
        RTS 

b1088   CMP #$16 ; T pressed.
        BNE b10B0

        ;"T: Controls whether logic-seeking is used in the buffer or not. The upshot of 
        ; this for you is a slightly different feel - continuous but fragmented when ON,
        ; or together-ish bursts when OFF. "
        LDA trackingActivated
        EOR #$FF
        STA trackingActivated
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR ClearLastLineOfScreen

        LDX #$00
b10A0   LDA txtTrackingOnOff,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE b10A0

        JMP WriteLastLineBufferToScreen
        RTS 

        ; Check if one of the presets has been selected.
b10B0   LDX #$00
b10B2   CMP presetKeyCodes,X
        BEQ b10BF
        INX 
        CPX #$10
        BNE b10B2

        JMP j10C2

b10BF   JMP DisplayPresetMessage

;-------------------------------
; j10C2
;-------------------------------
j10C2    
        CMP #$09 ; W pressed
        BNE b10CC
        LDA #$06
        STA selectedVariables
        RTS 

b10CC   LDX #$00
b10CE   CMP f1797,X
        BEQ b10DB
        INX 
        CPX #$04
        BNE b10CE
        JMP j10EC

b10DB   STX a173B
        LDA sequencerActive
        BNE j10EC
        LDA #$80
        STA selectedVariables
        JSR s173C
        RTS 

;-------------------------------
; j10EC
;-------------------------------
j10EC    
        CMP #$3E
        BNE b1108
        LDA sequencerActive
        BNE b10FD
        LDA #$80
        STA selectedVariables
        JMP j1922

b10FD   LDA #$00
        STA sequencerActive
        STA a19F8
        JMP DisplaySequencerState

b1108   CMP #$1F
        BNE b1112
        LDA #$07
        STA selectedVariables
        RTS 

b1112   CMP #$26
        BNE b111C
        LDA #$08
        STA selectedVariables
        RTS 

b111C   CMP #$31
        BNE b1126
        LDA #$09
        STA selectedVariables
        RTS 

b1126   CMP #$11
        BNE b112D
        JMP j1A4B

b112D   CMP #$36 ; Up arrow
        BNE b1152
        ; Up arrow pressed. "Press UP-ARROW to change the shape of the little pixels on the screen."
        INC pixelShapeIndex
        LDA pixelShapeIndex
        AND #$0F
        TAY 
        LDA pixelShapeArray,Y

        ; Rewrite the screen using the new pixel.
        LDX #$00
b113F   STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02C0,X
        DEX 
        BNE b113F
        STA currentPixel
        RTS 

b1152   CMP #$0A ; 'A' pressed
        BNE b115F
        LDA demoModeActive
        EOR #$01
        STA demoModeActive
        RTS 

b115F   RTS 


a1160
        .BYTE $10
        .BYTE $01,$01,$FF,$FF,$55,$02,$02,$FE    ; $1161:  
        .BYTE $FE,$55,$01,$03,$03,$01,$FF,$FD    ; $1169:  
        .BYTE $FD,$FF,$55,$03,$03,$FD,$FD,$55    ; $1171:  
        .BYTE $04,$04,$FC,$FC,$55,$03,$05,$05    ; $1179:  
        .BYTE $03,$FD,$FB,$FB,$FD,$55,$00,$55    ; $1181:  
        .BYTE $FF,$01,$01,$FF,$55,$FE,$02,$02    ; $1189:  
        .BYTE $FE,$55,$FD,$FF,$01,$03,$03,$01    ; $1191:  
        .BYTE $FF,$FD,$55,$FD,$03,$03,$FD,$55    ; $1199:  
        .BYTE $FC,$04,$04,$FC,$55,$FB,$FD,$03    ; $11A1:  
        .BYTE $05,$05,$03,$FD,$FB,$55,$00,$55    ; $11A9:  
        .BYTE $00,$01,$00,$FF,$55,$00,$02,$00    ; $11B1:  
        .BYTE $FE,$55,$00,$03,$00,$FD,$55,$00    ; $11B9:  
        .BYTE $04,$00,$FC,$55,$00,$05,$00,$FB    ; $11C1:  
        .BYTE $55,$00,$06,$00,$FA,$55,$00,$55    ; $11C9:  
        .BYTE $FF,$00,$01,$00,$55,$FE,$00,$02    ; $11D1:  
        .BYTE $00,$55,$FD,$00,$03,$00,$55,$FC    ; $11D9:  
        .BYTE $00,$04,$00,$55,$FB,$00,$05,$00    ; $11E1:  
        .BYTE $55,$FA,$00,$06,$00,$55,$00        ; $11E9:  
lastLineBufferPtrMinusOne
        .BYTE $55
lastLineBufferPtr
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF
a11F7
        .BYTE $FF
a11F8
        .BYTE $FF    ; $11F1:  
a11F9
        .BYTE $FF
        .BYTE $FF
        .BYTE $FF
        .BYTE $FF
        .BYTE $FF
customPatternValueBufferPtr
        .BYTE $FF
        .BYTE $FF
        .BYTE $FF    ; $11F9:  
f1201
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF    ; $1201:  
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF    ; $1209:  
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00    ; $1211:  


;-------------------------------
; ClearLastLineOfScreen
;-------------------------------
ClearLastLineOfScreen   
        
        LDX #$28
b121B   LDA #$20
        STA lastLineBufferPtrMinusOne,X
        STA SCREEN_RAM + $03BF,X
        DEX 
        BNE b121B
        RTS 

;-------------------------------
; WriteLastLineBufferToScreen
;-------------------------------
WriteLastLineBufferToScreen    
        LDX #$28
b1229   LDA lastLineBufferPtrMinusOne,X
        AND #$3F
        STA SCREEN_RAM + $03BF,X
        LDA #$0C
        STA COLOR_RAM + $03BF,X
        DEX 
        BNE b1229
        RTS 

txtPresetPatternNames
        ; 'STAR ON'
        .BYTE $D3,$D4,$C1,$D2,$A0,$CF,$CE       ; $1239:     
        ; 'E       '
        .BYTE $C5,$A0,$A0,$A0,$A0,$A0,$A0,$A0       ; $1241:     
        ; ' THE TWI'
        .BYTE $A0,$D4,$C8,$C5,$A0,$D4,$D7,$C9       ; $1249:     
        ; 'ST      '
        .BYTE $D3,$D4,$A0,$A0,$A0,$A0,$A0,$A0       ; $1251:     
        ; ' LA LLAM'
        .BYTE $A0,$CC,$C1,$A0,$CC,$CC,$C1,$CD       ; $1259:     
        ; 'ITA     '
        .BYTE $C9,$D4,$C1,$A0,$A0,$A0,$A0,$A0       ; $1261:     
        ; ' STAR TW'
        .BYTE $A0,$D3,$D4,$C1,$D2,$A0,$D4,$D7       ; $1269:     
        ; 'O       '
        .BYTE $CF,$A0,$A0,$A0,$A0,$A0,$A0,$A0       ; $1271:     
        ; ' DELTOID'
        .BYTE $A0,$C4,$C5,$CC,$D4,$CF,$C9,$C4       ; $1279:     
        ; 'S       '
        .BYTE $D3,$A0,$A0,$A0,$A0,$A0,$A0,$A0       ; $1281:     
        ; ' DIFFUSE'
        .BYTE $A0,$C4,$C9,$C6,$C6,$D5,$D3,$C5       ; $1289:     
        ; 'D       '
        .BYTE $C4,$A0,$A0,$A0,$A0,$A0,$A0,$A0       ; $1291:     
        ; ' MULTICR'
        .BYTE $A0,$CD,$D5,$CC,$D4,$C9,$C3,$D2       ; $1299:     
        ; 'OSS     '
        .BYTE $CF,$D3,$D3,$A0,$A0,$A0,$A0,$A0       ; $12A1:     
        ; ' PULSAR '
        .BYTE $A0,$D0,$D5,$CC,$D3,$C1,$D2,$A0       ; $12A9:     
        ; '        '
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0       ; $12B1:     
        ; ' '
        .BYTE $A0
txtSymmetrySettingDescriptions 
        ; 'NO SYMM'
        .BYTE $CE,$CF,$A0,$D3,$D9,$CD,$CD       ; $12B9:     
        ; 'ETRY    '
        .BYTE $C5,$D4,$D2,$D9,$A0,$A0,$A0,$A0       ; $12C1:     
        ; ' Y­AXIS '
        .BYTE $A0,$D9,$AD,$C1,$D8,$C9,$D3,$A0       ; $12C9:     
        ; 'SYMMETRY'
        .BYTE $D3,$D9,$CD,$CD,$C5,$D4,$D2,$D9       ; $12D1:     
        ; ' X­Y SYM'
        .BYTE $A0,$D8,$AD,$D9,$A0,$D3,$D9,$CD       ; $12D9:     
        ; 'METRY   '
        .BYTE $CD,$C5,$D4,$D2,$D9,$A0,$A0,$A0       ; $12E1:     
        ; ' X­AXIS '
        .BYTE $A0,$D8,$AD,$C1,$D8,$C9,$D3,$A0       ; $12E9:     
        ; 'SYMMETRY'
        .BYTE $D3,$D9,$CD,$CD,$C5,$D4,$D2,$D9       ; $12F1:     
        ; ' QUAD SY'
        .BYTE $A0,$D1,$D5,$C1,$C4,$A0,$D3,$D9       ; $12F9:     
        ; 'MMETRY  '
        .BYTE $CD,$CD,$C5,$D4,$D2,$D9,$A0,$A0       ; $1301:     
        ; ' '
        .BYTE $A0

;-------------------------------
; j130A
;-------------------------------
j130A 
        LDA a04
        AND #$7F
        STA a16
        LDA #$19
        SEC 
        SBC a16
        STA a03
        DEC a03
        LDA #$00
        STA a04
        LDA #$01
        STA a17
        JSR s09D4
        INC a03
        LDA #$00
        STA a17
        LDA a0E44
        EOR #$07
        STA a04
b1331   JSR s09D4
        INC a03
        INC a04
        LDA a04
        CMP #$08
        BNE b1343
        JMP j134B

        INC a04
b1343   STA a04
        LDA a03
        CMP #$19
        BNE b1331
;-------------------------------
; j134B
;-------------------------------
j134B    
        LDX a0CBB
        DEC f0AB6,X
        LDA f0AB6,X
        CMP #$80
        BEQ b135B
        JMP j0C39

b135B   LDA #$FF
        STA f0AB6,X
        STX a13
        JMP j0C39

lineModeSettingDescriptions
        ; 'LINE MOD'
        .BYTE $CC,$C9,$CE,$C5,$A0,$CD,$CF,$C4
        ; 'Eº OFF  '
        .BYTE $C5,$BA,$A0,$CF,$C6,$C6,$A0,$A0
        ; 'LINE MOD'
        .BYTE $CC,$C9,$CE,$C5,$A0,$CD,$CF,$C4
        ; 'Eº ON   '
        .BYTE $C5,$BA,$A0,$CF,$CE,$A0,$A0,$A0
;-------------------------------
; j1385
;-------------------------------
j1385   LDA a19
        PHA 
        CLC 
        ADC #$D4
        STA a19

        LDY #$00
b138F   LDA f15D3,Y
        STA (p18),Y
        INY 
        CPY #$10
        BNE b138F

        PLA 
        STA a19
        LDA #$00
        STA a13DA
        STA a13DC
        STA a13DD
        LDA a13DB
        BEQ b13D8
b13AC   LDA a13DD
        CLC 
        ADC a13D9
        STA a13DD
        LDX a13DD
        LDY a13DA
        LDA f13DE,X
        STA (p18),Y
        CPX #$08
        BNE b13CD
        LDA #$00
        STA a13DD
        INC a13DA
b13CD   INC a13DC
        LDA a13DC
        CMP a13DB
        BNE b13AC
b13D8   RTS 

a13DA   =*+$01
a13DB   =*+$02
a13D9   .BYTE $FF,$FF,$FF
a13DD   =*+$01
f13DE   =*+$02
a13DC   .BYTE $FF,$FF,$20
        .BYTE $65,$74
        ; 'ÕÁ¶ª§ '
        .BYTE $75,$61,$F6,$EA,$E7,$A0

b13E7   LDA #$00
        STA selectedVariables
        RTS 

;-------------------------------
; j13ED
;-------------------------------
j13ED    
        AND #$80
        BEQ b13F4
        JMP j179D

b13F4   LDA a12
        BEQ b13FD
        DEC a12
        JMP DisplayVariableSelection

b13FD   LDA lastKeyPressed
        CMP #$40
        BNE b1406
        JMP DisplayVariableSelection

b1406   LDA #$04
        STA a12
        LDA selectedVariables
        CMP #$05
        BEQ b1415
        CMP #$03
        BNE b143F
b1415   LDX #$00
b1417   LDA f0AB6,X
        CMP #$FF
        BNE b13E7
        INX 
        CPX a0E41
        BNE b1417
        LDA a19F8
        BNE b13E7
        LDA playbackOrRecordActive
        CMP #$02
        BEQ b13E7
        LDA demoModeActive
        BNE b13E7

        LDA #$FF
        STA a171E
        LDA #$00
        STA a0E3B
b143F   LDA #>SCREEN_RAM + $03D0
        STA a19
        LDA #<SCREEN_RAM + $03D0
        STA a18
        LDX selectedVariables
        LDA lastKeyPressed
        CMP #$2C
        BNE b1461
        INC f0E3E,X
        LDA f0E3E,X
        CMP f1512,X
        BNE b1473
        DEC f0E3E,X
        JMP b1473

b1461   CMP #$2F
        BNE b1473
        DEC f0E3E,X
        LDA f0E3E,X
        CMP f151C,X
        BNE b1473
        INC f0E3E,X
b1473   CPX #$05
        BNE b1482
        LDX a0E43
        LDY a1A
        LDA f15D2,X
        STA f0E48,Y
b1482   JSR DisplayVariableSelection
        JMP j14F2

;-------------------------------
; DisplayVariableSelection
;-------------------------------
DisplayVariableSelection    
        LDA #>SCREEN_RAM + $03D0
        STA a19
        LDA #<SCREEN_RAM + $03D0
        STA a18
        LDX selectedVariables
        CPX #$05
        BNE b14AE
        LDX a1A
        LDA f0E48,X
        LDY #$00
b149E   CMP f15D2,Y
        BEQ b14A8
        INY 
        CPY #$10
        BNE b149E
b14A8   STY a0E43
        LDX selectedVariables
b14AE   LDA f1526,X
        STA a13D9
        LDA f0E3E,X
        STA a13DB
        TXA 
        PHA 
        LDA a173A
        BNE b14C9
        LDA #$01
        STA a173A
        JSR ClearLastLineOfScreen
b14C9   PLA 
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        LDX #$00
b14D1   LDA txtVariableLabels,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE b14D1
        LDA selectedVariables
        CMP #$05
        BNE b14EC
        LDA #$30
        CLC 
        ADC a1A
        STA a11F8
b14EC   JSR WriteLastLineBufferToScreen
        JMP j1385

;-------------------------------
; j14F2
;-------------------------------
j14F2    
        LDA lastKeyPressed
        CMP #$01
        BEQ b14F9
        RTS 

b14F9   LDA selectedVariables
        CMP #$05
        BNE b1509
        INC a1A
        LDA a1A
        CMP #$08
        BEQ b1509
        RTS 

b1509   LDA #$00
        STA selectedVariables
        STA a173A
        RTS 


f1512   
        .BYTE $00,$40,$08,$40,$10,$10,$08        ; $1511:   
        .BYTE $20,$10,$08
f151C   
        .BYTE $00,$00,$00,$00,$00        ; $1519:   

        .BYTE $00,$00,$00,$00,$00
f1526   
        .BYTE $00,$01,$08        ; $1521:   
        .BYTE $01,$04,$08,$08,$02,$04,$08
selectedVariables   
        .BYTE $00        ; $1529:   
a1531   
        .BYTE $01
txtVariableLabels   
        ; '       '
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0        ; $1531:   
        ; '        '
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0        ; $1539:   
        ; ' SMOOTHI'
        .BYTE $A0,$D3,$CD,$CF,$CF,$D4,$C8,$C9        ; $1541:   
        ; 'NG DELAY'
        .BYTE $CE,$C7,$A0,$C4,$C5,$CC,$C1,$D9        ; $1549:   
        ; 'ºCURSOR '
        .BYTE $BA,$C3,$D5,$D2,$D3,$CF,$D2,$A0        ; $1551:   
        ; 'SPEED   '
        .BYTE $D3,$D0,$C5,$C5,$C4,$A0,$A0,$A0        ; $1559:   
        ; 'ºBUFFER '
        .BYTE $BA,$C2,$D5,$C6,$C6,$C5,$D2,$A0        ; $1561:   
        ; 'LENGTH  '
        .BYTE $CC,$C5,$CE,$C7,$D4,$C8,$A0,$A0        ; $1569:   
        ; 'ºPULSE S'
        .BYTE $BA,$D0,$D5,$CC,$D3,$C5,$A0,$D3        ; $1571:   
        ; 'PEED    '
        .BYTE $D0,$C5,$C5,$C4,$A0,$A0,$A0,$A0        ; $1579:   
        ; 'ºCOLOUR '
        .BYTE $BA,$C3,$CF,$CC,$CF,$D5,$D2,$A0        ; $1581:   
        ; '° SET   '
        .BYTE $B0,$A0,$D3,$C5,$D4,$A0,$A0,$A0        ; $1589:   
        ; 'ºWIDTH O'
        .BYTE $BA,$D7,$C9,$C4,$D4,$C8,$A0,$CF        ; $1591:   
        ; 'F LINE  '
        .BYTE $C6,$A0,$CC,$C9,$CE,$C5,$A0,$A0        ; $1599:   
        ; 'ºSEQUENC'
        .BYTE $BA,$D3,$C5,$D1,$D5,$C5,$CE,$C3        ; $15A1:   
        ; 'ER SPEED'
        .BYTE $C5,$D2,$A0,$D3,$D0,$C5,$C5,$C4        ; $15A9:   
        ; 'ºPULSE W'
        .BYTE $BA,$D0,$D5,$CC,$D3,$C5,$A0,$D7        ; $15B1:   
        ; 'IDTH    '
        .BYTE $C9,$C4,$D4,$C8,$A0,$A0,$A0,$A0        ; $15B9:   
        ; 'ºBASE LE'
        .BYTE $BA,$C2,$C1,$D3,$C5,$A0,$CC,$C5        ; $15C1:   
        ; 'VEL     '
        .BYTE $D6,$C5,$CC,$A0,$A0,$A0,$A0,$A0        ; $15C9:   
        .BYTE $BA
f15D2   
        .BYTE $00
f15D3   
        .BYTE $06,$02,$04,$05,$03,$07        ; $15D1:   
        .BYTE $01,$08,$09,$0A,$0B,$0C,$0D,$0E        ; $15D9:   
        .BYTE $0F
txtTrackingOnOff   
        ; 'TRACKIN'
        .BYTE $D4,$D2,$C1,$C3,$CB,$C9,$CE        ; $15E1:   
        ; 'Gº OFF  '
        .BYTE $C7,$BA,$A0,$CF,$C6,$C6,$A0,$A0        ; $15E9:   
        ; ' TRACKIN'
        .BYTE $A0,$D4,$D2,$C1,$C3,$CB,$C9,$CE        ; $15F1:   
        ; 'Gº ON   '
        .BYTE $C7,$BA,$A0,$CF,$CE,$A0,$A0,$A0        ; $15F9:   
        ; ' '
        .BYTE $A0


;-------------------------------
; DisplayPresetMessage
;-------------------------------
DisplayPresetMessage    
        LDA shiftPressed
        AND #$04
        BEQ b160C
        JMP j1C05

b160C   TXA 
        PHA 
        JSR ClearLastLineOfScreen
        LDX #$00
b1613   LDA txtPreset,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$10
        BNE b1613

        PLA 
        PHA 
        TAX 
        BEQ b1638
b1623   INC a11F9
        LDA a11F9
        CMP #$BA
        BNE b1635
        LDA #$30
        STA a11F9
        INC a11F8
b1635   DEX 
        BNE b1623
b1638   JMP j1670

j163B    
        JSR WriteLastLineBufferToScreen
        RTS 

txtPreset
        ; 'PR'
        .BYTE $D0,$D2      ; $1639:       
        ; 'ESET °° '
        .BYTE $C5,$D3,$C5,$D4,$A0,$B0,$B0,$A0      ; $1641:       
        ; '     º'
        .BYTE $A0,$A0,$A0,$A0,$A0,$BA
txtPresetActivatedStored
        ; ' A'
        .BYTE $A0,$C1      ; $1649:       
        ; 'CTIVATED'
        .BYTE $C3,$D4,$C9,$D6,$C1,$D4,$C5,$C4      ; $1651:       
        ; '       D'
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$C4
        ; 'ATA STOR'
        .BYTE $C1,$D4,$C1,$A0,$D3,$D4,$CF,$D2
        ; 'ED    '
        .BYTE $C5,$C4,$A0,$A0,$A0,$A0
shiftPressed
        .BYTE $00

;-------------------------------
; j1670
;-------------------------------
j1670    
        LDA shiftPressed
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 

        LDX #$00
b167C   LDA txtPresetActivatedStored,Y
        STA f1201,X
        INY 
        INX 
        CPX #$10
        BNE b167C

        LDA shiftPressed
        AND #$01
        BNE b1692
        JMP j16B2

b1692   PLA 
        TAX 
        JSR s16F7
        LDY #$00
        LDX #$00
b169B   LDA f0E3E,X
        STA (p1B),Y
        INY 
        INX 
        CPX #$15
        BNE b169B
        LDA currentPatternElement
        STA (p1B),Y
        INY 
        LDA currentSymmetrySetting
        STA (p1B),Y
        JMP j163B

;-------------------------------
; j16B2
;-------------------------------
j16B2    
        PLA 
        TAX 
        JSR s16F7
        LDY #$03
        LDA (p1B),Y
        CMP a0E41
        BEQ b16C6
        JSR s1713
        JMP j16DA

b16C6   LDX #$00
        LDY #$07
b16CA   LDA (p1B),Y
        CMP f0E48,X
        BNE j16DA
        INY 
        INX 
        CPX #$08
        BNE b16CA
        JMP j16DA

;-------------------------------
; j16DA
;-------------------------------
j16DA    
        LDA #$FF
        STA a171E
        LDY #$00
b16E1   LDA (p1B),Y
        STA f0E3E,Y
        INY 
        CPY #$15
        BNE b16E1
        LDA (p1B),Y
        STA currentPatternElement
        INY 
        LDA (p1B),Y
        STA currentSymmetrySetting
        JMP j163B

;-------------------------------
; s16F7
;-------------------------------
s16F7   
        LDA #>pC000
        STA a1C
        LDA #<pC000
        STA a1B
        TXA 
        BEQ b1712
b1702   LDA a1B
        CLC 
        ADC #$20
        STA a1B
        LDA a1C
        ADC #$00
        STA a1C
        DEX 
        BNE b1702
b1712   RTS 

;-------------------------------
; s1713
;-------------------------------
s1713   
        LDA #$FF
        STA a171E
        LDA #$00
        STA a0E3B
        RTS 

a171E  .BYTE $00
;-------------------------------
; s171F
;-------------------------------
s171F
        LDA #$00
        STA a0CBB
        STA a13

        LDX #$00
        LDA #$FF
b172a   STA $0AB6,X
        INX
        CPX #$40
        BNE b172A

        LDA #$00
        STA a171E
        JMP InitializeScreenWithInitCharacter

a173A   .BYTE $00
a173B   .BYTE $00

;-------------------------------
; s173C
;-------------------------------
s173C   
        JSR ClearLastLineOfScreen
        LDA shiftPressed
        AND #$01
        BEQ b1756
        LDX #$00
b1748   LDA f1787,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$10
        BNE b1748
        JSR WriteLastLineBufferToScreen
b1756   LDA #$C2
        STA a1E
        LDX a173B
        LDA f1783,X
        STA a1D
        LDA shiftPressed
        AND #$01
        BEQ b177B
        LDA #$10
        STA a179B
        LDY #$00
        LDA currentSymmetrySetting
        STA (p1D),Y
        LDA a0E3F
        INY 
        STA (p1D),Y
        RTS 

b177B   LDA #$FF
        STA sequencerActive
        JMP j1898

f1783   BRK #$20
        RTI 

        RTS 

f1787
        ; 'DA'
        .BYTE $C4,$C1                             ; $1781:   
        ; 'TAº °°° '
        .BYTE $D4,$C1,$BA,$A0,$B0,$B0,$B0,$A0     ; $1789:   
        ; 'FREE  '
        .BYTE $C6,$D2,$C5,$C5,$A0,$A0
f1797
        .BYTE $04,$05     ; $1791:   
        .BYTE $06,$03

a179B   .BYTE $FF,$60

;-------------------------------
; j179D
;-------------------------------
j179D 
        LDA selectedVariables
        CMP #$83
        BNE b17A7
        JMP j1C90

b17A7   CMP #$84
        BNE b17AE
        JMP j1E6C

b17AE   CMP #$85
        BNE b17B5
        JMP j1ED1

b17B5   LDA #$30
        STA a11F7
        STA a11F8
        STA a11F9
        LDX a179B
        BNE b17C8
        JMP j186C

b17C8   INC a11F9
        LDA a11F9
        CMP #$3A
        BNE b17E9
        LDA #$30
        STA a11F9
        INC a11F8
        LDA a11F8
        CMP #$3A
        BNE b17E9
        LDA #$30
        STA a11F8
        INC a11F7
b17E9   DEX 
        BNE b17C8
        JSR s1885
        LDA a1884
        BEQ b1801
        LDA lastKeyPressed
        CMP #$40
        BEQ b17FB
        RTS 

b17FB   LDA #$00
        STA a1884
b1800   RTS 

b1801   LDA lastKeyPressed
        CMP #$40
        BEQ b1800
        LDX #$01
        STX a1884
        CMP #$39
        BEQ b183D
        CMP #$01
        BEQ j186C
        CMP #$3C
        BNE b183C
        JSR s1885
        LDA a179B
        STA a1A47
        LDA a1D
        STA a1A48
        LDA a1E
        STA a1A49
        LDA #$00
        STA selectedVariables
        STA a1884
        STA sequencerActive
        LDY #$02
        LDA #$FF
        STA (p1D),Y
b183C   RTS 

b183D   LDY #$02
        LDA shiftKey
        AND #$01
        BEQ b184B
        LDA #$C0
f1848   JMP j184E

b184B   LDA a0E39
;-------------------------------
; j184E
;-------------------------------
j184E    
        STA (p1D),Y
        LDA jumpTableIndex
        INY 
        STA (p1D),Y
        LDA currentPatternElement
        INY 
        STA (p1D),Y
        LDA a1D
        CLC 
        ADC #$03
        STA a1D
        LDA a1E
        ADC #$00
        STA a1E
        DEC a179B
        RTS 

;-------------------------------
; j186C
;-------------------------------
j186C    
        JSR s1885
        LDA #$FF
        LDY #$02
        STA (p1D),Y
        LDA #$00
        STA selectedVariables
        STA a1884
        STA a1A47
        STA sequencerActive
        RTS 

a1884   .BYTE $00
;-------------------------------
; s1885
;-------------------------------
s1885
        LDA a11F7
        STA a07C6
        LDA a11F8
        STA a07C7
        LDA a11F9
        STA a07C8
        RTS 

;-------------------------------
; j1898
;-------------------------------
j1898    
        LDA #$00
        STA selectedVariables
        TAY 
        LDA (p1D),Y
        STA a1920
        INY 
        LDA (p1D),Y
        STA a191F
;-------------------------------
; j18A9
;-------------------------------
j18A9    
        LDY #$02
        INC a0E3B
        LDA a0E3B
        CMP a0E41
        BNE b18BB
        LDA #$00
        STA a0E3B
b18BB   LDX a0E3B
        LDA f0AB6,X
        CMP #$FF
        BEQ b18D7
        LDA a13
        AND trackingActivated
        BEQ b1901
        STA a0E3B
        TAX 
        LDA f0AB6,X
        CMP #$FF
        BNE b1901
b18D7   LDA a0E47
        STA f0AB6,X
        LDA (p1D),Y
        CMP #$C0
        BEQ b1901
        STA f0A36,X
        INY 
        LDA (p1D),Y
        STA f0A76,X
        INY 
        LDA (p1D),Y
        STA f0B76,X
        LDA a191F
        STA f0AF6,X
        STA f0B36,X
        LDA a1920
        STA f0BB6,X
b1901   LDA a1D
        CLC 
        ADC #$03
        STA a1D
        LDA a1E
        ADC #$00
        STA a1E
        LDY #$02
        LDA (p1D),Y
        CMP #$FF
        BEQ b1919
        JMP j18A9

b1919   LDA #$00
        STA sequencerActive
        RTS 

a191F   .BYTE $00
a1920   .BYTE $00
sequencerActive   .BYTE $00
;-------------------------------
; j1922
;-------------------------------
j1922 
        LDA #$C3
        STA a1E
        LDA #$00
        STA a1D
        LDA #$FF
        STA sequencerActive
        LDA shiftPressed
        AND #$01
        BNE b1945
        LDA a0E45
        STA a19F8
        LDA #$00
        STA selectedVariables
        JSR DisplaySequencerState
        RTS 

b1945   LDA a1A47
        BEQ b195D
        LDA a1A47
        STA a179B
        LDA a1A48
        STA a1D
        LDA a1A49
        STA a1E
        JMP j196E

b195D   LDA #$FF
        STA a179B
        LDA currentSymmetrySetting
        LDY #$00
        STA (p1D),Y
        LDA a0E3F
        INY 
        STA (p1D),Y
;-------------------------------
; j196E
;-------------------------------
j196E    
        JSR ClearLastLineOfScreen
        LDX #$00
b1973   LDA f19F9,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$10
        BNE b1973
        JSR WriteLastLineBufferToScreen
        RTS 

;-------------------------------
; s1982
;-------------------------------
s1982   
        INC a0E3B
        LDA a0E3B
        CMP a0E41
        BNE b1992
        LDA #$00
        STA a0E3B
b1992   TAX 
        LDA f0AB6,X
        CMP #$FF
        BEQ b19A9
        LDA a13
        AND trackingActivated
        BEQ b19D9
        TAX 
        LDA f0AB6,X
        CMP #$FF
        BNE b19D9
b19A9   LDY #$02
        LDA (p1D),Y
        CMP #$C0
        BEQ b19D9
        LDA a0E47
        STA f0AB6,X
        LDA aC301
        STA f0AF6,X
        STA f0B36,X
        LDA aC300
        STA f0BB6,X
        LDY #$02
        LDA (p1D),Y
        STA f0A36,X
        INY 
        LDA (p1D),Y
        STA f0A76,X
        INY 
        LDA (p1D),Y
        STA f0B76,X
b19D9   LDA a1D
        CLC 
        ADC #$03
        STA a1D
        LDA a1E
        ADC #$00
        STA a1E
        LDY #$02
        LDA (p1D),Y
        CMP #$FF
        BEQ b19EF
        RTS 

b19EF   LDA #<aC300
        STA a1D
        LDA #>aC300
        STA a1E
        RTS 

a19F8   .BYTE $00
f19F9
        ; 'SEQUº °°'
        .BYTE $D3,$C5,$D1,$D5,$BA,$A0,$B0,$B0
        ; '° FREE  '
        .BYTE $B0,$A0,$C6,$D2,$C5,$C5,$A0,$A0

;-------------------------------
; DisplaySequencerState
;-------------------------------
DisplaySequencerState    
        LDA sequencerActive
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR ClearLastLineOfScreen
        LDX #$00
b1A18   LDA txtSequencer,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE b1A18
        JMP WriteLastLineBufferToScreen

txtSequencer
      ; 'SE'
      .BYTE $D3,$C5       ; $1A21:               
      ; 'QUENCER '
      .BYTE $D1,$D5,$C5,$CE,$C3,$C5,$D2,$A0       ; $1A29:               
      ; 'OFF   SE'
      .BYTE $CF,$C6,$C6,$A0,$A0,$A0,$D3,$C5       ; $1A31:               
      ; 'QUENCER '
      .BYTE $D1,$D5,$C5,$CE,$C3,$C5,$D2,$A0     ; $1A39:       
      ; 'ON    '
      .BYTE $CF,$CE,$A0,$A0,$A0,$A0
a1A47
      .BYTE $00
a1A48
      .BYTE $00
a1A49
      .BYTE $00
a1A4A
      .BYTE $00

;-------------------------------
; j1A4B
;-------------------------------
j1A4B    
        LDA #>dynamicStorage
        STA a20
        LDA #<dynamicStorage
        STA a1F
        LDA #$01
        STA a1BE7
        LDA shiftPressed
        AND #$01
        STA shiftPressed
        LDA playbackOrRecordActive
        ORA shiftPressed
        EOR #$02
        STA playbackOrRecordActive
        AND #$02
        BNE b1A72
        JMP DisplayStoppedRecording

b1A72   LDA playbackOrRecordActive
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 
        JSR ClearLastLineOfScreen
        LDX #$00
b1A81   LDA txtPlayBackRecord,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE b1A81

        JSR WriteLastLineBufferToScreen
        LDA playbackOrRecordActive
        CMP #$03
        BNE b1AC5

;-------------------------------
; InitializeDynamicStorage
;-------------------------------
InitializeDynamicStorage   
        LDA #<dynamicStorage
        STA aFB
        LDA #>dynamicStorage
        STA aFC
        LDY #$00
        TYA 

        LDX #$50
b1AA4   STA (pFB),Y
        DEY 
        BNE b1AA4
        INC aFC
        DEX 
b1AAC   BNE b1AA4

        LDA #<p01FF
        STA dynamicStorage
        LDA #>p01FF
        STA a3001
        LDA a0E39
        STA a1BE8
        LDA jumpTableIndex
        STA a1BE9
        RTS 

b1AC5   LDA #$00
        STA a0C
        JSR UpdateJumpTable
        LDA a1BE8
        STA a0E39
        LDA a1BE9
        STA jumpTableIndex
        LDA #$FF
        STA a1BEB
        RTS 

txtPlayBackRecord
        ; 'PLA'
        .BYTE $D0,$CC,$C1       ; $1AD9:         
        ; 'YING BAC'
        .BYTE $D9,$C9,$CE,$C7,$A0,$C2,$C1,$C3       ; $1AE1:         
        ; 'K®®®®REC'
        .BYTE $CB,$AE,$AE,$AE,$AE,$D2,$C5,$C3       ; $1AE9:         
        ; 'ORDING®®'
        .BYTE $CF,$D2,$C4,$C9,$CE,$C7,$AE,$AE       ; $1AF1:         
        ; '®®®®®'
        .BYTE $AE,$AE,$AE,$AE,$AE

;-------------------------------
; DisplayStoppedRecording
;-------------------------------
DisplayStoppedRecording    
        LDA #$00
        STA playbackOrRecordActive
        STA $D020    ;Border Color
        STA a1BEB
        TAY 
        JSR ClearLastLineOfScreen
b1B0D   LDA f1B1B,Y
        STA lastLineBufferPtr,Y
        INY 
        CPY #$10
        BNE b1B0D
        JMP WriteLastLineBufferToScreen
        ; Returns

f1B1B
        ; 'STOPPE'
        .BYTE $D3,$D4,$CF,$D0,$D0,$C5    ; $1B19:     
        ; 'D       '
        .BYTE $C4,$A0,$A0,$A0,$A0,$A0,$A0,$A0    ; $1B21:     
        ; '  '
        .BYTE $A0,$A0
playbackOrRecordActive
        .BYTE $00

;-------------------------------
; j1B2C
;-------------------------------
j1B2C    
        LDA $DC00    ;CIA1: Data Port Register A
        STA lastJoystickInput
        LDY #$00
        CMP (p1F),Y
        BEQ b1B70
b1B37   LDA a1F
        CLC 
        ADC #$02
        STA a1F
        LDA a20
        ADC #$00
        STA a20
        CMP #$80
        BNE b1B50
        LDA #$00
        STA a7FFF
        JMP DisplayStoppedRecording

b1B50   LDY #$01
        TYA 
        STA (p1F),Y
        LDA $DC00    ;CIA1: Data Port Register A
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
        LDA f15D3,X
        STA $D020    ;Border Color
        RTS 

b1B70   INY 
        LDA (p1F),Y
        CLC 
        ADC #$01
        STA (p1F),Y
        CMP #$FF
        BEQ b1B37
        RTS 

;-------------------------------
; GetJoystickInput
;-------------------------------
GetJoystickInput   
        LDA playbackOrRecordActive
        BEQ b1B8C
        CMP #$03
        BNE b1B89
        JMP j1B2C

b1B89   JMP j1B9A

b1B8C   LDA demoModeActive
        BEQ b1B94
        JMP j1F27

b1B94   LDA $DC00    ;CIA1: Data Port Register A
        STA lastJoystickInput
        RTS 

j1B9A    
        DEC a1BE7
        BEQ b1BA6
        LDY #$00
        LDA (p1F),Y
        STA lastJoystickInput
        RTS 

b1BA6   LDA a1F
        CLC 
        ADC #$02
        STA a1F
        LDA a20
        ADC #$00
        STA a20
        CMP #$80
        BEQ b1BC6
        LDY #$01
        LDA (p1F),Y
        BEQ b1BC6
        STA a1BE7
        DEY 
        LDA (p1F),Y
        STA lastJoystickInput
        RTS 

b1BC6   LDA #>dynamicStorage
        STA a20
        LDA #<dynamicStorage
        STA a1F
        LDA #$01
        STA a1BE7
        LDA #$00
        STA a0C
        JSR UpdateJumpTable
        LDA a1BE8
        STA a0E39
        LDA a1BE9
        STA jumpTableIndex
        RTS 

a1BE7
        .BYTE $00
a1BE8
        .BYTE $0C   ; $1BE1:           
a1BE9
        .BYTE $0C
a1BEA
        .BYTE $00
a1BEB
        .BYTE $00
f1BEC
        ; 'DEFIN'
        .BYTE $C4,$C5,$C6,$C9,$CE   ; $1BE9:           
        ; 'E ALL LE'
        .BYTE $C5,$A0,$C1,$CC,$CC,$A0,$CC,$C5   ; $1BF1:           
        ; 'VEL ² PI'
        .BYTE $D6,$C5,$CC,$A0,$B2,$A0,$D0,$C9   ; $1BF9:           
        ; 'XELS'
        .BYTE $D8,$C5,$CC,$D3

;-------------------------------
; j1C05
;-------------------------------
j1C05 
        TXA
        AND #$08
        BEQ b1C0B
        RTS 

b1C0B   LDA #$83
        STA selectedVariables
        LDA #$00
        STA a22
        STA a1BEB
        LDA f0E6B,X
        STA a23
        TXA 
        CLC 
        ADC #$08
        STA a1BEA
        JSR ClearLastLineOfScreen
        LDX #$00
b1C28   LDA f1BEC,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$19
        BNE b1C28
        JSR WriteLastLineBufferToScreen
        LDA #$06
        STA a25
        LDY #$00
        TYA 
        STA (p22),Y
        INY 
        LDA #$55
        STA (p22),Y
        LDY #$81
        STA (p22),Y
        DEY 
        LDA #$00
        STA (p22),Y
        LDA #$07
        STA a24
        LDA #$01
        STA a26
        LDA #$17
        STA a171E
        RTS 

;-------------------------------
; j1C5B
;-------------------------------
j1C5B    
        LDA #<p0C13
        STA a0E39
        LDA #>p0C13
        STA jumpTableIndex
        JSR s171F
b1C68   LDA a1BEA
        STA a0E52
        LDA a25
        STA a04
        LDA #$00
        STA a14
        LDA #<p0C13
        STA a02
        LDA #>p0C13
        STA a03
        JSR s0915
        LDA a25
        BNE b1C68
        JSR s171F
        LDA #$00
        STA a171E
        JMP j0C39

;-------------------------------
; j1C90
;-------------------------------
j1C90    
        LDA a1884
        BEQ b1CA2
        LDA lastKeyPressed
        CMP #$40
        BEQ b1C9C
        RTS 

b1C9C   LDA #$00
        STA a1884
b1CA1   RTS 

b1CA2   LDA lastKeyPressed
        CMP #$40
        BEQ b1CA1
        LDA #$FF
        STA a1884
        LDA lastKeyPressed
        CMP #$01
        BEQ b1CB6
        JMP j1CEF

b1CB6   INC a26
        LDA #$00
        LDY a26
        STA (p22),Y
        PHA 
        TYA 
        CLC 
        ADC #$80
        TAY 
        PLA 
        STA (p22),Y
        INY 
        LDA #$55
        STA (p22),Y
        LDY a26
        INY 
        STA (p22),Y
        STY a26
        LDA #$07
        STA a24
        DEC a25
        BEQ b1CE6
        LDA a25
        EOR #$07
        CLC 
        ADC #$31
        STA a07D1
        RTS 

b1CE6   LDA #$00
        STA selectedVariables
        JSR ClearLastLineOfScreen
b1CEE   RTS 

;-------------------------------
; j1CEF
;-------------------------------
j1CEF    
        CMP #$39
        BNE b1CEE
        LDY a26
        LDA a0E39
        SEC 
        SBC #$13
        STA (p22),Y
        INY 
        LDA #$55
        STA (p22),Y
        STY a26
        TYA 
        CLC 
        ADC #$7F
        TAY 
        LDA jumpTableIndex
        SEC 
b1D0D   SBC #$0C
        STA (p22),Y
        INY 
        LDA #$55
        STA (p22),Y
        DEC a24
        BEQ b1D1B
        RTS 

b1D1B   JMP b1CB6

;-------------------------------
; GetCustomPatternElement
;-------------------------------
GetCustomPatternElement    
        JSR ClearLastLineOfScreen

        LDX #$00
b1D23   LDA txtCustomPatterns,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$0E
        BNE b1D23

        LDA currentPatternElement
        AND #$07
        CLC 
        ADC #$30
        STA customPatternValueBufferPtr
        JMP WriteLastLineBufferToScreen
        ; Returns

txtCustomPatterns
        ; 'USER S'
        .BYTE $D5,$D3,$C5,$D2,$A0,$D3      ; $1D39:   
        ; 'HAPE £°'
        .BYTE $C8,$C1,$D0,$C5,$A0,$A3,$B0
pixelShapeIndex
        .BYTE $00      ; $1D41:   
pixelShapeArray
        .BYTE $CF,$51,$53,$5A,$5B,$5F,$57,$7F      ; $1D49:   
        .BYTE $56,$61,$4F,$66,$6C,$EC,$A0,$2A      ; $1D51:   
        .BYTE $47,$4F,$41,$54,$53,$53,$48,$45      ; $1D59:   
        .BYTE $45,$50

;-------------------------------
; j1D63
;-------------------------------
j1D63 
        LDA #$13
        JSR $FFD2
        LDA #$FF
        STA a1BEB
        JSR InitializeScreenWithInitCharacter
b1D70   LDA a1EAA
        BEQ b1D70
        CMP #$01
        BNE b1DA4
        LDA #$01
        LDX #$01
        LDY #$01
        JSR ROM_SETLFS ;$FFBA - set file parameters              
        LDA #$05
        LDX #$59
        LDY #$1D
        JSR ROM_SETNAM ;$FFBD - set file name                    
        LDA #$01
        STA a0286
        LDA #>pC000
        STA aFF
        LDA #<pC000
        STA aFE
        LDX #$FF
        LDY #$CF
        LDA #$FE
        JSR ROM_SAVE ;$FFD8 - save after call SETLFS,SETNAM    
        JMP j1E08

b1DA4   CMP #$02
        BNE b1DE6
        LDA #$01
        LDX #$01
        LDY #$01
        JSR ROM_SETLFS ;$FFBA - set file parameters              
        LDA #$05
        LDX #$5E
        LDY #$1D
        JSR ROM_SETNAM ;$FFBD - set file name                    
        LDA #$01
        STA a0286
        LDA #$30
        STA aFF
        STA aFC
        LDA #$00
        STA aFE
        STA aFB
        LDY #$00
b1DCD   LDA (pFB),Y
        BEQ b1DDA
        INC aFB
        BNE b1DCD
        INC aFC
        JMP b1DCD

b1DDA   LDX aFB
        LDY aFC
        LDA #$FE
        JSR ROM_SAVE ;$FFD8 - save after call SETLFS,SETNAM    
        JMP j1E08

b1DE6   LDA #$01
        LDX #$01
        LDY #$01
        JSR ROM_SETLFS ;$FFBA - set file parameters              
        LDA #$00
        JSR ROM_SETNAM ;$FFBD - set file name                    
        LDA #$01
        STA a0286
        LDA #$00
        JSR ROM_LOAD ;$FFD5 - load after call SETLFS,SETNAM    
        JSR ROM_READST ;$FFB7 - read I/O status byte             
        AND #$10
        BEQ j1E08
        JSR DisplayLoadOrAbort
;-------------------------------
; j1E08
;-------------------------------
j1E08    
        LDA #$00
        STA a171E
        STA a1BEB
        STA a1EAA
        JSR ROM_CLALL ;$FFE7 - close or abort all files         
        JSR s171F
        JMP j0C39

        RTS 

;-------------------------------
; PromptToSave
;-------------------------------
PromptToSave    
        LDA a19F8
        BNE b1E43
        LDA playbackOrRecordActive
        CMP #$02
        BEQ b1E43

        LDA #$84
        STA selectedVariables

        LDX #$00
b1E30   LDA txtSavePrompt,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$28
        BNE b1E30

        LDA #$00
        STA a1EAA
        JSR WriteLastLineBufferToScreen
b1E43   RTS 

txtSavePrompt   .TEXT " SAVE (P)ARAMETERS, (M)OTION, (A)BORT?  "

;-------------------------------
; j1E6C
;-------------------------------
j1E6C    
        LDA selectedVariables
        CMP #$84
        BEQ b1E74
        RTS 

b1E74   LDA lastKeyPressed
        CMP #$0A
        BNE b1E87
        LDA #$00
        STA a171E
;-------------------------------
; j1E7F
;-------------------------------
j1E7F    
        LDA #$00
        STA selectedVariables
        JMP ClearLastLineOfScreen

b1E87   CMP #$24
        BNE b1E98
        LDA #$02
        STA a1EAA
        LDA #$18
        STA a171E
        JMP j1E7F

b1E98   CMP #$29
        BNE b1EA9
        LDA #$01
        STA a1EAA
        LDA #$18
        STA a171E
        JMP j1E7F

b1EA9   RTS 

a1EAA   .BYTE $00
;-------------------------------
; DisplayLoadOrAbort
;-------------------------------
DisplayLoadOrAbort    
        
        LDA a19F8
        BNE b1EA9
        LDA playbackOrRecordActive
        CMP #$02
        BEQ b1EA9
        LDA #$85
        STA selectedVariables
        LDX #$00
b1EBE   LDA txtContinueLoadOrAbort,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$28
        BNE b1EBE
        LDA #$00
        STA a1EAA
        JMP WriteLastLineBufferToScreen

;-------------------------------
; j1ED1
;-------------------------------
j1ED1    
        LDA lastKeyPressed
        CMP #$0A ; 'A'
        BNE b1EE5
        ; 'A' pressed
        LDA #$00
        STA selectedVariables
        STA a1EAA
        STA a171E
        JMP ClearLastLineOfScreen

b1EE5   CMP #$14 ; 'C'
        BNE b1EFB
        ; 'C' pressed
        LDA #$03
        STA a1EAA
        LDA #$00
        STA selectedVariables
        LDA #$18
        STA a171E
        JMP ClearLastLineOfScreen

b1EFB   RTS 

txtContinueLoadOrAbort
        ; '¨C©ON'
        .BYTE $A8,$C3,$A9,$CF,$CE       ; $1EF9:      
        ; 'TINUE LO'
        .BYTE $D4,$C9,$CE,$D5,$C5,$A0,$CC,$CF       ; $1F01:      
        ; 'AD¬ OR ¨'
        .BYTE $C1,$C4,$AC,$A0,$CF,$D2,$A0,$A8       ; $1F09:      
        ; 'A©BORT¿ '
        .BYTE $C1,$A9,$C2,$CF,$D2,$D4,$BF,$A0         ; $1F11:
        ; '        '
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0         ; $1F19:
        ; '   '
        .BYTE $A0,$A0,$A0
demoModeActive
        .BYTE $00
a1F25
        .BYTE $01
a1F26
        .BYTE $10

;-------------------------------
; j1F27
;-------------------------------
j1F27 
        DEC a1F25
        BEQ b1F2D
        RTS 

b1F2D   JSR s09CB
        AND #$1F
        ORA #$01
        STA a1F25
        LDA a1F26
        EOR #$10
        STA a1F26
        JSR s09CB
        AND #$0F
        ORA a1F26
        EOR #$1F
        STA lastJoystickInput
        DEC a1FA9
        BEQ b1F51
        RTS 

b1F51   JSR s09CB
        AND #$07
b1F56   ADC #$20
        STA a1FA9
        JSR s09CB
        AND #$0F
        TAX 
        LDA #$00
        STA shiftPressed
        JMP b160C

;-------------------------------
; DisplayDemoModeMessage
;-------------------------------
DisplayDemoModeMessage   
        LDA demoModeActive
        BNE b1F71
        JMP ClearLastLineOfScreen
        ;Returns

b1F71   LDX #$00
b1F73   LDA demoMessage,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$28
        BNE b1F73
        JMP WriteLastLineBufferToScreen

demoMessage
        ; 'PSYCHEDE'
        .BYTE $D0,$D3,$D9,$C3,$C8,$C5,$C4,$C5         ; $1F81:
        ; 'LIA CRAC'
        .BYTE $CC,$C9,$C1,$A0,$C3,$D2,$C1,$C3         ; $1F89:
        ; 'KED BY S'
        .BYTE $CB,$C5,$C4,$A0,$C2,$D9,$A0,$D3         ; $1F91:
        ; 'NAIL HI '
        .BYTE $CE,$C1,$C9,$CC,$20,$C8,$C9,$20         ; $1F99:
        ; 'J MINTER'
        .BYTE $CA,$A0,$CD,$C9,$CE,$D4,$C5,$D2         ; $1FA1:
a1FA9
        .BYTE $20
NMIInterruptHandler
        .BYTE $A2,$F8,$9A,$A9,$0C,$48,$A9         ; $1FA9:
        .BYTE $30,$48,$A9,$23,$48,$40


;-------------------------------
; CopyDataFrom2000ToC000
;-------------------------------
CopyDataFrom2000ToC000   
        LDY #$00
        TYA 
        STA aFB
        STA aFD
        LDA #$20
        STA aFC
        LDA #$C0
        STA aFE

        LDX #$10
b1FC8   LDA (pFB),Y
        STA (pFD),Y
        DEY 
        BNE b1FC8

        INC aFC
        INC aFE
        DEX 
        BNE b1FC8

        LDX #$09
b1FD8   LDA f1FE1,X
        STA a7FFF,X
        DEX 
        BNE b1FD8
        RTS 

f1FE1=*-$01   
        ; '00CBM'
        .BYTE $30,$0C,$30,$0C,$C3,$C2,$CD          ; $1FE1:             
        .BYTE $38,$30,$00,$00,$00,$00,$00,$00          ; $1FE9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $1FF1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $1FF9:             
f2000
        .BYTE $0C,$02,$1F,$01,$01,$07,$04,$01          ; $2001:             
        .BYTE $07,$00,$06,$02,$04,$05,$03,$07          ; $2009:             
        .BYTE $01,$00,$00,$00,$00,$01,$FF,$00          ; $2011:             
        .BYTE $FF,$FF,$00,$FF,$00,$FF,$00,$00          ; $2019:             
        .BYTE $0C,$02,$28,$01,$0E,$07,$08,$01          ; $2021:             
        .BYTE $07,$00,$09,$02,$08,$04,$0A,$06          ; $2029:             
        .BYTE $0E,$FF,$00,$01,$01,$04,$FF,$00          ; $2031:             
        .BYTE $FF,$FF,$00,$FF,$00,$FF,$00,$00          ; $2039:             
        .BYTE $0B,$02,$28,$01,$01,$07,$0B,$01          ; $2041:             
        .BYTE $07,$00,$06,$0E,$03,$0D,$05,$0E          ; $2049:             
        .BYTE $06,$FF,$00,$05,$05,$01,$FF,$00          ; $2051:             
        .BYTE $FF,$FF,$00,$FF,$00,$FF,$00,$00          ; $2059:             
        .BYTE $04,$02,$26,$01,$01,$07,$0A,$01          ; $2061:             
        .BYTE $07,$00,$02,$04,$0A,$0D,$03,$0E          ; $2069:             
        .BYTE $06,$00,$00,$0E,$0E,$02,$FF,$00          ; $2071:             
        .BYTE $FF,$FF,$00,$FF,$00,$EA,$10,$00          ; $2079:             
        .BYTE $0C,$01,$2B,$01,$07,$07,$08,$01          ; $2081:             
        .BYTE $07,$00,$0B,$06,$0C,$04,$0F,$03          ; $2089:             
        .BYTE $01,$00,$00,$01,$01,$01,$00,$FF          ; $2091:             
        .BYTE $00,$00,$FF,$00,$FF,$00,$FF,$00          ; $2099:             
        .BYTE $0C,$02,$2B,$01,$07,$07,$0C,$01          ; $20A1:             
        .BYTE $07,$00,$0B,$06,$0C,$04,$0F,$03          ; $20A9:             
        .BYTE $01,$00,$00,$06,$06,$03,$00,$FF          ; $20B1:             
        .BYTE $00,$00,$FF,$00,$FF,$00,$F7,$00          ; $20B9:             
        .BYTE $0F,$02,$3F,$01,$01,$07,$0F,$01          ; $20C1:             
        .BYTE $07,$00,$06,$02,$04,$05,$03,$07          ; $20C9:             
        .BYTE $01,$FF,$00,$03,$03,$04,$00,$FF          ; $20D1:             
        .BYTE $00,$00,$FF,$00,$FF,$00,$FF,$00          ; $20D9:             
        .BYTE $0B,$01,$1C,$02,$0A,$07,$09,$01          ; $20E1:             
        .BYTE $07,$00,$07,$03,$0E,$06,$02,$04          ; $20E9:             
        .BYTE $0A,$00,$00,$07,$07,$01,$00,$FF          ; $20F1:             
        .BYTE $00,$00,$FF,$00,$FF,$15,$EF,$00          ; $20F9:             
        .BYTE $04,$01,$28,$02,$01,$07,$0A,$01          ; $2101:             
        .BYTE $07,$00,$08,$09,$05,$03,$0D,$0E          ; $2109:             
        .BYTE $06,$FF,$00,$01,$01,$03,$FF,$00          ; $2111:             
        .BYTE $FF,$FF,$00,$FF,$00,$FF,$00,$00          ; $2119:             
        .BYTE $11,$01,$0D,$07,$01,$07,$0C,$01          ; $2121:             
        .BYTE $07,$00,$06,$03,$06,$03,$06,$03          ; $2129:             
        .BYTE $06,$FF,$00,$07,$07,$04,$FF,$00          ; $2131:             
        .BYTE $FF,$FF,$00,$FF,$00,$FF,$00,$00          ; $2139:             
        .BYTE $01,$02,$1F,$02,$09,$04,$08,$01          ; $2141:             
        .BYTE $07,$00,$06,$02,$02,$04,$0A,$08          ; $2149:             
        .BYTE $09,$FF,$01,$00,$00,$04,$FF,$00          ; $2151:             
        .BYTE $FF,$FF,$00,$FF,$00,$FF,$00,$00          ; $2159:             
        .BYTE $01,$01,$13,$06,$01,$07,$08,$05          ; $2161:             
        .BYTE $07,$00,$06,$02,$04,$05,$03,$07          ; $2169:             
        .BYTE $01,$FF,$00,$0F,$0F,$04,$FF,$00          ; $2171:             
        .BYTE $FF,$FF,$00,$FF,$00,$EA,$10,$00          ; $2179:             
        .BYTE $0C,$02,$28,$01,$02,$07,$09,$01          ; $2181:             
        .BYTE $07,$00,$06,$0E,$03,$0D,$07,$04          ; $2189:             
        .BYTE $02,$00,$00,$0A,$0A,$01,$00,$FF          ; $2191:             
        .BYTE $00,$00,$FF,$00,$FF,$00,$FF,$00          ; $2199:             
        .BYTE $0B,$01,$1C,$02,$0A,$07,$09,$01          ; $21A1:             
        .BYTE $07,$00,$07,$03,$0E,$06,$02,$04          ; $21A9:             
        .BYTE $0A,$00,$00,$03,$03,$04,$00,$FF          ; $21B1:             
        .BYTE $00,$00,$FF,$00,$FF,$00,$FF,$00          ; $21B9:             
        .BYTE $0C,$02,$2B,$01,$0A,$07,$08,$01          ; $21C1:             
        .BYTE $07,$00,$02,$09,$08,$04,$02,$07          ; $21C9:             
        .BYTE $0A,$FF,$00,$04,$04,$02,$00,$FF          ; $21D1:             
        .BYTE $00,$00,$FF,$00,$FF,$00,$FF,$00          ; $21D9:             
        .BYTE $03,$01,$1F,$06,$01,$07,$00,$01          ; $21E1:             
        .BYTE $07,$00,$06,$02,$04,$05,$03,$07          ; $21E9:             
        .BYTE $01,$FF,$00,$04,$04,$04,$00,$FF          ; $21F1:             
        .BYTE $00,$00,$FF,$00,$FF,$15,$EF,$01          ; $21F9:             
        .BYTE $0C,$07,$06,$07,$11,$0D,$07,$06          ; $2201:             
        .BYTE $11,$07,$FF,$0B,$07,$FF,$00,$FF          ; $2209:             
        .BYTE $21,$06,$00,$06,$01,$06,$41,$FF          ; $2211:             
        .BYTE $00,$06,$01,$06,$01,$06,$00,$01          ; $2219:             
        .BYTE $0C,$13,$08,$00,$07,$0F,$00,$FF          ; $2221:             
        .BYTE $00,$06,$01,$2A,$41,$02,$00,$04          ; $2229:             
        .BYTE $62,$FF,$41,$06,$40,$00,$6B,$04          ; $2231:             
        .BYTE $41,$FF,$00,$FF,$00,$FF,$00,$04          ; $2239:             
        .BYTE $01,$08,$01,$02,$FF,$01,$02,$08          ; $2241:             
        .BYTE $01,$02,$08,$01,$02,$08,$01,$02          ; $2249:             
        .BYTE $08,$01,$02,$08,$01,$02,$FF,$03          ; $2251:             
        .BYTE $02,$08,$03,$02,$08,$03,$02,$00          ; $2259:             
        .BYTE $11,$12,$09,$08,$12,$09,$08,$FF          ; $2261:             
        .BYTE $08,$03,$02,$08,$03,$02,$08,$03          ; $2269:             
        .BYTE $02,$FF,$00,$00,$00,$00,$01,$24          ; $2271:             
        .BYTE $00,$05,$01,$00,$00,$00,$00,$00          ; $2279:             
        .BYTE $BD,$00,$B9,$00,$BD,$00,$BD,$81          ; $2281:             
        .BYTE $BD,$81,$FF,$00,$BD,$F1,$FF,$00          ; $2289:             
        ; '(¿®® '
        .BYTE $28,$81,$FF,$81,$AE,$83,$AE,$00          ; $2291:             
        ; '¿®¬A½A'
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$BD,$C1          ; $2299:             
        ; '$¿A¿ ®'
        .BYTE $24,$81,$FF,$C1,$FF,$00,$EE,$81          ; $22A1:             
        ; '¿®¬¡¿'
        .BYTE $BF,$85,$AE,$81,$EC,$E1,$BF,$83          ; $22A9:             
        ; '7 ®¿C.'
        .BYTE $37,$00,$EE,$81,$BF,$C3,$2E,$81          ; $22B1:             
        .BYTE $2E,$00,$FF,$00,$FF,$00,$FD,$05          ; $22B9:             
        ; '|®¬G '
        .BYTE $DC,$02,$EE,$81,$EC,$C7,$0C,$00          ; $22C1:             
        .BYTE $68,$81,$EC,$03,$EE,$81,$EE,$85          ; $22C9:             
        .BYTE $62,$81,$EE,$01,$EC,$87,$EA,$85          ; $22D1:             
        ; '½Mb¯ ¿ '
        .BYTE $FD,$83,$CD,$42,$EF,$00,$FF,$00          ; $22D9:             
        .BYTE $28,$02,$EA,$81,$BD,$85,$BF,$81          ; $22E1:             
        .BYTE $FF,$85,$EE,$00,$BF,$87,$BF,$00          ; $22E9:             
        ; '®¿¿§¾'
        .BYTE $EE,$87,$FF,$81,$FF,$A7,$FE,$01          ; $22F1:             
        .BYTE $FF,$80,$EE,$FD,$FF,$FF,$FF,$01          ; $22F9:             
        .BYTE $0B,$04,$04,$07,$08,$09,$07,$0C          ; $2301:             
        .BYTE $0C,$07,$10,$11,$07,$14,$13,$07          ; $2309:             
        .BYTE $17,$13,$07,$FF,$01,$06,$41,$FF          ; $2311:             
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00          ; $2319:             
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46          ; $2321:             
        ; ' ªa '
        .BYTE $00,$06,$81,$AA,$41,$02,$00,$04          ; $2329:             
        .BYTE $62,$FF,$41,$06,$40,$00,$6B,$04          ; $2331:             
        ; 'A¿ ¿ ¿ b'
        .BYTE $C1,$FF,$00,$FF,$00,$FF,$00,$42          ; $2339:             
        ; '® ¿'
        .BYTE $02,$AE,$01,$00,$07,$1C,$80,$FF          ; $2341:             
        .BYTE $05,$06,$01,$02,$07,$02,$05,$00          ; $2349:             
        .BYTE $85,$06,$01,$02,$05,$02,$41,$00          ; $2351:             
        .BYTE $00,$06,$03,$BD,$00,$BF,$00,$BF          ; $2359:             
        ; 'E¿ b@ '
        .BYTE $C5,$BF,$01,$00,$42,$02,$40,$00          ; $2361:             
        .BYTE $40,$06,$01,$FF,$00,$02,$40,$FF          ; $2369:             
        .BYTE $05,$02,$00,$00,$00,$00,$01,$20          ; $2371:             
        .BYTE $00,$8D,$01,$00,$00,$00,$00,$00          ; $2379:             
        .BYTE $BD,$00,$BD,$00,$BD,$40,$BD,$81          ; $2381:             
        .BYTE $BD,$81,$FF,$00,$FF,$F1,$FF,$00          ; $2389:             
        ; ' ¿®C® '
        .BYTE $20,$81,$FF,$81,$AE,$C3,$EE,$00          ; $2391:             
        ; '¿®¬A½Q'
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$FD,$D1          ; $2399:             
        ; '$¿A¿ ®'
        .BYTE $24,$81,$FF,$C1,$FF,$00,$AE,$81          ; $23A1:             
        ; '¿E®a¬¡¿C'
        .BYTE $FF,$C5,$EE,$41,$EC,$E1,$FF,$C3          ; $23A9:             
        ; '7 ®A¿C®A'
        .BYTE $37,$00,$EE,$C1,$BF,$C3,$AE,$C1          ; $23B1:             
        ; '® ¿ ¿ ½'
        .BYTE $AE,$00,$FF,$00,$FF,$00,$FD,$05          ; $23B9:             
        ; '}®¬Gl '
        .BYTE $DD,$03,$EE,$85,$EC,$C7,$4C,$00          ; $23C1:             
        .BYTE $60,$81,$EC,$87,$EE,$81,$EE,$8D          ; $23C9:             
        .BYTE $62,$85,$EE,$85,$EE,$87,$EA,$85          ; $23D1:             
        .BYTE $FD,$83,$ED,$42,$EF,$00,$FF,$40          ; $23D9:             
        ; '(®A½¿'
        .BYTE $28,$02,$EE,$C1,$BD,$85,$FF,$81          ; $23E1:             
        ; '¿® ¿§¿ '
        .BYTE $FF,$85,$EE,$00,$FF,$A7,$BF,$00          ; $23E9:             
        ; '®¿¿§¾'
        .BYTE $EE,$87,$FF,$81,$FF,$A7,$FE,$01          ; $23F1:             
        .BYTE $FF,$00,$EE,$FD,$FF,$FF,$FF,$FF          ; $23F9:             
        .BYTE $00,$F7,$00,$FF,$00,$BF,$40,$46          ; $2401:             
        .BYTE $00,$06,$00,$FF,$00,$06,$00,$FF          ; $2409:             
        .BYTE $01,$06,$00,$06,$01,$06,$41,$FF          ; $2411:             
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00          ; $2419:             
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46          ; $2421:             
        .BYTE $00,$06,$01,$2A,$41,$02,$00,$04          ; $2429:             
        .BYTE $6A,$FF,$41,$06,$40,$00,$4B,$04          ; $2431:             
        .BYTE $89,$FF,$00,$FF,$00,$FF,$00,$42          ; $2439:             
        .BYTE $02,$BF,$01,$00,$07,$1C,$00,$FF          ; $2441:             
        .BYTE $05,$06,$01,$02,$07,$02,$05,$00          ; $2449:             
        .BYTE $05,$06,$01,$02,$05,$02,$01,$00          ; $2451:             
        .BYTE $00,$06,$02,$BD,$00,$BF,$00,$FF          ; $2459:             
        ; 'E¿ b@ '
        .BYTE $C5,$BF,$01,$00,$42,$02,$40,$00          ; $2461:             
        .BYTE $40,$06,$01,$FF,$00,$02,$40,$FF          ; $2469:             
        .BYTE $45,$02,$00,$00,$00,$02,$01,$24          ; $2471:             
        .BYTE $00,$05,$01,$00,$00,$00,$00,$00          ; $2479:             
        .BYTE $BD,$00,$B9,$00,$BD,$40,$BD,$81          ; $2481:             
        .BYTE $BD,$81,$FF,$00,$FD,$F1,$FF,$00          ; $2489:             
        ; ' ¿A®® '
        .BYTE $20,$81,$FF,$C1,$AE,$83,$EE,$00          ; $2491:             
        ; '¿®¬A½A'
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$BD,$C1          ; $2499:             
        ; '$A¿A¿ ®'
        .BYTE $24,$C1,$FF,$C1,$FF,$00,$EE,$81          ; $24A1:             
        ; '½E®A¬¡¿C'
        .BYTE $FD,$C5,$EE,$C1,$EC,$E1,$FF,$C3          ; $24A9:             
        ; '7 ®A¿C®A'
        .BYTE $37,$00,$EE,$C1,$BF,$C3,$AE,$C1          ; $24B1:             
        ; '® ¿ ¿ ½'
        .BYTE $AE,$00,$FF,$00,$FF,$00,$FD,$81          ; $24B9:             
        ; '}ª¬GL '
        .BYTE $DD,$03,$EA,$81,$EC,$C7,$CC,$00          ; $24C1:             
        .BYTE $60,$81,$EC,$83,$EE,$81,$EE,$85          ; $24C9:             
        .BYTE $62,$81,$EE,$81,$EE,$87,$EA,$85          ; $24D1:             
        .BYTE $FD,$83,$ED,$42,$EF,$00,$FF,$00          ; $24D9:             
        .BYTE $28,$02,$EE,$81,$FD,$85,$FF,$81          ; $24E1:             
        .BYTE $FF,$85,$EE,$00,$FD,$85,$FF,$00          ; $24E9:             
        ; '®¿¿§¿'
        .BYTE $EE,$87,$FF,$81,$FF,$A7,$FF,$01          ; $24F1:             
        .BYTE $FF,$80,$EE,$FD,$FF,$FF,$FF,$FF          ; $24F9:             
        .BYTE $00,$F7,$00,$FF,$00,$BF,$40,$06          ; $2501:             
        .BYTE $00,$06,$00,$FF,$00,$06,$00,$FF          ; $2509:             
        .BYTE $21,$06,$00,$06,$01,$06,$01,$BF          ; $2511:             
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00          ; $2519:             
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46          ; $2521:             
        .BYTE $00,$06,$01,$2A,$01,$02,$00,$04          ; $2529:             
        .BYTE $62,$FF,$01,$06,$40,$00,$6B,$04          ; $2531:             
        .BYTE $91,$BF,$00,$FF,$00,$FF,$00,$42          ; $2539:             
        .BYTE $02,$BF,$01,$00,$07,$1C,$80,$FF          ; $2541:             
        .BYTE $25,$06,$01,$02,$07,$02,$05,$00          ; $2549:             
        .BYTE $85,$06,$01,$02,$05,$02,$01,$00          ; $2551:             
        .BYTE $00,$06,$03,$BD,$00,$BF,$00,$BF          ; $2559:             
        ; 'E¿ b@ '
        .BYTE $C5,$BF,$01,$00,$42,$02,$40,$00          ; $2561:             
        .BYTE $00,$06,$01,$FF,$00,$02,$40,$FF          ; $2569:             
        .BYTE $05,$02,$00,$00,$00,$00,$01,$20          ; $2571:             
        .BYTE $00,$8D,$01,$00,$00,$00,$00,$00          ; $2579:             
        .BYTE $BD,$00,$B9,$00,$BD,$40,$BD,$81          ; $2581:             
        .BYTE $BD,$81,$FF,$00,$BF,$F9,$FF,$00          ; $2589:             
        ; '(¿®® '
        .BYTE $28,$81,$FF,$81,$AE,$83,$AE,$00          ; $2591:             
        ; '¿®¬A½¡'
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$BD,$A1          ; $2599:             
        ; '$A¿A¿ ®'
        .BYTE $24,$C1,$FF,$C1,$FF,$00,$AE,$81          ; $25A1:             
        ; '¿E®A¬¡¿'
        .BYTE $BF,$C5,$EE,$C1,$EC,$E1,$BF,$83          ; $25A9:             
        ; '? ®A¿£®A'
        .BYTE $3F,$00,$EE,$C1,$BF,$E3,$AE,$C1          ; $25B1:             
        ; '® ¿ ¿ ½'
        .BYTE $AE,$20,$FF,$00,$FF,$00,$BD,$05          ; $25B9:             
        ; '}ª¬Gl '
        .BYTE $DD,$03,$EA,$81,$EC,$C7,$4C,$00          ; $25C1:             
        ; 'È¬®®­'
        .BYTE $68,$81,$EC,$87,$EE,$81,$EE,$AD          ; $25C9:             
        .BYTE $62,$85,$EE,$81,$EE,$87,$EA,$85          ; $25D1:             
        .BYTE $FD,$83,$EC,$42,$EF,$00,$FF,$00          ; $25D9:             
        ; '(®½¥¿'
        .BYTE $28,$02,$EE,$81,$BD,$A5,$BF,$81          ; $25E1:             
        ; '¿® ¿¯¿ '
        .BYTE $BF,$85,$EE,$00,$BF,$AF,$BF,$00          ; $25E9:             
        ; '¬¿¿§®'
        .BYTE $EC,$87,$FF,$81,$FF,$A7,$EE,$01          ; $25F1:             
        .BYTE $FF,$80,$EE,$FD,$FF,$FF,$FF,$FF          ; $25F9:             
        .BYTE $00,$F7,$00,$FF,$00,$BF,$40,$46          ; $2601:             
        .BYTE $00,$06,$00,$FF,$00,$06,$00,$FF          ; $2609:             
        ; '¡ a¿'
        .BYTE $A1,$06,$00,$06,$01,$06,$41,$FF          ; $2611:             
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00          ; $2619:             
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46          ; $2621:             
        .BYTE $00,$06,$81,$2A,$01,$02,$00,$04          ; $2629:             
        .BYTE $62,$FF,$41,$06,$40,$00,$6B,$04          ; $2631:             
        .BYTE $B1,$FB,$00,$FF,$00,$FF,$00,$42          ; $2639:             
        .BYTE $02,$B6,$01,$00,$07,$1C,$80,$FF          ; $2641:             
        .BYTE $25,$06,$01,$02,$07,$02,$05,$00          ; $2649:             
        .BYTE $85,$06,$01,$02,$05,$02,$01,$00          ; $2651:             
        .BYTE $00,$06,$03,$BD,$00,$BF,$00,$BF          ; $2659:             
        ; 'E¿ b@ '
        .BYTE $C5,$BF,$01,$00,$42,$02,$40,$00          ; $2661:             
        .BYTE $40,$06,$01,$FF,$00,$02,$40,$FF          ; $2669:             
        ; 'e    '
        .BYTE $45,$02,$00,$02,$00,$00,$01,$A0          ; $2671:             
        .BYTE $00,$8F,$01,$00,$00,$00,$00,$00          ; $2679:             
        .BYTE $BD,$00,$BD,$00,$BD,$40,$BD,$81          ; $2681:             
        .BYTE $BD,$81,$FF,$00,$FD,$F1,$FF,$00          ; $2689:             
        ; ' ¿¬® '
        .BYTE $20,$81,$FF,$81,$AC,$83,$EE,$00          ; $2691:             
        ; '¿®¬A½A'
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$BD,$C1          ; $2699:             
        ; '$A¿A¿ ®'
        .BYTE $24,$C1,$FF,$C1,$FF,$00,$EE,$81          ; $26A1:             
        ; '½E®A¬¡¿C'
        .BYTE $FD,$C5,$AE,$C1,$EC,$E1,$BF,$C3          ; $26A9:             
        ; '? ®A¿C®A'
        .BYTE $3F,$00,$EE,$C1,$BF,$C3,$AE,$C1          ; $26B1:             
        .BYTE $EE,$00,$FF,$00,$FF,$00,$FD,$85          ; $26B9:             
        ; '}®¬GL '
        .BYTE $DD,$03,$EE,$85,$EC,$C7,$CC,$00          ; $26C1:             
        .BYTE $E8,$81,$EC,$87,$EE,$81,$EE,$8D          ; $26C9:             
        .BYTE $62,$81,$EE,$81,$EE,$87,$EA,$85          ; $26D1:             
        ; '½Lb¯ ¿ '
        .BYTE $FD,$83,$CC,$42,$EF,$00,$FF,$00          ; $26D9:             
        ; '(®A½¿'
        .BYTE $28,$02,$EE,$C1,$FD,$85,$FF,$81          ; $26E1:             
        .BYTE $FF,$85,$EE,$00,$FD,$85,$BF,$00          ; $26E9:             
        .BYTE $EE,$87,$FF,$81,$FF,$87,$FE,$01          ; $26F1:             
        .BYTE $FF,$80,$EE,$FD,$FF,$FF,$FF,$FF          ; $26F9:             
        .BYTE $00,$F7,$00,$FF,$00,$BF,$40,$46          ; $2701:             
        .BYTE $00,$06,$00,$FF,$00,$06,$00,$FF          ; $2709:             
        .BYTE $11,$06,$00,$06,$01,$06,$41,$FF          ; $2711:             
        .BYTE $00,$06,$01,$06,$01,$06,$00,$00          ; $2719:             
        .BYTE $FF,$06,$00,$02,$00,$FF,$41,$46          ; $2721:             
        ; ' «a '
        .BYTE $00,$06,$01,$AB,$41,$02,$00,$04          ; $2729:             
        .BYTE $62,$FF,$41,$06,$40,$00,$6B,$04          ; $2731:             
        .BYTE $91,$FF,$00,$FF,$00,$FF,$00,$42          ; $2739:             
        .BYTE $02,$27,$01,$00,$07,$1C,$00,$FF          ; $2741:             
        .BYTE $25,$06,$05,$02,$07,$02,$05,$00          ; $2749:             
        .BYTE $05,$06,$01,$02,$05,$02,$41,$00          ; $2751:             
        .BYTE $00,$06,$03,$BD,$00,$BF,$00,$BD          ; $2759:             
        ; 'E¿ ba '
        .BYTE $C5,$BF,$01,$00,$42,$02,$41,$00          ; $2761:             
        .BYTE $40,$06,$01,$FF,$00,$02,$41,$FF          ; $2769:             
        .BYTE $45,$02,$00,$00,$00,$00,$01,$24          ; $2771:             
        .BYTE $00,$0D,$01,$00,$00,$00,$00,$00          ; $2779:             
        .BYTE $BD,$00,$FD,$00,$FD,$40,$BD,$81          ; $2781:             
        .BYTE $BD,$81,$FF,$00,$FF,$F1,$FF,$00          ; $2789:             
        ; ' ¿®C® '
        .BYTE $20,$81,$FF,$81,$AE,$C3,$EE,$00          ; $2791:             
        ; '¿®¬A½'
        .BYTE $FF,$81,$EE,$81,$AC,$C1,$FD,$81          ; $2799:             
        ; '$A¿A¿ ®'
        .BYTE $24,$C1,$FF,$C1,$FF,$00,$EE,$81          ; $27A1:             
        ; '¿E®a¬¡¿C'
        .BYTE $FF,$C5,$EE,$41,$EC,$E1,$FF,$C3          ; $27A9:             
        ; '7 ®A¿C¦A'
        .BYTE $37,$00,$EE,$C1,$BF,$C3,$A6,$C1          ; $27B1:             
        ; '¦ ¿ ¿ ¿'
        .BYTE $A6,$00,$FF,$00,$FF,$00,$BF,$05          ; $27B9:             
        ; '½ª¬G} '
        .BYTE $FD,$03,$EA,$85,$EC,$C7,$DD,$00          ; $27C1:             
        .BYTE $60,$81,$EC,$87,$EE,$81,$EE,$85          ; $27C9:             
        .BYTE $62,$81,$EE,$81,$EE,$87,$EA,$85          ; $27D1:             
        .BYTE $FD,$83,$EC,$40,$EF,$00,$FF,$00          ; $27D9:             
        ; '(ªA¬¿'
        .BYTE $28,$02,$EA,$C1,$AC,$85,$BF,$81          ; $27E1:             
        ; '¿® ¿G¿ '
        .BYTE $FF,$85,$EE,$00,$FF,$C7,$BF,$00          ; $27E9:             
        .BYTE $EE,$87,$FF,$81,$FF,$87,$FE,$01          ; $27F1:             
        .BYTE $FF,$00,$EE,$FD,$FF,$FF,$FF,$00          ; $27F9:             
        .BYTE $00,$00,$FF,$FE,$FD,$01,$02,$55          ; $2801:             
        .BYTE $00,$03,$55,$00,$00,$00,$00,$00          ; $2809:             
        .BYTE $55,$00,$FF,$FE,$FC,$FB,$FC,$01          ; $2811:             
        .BYTE $02,$55,$00,$04,$05,$04,$FF,$01          ; $2819:             
        .BYTE $55,$00,$FD,$FB,$03,$05,$02,$FE          ; $2821:             
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00          ; $2829:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2831:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2839:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2841:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2849:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2851:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2859:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2861:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2869:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2871:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2879:             
        .BYTE $FF,$FE,$01,$02,$03,$01,$02,$55          ; $2881:             
        .BYTE $00,$03,$55,$00,$01,$02,$03,$04          ; $2889:             
        .BYTE $55,$00,$FE,$FE,$FF,$01,$03,$FE          ; $2891:             
        .BYTE $FE,$55,$00,$FF,$01,$03,$04,$04          ; $2899:             
        .BYTE $55,$00,$FF,$00,$FF,$00,$04,$04          ; $28A1:             
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00          ; $28A9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28B1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28B9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28C1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28C9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28D1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28D9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28E1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28E9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28F1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $28F9:             
        .BYTE $00,$FF,$01,$55,$00,$FE,$02,$55          ; $2901:             
        .BYTE $00,$00,$FA,$06,$03,$FD,$55,$00          ; $2909:             
        .BYTE $FD,$03,$FB,$05,$55,$00,$00,$00          ; $2911:             
        .BYTE $55,$00,$00,$FC,$04,$03,$FD,$55          ; $2919:             
        .BYTE $00,$55,$00,$00,$00,$00,$00,$00          ; $2921:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2929:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2931:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2939:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2941:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2949:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2951:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2959:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2961:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2969:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2971:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2979:             
        .BYTE $FF,$01,$01,$55,$00,$01,$01,$55          ; $2981:             
        .BYTE $00,$FC,$FF,$FF,$05,$05,$55,$00          ; $2989:             
        .BYTE $FD,$FD,$02,$02,$55,$00,$05,$FD          ; $2991:             
        .BYTE $55,$00,$FE,$02,$02,$02,$02,$55          ; $2999:             
        .BYTE $00,$55,$00,$00,$00,$00,$00,$00          ; $29A1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29A9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29B1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29B9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29C1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29C9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29D1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29D9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29E1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29E9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29F1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $29F9:             
        .BYTE $55,$00,$FD,$03,$55,$00,$F9,$07          ; $2A01:             
        .BYTE $55,$00,$FB,$05,$55,$00,$00,$55          ; $2A09:             
        .BYTE $00,$00,$55,$00,$55,$FE,$02,$55          ; $2A11:             
        .BYTE $00,$55,$55,$00,$00,$00,$00,$00          ; $2A19:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A21:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A29:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A31:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A39:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A41:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A49:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A51:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A59:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A61:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A69:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A71:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2A79:             
        .BYTE $55,$00,$00,$00,$55,$00,$00,$00          ; $2A81:             
        .BYTE $55,$00,$FD,$FD,$55,$00,$FB,$55          ; $2A89:             
        .BYTE $00,$04,$55,$00,$55,$FC,$FC,$55          ; $2A91:             
        .BYTE $00,$55,$55,$00,$00,$00,$00
a2AA0
        .BYTE $00          ; $2A99:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AA1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AA9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AB1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AB9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AC1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AC9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AD1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AD9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AE1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AE9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AF1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2AF9:             
        .BYTE $01,$01,$02,$55,$00,$00,$01,$02          ; $2B01:             
        .BYTE $02,$55,$00,$00,$00,$02,$55,$00          ; $2B09:             
        .BYTE $FF,$FE,$55,$00,$FE,$FE,$55,$00          ; $2B11:             
        .BYTE $FD,$FE,$55,$00,$55,$00,$00,$00          ; $2B19:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B21:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B29:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B31:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B39:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B41:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B49:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B51:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B59:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B61:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B69:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B71:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2B79:             
        .BYTE $FF,$00,$00,$55,$00,$01,$01,$01          ; $2B81:             
        .BYTE $02,$55,$00,$02,$03,$03,$55,$00          ; $2B89:             
        .BYTE $01,$00,$55,$00,$FF,$FE,$55,$00          ; $2B91:             
        .BYTE $FF,$FF,$55,$00,$55,$00,$00,$00          ; $2B99:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BA1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BA9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BB1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BB9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BC1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BC9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BD1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BD9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BE1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BE9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BF1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2BF9:             
        .BYTE $00,$00,$ED,$14,$55,$00,$F2,$0F          ; $2C01:             
        .BYTE $55,$00,$00,$55,$00,$00,$55,$00          ; $2C09:             
        .BYTE $00,$55,$00,$00,$FF,$01,$55,$00          ; $2C11:             
        .BYTE $55,$02,$55,$00,$FC,$FD,$03,$04          ; $2C19:             
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00          ; $2C21:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C29:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C31:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C39:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C41:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C49:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C51:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C59:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C61:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C69:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C71:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2C79:             
        .BYTE $0B,$F4,$00,$00,$55,$00,$00,$00          ; $2C81:             
        .BYTE $55,$00,$F9,$55,$00,$FC,$55,$00          ; $2C89:             
        .BYTE $FE,$55,$00,$FF,$00,$00,$55,$00          ; $2C91:             
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00          ; $2C99:             
        .BYTE $55,$00,$55,$00,$00,$00,$00,$00          ; $2CA1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CA9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CB1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CB9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CC1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CC9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CD1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CD9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CE1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CE9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CF1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2CF9:             
        .BYTE $00,$01,$01,$55,$00,$FF,$FF,$FE          ; $2D01:             
        .BYTE $55,$00,$FD,$FC,$FB,$55,$00,$FD          ; $2D09:             
        .BYTE $FE,$FF,$55,$00,$00,$01,$02,$55          ; $2D11:             
        .BYTE $00,$03,$04,$55,$00,$55,$00,$00          ; $2D19:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D21:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D29:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D31:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D39:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D41:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D49:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D51:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D59:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D61:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D69:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D71:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2D79:             
        .BYTE $FF,$FE,$FD,$55,$00,$01,$02,$03          ; $2D81:             
        .BYTE $55,$00,$04,$04,$03,$55,$00,$FC          ; $2D89:             
        .BYTE $FC,$FC,$55,$00,$FC,$FC,$FC,$55          ; $2D91:             
        .BYTE $00,$FC,$FC,$55,$00,$55,$00,$00          ; $2D99:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DA1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DA9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DB1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DB9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DC1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DC9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DD1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DD9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DE1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DE9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DF1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2DF9:             
        .BYTE $01,$02,$55,$00,$F6,$F6,$55,$00          ; $2E01:             
        .BYTE $FB,$FA,$FB,$FC,$55,$00,$FD,$FD          ; $2E09:             
        .BYTE $FE,$FE,$55,$00,$05,$07,$55,$00          ; $2E11:             
        .BYTE $F9,$F7,$FB,$55,$00,$55,$00,$55          ; $2E19:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E21:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E29:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E31:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E39:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E41:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E49:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E51:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E59:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E61:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E69:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E71:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2E79:             
        .BYTE $FF,$FE,$55,$00,$FC,$FD,$55,$00          ; $2E81:             
        .BYTE $FA,$FB,$FC,$FB,$55,$00,$05,$06          ; $2E89:             
        .BYTE $06,$05,$55,$00,$03,$02,$55,$00          ; $2E91:             
        .BYTE $01,$03,$03,$55,$00,$55,$00,$55          ; $2E99:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EA1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EA9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EB1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EB9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EC1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EC9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2ED1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2ED9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EE1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EE9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EF1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2EF9:             
        .BYTE $55,$00,$55,$00,$55,$00,$55,$00          ; $2F01:             
        .BYTE $55,$00,$55,$00,$55,$00,$00,$00          ; $2F09:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F11:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F19:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F21:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F29:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F31:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F39:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F41:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F49:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F51:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F59:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F61:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F69:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F71:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F79:             
        .BYTE $55,$00,$55,$00,$55,$00,$55,$00          ; $2F81:             
        .BYTE $55,$00,$55,$00,$55,$00,$00,$00          ; $2F89:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F91:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2F99:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FA1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FA9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FB1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FB9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FC1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FC9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FD1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FD9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FE1:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FE9:             
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00          ; $2FF1:             
        .BYTE $00,$00,$00,$00,$00,$00                  ; $2FF9:             
        .BYTE $FF
dynamicStorage
        .BYTE $00
a3001

