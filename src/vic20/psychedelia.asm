; This is the reverse-engineered source code for the game 'Psychedelia'
; written by Jeff Minter in 1984.
;
; The code in this file was created by disassembling a binary of the game released into
; the public domain by Jeff Minter in 2019.
;
; The original code from which this source is derived is the copyright of Jeff Minter.
;
; The original home of this file is at: https://github.com/mwenge/psychedelia
;
; To the extent to which any copyright may apply to the act of disassembling and reconstructing
; the code from its binary, the author disclaims copyright to this source code.  In place of
; a legal notice, here is a blessing:
;
;    May you do good and not evil.
;    May you find forgiveness for yourself and forgive others.
;    May you share freely, never taking more than you give.
;
; **** ZP ABSOLUTE ADRESSES **** 
;
pixelXPosition = $02
pixelYPosition = $03
currentIndexToColorValues = $04
colorRamTableLoPtr2 = $05
colorRamTableHiPtr2 = $06
previousPixelXPosition = $08
previousPixelYPosition = $09
colorRamTableLoPtr = $0A
colorRamTableHiPtr = $0B
currentColorToPaint = $0C
dataLoPtr = $0D
dataHiPtr = $0E
currentPatternElement = $0F
dataLoPtr2 = $10
dataHiPtr2 = $11
timerBetweenKeyStrokes = $12
a13 = $13
a14 = $14
currentSymmetrySetting = $15
a17 = $17
colorBarColorRamHiPtr = $19
colorBarColorRamLoPtr = $18
currentColorSet = $1A
a1B = $1B
a1C = $1C
lastJoystickInput = $21
aAE = $AE
aC4 = $C4
lastKeyPressed = $C5
aC6 = $C6
aCC = $CC
aFB = $FB
aFC = $FC
aFD = $FD
;
; **** ZP POINTERS **** 
;
p1B = $1B
;
; **** FIELDS **** 
;
colorRamLineTableLoPtrArray = $0340
colorRamLineTableHiPtrArray = $0360
SCREEN_RAM = $1E00
COLOR_RAM = $9600
fC8C3 = $C8C3
fCAA0 = $CAA0
fE199 = $E199
;
; **** ABSOLUTE ADRESSES **** 
;
shiftKey = $028D
a0291 = $0291
a0315 = $0315
a20AE = $20AE
;
; **** POINTERS **** 
;
p07D0 = $07D0
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

;-----------------------------------------------------------------------------------
; Start program at InitializeGame (SYS 4112 ($1010)
;-----------------------------------------------------------------------------------
        .BYTE $0B,$10,$0A,$00,$9E,$34,$31,$31
        .BYTE $32,$00,$00,$00,$01,$D5,$02
;---------------------------------------------------------------------------------
; InitializeGame   
;---------------------------------------------------------------------------------
InitializeGame   
        LDA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDA #$02
        STA VIA1IER  ;$911E - interrupt enable register (IER)
        LDA #$F0
        STA VICCR5   ;$9005 - screen map & character map address
        STA a13

        ; Create a Hi/Lo pointer to $D800
        LDA #>COLOR_RAM
        STA aFC
        LDA #<COLOR_RAM
        STA aFB

        ; Populate a table of hi/lo ptrs to the color RAM
        ; of each line on the screen (e.g. $D800,
        ; $D828, $D850 etc). Each entry represents a single
        ; line 40 bytes long and there are nineteen lines.
        ; The last line is reserved for configuration messages.
        LDX #$00
b102B   LDA aFC
        STA colorRamLineTableHiPtrArray,X
        LDA aFB
        STA colorRamLineTableLoPtrArray,X
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
        JMP LaunchPsychedelia

;-------------------------------------------------------------------------
; InitializeScreenWithInitCharacter
;-------------------------------------------------------------------------
InitializeScreenWithInitCharacter
        LDX #$00
currentPixel   =*+$01
b104F   LDA #$CF
        STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $00E4,X
        LDA #$00
        STA COLOR_RAM,X
        STA COLOR_RAM + $00E4,X
        DEX 
        BNE b104F
        RTS 

presetKeyCodes   .BYTE $08,$00,$38,$01,$39,$02,$3A,$03
        .BYTE $3B,$04,$3C,$05,$3D,$06,$3E,$07
;-------------------------------------------------------------------------
; GetColorRAMPtrFromLineTable
;-------------------------------------------------------------------------
GetColorRAMPtrFromLineTable
        LDX pixelYPosition
        LDA colorRamLineTableLoPtrArray,X
        STA colorRamTableLoPtr2
        LDA colorRamLineTableHiPtrArray,X
        STA colorRamTableHiPtr2
        LDY pixelXPosition
b1081   RTS 

;-------------------------------------------------------------------------
; PaintPixel
;-------------------------------------------------------------------------
PaintPixel
        LDA pixelXPosition
        AND #$80
        BNE b1081
        LDA pixelXPosition
        CMP #$16
        BPL b1081
        LDA pixelYPosition
        AND #$80
        BNE b1081
        LDA pixelYPosition
        CMP #$16
        BPL b1081

        JSR GetColorRAMPtrFromLineTable
        LDA a17
        BNE b10BE

        LDA (colorRamTableLoPtr2),Y
        AND #$07

        LDX #$00
b10A7   CMP presetColorValuesArray,X
        BEQ b10B1
        INX 
        CPX #$08
        BNE b10A7

b10B1   TXA 
        STA aFD
        LDX currentIndexToColorValues
        INX 
        CPX aFD
        BEQ b10BE
        BPL b10BE
        RTS 

b10BE   LDX currentIndexToColorValues
        LDA presetColorValuesArray,X
        STA (colorRamTableLoPtr2),Y
        RTS 

;-------------------------------------------------------------------------
; LoopeThroughPixelsAndPaint
;-------------------------------------------------------------------------
LoopeThroughPixelsAndPaint
        JSR PushOffsetAndIndexAndPaintPixel
        LDY #$00
        LDA currentIndexToColorValues
        CMP #$07
        BNE b10D2
        RTS 

b10D2   LDA #$07
        STA a117B

        LDA pixelXPosition
        STA previousPixelXPosition
        LDA pixelYPosition
        STA previousPixelYPosition

        LDX dataPtrIndex
        LDA pixelXPositionLoPtrArray,X
        STA dataLoPtr
        LDA pixelXPositionHiPtrArray,X
        STA dataHiPtr
        LDA pixelYPositionLoPtrArray,X
        STA dataLoPtr2
        LDA pixelYPositionHiPtrArray,X
        STA dataHiPtr2

        ; Paint pixels in the sequence until hitting a break
        ; at $55
b10F6   LDA previousPixelXPosition
        CLC 
        ADC (dataLoPtr),Y
        STA pixelXPosition
        LDA previousPixelYPosition
        CLC 
        ADC (dataLoPtr2),Y
        STA pixelYPosition

        ; Push Y to the stack.
        TYA 
        PHA 

        JSR PushOffsetAndIndexAndPaintPixel

        ; Pull Y back from the stack and increment
        PLA 
        TAY 
        INY 

        LDA (dataLoPtr),Y
        CMP #$55
        BNE b10F6

        DEC a117B
        LDA a117B
        CMP currentIndexToColorValues
        BEQ b1124
        CMP #$01
        BEQ b1124
        INY 
        JMP b10F6

b1124   LDA previousPixelXPosition
        STA pixelXPosition
        LDA previousPixelYPosition
        STA pixelYPosition
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

;-------------------------------------------------------------------------
; PutRandomByteInAccumulator
;-------------------------------------------------------------------------
PutRandomByteInAccumulator
a117D   =*+$01
        LDA fE199,X
        INC a117D
        RTS 

        .BYTE $00,$00
;-------------------------------------------------------------------------
; PushOffsetAndIndexAndPaintPixel
;-------------------------------------------------------------------------
PushOffsetAndIndexAndPaintPixel
        LDA pixelXPosition
        PHA 
        LDA pixelYPosition
        PHA 
        JSR PaintPixel
        LDA a14
        BNE b119A
b1192   PLA 
        STA pixelYPosition
        PLA 
        STA pixelXPosition
        RTS 

        .BYTE $60
b119A   CMP #$03
        BEQ b11CC
        LDA #$15
        SEC 
        SBC pixelXPosition
        STA pixelXPosition
        LDY a14
        CPY #$02
        BEQ b11D6
        JSR PaintPixel
        LDA a14
        CMP #$01
        BEQ b1192
        LDA #$15
        SEC 
        SBC pixelYPosition
        STA pixelYPosition
        JSR PaintPixel

;-------------------------------------------------------------------------
; j11BE
;-------------------------------------------------------------------------
j11BE
        PLA 
        TAY 
        PLA 
        STA pixelXPosition
        TYA 
        PHA 
        JSR PaintPixel
        PLA 
        STA pixelYPosition
        RTS 

b11CC   LDA #$15
        SEC 
        SBC pixelYPosition
        STA pixelYPosition
        JMP j11BE

b11D6   LDA #$15
        SEC 
        SBC pixelYPosition
        STA pixelYPosition
        JSR PaintPixel
        PLA 
        STA pixelYPosition
        PLA 
        STA pixelXPosition
        RTS 

pixelXPositionArray   .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
        .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$FF
pixelYPositionArray   .BYTE $0E,$0D,$0C,$0B,$0A,$09,$08,$07
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
nextPixelYPositionArray   .BYTE $04,$04,$04,$04,$04,$04,$04,$04
        .BYTE $04,$04,$04,$04,$04,$04,$04,$04
        .BYTE $04,$04,$04,$04,$04,$04,$04,$04
        .BYTE $04,$04,$04,$04,$04,$04,$04,$00
f12A7   .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$01,$01,$00
;-------------------------------------------------------------------------
; ReinitializeSequences
;-------------------------------------------------------------------------
ReinitializeSequences
        LDX #$00
        LDA #$FF
b12CB   STA f1227,X
        INX 
        CPX #$20
        BNE b12CB
        LDA #$00
        STA timerBetweenKeyStrokes
        STA currentPatternElement
        STA a13
        STA a17
        LDA #$01
        STA currentSymmetrySetting
        STA currentModeActive
        RTS 

;-------------------------------------------------------------------------
; LaunchPsychedelia
;-------------------------------------------------------------------------
LaunchPsychedelia
        JSR SetUpInterruptHandler
        JSR ReinitializeScreen
        JSR ReinitializeSequences
        JSR ClearLastLineOfScreen
        JSR SetUpInterruptHandler

;-------------------------------------------------------------------------
; MainPaintRoutine
;-------------------------------------------------------------------------
MainPaintRoutine
        INC stepCount

        ; Left/Right cursor key pauses the paint animation.
        ; This section just loops around if the left/right keys
        ; are pressed and keeps looping until they're pressed again.
        LDA lastKeyPressed
        CMP #$17
        BNE b130F
b12FD   LDA lastKeyPressed
        CMP #$40
        BNE b12FD
b1303   LDA lastKeyPressed
        CMP #$17
        BNE b1303
b1309   LDA lastKeyPressed
        CMP #$40
        BNE b1309

b130F   LDA currentModeActive
        BEQ b1317
        JSR ReinitializeScreen

b1317   LDA stepCount
        CMP a14C0
        BNE b1324
        LDA #$00
        STA stepCount
b1324   LDX stepCount
        LDA f1227,X
        CMP #$FF
        BNE b1333
        STX a13
        JMP MainPaintRoutine

b1333   STA currentIndexToColorValues
        DEC f1267,X
        BNE b135F
        LDA f1247,X
        STA f1267,X

        LDA pixelXPositionArray,X
        STA pixelXPosition
        LDA pixelYPositionArray,X
        STA pixelYPosition

        LDA nextPixelYPositionArray,X
        STA dataPtrIndex

        LDA f12A7,X
        STA a14
        TXA 
        PHA 
        JSR LoopeThroughPixelsAndPaint
        PLA 
        TAX 
        DEC f1227,X
b135F   JMP MainPaintRoutine

stepCount   .BYTE $19
;-------------------------------------------------------------------------
; SetUpInterruptHandler
;-------------------------------------------------------------------------
SetUpInterruptHandler
        SEI 
        LDA #<MainInterruptHandler
        STA RAM_CINV
        LDA #>MainInterruptHandler
        STA a0315
        LDA #$0A
        STA pixelXPositionMain
        STA colorRamLineTableIndex
        CLI 
        RTS 

counteStepsBeforeCheckingJoystickInput   .BYTE $01,$00
;---------------------------------------------------------------------------------
; MainInterruptHandler   
;---------------------------------------------------------------------------------
MainInterruptHandler   
        DEC counteStepsBeforeCheckingJoystickInput
        BEQ b1382
        JMP JumpToCheckKeyboardInput

b1382   LDA #$00
        STA currentColorToPaint
        LDA a14BF
        STA counteStepsBeforeCheckingJoystickInput
        JSR UpdateLineInColorRamUsingIndex

        JSR GetJoystickInput
        LDA lastJoystickInput
        AND #$03
        CMP #$03
        BEQ b13BF

        CMP #$02
        BEQ b13A4 ; Player has pressed down

        ; Player has pressed up. Incremeent up two lines
        ; so that when we decrement down one, we're still
        ; one up!
        INC colorRamLineTableIndex
        INC colorRamLineTableIndex

b13A4   DEC colorRamLineTableIndex
        LDA colorRamLineTableIndex
        CMP #$FF
        BNE b13B6
        LDA #$15
        STA colorRamLineTableIndex
        JMP b13BF

b13B6   CMP #$16
        BNE b13BF
        LDA #$00
        STA colorRamLineTableIndex

        ;Player has pressed left or right?
b13BF   LDA lastJoystickInput
        AND #$0C
        CMP #$0C
        BEQ b13EC

        CMP #$08
        BEQ b13D1 ; Pressed left.

        ; Player has pressed right.
        INC pixelXPositionMain
        INC pixelXPositionMain

        ; Player has pressed left.
b13D1   DEC pixelXPositionMain
        ; Handle any wrap around from left to right.
        LDA pixelXPositionMain
        CMP #$FF
        BNE b13E3

        ; Cursor has wrapped around, move it to the extreme
        ; right of the screen.
        LDA #$15
        STA pixelXPositionMain
        JMP b13EC

        ; Handle any wrap around from right to left.
b13E3   CMP #$16
        BNE b13EC
        LDA #$00
        STA pixelXPositionMain

b13EC   LDA lastJoystickInput
        AND #$80
        BEQ b13FA

        ; Player has pressed fire.
        LDA #$00
        STA stepsSincePressedFire
        JMP DrawWhiteCursor

        ; Player hasn't pressed fire.
b13FA   LDA a14BC
        BEQ b140A
        LDA stepsSincePressedFire
        BEQ b1407
        JMP DrawWhiteCursor

b1407   INC stepsSincePressedFire
b140A   LDA a1BC4
        BEQ b1417
        DEC a1BC4
        BEQ b1417
        JMP UpdateDisplayedPattern

b1417   DEC a1984
        BEQ b141F
        JMP DrawWhiteCursor

b141F   LDA a14C1
        STA a1984
        LDA a14C5
        STA a1BC4

;-------------------------------------------------------------------------
; UpdateDisplayedPattern
;-------------------------------------------------------------------------
UpdateDisplayedPattern
        INC a14BA
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
        AND trackingActivated
        BEQ DrawWhiteCursor
        TAX 
        LDA f1227,X
        CMP #$FF
        BNE DrawWhiteCursor
        STX a14BA

b1455   LDA pixelXPositionMain
        STA pixelXPositionArray,X
        LDA colorRamLineTableIndex
        STA pixelYPositionArray,X
        LDA lineModeActivated
        BEQ b1474
        LDA #$19
        SEC 
        SBC colorRamLineTableIndex
        ORA #$80
        STA f1227,X
        JMP j147F

b1474   LDA a14C6
        STA f1227,X
        LDA currentPatternElement
        STA nextPixelYPositionArray,X

;-------------------------------------------------------------------------
; j147F
;-------------------------------------------------------------------------
j147F
        LDA a14BE
        STA f1247,X
        STA f1267,X
        LDA currentSymmetrySetting
        STA f12A7,X

;-------------------------------------------------------------------------
; DrawWhiteCursor
;-------------------------------------------------------------------------
DrawWhiteCursor
        LDA #$01
        STA currentColorToPaint
        JSR UpdateLineInColorRamUsingIndex

;-------------------------------------------------------------------------
; JumpToCheckKeyboardInput
;-------------------------------------------------------------------------
JumpToCheckKeyboardInput
        JSR CheckKeyboardInput
        JMP ROM_IRQ  ;$EABF - IRQ interrupt handler

;-------------------------------------------------------------------------
; GetColorRAMPtrFromLineTableUsingIndex
;-------------------------------------------------------------------------
GetColorRAMPtrFromLineTableUsingIndex
        LDX colorRamLineTableIndex
        LDA colorRamLineTableLoPtrArray,X
        STA colorRamTableLoPtr
        LDA colorRamLineTableHiPtrArray,X
        STA colorRamTableHiPtr
        LDY pixelXPositionMain
b14AA   RTS 

;-------------------------------------------------------------------------
; UpdateLineInColorRamUsingIndex
;-------------------------------------------------------------------------
UpdateLineInColorRamUsingIndex
        LDA a1BC5
        BNE b14AA
        JSR GetColorRAMPtrFromLineTableUsingIndex
        LDA currentColorToPaint
        STA (colorRamTableLoPtr),Y
        RTS 

pixelXPositionMain   .BYTE $0F
colorRamLineTableIndex   .BYTE $12
a14BA   .BYTE $10
stepsSincePressedFire   .BYTE $00
a14BC   .BYTE $00
colorBarCurrentValueForModePtr   .BYTE $00
a14BE   .BYTE $0C
a14BF   .BYTE $02
a14C0   .BYTE $1F
a14C1   .BYTE $01
a14C2   .BYTE $07,$07,$04
a14C5   .BYTE $01
a14C6   .BYTE $07
presetColorValuesArray   .BYTE $00,$06,$02,$03,$04,$05,$07,$01
trackingActivated   .BYTE $00
lineModeActivated   .BYTE $00
dataPtrIndex   .BYTE $04

; A pair of arrays together consituting a list of pointers
; to positions in memory containing X position data.
; (i.e. $097C, $0E93,$0EC3, $0F07, $0F23, $0F57, $1161, $11B1)
pixelXPositionLoPtrArray   .BYTE $2D,$F2,$22,$66,$82,$B6,$FD,$4D
pixelXPositionHiPtrArray   .BYTE $11,$14,$15,$15,$15,$15,$16,$17
pixelYPositionLoPtrArray   .BYTE $54,$0A,$44,$74,$9C,$D2,$25,$6D
pixelYPositionHiPtrArray   .BYTE $11,$15,$15,$15,$15,$15,$17,$17
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
;-------------------------------------------------------------------------
; CheckKeyboardInput
;-------------------------------------------------------------------------
CheckKeyboardInput
        LDA currentVariableMode
        BEQ b15F6
        JMP CheckKeyboardInputForActiveVariable

        ; Allow a bit of time to elapse between detected key strokes.
b15F6   LDA timerBetweenKeyStrokes
        BEQ b15FE
        DEC timerBetweenKeyStrokes
        BNE b160B

b15FE   LDA lastKeyPressed
        CMP #$40
        BNE b160C

        ; No key was pressed. Return early.
        LDA #$00
        STA timerBetweenKeyStrokes
        JSR DisplayDemoModeMessage
b160B   RTS 

        ; A key was pressed. Figure out which one.
b160C   LDY a16FC
        STY timerBetweenKeyStrokes
        LDY shiftKey
        STY shiftPressed

        CMP #$20
        BNE b1624

        ; Space pressed. Selects a new pattern element. " There are eight permanent ones,
        ; and eight you can define for yourself (more on this later!). The latter eight
        ; are all set up when you load, so you can always choose from 16 shapes."
        INC currentPatternElement
        LDA currentPatternElement
        AND #$07
        STA currentPatternElement
        RTS 

b1624   CMP #$29
        BNE b164C
        INC currentSymmetrySetting
        LDA currentSymmetrySetting

        CMP #$05
        BNE b1634
        LDA #$00
        STA currentSymmetrySetting

b1634   ASL 
        ASL 
        ASL 
        TAY 
        JSR ClearLastLineOfScreen

        LDX #$00
b163D   LDA txtPresetPatternNames,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$08
        BNE b163D
        JMP WriteLastLineBufferToScreen

b164C   CMP #$12
        BNE b1656
        LDA #$01
        STA currentVariableMode
        RTS 

b1656   CMP #$22
        BNE b1660
        LDA #$02
        STA currentVariableMode
        RTS 

b1660   CMP #$23
        BNE b166A
        LDA #$03
        STA currentVariableMode
        RTS 

b166A   CMP #$0D
        BNE b1674
        LDA #$04
        STA currentVariableMode
        RTS 

b1674   CMP #$2B
        BNE b1682
        LDA #$01
        STA currentColorSet
        LDA #$05
        STA currentVariableMode
        RTS 

b1682   CMP #$32
        BNE b16A9
        LDA trackingActivated
        EOR #$FF
        STA trackingActivated
        AND #$01
        ASL 
        ASL 
        ASL 
        TAY 
        JSR ClearLastLineOfScreen

        LDX #$00
b1699   LDA txtTrackingOnOff,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$08
        BNE b1699
        JMP WriteLastLineBufferToScreen

        RTS 

b16A9   LDX #$00
b16AB   CMP presetKeyCodes,X
        BEQ b16B8
        INX 
        CPX #$10
        BNE b16AB
        JMP j16BB

b16B8   JMP DisplayPresetMessage

;-------------------------------------------------------------------------
; j16BB
;-------------------------------------------------------------------------
j16BB
        CMP #$34
        BNE b16C5
        LDA #$08
        STA currentVariableMode
        RTS 

b16C5   CMP #$0E
        BNE b16CF
        LDA #$09
        STA currentVariableMode
        RTS 

b16CF   CMP #$36
        BNE b16EE
        INC a1B03
        LDA a1B03
        AND #$0F
        TAY 
        LDA f1B04,Y
        LDX #$00
b16E1   STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $00E4,X
        DEX 
        BNE b16E1
        STA currentPixel
        RTS 

b16EE   CMP #$11
        BNE b16FB
        LDA demoModeActive
        EOR #$01
        STA demoModeActive
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
        .BYTE $55
lastLineTextBuffer =*-$01
lastLineBufferPtr   .BYTE $20,$20,$20,$20,$20,$20
a1793   .BYTE $20
a1794   .BYTE $20
f1795   .BYTE $20,$20,$20,$20,$20,$20,$20,$20
        .BYTE $20,$20,$20,$20,$20,$20
;-------------------------------------------------------------------------
; ClearLastLineOfScreen
;-------------------------------------------------------------------------
ClearLastLineOfScreen
        LDX #$16
b17A5   LDA #$20
        STA lastLineTextBuffer,X
        STA SCREEN_RAM + $01E3,X
        DEX 
        BNE b17A5
        RTS 

;-------------------------------------------------------------------------
; WriteLastLineBufferToScreen
;-------------------------------------------------------------------------
WriteLastLineBufferToScreen
        LDX #$16
b17B3   LDA lastLineTextBuffer,X
        AND #$3F
        STA SCREEN_RAM + $01E3,X
        LDA #$03
        STA COLOR_RAM + $01E3,X
        DEX 
        BNE b17B3
        RTS 

txtPresetPatternNames   .BYTE $CE,$CF,$A0,$D3,$D9,$CD,$A0,$A0
        .BYTE $D9,$AD,$D3,$D9,$CD,$A0,$A0,$A0
        .BYTE $D8,$AD,$D9,$A0,$D3,$D9,$CD,$A0
        .BYTE $D8,$AD,$D3,$D9,$CD,$A0,$A0,$A0
        .BYTE $D1,$D5,$C1,$C4,$A0,$D3,$D9,$CD

;-------------------------------------------------------------------------
; DrawColorValueBar
;-------------------------------------------------------------------------
DrawColorValueBar
        ; Shift the pointer from SCREEN_RAM ($0400) to COLOR_RAM ($D800)
        LDA colorBarColorRamHiPtr
        PHA 
        CLC 
        ADC #$78
        STA colorBarColorRamHiPtr

        ; Draw the colors from the bar to color ram.
        LDY #$00
b17F6   LDA colorBarValues,Y
        STA (colorBarColorRamLoPtr),Y
        INY 
        CPY #$08
        BNE b17F6

        PLA 
        STA colorBarColorRamHiPtr
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
        STA (colorBarColorRamLoPtr),Y
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
ResetSelectedVariableAndReturn   LDA #$00
        STA currentVariableMode
        RTS 

;-------------------------------------------------------------------------
; CheckKeyboardInputForActiveVariable
;-------------------------------------------------------------------------
CheckKeyboardInputForActiveVariable
        ; The active variable is one with a sliding scale.
        ; Allow a bit of time between detected keystrokes.
        LDA timerBetweenKeyStrokes
        BEQ b185D
        DEC timerBetweenKeyStrokes
        JMP DisplayVariableSelection
        ; Returns

b185D   LDA lastKeyPressed
        CMP #$40
        BNE b1866
        ; No key pressed. Just display the active variable mode and return.
        JMP DisplayVariableSelection
        ; Returns

        ; Display the current active variable
b1866   LDA #$04
        STA timerBetweenKeyStrokes

        LDA currentVariableMode
        CMP #$05 ; Color Change
        BEQ b1875
        CMP #$03 ; Buffer Length
        BNE b1893

        ; The active mode is 'COlor Change'.
b1875   LDX #$00
b1877   LDA f1227,X
        CMP #$FF
        BNE ResetSelectedVariableAndReturn

        INX 
        CPX a14C0
        BNE b1877

        ; Reset the selected variable if necessary.
        LDA demoModeActive
        BNE ResetSelectedVariableAndReturn
        LDA #$FF
        STA currentModeActive
        LDA #$00
        STA a14BA

        ; Missed in the conversion? This should point to SCREEN_RAM, i.e.
        ; SCREEN_RAM + 3FD0
b1893   LDA #>p07D0
        STA colorBarColorRamHiPtr
        LDA #<p07D0
        STA colorBarColorRamLoPtr

        LDX currentVariableMode
        LDA lastKeyPressed
        CMP #$25
        BNE b18B5

        ; > pressed, increase the value bar.
        INC colorBarCurrentValueForModePtr,X
        LDA colorBarCurrentValueForModePtr,X
        ; Make sure we don't exceed the max value.
        CMP colorBarMaxValueForModePtr,X
        BNE b18C7
        DEC colorBarCurrentValueForModePtr,X
        JMP b18C7

b18B5   CMP #$1D
        BNE b18C7
        DEC colorBarCurrentValueForModePtr,X
        LDA colorBarCurrentValueForModePtr,X
        CMP colorBarMinValueForModePtr,X
        BNE b18C7
        INC colorBarCurrentValueForModePtr,X
b18C7   CPX #$05
        BNE b18D6
        LDX a14C2
        LDY currentColorSet
        LDA colorValuesPtr,X
        STA presetColorValuesArray,Y

b18D6   JSR DisplayVariableSelection
        JMP CheckIfEnterPressed

;-------------------------------------------------------------------------
; DisplayVariableSelection
;-------------------------------------------------------------------------
DisplayVariableSelection
        LDA #>SCREEN_RAM + $01EC
        STA colorBarColorRamHiPtr
        LDA #<SCREEN_RAM + $01EC
        STA colorBarColorRamLoPtr

        LDX currentVariableMode
        CPX #$05
        BNE b1902

        ; Current variable mode is 'color change'
        LDX currentColorSet
        LDA presetColorValuesArray,X
        LDY #$00
b18F2   CMP colorValuesPtr,Y
        BEQ b18FC
        INY 
        CPY #$10
        BNE b18F2
b18FC   STY a14C2
        LDX currentVariableMode

b1902   LDA f1979,X
        STA a1840
        LDA colorBarCurrentValueForModePtr,X
        STA a1842
        TXA 
        PHA 
        LDA a1B02
        BNE b191D
        LDA #$01
        STA a1B02
        JSR ClearLastLineOfScreen

b191D   PLA 
        ASL 
        ASL 
        ASL 
        TAY 
        LDX #$00
b1924   LDA txtVariableLabels,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$08
        BNE b1924
        LDA currentVariableMode
        CMP #$05
        BNE b193F
        LDA #$30
        CLC 
        ADC currentColorSet
        STA a1794
b193F   JSR WriteLastLineBufferToScreen
        JMP DrawColorValueBar

;-------------------------------------------------------------------------
; CheckIfEnterPressed
;-------------------------------------------------------------------------
CheckIfEnterPressed
        LDA lastKeyPressed
        CMP #$0F
        BEQ b194C
        RTS 

        ; Enter pressed
b194C   LDA currentVariableMode
        CMP #$05
        BNE b195C

        ; In Color Change mode, move to the next color set
        ; until you reach the last one.
        INC currentColorSet
        LDA currentColorSet
        CMP #$08
        BEQ b195C
        RTS 

        ; Enter was pressed, so exit variable mode.
b195C   LDA #$00
        STA currentVariableMode
        STA a1B02
        RTS 

colorBarMaxValueForModePtr   .BYTE $00,$40,$08,$20,$10,$08,$08,$20
        .BYTE $10,$08
colorBarMinValueForModePtr   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00
f1979   .BYTE $00,$01,$08,$01,$04,$08,$08,$02
        .BYTE $04,$08
currentVariableMode   .BYTE $00
a1984   .BYTE $01
txtVariableLabels   .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $C4,$C5,$CC,$C1,$D9,$BA,$A0,$A0
        .BYTE $C3,$D3,$D0,$C5,$C5,$C4,$BA,$A0
        .BYTE $C2,$CC,$C5,$CE,$C7,$D4,$C8,$BA
        .BYTE $D0,$D3,$D0,$C5,$C5,$C4,$BA,$A0
        .BYTE $C3,$CF,$CC,$CF,$D5,$D2,$A0,$B0
        .BYTE $CC,$D7,$C9,$C4,$D4,$C8,$BA,$A0
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        .BYTE $D0,$D7,$C9,$C4,$D4,$C8,$BA,$A0
        .BYTE $C2,$C1,$D3,$C5,$BA,$A0,$A0,$A0
colorValuesPtr   .BYTE $00
colorBarValues   .BYTE $06,$02,$04,$05,$03,$07,$01
txtTrackingOnOff   .BYTE $D4,$D2,$AE,$CF,$C6,$C6,$A0,$A0
        .BYTE $D4,$D2,$AE,$CF,$CE,$A0,$A0,$A0
;-------------------------------------------------------------------------
; DisplayPresetMessage
;-------------------------------------------------------------------------
DisplayPresetMessage
        TXA 
        PHA 
        JSR ClearLastLineOfScreen
        LDX #$00
b19F4   LDA txtPreset,X
        STA lastLineBufferPtr,X
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

b1A19   JMP DrawPresetActivatedMessage

;-------------------------------------------------------------------------
; WriteLastLineBufferAndReturn
;-------------------------------------------------------------------------
WriteLastLineBufferAndReturn
        JSR WriteLastLineBufferToScreen
        RTS 

txtPreset   .BYTE $D0,$D2,$C5,$D3,$C5,$D4,$B0,$B0
txtPresetActivatedStored   .BYTE $A0,$C1,$C3,$D4,$C9,$D6,$C5,$A0
        .BYTE $A0,$D3,$C5,$D4,$A0,$D5,$D0,$A0
shiftPressed   .BYTE $00
;-------------------------------------------------------------------------
; DrawPresetActivatedMessage
;-------------------------------------------------------------------------
DrawPresetActivatedMessage
        LDA shiftPressed
        AND #$01
        ASL 
        ASL 
        ASL 
        TAY 
        LDX #$00
b1A44   LDA txtPresetActivatedStored,Y
        STA f1795,X
        INY 
        INX 
        CPX #$08
        BNE b1A44

        LDA shiftPressed
        AND #$01
        BNE b1A5A
        JMP j1A7A

b1A5A   PLA 
        TAX 
        JSR UpdatePointersForPreset
        LDY #$00
        LDX #$00
b1A63   LDA colorBarCurrentValueForModePtr,X
        STA (p1B),Y
        INY 
        INX 
        CPX #$15
        BNE b1A63
        LDA currentPatternElement
        STA (p1B),Y
        INY 
        LDA currentSymmetrySetting
        STA (p1B),Y
        JMP WriteLastLineBufferAndReturn

;-------------------------------------------------------------------------
; j1A7A
;-------------------------------------------------------------------------
j1A7A
        PLA 
        TAX 
        JSR UpdatePointersForPreset
        LDY #$03
        LDA (p1B),Y
        CMP a14C0
        BEQ b1A8E
        JSR ResetCurrentActiveMode
        JMP j1AA2

b1A8E   LDX #$00
        LDY #$07
b1A92   LDA (p1B),Y
        CMP presetColorValuesArray,X
        BNE j1AA2
        INY 
        INX 
        CPX #$08
        BNE b1A92
        JMP j1AA2

;-------------------------------------------------------------------------
; j1AA2
;-------------------------------------------------------------------------
j1AA2
        LDA #$FF
        STA currentModeActive
        LDY #$00
b1AA9   LDA (p1B),Y
        STA colorBarCurrentValueForModePtr,Y
        INY 
        CPY #$15
        BNE b1AA9
        LDA (p1B),Y
        STA currentPatternElement
        INY 
        LDA (p1B),Y
        STA currentSymmetrySetting
        JMP WriteLastLineBufferAndReturn

;-------------------------------------------------------------------------
; UpdatePointersForPreset
;-------------------------------------------------------------------------
UpdatePointersForPreset
        LDA #>p1C00
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

;-------------------------------------------------------------------------
; ResetCurrentActiveMode
;-------------------------------------------------------------------------
ResetCurrentActiveMode
        LDA #$FF
        STA currentModeActive
        LDA #$00
        STA a14BA
        RTS 

currentModeActive   .BYTE $00
;-------------------------------------------------------------------------
; ReinitializeScreen
;-------------------------------------------------------------------------
ReinitializeScreen
        LDA #$00
        STA stepCount
        STA a13
        LDX #$00
        LDA #$FF
b1AF2   STA f1227,X
        INX 
        CPX #$20
        BNE b1AF2
        LDA #$00
        STA currentModeActive
        JMP InitializeScreenWithInitCharacter

a1B02   .BYTE $00
a1B03   .BYTE $10
f1B04   .BYTE $CF,$51,$53,$5A,$5B,$5F,$57,$7F
        .BYTE $56,$61,$4F,$66,$6C,$EC,$A0,$2A
demoModeActive   .BYTE $00
a1B15   .BYTE $01
a1B16   .BYTE $80
;-------------------------------------------------------------------------
; PerformRandomJoystickMovememnt
;-------------------------------------------------------------------------
PerformRandomJoystickMovememnt
        DEC a1B15
        BEQ b1B1D
        RTS 

b1B1D   JSR PutRandomByteInAccumulator
        AND #$1F
        ORA #$01
        STA a1B15
        LDA a1B16
        EOR #$80
        STA a1B16
        JSR PutRandomByteInAccumulator
        AND #$0F
        ORA a1B16
        EOR #$8F
        STA lastJoystickInput
        DEC a1B87
        BEQ b1B41
        RTS 

b1B41   JSR PutRandomByteInAccumulator
        AND #$07
b1B46   ADC #$20
        STA a1B87
        JSR PutRandomByteInAccumulator
        AND #$0F
        TAX 
        LDA #$00
        STA shiftPressed
        JMP DisplayPresetMessage

;-------------------------------------------------------------------------
; DisplayDemoModeMessage
;-------------------------------------------------------------------------
DisplayDemoModeMessage
        LDA demoModeActive
        BNE b1B61
        JMP ClearLastLineOfScreen

b1B61   LDX #$00
b1B63   LDA f1B71,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$16
        BNE b1B63
        JMP WriteLastLineBufferToScreen

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

;-------------------------------------------------------------------------
; GetJoystickInput
;-------------------------------------------------------------------------
GetJoystickInput
        LDA demoModeActive
        BEQ b1B90
        JMP PerformRandomJoystickMovememnt

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
        STA lastJoystickInput
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
