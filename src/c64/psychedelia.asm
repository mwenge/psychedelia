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


pixelXPositionZP          = $02
pixelYPositionZP          = $03
currentIndexToColorValues = $04
colorRamTableLoPtr2       = $05
colorRamTableHiPtr2       = $06
previousPixelXPositionZP  = $08
previousPixelYPositionZP  = $09
colorRamTableLoPtr        = $0A
colorRamTableHiPtr        = $0B
currentColorToPaint       = $0C
xPosLoPtr                 = $0D
xPosHiPtr                 = $0E
currentPatternElement     = $0F
yPosLoPtr                = $10
yPosHiPtr                = $11
timerBetweenKeyStrokes    = $12
a13                       = $13
a14                       = $14
currentSymmetrySetting    = $15
a16                       = $16
a17                       = $17
colorBarColorRamLoPtr                       = $18
colorBarColorRamHiPtr                       = $19
currentColorSet           = $1A
presetSequenceDataLoPtr                       = $1B
presetSequenceDataHiPtr                       = $1C
currentSequencePtrLo      = $1D
currentSequencePtrHi      = $1E
a1F                       = $1F
a20                       = $20
lastJoystickInput         = $21
customPresetLoPtr         = $22
customPresetHiPtr         = $23
a24                       = $24
a25                       = $25
a26                       = $26
lastKeyPressed            = $C5
aFB                       = $FB
aFC                       = $FC
aFD                       = $FD
aFE                       = $FE
aFF                       = $FF
;
; **** ZP POINTERS **** 
;
p01 = $01
p1F = $1F
pFB = $FB
pFD = $FD
;
; **** FIELDS **** 
;
SCREEN_RAM  = $0400
COLOR_RAM = $D800
;
; **** ABSOLUTE ADRESSES **** 
;
a0286 = $0286
shiftKey = $028D
a0291 = $0291
a07C6 = $07C6
a07C7 = $07C7
a07C8 = $07C8
a07D1 = $07D1
a7FFF = $7FFF
aC300 = $C300
aC301 = $C301
;
; **** POINTERS **** 
;
p01FF = $01FF
customPresetSequenceData = $C000
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
;-----------------------------------------------------------------------------------
; Start program at InitializeProgram (SYS 2064)
;-----------------------------------------------------------------------------------
        .BYTE $0B,$08,$C1,$07,$9E,$32,$30,$36,$34
        .BYTE $00,$00,$00,$F9
        .BYTE $02,$F9
;-------------------------------------------------------
; InitializeProgram
;-------------------------------------------------------
InitializeProgram
        ; Set border and background to black
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0

        JSR CopyDataFrom2000ToC000

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
b0827   LDA aFC
        STA colorRAMLineTableHiPtrArray,X
        LDA aFB
        STA colorRAMLineTableLoPtrArray,X
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
        STA $0291 ; Disable character set case change

        ; Points character memory to $1000 (i.e. the ROM IMAGE,
        ; rather than the adress in RAM here)
        LDA #$15
        STA $D018    ;VIC Memory Control Register

        JSR ROM_IOINIT ;$FF84 - initialize CIA & IRQ             
        JSR InitializeDynamicStorage
        JMP LaunchPsychedelia

colorRAMLineTableLoPtrArray
      .BYTE $00,$00,$00,$00,$00
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00
      .BYTE $00
colorRAMLineTableHiPtrArray
      .BYTE $00,$00,$00,$00,$00,$00,$BF
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00
      .BYTE $00,$00,$00,$00,$00,$00,$00,$00
      .BYTE $00,$00,$00,$00,$00,$00,$00

;-------------------------------------------------------
; InitializeScreenWithInitCharacter
;-------------------------------------------------------
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

;-------------------------------------------------------
; GetColorRAMPtrFromLineTable
;-------------------------------------------------------
GetColorRAMPtrFromLineTable   
        LDX pixelYPositionZP
        LDA colorRAMLineTableLoPtrArray,X
        STA colorRamTableLoPtr2
        LDA colorRAMLineTableHiPtrArray,X
        STA colorRamTableHiPtr2
        LDY pixelXPositionZP
b08D0   RTS 

;-------------------------------------------------------
; PaintPixel
;-------------------------------------------------------
PaintPixel   
        ; Return early if the index or offset are invalid
        LDA pixelXPositionZP
        AND #$80
        BNE b08D0
        LDA pixelXPositionZP
        CMP #$28
        BPL b08D0
        LDA pixelYPositionZP
        AND #$80
        BNE b08D0
        LDA pixelYPositionZP
        CMP #$18
        BPL b08D0

        JSR GetColorRAMPtrFromLineTable
        LDA a17
        BNE b090D

        LDA (colorRamTableLoPtr2),Y
        AND #$0F

        LDX #$00
b08F6   CMP presetColorValuesArray,X
        BEQ b0900
        INX 
        CPX #$08
        BNE b08F6

b0900   TXA 
        STA aFD
        LDX currentIndexToColorValues
        INX 
        CPX aFD
        BEQ b090D
        BPL b090D
        RTS 

b090D   LDX currentIndexToColorValues
        LDA presetColorValuesArray,X
        STA (colorRamTableLoPtr2),Y
        RTS 

;-------------------------------------------------------
; LoopThroughPixelsAndPaint
;-------------------------------------------------------
LoopThroughPixelsAndPaint   
        JSR PushOffsetAndIndexAndPaintPixel
        LDY #$00
        LDA currentIndexToColorValues
        CMP #$07
        BNE b0921
        RTS 

b0921   LDA #$07
        STA a09CA

        LDA pixelXPositionZP
        STA previousPixelXPositionZP
        LDA pixelYPositionZP
        STA previousPixelYPositionZP

        LDX dataPtrIndex
        LDA pixelXPositionLoPtrArray,X
        STA xPosLoPtr
        LDA pixelXPositionHiPtrArray,X
        STA xPosHiPtr
        LDA pixelYPositionLoPtrArray,X
        STA yPosLoPtr
        LDA pixelYPositionHiPtrArray,X
        STA yPosHiPtr

        ; Paint pixels in the sequence until hitting a break
        ; at $55
b0945   LDA previousPixelXPositionZP
        CLC 
        ADC (xPosLoPtr),Y
        STA pixelXPositionZP
        LDA previousPixelYPositionZP
        CLC 
        ADC (yPosLoPtr),Y
        STA pixelYPositionZP

        ; Push Y to the stack.
        TYA 
        PHA 

        JSR PushOffsetAndIndexAndPaintPixel

        ; Pull Y back from the stack and increment
        PLA 
        TAY 
        INY 

        LDA (xPosLoPtr),Y
        CMP #$55
        BNE b0945

        DEC a09CA
        LDA a09CA
        CMP currentIndexToColorValues
        BEQ b0973
        CMP #$01
        BEQ b0973
        INY 
        JMP b0945

b0973   LDA previousPixelXPositionZP
        STA pixelXPositionZP
        LDA previousPixelYPositionZP
        STA pixelYPositionZP
        RTS 

; Redundant data?
starOneXPosArray
        .BYTE $00,$01,$01,$01,$00
        .BYTE $FF,$FF,$FF,$55,$00,$02,$00,$FE
        .BYTE $55,$00,$03,$00,$FD,$55,$00,$04
        .BYTE $00,$FC,$55,$FF,$01,$05,$05,$01
        .BYTE $FF,$FB,$FB,$55,$00,$07,$00,$F9
        .BYTE $55,$55
starOneYPosArray
        .BYTE $FF,$FF,$00,$01,$01,$01
        .BYTE $00,$FF,$55,$FE,$00,$02,$00,$55
        .BYTE $FD,$00,$03,$00,$55,$FC,$00,$04
        .BYTE $00,$55,$FB,$FB,$FF,$01,$05,$05
        .BYTE $01,$FF,$55,$F9,$00,$07,$00,$55
        .BYTE $55

a09CA   .BYTE $00

;-------------------------------------------------------
; PutRandomByteInAccumulator
;-------------------------------------------------------
PutRandomByteInAccumulator   
a09CC   =*+$01
        LDA $E199,X
        INC a09CC
        RTS 

        BRK #$00
;-------------------------------------------------------
; PushOffsetAndIndexAndPaintPixel
;-------------------------------------------------------
PushOffsetAndIndexAndPaintPixel   
        LDA pixelXPositionZP
        PHA 
        LDA pixelYPositionZP
        PHA 
        JSR PaintPixel
        LDA a14
        BNE b09E9
b09E1   PLA 
        STA pixelYPositionZP
        PLA 
        STA pixelXPositionZP
        RTS 

        .BYTE $60
b09E9   CMP #$03
        BEQ b0A1B
        LDA #$27
        SEC 
        SBC pixelXPositionZP
        STA pixelXPositionZP
        LDY a14
        CPY #$02
        BEQ b0A25
        JSR PaintPixel
        LDA a14
        CMP #$01
        BEQ b09E1
        LDA #$17
        SEC 
        SBC pixelYPositionZP
        STA pixelYPositionZP
        JSR PaintPixel

j0A0D    
        PLA 
        TAY 
        PLA 
        STA pixelXPositionZP
        TYA 
        PHA 
        JSR PaintPixel
        PLA 
        STA pixelYPositionZP
        RTS 

b0A1B   LDA #$17
        SEC 
        SBC pixelYPositionZP
        STA pixelYPositionZP
        JMP j0A0D

b0A25   LDA #$17
        SEC 
        SBC pixelYPositionZP
        STA pixelYPositionZP
        JSR PaintPixel
        PLA 
        STA pixelYPositionZP
        PLA 
        STA pixelXPositionZP
        RTS 

pixelXPositionArray
       .BYTE $00,$00,$FF
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00
pixelYPositionArray
       .BYTE $00,$00,$FD
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00
f0AB6
       .BYTE $00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00
f0AF6
       .BYTE $00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$00
       .BYTE $00,$00,$00,$00,$00,$00,$00,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF
f0B36
       .BYTE $FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF
nextPixelYPositionArray
       .BYTE $FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF
f0BB6
       .BYTE $FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
       .BYTE $FF,$FF,$FF,$FF,$FF

;-------------------------------------------------------
; ReinitializeSequences
;-------------------------------------------------------
ReinitializeSequences
        LDX #$00
        TXA 
b0BF9   STA pixelXPositionArray,X
        STA pixelYPositionArray,X
        LDA #$FF
        STA f0AB6,X
        LDA #$00
        STA f0AF6,X
        STA f0B36,X
        STA nextPixelYPositionArray,X
        STA f0BB6,X
        INX 
p0C13   CPX #$40
        BNE b0BF9
        STA timerBetweenKeyStrokes
        STA currentPatternElement
        STA a13
        STA a17
        LDA #$01
        STA currentSymmetrySetting
        RTS 

;-------------------------------------------------------
; LaunchPsychedelia
;-------------------------------------------------------
LaunchPsychedelia    
        JSR SetUpInterruptHandlers

        LDX #$10
b0C29   TXA 
        STA SetUpInterruptHandlers,X
        DEX 
        BNE b0C29

        JSR ReinitializeScreen
        JSR ReinitializeSequences
        JSR ClearLastLineOfScreen

;-------------------------------------------------------
; MainPaintRoutine
;-------------------------------------------------------
MainPaintRoutine    
        INC stepCount

        ; Left/Right cursor key pauses the paint animation.
        ; This section just loops around if the left/right keys
        ; are pressed and keeps looping until they're pressed again.
        LDA lastKeyPressed
        CMP #$02 ; Left/Right cursor key
        BNE b0C54
b0C42   LDA lastKeyPressed
        CMP #$40 ;  No key pressed
        BNE b0C42
b0C48   LDA lastKeyPressed
        CMP #$02 ; Left/Right cursor key
        BNE b0C48
b0C4E   LDA lastKeyPressed
        CMP #$40 ;No key pressed
        BNE b0C4E

b0C54   LDA currentModeActive
        BEQ b0C6A
        CMP #$17 ; Custom Preset active?
        BNE b0C60
        ; Custom Preset active.
        JMP UpdateStuffAndReenterMainPaint

b0C60   CMP #$18 ; Current Mode is 'Save/Prompt'
        BNE b0C67
        JMP DisplaySavePromptScreen

b0C67   JSR ReinitializeScreen
b0C6A   LDA stepCount
        CMP a0E41
        BNE b0C77
        LDA #$00
        STA stepCount
b0C77   LDX stepCount
        LDA f0AB6,X
        CMP #$FF
        BNE b0C86
        STX a13
        JMP MainPaintRoutine

b0C86   STA currentIndexToColorValues
        DEC f0B36,X
        BNE b0CB8
        LDA f0AF6,X
        STA f0B36,X

        LDA pixelXPositionArray,X
        STA pixelXPositionZP
        LDA pixelYPositionArray,X
        STA pixelYPositionZP

        LDA nextPixelYPositionArray,X
        STA dataPtrIndex

        LDA f0BB6,X
        STA a14
        LDA currentIndexToColorValues
        AND #$80
        BNE b0CBC
        TXA 
        PHA 
        JSR LoopThroughPixelsAndPaint
        PLA 
        TAX 
        DEC f0AB6,X
b0CB8   JMP MainPaintRoutine

stepCount   .BYTE $00
b0CBC
        ; Loops back to MainPaintRoutine
        JMP ResetAndReenterMainPaint

;-------------------------------------------------------
; SetUpInterruptHandlers
;-------------------------------------------------------
SetUpInterruptHandlers
        SEI
        LDA #<MainInterruptHandler
        STA $0314    ;IRQ
        LDA #>MainInterruptHandler
        STA $0315    ;IRQ

        LDA #$0A
        STA pixelXPosition
        STA colorRAMLineTableIndex

        LDA #$01
        STA $D015    ;Sprite display Enable
        STA $D027    ;Sprite 0 Color
        LDA #<NMIInterruptHandler
        STA $0318    ;NMI
        LDA #>NMIInterruptHandler
        STA $0319    ;NMI
        CLI 
        RTS 

countStepsBeforeCheckingJoystickInput   .BYTE $02,$00
;-------------------------------------------------------
; MainInterruptHandler
;-------------------------------------------------------
MainInterruptHandler
        LDA stepsRemainingInSequencerSequence
        BEQ b0CFB
        DEC stepsRemainingInSequencerSequence
        BNE b0CFB

        LDA a0E45
        STA stepsRemainingInSequencerSequence
        JSR UpdatePointersFromSequenceData

b0CFB   DEC countStepsBeforeCheckingJoystickInput
        BEQ b0D03
        JMP JumpToCheckKeyboardInput
        ;Returns?

        ; Once in every 256 interrupts, check the joystick
        ; for input and act on it.
b0D03   LDA #$00
        STA currentColorToPaint
        LDA a0E40
        STA countStepsBeforeCheckingJoystickInput
        JSR UpdateLineinColorRAMUsingIndex

        JSR GetJoystickInput
        LDA lastJoystickInput
        AND #$03
        CMP #$03
        BEQ b0D40 ; Neither up nor down have been pushed.

        CMP #$02
        BEQ b0D25 ; Player has pressed down.
        
        ; Player has pressed up. Incremeent up two lines
        ; so that when we decrement down one, we're still
        ; one up!
        INC colorRAMLineTableIndex
        INC colorRAMLineTableIndex

        ; Player has pressed down.
b0D25   DEC colorRAMLineTableIndex
        LDA colorRAMLineTableIndex
        CMP #$FF
        BNE b0D37
        LDA #$17
        STA colorRAMLineTableIndex
        JMP b0D40

b0D37   CMP #$18
        BNE b0D40
        LDA #$00
        STA colorRAMLineTableIndex

        ; Player has pressed left or right?
b0D40   LDA lastJoystickInput
        AND #$0C
        CMP #$0C
        BEQ b0D6D ; Player has pressed neither left nor right.

        CMP #$08
        BEQ b0D52 ; Player has pressed left.

        ; Player has pressed right.
        INC pixelXPosition
        INC pixelXPosition

        ; Player has pressed left.
b0D52   DEC pixelXPosition
        ; Handle any wrap around from left to right.
        LDA pixelXPosition
        CMP #$FF
        BNE b0D64

        ; Cursor has wrapped around, move it to the extreme
        ; right of the screen.
        LDA #$27
        STA pixelXPosition
        JMP b0D6D

        ; Handle any wrap around from right to left.
b0D64   CMP #$28
        BNE b0D6D
        LDA #$00
        STA pixelXPosition

b0D6D   LDA lastJoystickInput
        AND #$10
        BEQ b0D7B

        ; Player has pressed fire.
        LDA #$00
        STA stepsSincePressedFire
        JMP DrawWhiteCursor

        ; Player hasn't pressed fire.
b0D7B   LDA a0E3D
        BEQ b0D8B
        LDA stepsSincePressedFire
        BEQ b0D88
        JMP DrawWhiteCursor

b0D88   INC stepsSincePressedFire
b0D8B   LDA a1A4A
        BEQ b0D98
        DEC a1A4A
        BEQ b0D98
        JMP UpdateDisplayedPattern

b0D98   DEC a1531
        BEQ b0DA0
        JMP DrawWhiteCursor

b0DA0   LDA a0E42
        STA a1531
        LDA a0E46
        STA a1A4A

UpdateDisplayedPattern    
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
        BEQ DrawWhiteCursor
        TAX 
        LDA f0AB6,X
        CMP #$FF
        BNE DrawWhiteCursor
        STX a0E3B

b0DD6   LDA pixelXPosition
        STA pixelXPositionArray,X
        LDA colorRAMLineTableIndex
        STA pixelYPositionArray,X
        LDA lineModeActivated
        BEQ b0DF5
        LDA #$19
        SEC 
        SBC colorRAMLineTableIndex
        ORA #$80
        STA f0AB6,X
        JMP j0E00

b0DF5   LDA a0E47
        STA f0AB6,X
        LDA currentPatternElement
        STA nextPixelYPositionArray,X

j0E00    
        LDA a0E3F
a0E03   STA f0AF6,X
        STA f0B36,X
        LDA currentSymmetrySetting
        STA f0BB6,X

DrawWhiteCursor    
        LDA #$01
        STA currentColorToPaint
        JSR UpdateLineinColorRAMUsingIndex
        ; Falls through

;-------------------------------------------------------
; JumpToCheckKeyboardInput
;-------------------------------------------------------
JumpToCheckKeyboardInput    
        JSR CheckKeyboardInput
        JMP eEA31

;-------------------------------------------------------
; GetColorRAMPtrFromLineTableUsingIndex
;-------------------------------------------------------
GetColorRAMPtrFromLineTableUsingIndex   
        LDX colorRAMLineTableIndex
        LDA colorRAMLineTableLoPtrArray,X
        STA colorRamTableLoPtr
        LDA colorRAMLineTableHiPtrArray,X
        STA colorRamTableHiPtr
        LDY pixelXPosition
b0E2B   RTS 

;-------------------------------------------------------
; UpdateLineinColorRAMUsingIndex
;-------------------------------------------------------
UpdateLineinColorRAMUsingIndex   
        LDA a1BEB
        BNE b0E2B
        JSR GetColorRAMPtrFromLineTableUsingIndex
        LDA currentColorToPaint
        STA (colorRamTableLoPtr),Y
        RTS 


pixelXPosition            .BYTE $0A
colorRAMLineTableIndex         .BYTE $0A
a0E3B                          .BYTE $00
stepsSincePressedFire                          .BYTE $00
a0E3D                          .BYTE $00
colorBarCurrentValueForModePtr .BYTE $00
a0E3F                          .BYTE $0C
a0E40                          .BYTE $02
a0E41                          .BYTE $1F
a0E42                          .BYTE $01
a0E43                          .BYTE $01
a0E44                          .BYTE $07
a0E45                          .BYTE $04
a0E46                          .BYTE $01
a0E47                          .BYTE $07
presetColorValuesArray         .BYTE $00,$06,$02,$04,$05,$03,$07,$01
trackingActivated              .BYTE $FF
lineModeActivated              .BYTE $00
dataPtrIndex                          .BYTE $05


preset0 = $C800
preset1 = $C900
preset2 = $CA00
preset3 = $CB00
preset4 = $CC00
preset5 = $CD00
preset6 = $CE00
preset7 = $CF00
preset8 = $C880
preset9 = $C980
preset10 = $CA80
preset11 = $CB80
preset12 = $CC80
preset13 = $CD80
preset14 = $CE80
preset15 = $CF80

; A pair of arrays together consituting a list of pointers
; to positions in memory containing X position data.
; (i.e. $097C, $0E93,$0EC3, $0F07, $0F23, $0F57, $1161, $11B1)
pixelXPositionLoPtrArray .BYTE <starOneXPosArray,<theTwistXPosArray,<laLlamitaXPosArray
                         .BYTE <starTwoXPosArray,<deltoidXPosArray,<diffusedXPosArray
                         .BYTE <multicrossXPosArray,<pulsarXPosArray

customPresetLoPtrArray   .BYTE <preset0,<preset1,<preset2,<preset3,<preset4,<preset5,<preset6,<preset7

pixelXPositionHiPtrArray .BYTE >starOneXPosArray,>theTwistXPosArray,>laLlamitaXPosArray
                         .BYTE >starTwoXPosArray,>deltoidXPosArray,>diffusedXPosArray
                         .BYTE >multicrossXPosArray,>pulsarXPosArray

customPresetHiPtrArray   .BYTE >preset0,>preset1,>preset2,>preset3,>preset4,>preset5,>preset6,>preset7

; A pair of arrays together consituting a list of pointers
; to positions in memory containing Y position data.
; (i.e. $097C, $0E93,$0EC3, $0F07, $0F23, $0F57, $1161, $11B1)
pixelYPositionLoPtrArray .BYTE <starOneYPosArray,<theTwistYPosArray,<laLlamitaYPosArray
                         .BYTE <starTwoYPosArray,<deltoidYPosArray,<diffusedYPosArray
                         .BYTE <multicrossYPosArray,<pulsarYPosArray

                         .BYTE <preset8,<preset9,<preset10,<preset11,<preset12,<preset13,<preset14,<preset15

pixelYPositionHiPtrArray .BYTE >starOneYPosArray,>theTwistYPosArray,>laLlamitaYPosArray
                         .BYTE >starTwoYPosArray,>deltoidYPosArray,>diffusedYPosArray
                         .BYTE >multicrossYPosArray,>pulsarYPosArray

                         .BYTE >preset8,>preset9,>preset10,>preset11,>preset12,>preset13,>preset14,>preset15

theTwistXPosArray  .BYTE $00,$55,$01,$02,$55,$01
                   .BYTE $02,$03,$55,$01,$02,$03,$04,$55
                   .BYTE $00,$00,$00,$55,$FF,$FE,$55,$FF
                   .BYTE $55,$55
theTwistYPosArray  .BYTE $FF,$55,$FF,$FE,$55,$00
                   .BYTE $00,$00,$55,$01,$02,$03,$04,$55
                   .BYTE $01,$02,$03,$55,$01,$02,$55,$00
                   .BYTE $55,$55

laLlamitaXPosArray .BYTE $00,$FF,$00,$55,$00,$00
                   .BYTE $55,$01,$02,$03,$00,$01,$02,$03
                   .BYTE $55,$04,$05,$06,$04,$00,$01,$02
                   .BYTE $55,$04,$00,$04,$00,$04,$55,$FF
                   .BYTE $03,$55,$00,$55
laLlamitaYPosArray .BYTE $FF,$00,$01,$55
                   .BYTE $02,$03,$55,$03,$03,$03,$04,$04
                   .BYTE $04,$04,$55,$03,$02,$03,$04,$05
                   .BYTE $05,$05,$55,$05,$06,$06,$07,$07
                   .BYTE $55,$07,$07,$55,$00,$55

starTwoXPosArray   .BYTE $FF,$55
                   .BYTE $00,$55,$02,$55,$01
                   .BYTE $55,$FD,$55
                   .BYTE $FE,$55,$00,$55
starTwoYPosArray   .BYTE $FF,$55,$FE,$55
                   .BYTE $FF,$55,$02,$55,$01,$55,$FC,$55
                   .BYTE $00,$55
deltoidXPosArray   .BYTE $00,$01,$FF,$55,$00,$55
                   .BYTE $00,$01,$02,$FE,$FF,$55,$00,$03
                   .BYTE $FD,$55,$00,$04,$FC,$55,$00,$06
                   .BYTE $FA,$55,$00,$55
deltoidYPosArray   .BYTE $FF,$00,$00,$55
                   .BYTE $00,$55,$FE,$FF,$00,$00,$FF,$55
                   .BYTE $FD,$01,$01,$55,$FC,$02,$02,$55
                   .BYTE $FA,$04,$04,$55,$00,$55
diffusedXPosArray  .BYTE $FF,$01
                   .BYTE $55,$FE,$02,$55,$FD,$03,$55,$FC
                   .BYTE $04,$FC,$FC,$04,$04,$55,$FB,$05
                   .BYTE $55,$FA,$06,$FA,$FA,$06,$06,$55
                   .BYTE $00,$55
diffusedYPosArray  .BYTE $01,$FF,$55,$FE,$02,$55
                   .BYTE $03,$FD,$55,$FC,$04,$FF,$01,$FF
                   .BYTE $01,$55,$05,$FB,$55,$FA,$06,$FE
                   .BYTE $02,$FE,$02,$55,$00,$55


;-------------------------------------------------------
; CheckKeyboardInput
;-------------------------------------------------------
CheckKeyboardInput   
        LDA currentVariableMode
        BEQ b0F97
        JMP CheckKeyboardInputForActiveVariable

        ; Allow a bit of time to elapse between detected key strokes.
b0F97   LDA timerBetweenKeyStrokes
        BEQ b0F9F
        DEC timerBetweenKeyStrokes
        BNE b0FAC

b0F9F   LDA lastKeyPressed
        CMP #$40
        BNE b0FAD

        ; No key was pressed. Return early.
        LDA #$00
        STA timerBetweenKeyStrokes
        JSR DisplayDemoModeMessage
b0FAC   RTS 

        ; A key was pressed. Figure out which one.
b0FAD   LDY a1160
        STY timerBetweenKeyStrokes
        LDY shiftKey
        STY shiftPressed

        CMP #$3C ; Space pressed?
        BNE b0FE6

        ; Space pressed. Selects a new pattern element. " There are eight permanent ones,
        ; and eight you can define for yourself (more on this later!). The latter eight
        ; are all set up when you load, so you can always choose from 16 shapes."
        INC currentPatternElement
        LDA currentPatternElement
        AND #$0F
        STA currentPatternElement
        AND #$08
        BEQ b0FCB
        ; The first 8 patterns are standard, the rest are custom.
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

        ; 'S' pressed. "This changes the 'symmetry'. The pattern gets reflected
        ; in various planes, or not at all according to the setting."
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

        ; 'L' pressed. Turn line mode on or off.
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
        STA currentVariableMode
        RTS 

b105C   CMP #$14 ; C pressed?
        BNE b1066
        ; C pressed.
        LDA #$02
        STA currentVariableMode
        RTS 

b1066   CMP #$1C ; B pressed?
        BNE b1070
        ; B pressed.
        LDA #$03
        STA currentVariableMode
        RTS 

b1070   CMP #$29 ; P pressed
        BNE b107A
        ; P pressed.
        LDA #$04
        STA currentVariableMode
        RTS 

b107A   CMP #$1D ; H pressed.
        BNE b1088
        ; H pressed. Select a change to the pattern colors.
        LDA #$01
        STA currentColorSet
        LDA #$05
        STA currentVariableMode
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

j10C2    
        CMP #$09 ; W pressed?
        BNE b10CC
        ; W pressed
        LDA #$06
        STA currentVariableMode
        RTS 

        ; Was one of the function keys pressed?
b10CC   LDX #$00
b10CE   CMP functionKeys,X
        BEQ b10DB ; One of them was pressed!
        INX 
        CPX #$04
        BNE b10CE
        ; Continue checking
        JMP j10EC

        ; A Function key was pressed, only valid if the sequencer is active.
b10DB   STX functionKeyIndex
        LDA sequencerActive
        BNE j10EC
        LDA #$80
        STA currentVariableMode
        JSR UpdateSequencer
        RTS 

j10EC    
        CMP #$3E ; Q pressed?
        BNE b1108
        ; Q was presed. Toggle the sequencer on or off.
        LDA sequencerActive
        BNE b10FD
        LDA #$80
        STA currentVariableMode
        JMP ActivateSequencer
        ;Returns

        ;Turn the sequencer off.
b10FD   LDA #$00
        STA sequencerActive
        STA stepsRemainingInSequencerSequence
        JMP DisplaySequencerState

b1108   CMP #$1F ; V pressed?
        BNE b1112
        ; V pressed.
        LDA #$07
        STA currentVariableMode
        RTS 

b1112   CMP #$26 ; O pressed.
        BNE b111C
        ; O pressed.
        LDA #$08
        STA currentVariableMode
        RTS 

b111C   CMP #$31 ; * pressed?
        BNE b1126
        ; * pressed.
        LDA #$09
        STA currentVariableMode
        RTS 

b1126   CMP #$11 ; R pressed?
        BNE b112D
        ; R was pressed. Stop or start recording.
        JMP StopOrStartRecording

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
multicrossXPosArray
        .BYTE $01,$01,$FF,$FF,$55,$02,$02,$FE
        .BYTE $FE,$55,$01,$03,$03,$01,$FF,$FD
        .BYTE $FD,$FF,$55,$03,$03,$FD,$FD,$55
        .BYTE $04,$04,$FC,$FC,$55,$03,$05,$05
        .BYTE $03,$FD,$FB,$FB,$FD,$55,$00,$55
multicrossYPosArray
        .BYTE $FF,$01,$01,$FF,$55,$FE,$02,$02
        .BYTE $FE,$55,$FD,$FF,$01,$03,$03,$01
        .BYTE $FF,$FD,$55,$FD,$03,$03,$FD,$55
        .BYTE $FC,$04,$04,$FC,$55,$FB,$FD,$03
        .BYTE $05,$05,$03,$FD,$FB,$55,$00,$55
pulsarXPosArray
        .BYTE $00,$01,$00,$FF,$55,$00,$02,$00
        .BYTE $FE,$55,$00,$03,$00,$FD,$55,$00
        .BYTE $04,$00,$FC,$55,$00,$05,$00,$FB
        .BYTE $55,$00,$06,$00,$FA,$55,$00,$55
pulsarYPosArray
        .BYTE $FF,$00,$01,$00,$55,$FE,$00,$02
        .BYTE $00,$55,$FD,$00,$03,$00,$55,$FC
        .BYTE $00,$04,$00,$55,$FB,$00,$05,$00
        .BYTE $55,$FA,$00,$06,$00,$55,$00
lastLineBufferPtrMinusOne
        .BYTE $55
lastLineBufferPtr
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF
a11F7
        .BYTE $FF
a11F8
        .BYTE $FF
a11F9
        .BYTE $FF
        .BYTE $FF
        .BYTE $FF
        .BYTE $FF
        .BYTE $FF
customPatternValueBufferPtr
        .BYTE $FF
        .BYTE $FF
        .BYTE $FF
f1201
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00


;-------------------------------------------------------
; ClearLastLineOfScreen
;-------------------------------------------------------
ClearLastLineOfScreen   
        
        LDX #$28
b121B   LDA #$20
        STA lastLineBufferPtrMinusOne,X
        STA SCREEN_RAM + $03BF,X
        DEX 
        BNE b121B
        RTS 

;-------------------------------------------------------
; WriteLastLineBufferToScreen
;-------------------------------------------------------
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
        .BYTE $D3,$D4,$C1,$D2,$A0,$CF,$CE
        ; 'E       '
        .BYTE $C5,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; ' THE TWI'
        .BYTE $A0,$D4,$C8,$C5,$A0,$D4,$D7,$C9
        ; 'ST      '
        .BYTE $D3,$D4,$A0,$A0,$A0,$A0,$A0,$A0
        ; ' LA LLAM'
        .BYTE $A0,$CC,$C1,$A0,$CC,$CC,$C1,$CD
        ; 'ITA     '
        .BYTE $C9,$D4,$C1,$A0,$A0,$A0,$A0,$A0
        ; ' STAR TW'
        .BYTE $A0,$D3,$D4,$C1,$D2,$A0,$D4,$D7
        ; 'O       '
        .BYTE $CF,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; ' DELTOID'
        .BYTE $A0,$C4,$C5,$CC,$D4,$CF,$C9,$C4
        ; 'S       '
        .BYTE $D3,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; ' DIFFUSE'
        .BYTE $A0,$C4,$C9,$C6,$C6,$D5,$D3,$C5
        ; 'D       '
        .BYTE $C4,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; ' MULTICR'
        .BYTE $A0,$CD,$D5,$CC,$D4,$C9,$C3,$D2
        ; 'OSS     '
        .BYTE $CF,$D3,$D3,$A0,$A0,$A0,$A0,$A0
        ; ' PULSAR '
        .BYTE $A0,$D0,$D5,$CC,$D3,$C1,$D2,$A0
        ; '        '
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; ' '
        .BYTE $A0
txtSymmetrySettingDescriptions 
        ; 'NO SYMM'
        .BYTE $CE,$CF,$A0,$D3,$D9,$CD,$CD
        ; 'ETRY    '
        .BYTE $C5,$D4,$D2,$D9,$A0,$A0,$A0,$A0
        ; ' Y­AXIS '
        .BYTE $A0,$D9,$AD,$C1,$D8,$C9,$D3,$A0
        ; 'SYMMETRY'
        .BYTE $D3,$D9,$CD,$CD,$C5,$D4,$D2,$D9
        ; ' X­Y SYM'
        .BYTE $A0,$D8,$AD,$D9,$A0,$D3,$D9,$CD
        ; 'METRY   '
        .BYTE $CD,$C5,$D4,$D2,$D9,$A0,$A0,$A0
        ; ' X­AXIS '
        .BYTE $A0,$D8,$AD,$C1,$D8,$C9,$D3,$A0
        ; 'SYMMETRY'
        .BYTE $D3,$D9,$CD,$CD,$C5,$D4,$D2,$D9
        ; ' QUAD SY'
        .BYTE $A0,$D1,$D5,$C1,$C4,$A0,$D3,$D9
        ; 'MMETRY  '
        .BYTE $CD,$CD,$C5,$D4,$D2,$D9,$A0,$A0
        ; ' '
        .BYTE $A0

;-------------------------------------------------------
; ResetAndReenterMainPaint
;-------------------------------------------------------
ResetAndReenterMainPaint 
        LDA currentIndexToColorValues
        AND #$7F
        STA a16
        LDA #$19
        SEC 
        SBC a16
        STA pixelYPositionZP
        DEC pixelYPositionZP
        LDA #$00
        STA currentIndexToColorValues
        LDA #$01
        STA a17
        JSR PushOffsetAndIndexAndPaintPixel
        INC pixelYPositionZP
        LDA #$00
        STA a17
        LDA a0E44
        EOR #$07
        STA currentIndexToColorValues
b1331   JSR PushOffsetAndIndexAndPaintPixel
        INC pixelYPositionZP
        INC currentIndexToColorValues
        LDA currentIndexToColorValues
        CMP #$08
        BNE b1343
        JMP j134B

        INC currentIndexToColorValues
b1343   STA currentIndexToColorValues
        LDA pixelYPositionZP
        CMP #$19
        BNE b1331

j134B    
        LDX stepCount
        DEC f0AB6,X
        LDA f0AB6,X
        CMP #$80
        BEQ b135B
        JMP MainPaintRoutine

b135B   LDA #$FF
        STA f0AB6,X
        STX a13
        JMP MainPaintRoutine

lineModeSettingDescriptions
        ; 'LINE MOD'
        .BYTE $CC,$C9,$CE,$C5,$A0,$CD,$CF,$C4
        ; 'Eº OFF  '
        .BYTE $C5,$BA,$A0,$CF,$C6,$C6,$A0,$A0
        ; 'LINE MOD'
        .BYTE $CC,$C9,$CE,$C5,$A0,$CD,$CF,$C4
        ; 'Eº ON   '
        .BYTE $C5,$BA,$A0,$CF,$CE,$A0,$A0,$A0
;-------------------------------------------------------
; DrawColorValueBar
;-------------------------------------------------------
DrawColorValueBar
        ; Shift the pointer from SCREEN_RAM ($0400) to COLOR_RAM ($D800)
        LDA colorBarColorRamHiPtr
        PHA 
        CLC 
        ADC #$D4
        STA colorBarColorRamHiPtr

        ; Draw the colors from the bar to color ram.
        LDY #$00
b138F   LDA colorBarValues,Y
        STA (colorBarColorRamLoPtr),Y
        INY 
        CPY #$10
        BNE b138F

        PLA 
        STA colorBarColorRamHiPtr
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
        STA (colorBarColorRamLoPtr),Y
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

a13D9   .BYTE $FF
a13DA   .BYTE $FF
a13DB   .BYTE $FF
a13DC   .BYTE $FF
a13DD   .BYTE $FF
f13DE   .BYTE $20
        .BYTE $65,$74
        .BYTE $75,$61,$F6,$EA,$E7,$A0

ResetSelectedVariableAndReturn
        LDA #$00
        STA currentVariableMode
        RTS 

;-------------------------------------------------------
; CheckKeyboardInputForActiveVariable
;-------------------------------------------------------
CheckKeyboardInputForActiveVariable    
        AND #$80
        BEQ b13F4
        ; The value in currentVariableMode starts with an $8, so is
        ; one of Custom Preset, Save Prompt, Display/Load/Abort,
        JMP CheckKeyboardWhilePromptActive
        ;Returns

        ; The active variable is one with a sliding scale.
        ; Allow a bit of time between detected keystrokes.
b13F4   LDA timerBetweenKeyStrokes
        BEQ b13FD
        DEC timerBetweenKeyStrokes
        JMP DisplayVariableSelection
        ; Returns

b13FD   LDA lastKeyPressed
        CMP #$40
        BNE b1406
        ; No key pressed. Just display the active variable mode and return.
        JMP DisplayVariableSelection
        ; Returns

        ; Display the current active variable
b1406   LDA #$04
        STA timerBetweenKeyStrokes

        LDA currentVariableMode
        CMP #$05 ; 'Color Change'
        BEQ b1415
        CMP #$03 ; 'Buffer Length'
        BNE b143F

        ; The active mode is 'COlor Change'.
b1415   LDX #$00
b1417   LDA f0AB6,X
        CMP #$FF
        BNE ResetSelectedVariableAndReturn

        INX 
        CPX a0E41
        BNE b1417

        ; Reset the selected variable if necessary.
        LDA stepsRemainingInSequencerSequence
        BNE ResetSelectedVariableAndReturn
        LDA playbackOrRecordActive
        CMP #$02
        BEQ ResetSelectedVariableAndReturn
        LDA demoModeActive
        BNE ResetSelectedVariableAndReturn

        LDA #$FF
        STA currentModeActive
        LDA #$00
        STA a0E3B

b143F   LDA #>SCREEN_RAM + $03D0
        STA colorBarColorRamHiPtr
        LDA #<SCREEN_RAM + $03D0
        STA colorBarColorRamLoPtr

        LDX currentVariableMode
        LDA lastKeyPressed
        CMP #$2C ; > pressed?
        BNE b1461

        ; > pressed, increase the value bar.
        INC colorBarCurrentValueForModePtr,X
        LDA colorBarCurrentValueForModePtr,X
        ; Make sure we don't exceed the max value.
        CMP colorBarMaxValueForModePtr,X
        BNE b1473
        DEC colorBarCurrentValueForModePtr,X
        JMP b1473

b1461   CMP #$2F ; < pressed?
        BNE b1473
        ; < pressed, decrease the value bar.
        DEC colorBarCurrentValueForModePtr,X
        LDA colorBarCurrentValueForModePtr,X
        ; Make sure we don't exceed the min value.
        CMP colorBarMinValueForModePtr,X
        BNE b1473
        INC colorBarCurrentValueForModePtr,X

b1473   CPX #$05 ; Color Mode?
        BNE b1482

        ; For Color Mode update some variables.
        LDX a0E43
        LDY currentColorSet
        LDA colorValuesPtr,X
        STA presetColorValuesArray,Y

b1482   JSR DisplayVariableSelection
        JMP CheckIfEnterPressed

;-------------------------------------------------------
; DisplayVariableSelection
;-------------------------------------------------------
DisplayVariableSelection    
        ; Set the pointers to the position on screen for the color bar.
        LDA #>SCREEN_RAM + $03D0
        STA colorBarColorRamHiPtr
        LDA #<SCREEN_RAM + $03D0
        STA colorBarColorRamLoPtr

        LDX currentVariableMode
        CPX #$05
        BNE b14AE

        ; Current variable mode is 'color change'
        LDX currentColorSet
        LDA presetColorValuesArray,X
        LDY #$00
b149E   CMP colorValuesPtr,Y
        BEQ b14A8
        INY 
        CPY #$10
        BNE b149E
b14A8   STY a0E43
        LDX currentVariableMode

b14AE   LDA f1526,X
        STA a13D9
        LDA colorBarCurrentValueForModePtr,X
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

        LDA currentVariableMode
        CMP #$05
        BNE b14EC
        LDA #$30
        CLC 
        ADC currentColorSet
        STA a11F8
b14EC   JSR WriteLastLineBufferToScreen
        JMP DrawColorValueBar

;-------------------------------------------------------
; CheckIfEnterPressed
;-------------------------------------------------------
CheckIfEnterPressed    
        LDA lastKeyPressed
        CMP #$01
        BEQ b14F9
        RTS 

        ; Enter pressed
b14F9   LDA currentVariableMode
        CMP #$05
        BNE b1509

        ; In Color Change mode, move to the next color set
        ; until you reach the last one.
        INC currentColorSet
        LDA currentColorSet
        CMP #$08
        BEQ b1509
        RTS 

        ; Enter was pressed, so exit variable mode.
b1509   LDA #$00
        STA currentVariableMode
        STA a173A
        RTS 


colorBarMaxValueForModePtr   
        .BYTE $00,$40,$08,$40,$10,$10,$08
        .BYTE $20,$10,$08
colorBarMinValueForModePtr   
        .BYTE $00,$00,$00,$00,$00

        .BYTE $00,$00,$00,$00,$00
f1526   
        .BYTE $00,$01,$08
        .BYTE $01,$04,$08,$08,$02,$04,$08
currentVariableMode   
        .BYTE $00
a1531   
        .BYTE $01
txtVariableLabels   
        ; '       '
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; '        '
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; ' SMOOTHI'
        .BYTE $A0,$D3,$CD,$CF,$CF,$D4,$C8,$C9
        ; 'NG DELAY'
        .BYTE $CE,$C7,$A0,$C4,$C5,$CC,$C1,$D9
        ; 'ºCURSOR '
        .BYTE $BA,$C3,$D5,$D2,$D3,$CF,$D2,$A0
        ; 'SPEED   '
        .BYTE $D3,$D0,$C5,$C5,$C4,$A0,$A0,$A0
        ; 'ºBUFFER '
        .BYTE $BA,$C2,$D5,$C6,$C6,$C5,$D2,$A0
        ; 'LENGTH  '
        .BYTE $CC,$C5,$CE,$C7,$D4,$C8,$A0,$A0
        ; 'ºPULSE S'
        .BYTE $BA,$D0,$D5,$CC,$D3,$C5,$A0,$D3
        ; 'PEED    '
        .BYTE $D0,$C5,$C5,$C4,$A0,$A0,$A0,$A0
        ; 'ºCOLOUR '
        .BYTE $BA,$C3,$CF,$CC,$CF,$D5,$D2,$A0
        ; '° SET   '
        .BYTE $B0,$A0,$D3,$C5,$D4,$A0,$A0,$A0
        ; 'ºWIDTH O'
        .BYTE $BA,$D7,$C9,$C4,$D4,$C8,$A0,$CF
        ; 'F LINE  '
        .BYTE $C6,$A0,$CC,$C9,$CE,$C5,$A0,$A0
        ; 'ºSEQUENC'
        .BYTE $BA,$D3,$C5,$D1,$D5,$C5,$CE,$C3
        ; 'ER SPEED'
        .BYTE $C5,$D2,$A0,$D3,$D0,$C5,$C5,$C4
        ; 'ºPULSE W'
        .BYTE $BA,$D0,$D5,$CC,$D3,$C5,$A0,$D7
        ; 'IDTH    '
        .BYTE $C9,$C4,$D4,$C8,$A0,$A0,$A0,$A0
        ; 'ºBASE LE'
        .BYTE $BA,$C2,$C1,$D3,$C5,$A0,$CC,$C5
        ; 'VEL     '
        .BYTE $D6,$C5,$CC,$A0,$A0,$A0,$A0,$A0
        .BYTE $BA
colorValuesPtr   
        .BYTE $00
colorBarValues   
        .BYTE $06,$02,$04,$05,$03,$07
        .BYTE $01,$08,$09,$0A,$0B,$0C,$0D,$0E
        .BYTE $0F
txtTrackingOnOff   
        ; 'TRACKIN'
        .BYTE $D4,$D2,$C1,$C3,$CB,$C9,$CE
        ; 'Gº OFF  '
        .BYTE $C7,$BA,$A0,$CF,$C6,$C6,$A0,$A0
        ; ' TRACKIN'
        .BYTE $A0,$D4,$D2,$C1,$C3,$CB,$C9,$CE
        ; 'Gº ON   '
        .BYTE $C7,$BA,$A0,$CF,$CE,$A0,$A0,$A0
        ; ' '
        .BYTE $A0


;-------------------------------------------------------
; DisplayPresetMessage
;-------------------------------------------------------
DisplayPresetMessage    
        LDA shiftPressed
        AND #$04
        BEQ SelectNewPreset
        JMP DisplayCustomPreset

SelectNewPreset
        TXA 
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

b1638   JMP DrawPresetActivatedMessage

WriteLastLineBufferAndReturn    
        JSR WriteLastLineBufferToScreen
        RTS 

txtPreset
        ; 'PR'
        .BYTE $D0,$D2
        ; 'ESET °° '
        .BYTE $C5,$D3,$C5,$D4,$A0,$B0,$B0,$A0
        ; '     º'
        .BYTE $A0,$A0,$A0,$A0,$A0,$BA
txtPresetActivatedStored
        ; ' A'
        .BYTE $A0,$C1
        ; 'CTIVATED'
        .BYTE $C3,$D4,$C9,$D6,$C1,$D4,$C5,$C4
        ; '       D'
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$C4
        ; 'ATA STOR'
        .BYTE $C1,$D4,$C1,$A0,$D3,$D4,$CF,$D2
        ; 'ED    '
        .BYTE $C5,$C4,$A0,$A0,$A0,$A0
shiftPressed
        .BYTE $00

;-------------------------------------------------------
; DrawPresetActivatedMessage
;-------------------------------------------------------
DrawPresetActivatedMessage    
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
        JSR UpdatePointersForPreset
        LDY #$00
        LDX #$00
b169B   LDA colorBarCurrentValueForModePtr,X
        STA (presetSequenceDataLoPtr),Y
        INY 
        INX 
        CPX #$15
        BNE b169B

        LDA currentPatternElement
        STA (presetSequenceDataLoPtr),Y
        INY 
        LDA currentSymmetrySetting
        STA (presetSequenceDataLoPtr),Y
        JMP WriteLastLineBufferAndReturn

j16B2    
        PLA 
        TAX 
        JSR UpdatePointersForPreset
        LDY #$03
        LDA (presetSequenceDataLoPtr),Y
        CMP a0E41
        BEQ b16C6
        JSR ResetCurrentActiveMode
        JMP j16DA

b16C6   LDX #$00
        LDY #$07
b16CA   LDA (presetSequenceDataLoPtr),Y
        CMP presetColorValuesArray,X
        BNE j16DA
        INY 
        INX 
        CPX #$08
        BNE b16CA
        JMP j16DA

j16DA    
        LDA #$FF
        STA currentModeActive
        LDY #$00
b16E1   LDA (presetSequenceDataLoPtr),Y
        STA colorBarCurrentValueForModePtr,Y
        INY 
        CPY #$15
        BNE b16E1
        LDA (presetSequenceDataLoPtr),Y
        STA currentPatternElement
        INY 
        LDA (presetSequenceDataLoPtr),Y
        STA currentSymmetrySetting
        JMP WriteLastLineBufferAndReturn

;-------------------------------------------------------
; UpdatePointersForPreset
;-------------------------------------------------------
UpdatePointersForPreset   
        LDA #>customPresetSequenceData
        STA presetSequenceDataHiPtr
        LDA #<customPresetSequenceData
        STA presetSequenceDataLoPtr
        TXA 
        BEQ b1712
b1702   LDA presetSequenceDataLoPtr
        CLC 
        ADC #$20
        STA presetSequenceDataLoPtr
        LDA presetSequenceDataHiPtr
        ADC #$00
        STA presetSequenceDataHiPtr
        DEX 
        BNE b1702
b1712   RTS 

;-------------------------------------------------------
; ResetCurrentActiveMode
;-------------------------------------------------------
ResetCurrentActiveMode   
        LDA #$FF
        STA currentModeActive
        LDA #$00
        STA a0E3B
        RTS 

currentModeActive  .BYTE $00
;-------------------------------------------------------
; ReinitializeScreen
;-------------------------------------------------------
ReinitializeScreen
        LDA #$00
        STA stepCount
        STA a13

        LDX #$00
        LDA #$FF
b172a   STA f0AB6,X
        INX
        CPX #$40
        BNE b172A

        LDA #$00
        STA currentModeActive
        JMP InitializeScreenWithInitCharacter
        ; Returns

a173A   .BYTE $00
functionKeyIndex   .BYTE $00

;-------------------------------------------------------
; UpdateSequencer
;-------------------------------------------------------
UpdateSequencer   
        JSR ClearLastLineOfScreen
        LDA shiftPressed
        AND #$01
        BEQ b1756

        ; Display data free
        LDX #$00
b1748   LDA txtDataFree,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$10
        BNE b1748
        JSR WriteLastLineBufferToScreen

b1756   LDA #$C2
        STA currentSequencePtrHi
        LDX functionKeyIndex
        LDA functionKeyToSequenceArray,X
        STA currentSequencePtrLo
        LDA shiftPressed
        AND #$01
        BEQ b177B
        LDA #$10
        STA a179B

        ; Store the current symmetry setting at one of $C200,
        ; $C220, $C240, $C260 depending on the Function key
        ; selected.
        LDY #$00
        LDA currentSymmetrySetting
        STA (currentSequencePtrLo),Y
        LDA a0E3F
        INY 
        STA (currentSequencePtrLo),Y
        RTS 

b177B   LDA #$FF
        STA sequencerActive
        JMP InitializeSequencer

functionKeyToSequenceArray   .BYTE $00,$20,$40,$60

txtDataFree
        ; 'DA'
        .BYTE $C4,$C1
        ; 'TAº °°° '
        .BYTE $D4,$C1,$BA,$A0,$B0,$B0,$B0,$A0
        ; 'FREE  '
        .BYTE $C6,$D2,$C5,$C5,$A0,$A0
functionKeys
        .BYTE $04,$05
        .BYTE $06,$03

a179B   .BYTE $FF,$60

;-------------------------------------------------------
; CheckKeyboardWhilePromptActive
;-------------------------------------------------------
CheckKeyboardWhilePromptActive 
        LDA currentVariableMode
        CMP #$83
        BNE b17A7
        JMP CheckKeyboardInputForOtherPrompts

b17A7   CMP #$84
        BNE b17AE
        JMP CheckKeyboardInputWhileSavePromptActive

b17AE   CMP #$85 ; Display Load/Abort
        BNE b17B5
        JMP CheckKeyboardInputWhileLoadAbortActive
        ;Returns

b17B5   LDA #$30
        STA a11F7
        STA a11F8
        STA a11F9
        LDX a179B
        BNE b17C8
        JMP ReturnPressed
        ; Returns

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
        JSR ResetSomeData
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
        BEQ ReturnPressed
        CMP #$3C
        BNE b183C
        JSR ResetSomeData
        LDA a179B
        STA a1A47
        LDA currentSequencePtrLo
        STA a1A48
        LDA currentSequencePtrHi
        STA a1A49
        LDA #$00
        STA currentVariableMode
        STA a1884
        STA sequencerActive
        LDY #$02
        LDA #$FF
        STA (currentSequencePtrLo),Y
b183C   RTS 

b183D   LDY #$02
        LDA shiftKey
        AND #$01
        BEQ b184B
        LDA #$C0
f1848   JMP j184E

b184B   LDA pixelXPosition

j184E    
        STA (currentSequencePtrLo),Y
        LDA colorRAMLineTableIndex
        INY 
        STA (currentSequencePtrLo),Y
        LDA currentPatternElement
        INY 
        STA (currentSequencePtrLo),Y
        LDA currentSequencePtrLo
        CLC 
        ADC #$03
        STA currentSequencePtrLo
        LDA currentSequencePtrHi
        ADC #$00
        STA currentSequencePtrHi
        DEC a179B
        RTS 

;-------------------------------------------------------
; ReturnPressed
;-------------------------------------------------------
ReturnPressed    
        JSR ResetSomeData
        LDA #$FF
        LDY #$02
        STA (currentSequencePtrLo),Y
        LDA #$00
        STA currentVariableMode
        STA a1884
        STA a1A47
        STA sequencerActive
        RTS 

a1884   .BYTE $00
;-------------------------------------------------------
; ResetSomeData
;-------------------------------------------------------
ResetSomeData
        LDA a11F7
        STA a07C6
        LDA a11F8
        STA a07C7
        LDA a11F9
        STA a07C8
        RTS 

;-------------------------------------------------------
; InitializeSequencer
;-------------------------------------------------------
InitializeSequencer    
        LDA #$00
        STA currentVariableMode
        TAY 
        LDA (currentSequencePtrLo),Y
        STA a1920
        INY 
        LDA (currentSequencePtrLo),Y
        STA a191F

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
        LDA (currentSequencePtrLo),Y
        CMP #$C0
        BEQ b1901
        STA pixelXPositionArray,X
        INY 
        LDA (currentSequencePtrLo),Y
        STA pixelYPositionArray,X
        INY 
        LDA (currentSequencePtrLo),Y
        STA nextPixelYPositionArray,X
        LDA a191F
        STA f0AF6,X
        STA f0B36,X
        LDA a1920
        STA f0BB6,X
b1901   LDA currentSequencePtrLo
        CLC 
        ADC #$03
        STA currentSequencePtrLo
        LDA currentSequencePtrHi
        ADC #$00
        STA currentSequencePtrHi
        LDY #$02
        LDA (currentSequencePtrLo),Y
        CMP #$FF
        BEQ b1919
        JMP j18A9

b1919   LDA #$00
        STA sequencerActive
        RTS 

a191F   .BYTE $00
a1920   .BYTE $00
sequencerActive   .BYTE $00
;-------------------------------------------------------
; ActivateSequencer
;-------------------------------------------------------
ActivateSequencer 
        LDA #$C3
        STA currentSequencePtrHi
        LDA #$00
        STA currentSequencePtrLo
        LDA #$FF
        STA sequencerActive
        LDA shiftPressed
        AND #$01
        BNE b1945
        LDA a0E45
        STA stepsRemainingInSequencerSequence
        LDA #$00
        STA currentVariableMode
        JSR DisplaySequencerState
        RTS 

b1945   LDA a1A47
        BEQ b195D
        LDA a1A47
        STA a179B
        LDA a1A48
        STA currentSequencePtrLo
        LDA a1A49
        STA currentSequencePtrHi
        JMP DisplaySequFree
        ;Returns

b195D   LDA #$FF
        STA a179B
        LDA currentSymmetrySetting
        LDY #$00
        STA (currentSequencePtrLo),Y
        LDA a0E3F
        INY 
        STA (currentSequencePtrLo),Y

DisplaySequFree    
        JSR ClearLastLineOfScreen

        LDX #$00
b1973   LDA txtSequFree,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$10
        BNE b1973

        JSR WriteLastLineBufferToScreen
        RTS 

;-------------------------------------------------------
; UpdatePointersFromSequenceData
;-------------------------------------------------------
UpdatePointersFromSequenceData   
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
        LDA (currentSequencePtrLo),Y
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
        LDA (currentSequencePtrLo),Y
        STA pixelXPositionArray,X
        INY 
        LDA (currentSequencePtrLo),Y
        STA pixelYPositionArray,X
        INY 
        LDA (currentSequencePtrLo),Y
        STA nextPixelYPositionArray,X
b19D9   LDA currentSequencePtrLo
        CLC 
        ADC #$03
        STA currentSequencePtrLo
        LDA currentSequencePtrHi
        ADC #$00
        STA currentSequencePtrHi
        LDY #$02
        LDA (currentSequencePtrLo),Y
        CMP #$FF
        BEQ b19EF
        RTS 

b19EF   LDA #<aC300
        STA currentSequencePtrLo
        LDA #>aC300
        STA currentSequencePtrHi
        RTS 

stepsRemainingInSequencerSequence   .BYTE $00
txtSequFree
        ; 'SEQUº °°'
        .BYTE $D3,$C5,$D1,$D5,$BA,$A0,$B0,$B0
        ; '° FREE  '
        .BYTE $B0,$A0,$C6,$D2,$C5,$C5,$A0,$A0

;-------------------------------------------------------
; DisplaySequencerState
;-------------------------------------------------------
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
      .BYTE $D3,$C5
      ; 'QUENCER '
      .BYTE $D1,$D5,$C5,$CE,$C3,$C5,$D2,$A0
      ; 'OFF   SE'
      .BYTE $CF,$C6,$C6,$A0,$A0,$A0,$D3,$C5
      ; 'QUENCER '
      .BYTE $D1,$D5,$C5,$CE,$C3,$C5,$D2,$A0
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

;-------------------------------------------------------
; StopOrStartRecording
;-------------------------------------------------------
StopOrStartRecording    
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

;-------------------------------------------------------
; InitializeDynamicStorage
;-------------------------------------------------------
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
        LDA pixelXPosition
        STA a1BE8
        LDA colorRAMLineTableIndex
        STA a1BE9
        RTS 

b1AC5   LDA #$00
        STA currentColorToPaint
        JSR UpdateLineinColorRAMUsingIndex
        LDA a1BE8
        STA pixelXPosition
        LDA a1BE9
        STA colorRAMLineTableIndex
        LDA #$FF
        STA a1BEB
        RTS 

txtPlayBackRecord
        ; 'PLA'
        .BYTE $D0,$CC,$C1
        ; 'YING BAC'
        .BYTE $D9,$C9,$CE,$C7,$A0,$C2,$C1,$C3
        ; 'K®®®®REC'
        .BYTE $CB,$AE,$AE,$AE,$AE,$D2,$C5,$C3
        ; 'ORDING®®'
        .BYTE $CF,$D2,$C4,$C9,$CE,$C7,$AE,$AE
        ; '®®®®®'
        .BYTE $AE,$AE,$AE,$AE,$AE

;-------------------------------------------------------
; DisplayStoppedRecording
;-------------------------------------------------------
DisplayStoppedRecording    
        LDA #$00
        STA playbackOrRecordActive
        STA $D020    ;Border Color
        STA a1BEB
        TAY 
        JSR ClearLastLineOfScreen
b1B0D   LDA txtStopped,Y
        STA lastLineBufferPtr,Y
        INY 
        CPY #$10
        BNE b1B0D
        JMP WriteLastLineBufferToScreen
        ; Returns

txtStopped
        ; 'STOPPE'
        .BYTE $D3,$D4,$CF,$D0,$D0,$C5
        ; 'D       '
        .BYTE $C4,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; '  '
        .BYTE $A0,$A0
playbackOrRecordActive
        .BYTE $00

;-------------------------------------------------------
; RecordJoystickMovements
;-------------------------------------------------------
RecordJoystickMovements    
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
        LDA colorBarValues,X
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

;-------------------------------------------------------
; GetJoystickInput
;-------------------------------------------------------
GetJoystickInput   
        LDA playbackOrRecordActive
        BEQ b1B8C
        CMP #$03
        BNE b1B89
        JMP RecordJoystickMovements

b1B89   JMP PlaybackRecordedJoystickInputs

b1B8C   LDA demoModeActive
        BEQ b1B94
        JMP PerformRandomJoystickMovement

b1B94   LDA $DC00    ;CIA1: Data Port Register A
        STA lastJoystickInput
        RTS 

PlaybackRecordedJoystickInputs    
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
        STA currentColorToPaint
        JSR UpdateLineinColorRAMUsingIndex
        LDA a1BE8
        STA pixelXPosition
        LDA a1BE9
        STA colorRAMLineTableIndex
        RTS 

a1BE7
        .BYTE $00
a1BE8
        .BYTE $0C
a1BE9
        .BYTE $0C
a1BEA
        .BYTE $00
a1BEB
        .BYTE $00
txtDefineAllLevelPixels
        ; 'DEFIN'
        .BYTE $C4,$C5,$C6,$C9,$CE
        ; 'E ALL LE'
        .BYTE $C5,$A0,$C1,$CC,$CC,$A0,$CC,$C5
        ; 'VEL ² PI'
        .BYTE $D6,$C5,$CC,$A0,$B2,$A0,$D0,$C9
        ; 'XELS'
        .BYTE $D8,$C5,$CC,$D3

;-------------------------------------------------------
; DisplayCustomPreset
;-------------------------------------------------------
DisplayCustomPreset 
        TXA
        AND #$08
        BEQ b1C0B
        RTS 

b1C0B   LDA #$83
        STA currentVariableMode

        ; Custome presets are stored between $C800 and
        ; $CFFF.
        LDA #$00
        STA customPresetLoPtr
        STA a1BEB
        LDA customPresetHiPtrArray,X
        STA customPresetHiPtr

        TXA 
        CLC 
        ADC #$08
        STA a1BEA
        JSR ClearLastLineOfScreen
        LDX #$00
b1C28   LDA txtDefineAllLevelPixels,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$19
        BNE b1C28
        JSR WriteLastLineBufferToScreen
        LDA #$06
        STA a25
        LDY #$00
        TYA 
        STA (customPresetLoPtr),Y
        INY 
        LDA #$55
        STA (customPresetLoPtr),Y
        LDY #$81
        STA (customPresetLoPtr),Y
        DEY 
        LDA #$00
        STA (customPresetLoPtr),Y
        LDA #$07
        STA a24
        LDA #$01
        STA a26
        LDA #$17
        STA currentModeActive
        RTS 

;-------------------------------------------------------
; UpdateStuffAndReenterMainPaint
;-------------------------------------------------------
UpdateStuffAndReenterMainPaint    
        LDA #<p0C13
        STA pixelXPosition
        LDA #>p0C13
        STA colorRAMLineTableIndex
        JSR ReinitializeScreen
b1C68   LDA a1BEA
        STA dataPtrIndex
        LDA a25
        STA currentIndexToColorValues
        LDA #$00
        STA a14
        LDA #<p0C13
        STA pixelXPositionZP
        LDA #>p0C13
        STA pixelYPositionZP
        JSR LoopThroughPixelsAndPaint
        LDA a25
        BNE b1C68
        JSR ReinitializeScreen
        LDA #$00
        STA currentModeActive
        JMP MainPaintRoutine

;-------------------------------------------------------
; CheckKeyboardInputForOtherPrompts
;-------------------------------------------------------
CheckKeyboardInputForOtherPrompts    
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
        STA (customPresetLoPtr),Y
        PHA 
        TYA 
        CLC 
        ADC #$80
        TAY 
        PLA 
        STA (customPresetLoPtr),Y
        INY 
        LDA #$55
        STA (customPresetLoPtr),Y
        LDY a26
        INY 
        STA (customPresetLoPtr),Y
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
        STA currentVariableMode
        JSR ClearLastLineOfScreen
b1CEE   RTS 

j1CEF    
        CMP #$39
        BNE b1CEE
        LDY a26
        LDA pixelXPosition
        SEC 
        SBC #$13
        STA (customPresetLoPtr),Y
        INY 
        LDA #$55
        STA (customPresetLoPtr),Y
        STY a26
        TYA 
        CLC 
        ADC #$7F
        TAY 
        LDA colorRAMLineTableIndex
        SEC 
b1D0D   SBC #$0C
        STA (customPresetLoPtr),Y
        INY 
        LDA #$55
        STA (customPresetLoPtr),Y
        DEC a24
        BEQ b1D1B
        RTS 

b1D1B   JMP b1CB6

;-------------------------------------------------------
; GetCustomPatternElement
;-------------------------------------------------------
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
        .BYTE $D5,$D3,$C5,$D2,$A0,$D3
        ; 'HAPE £°'
        .BYTE $C8,$C1,$D0,$C5,$A0,$A3,$B0
pixelShapeIndex
        .BYTE $00
pixelShapeArray
        .BYTE $CF,$51,$53,$5A,$5B,$5F,$57,$7F
        .BYTE $56,$61,$4F,$66,$6C,$EC,$A0,$2A
        .BYTE $47,$4F,$41,$54,$53,$53,$48,$45
        .BYTE $45,$50

;-------------------------------------------------------
; DisplaySavePromptScreen
;-------------------------------------------------------
DisplaySavePromptScreen 
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
        LDA #>customPresetSequenceData
        STA aFF
        LDA #<customPresetSequenceData
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

j1E08    
        LDA #$00
        STA currentModeActive
        STA a1BEB
        STA a1EAA
        JSR ROM_CLALL ;$FFE7 - close or abort all files         
        JSR ReinitializeScreen
        JMP MainPaintRoutine

        RTS 

;-------------------------------------------------------
; PromptToSave
;-------------------------------------------------------
PromptToSave    
        LDA stepsRemainingInSequencerSequence
        BNE b1E43
        LDA playbackOrRecordActive
        CMP #$02
        BEQ b1E43

        LDA #$84
        STA currentVariableMode

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

;-------------------------------------------------------
; CheckKeyboardInputWhileSavePromptActive
;-------------------------------------------------------
CheckKeyboardInputWhileSavePromptActive    
        LDA currentVariableMode
        CMP #$84
        BEQ b1E74
        RTS 

b1E74   LDA lastKeyPressed
        CMP #$0A
        BNE b1E87
        LDA #$00
        STA currentModeActive

j1E7F    
        LDA #$00
        STA currentVariableMode
        JMP ClearLastLineOfScreen

b1E87   CMP #$24
        BNE b1E98
        LDA #$02
        STA a1EAA
        LDA #$18
        STA currentModeActive
        JMP j1E7F

b1E98   CMP #$29
        BNE b1EA9
        LDA #$01
        STA a1EAA
        LDA #$18
        STA currentModeActive
        JMP j1E7F

b1EA9   RTS 

a1EAA   .BYTE $00
;-------------------------------------------------------
; DisplayLoadOrAbort
;-------------------------------------------------------
DisplayLoadOrAbort    
        
        LDA stepsRemainingInSequencerSequence
        BNE b1EA9
        LDA playbackOrRecordActive
        CMP #$02
        BEQ b1EA9
        LDA #$85
        STA currentVariableMode
        LDX #$00
b1EBE   LDA txtContinueLoadOrAbort,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$28
        BNE b1EBE
        LDA #$00
        STA a1EAA
        JMP WriteLastLineBufferToScreen

;-------------------------------------------------------
; CheckKeyboardInputWhileLoadAbortActive
;-------------------------------------------------------
CheckKeyboardInputWhileLoadAbortActive    
        LDA lastKeyPressed
        CMP #$0A ; 'A'
        BNE b1EE5
        ; 'A' pressed
        LDA #$00
        STA currentVariableMode
        STA a1EAA
        STA currentModeActive
        JMP ClearLastLineOfScreen

b1EE5   CMP #$14 ; 'C'
        BNE b1EFB
        ; 'C' pressed
        LDA #$03
        STA a1EAA
        LDA #$00
        STA currentVariableMode
        LDA #$18
        STA currentModeActive
        JMP ClearLastLineOfScreen

b1EFB   RTS 

txtContinueLoadOrAbort
        ; '¨C©ON'
        .BYTE $A8,$C3,$A9,$CF,$CE
        ; 'TINUE LO'
        .BYTE $D4,$C9,$CE,$D5,$C5,$A0,$CC,$CF
        ; 'AD¬ OR ¨'
        .BYTE $C1,$C4,$AC,$A0,$CF,$D2,$A0,$A8
        ; 'A©BORT¿ '
        .BYTE $C1,$A9,$C2,$CF,$D2,$D4,$BF,$A0
        ; '        '
        .BYTE $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
        ; '   '
        .BYTE $A0,$A0,$A0
demoModeActive
        .BYTE $00
a1F25
        .BYTE $01
a1F26
        .BYTE $10

;-------------------------------------------------------
; PerformRandomJoystickMovement
;-------------------------------------------------------
PerformRandomJoystickMovement 
        DEC a1F25
        BEQ b1F2D
        RTS 

b1F2D   JSR PutRandomByteInAccumulator
        AND #$1F
        ORA #$01
        STA a1F25
        LDA a1F26
        EOR #$10
        STA a1F26
        JSR PutRandomByteInAccumulator
        AND #$0F
        ORA a1F26
        EOR #$1F
        STA lastJoystickInput
        DEC demoModeCountDownToChangePreset
        BEQ b1F51
        RTS 

b1F51   JSR PutRandomByteInAccumulator
        AND #$07
b1F56   ADC #$20
        STA demoModeCountDownToChangePreset
        JSR PutRandomByteInAccumulator
        AND #$0F
        TAX 
        LDA #$00
        STA shiftPressed
        JMP SelectNewPreset
        ; Returns

;-------------------------------------------------------
; DisplayDemoModeMessage
;-------------------------------------------------------
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
        .TEXT "      PSYCHEDELIA BY JEFF MINTER         "

* = $1FA9
demoModeCountDownToChangePreset
        .BYTE $20
NMIInterruptHandler
        .BYTE $A2,$F8,$9A,$A9,$0C,$48,$A9
        .BYTE $30,$48,$A9,$23,$48,$40


;-------------------------------------------------------
; CopyDataFrom2000ToC000
;-------------------------------------------------------
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
        .BYTE $30,$0C,$30,$0C,$C3,$C2,$CD
        .BYTE $38,$30,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00

;-------------------------------------------------------
; This is the main data driving the sequences in
; Psychedelia. It's copied from this position to $C000 when
; the game is loaded.
;
; The data for the 16 presets. Each chunk contains the following values:
;  colorBarCurrentValueForModePtr  
;  seedValue                       
;  initialValueForSteps            
;  maxStepCount                    
;  displayCursorInitialValue       
;  indexForPresetColorValues       
;  shouldUpdatePatternInitialValue 
;  presetForCurrentColorIndex      
;  presetColorValuesArray          
;  trackingActivated               
;  lineModeActivated               
;  patternIndex                    
;  currentPatternElement
;  currentSymmetrySetting
;--------------------------------------------------------------------------
f2000
;preset0
        .BYTE $00,$0C,$02,$1F,$01,$01,$07,$04
        .BYTE $01,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$00,$00,$00,$00,$01,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset1
        .BYTE $00,$0C,$02,$28,$01,$0E,$07,$08
        .BYTE $01,$07,$00,$09,$02,$08,$04,$0A
        .BYTE $06,$0E,$FF,$00,$01,$01,$04,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset2
        .BYTE $00,$0B,$02,$28,$01,$01,$07,$0B
        .BYTE $01,$07,$00,$06,$0E,$03,$0D,$05
        .BYTE $0E,$06,$FF,$00,$05,$05,$01,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset3
        .BYTE $00,$04,$02,$26,$01,$01,$07,$0A
        .BYTE $01,$07,$00,$02,$04,$0A,$0D,$03
        .BYTE $0E,$06,$00,$00,$0E,$0E,$02,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$EA,$10
;preset4
        .BYTE $00,$0C,$01,$2B,$01,$07,$07,$08
        .BYTE $01,$07,$00,$0B,$06,$0C,$04,$0F
        .BYTE $03,$01,$00,$00,$01,$01,$01,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset5
        .BYTE $00,$0C,$02,$2B,$01,$07,$07,$0C
        .BYTE $01,$07,$00,$0B,$06,$0C,$04,$0F
        .BYTE $03,$01,$00,$00,$06,$06,$03,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$F7
;preset6
        .BYTE $00,$0F,$02,$3F,$01,$01,$07,$0F
        .BYTE $01,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$FF,$00,$03,$03,$04,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset7
        .BYTE $00,$0B,$01,$1C,$02,$0A,$07,$09
        .BYTE $01,$07,$00,$07,$03,$0E,$06,$02
        .BYTE $04,$0A,$00,$00,$07,$07,$01,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$15,$EF
;preset8
        .BYTE $00,$04,$01,$28,$02,$01,$07,$0A
        .BYTE $01,$07,$00,$08,$09,$05,$03,$0D
        .BYTE $0E,$06,$FF,$00,$01,$01,$03,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset9
        .BYTE $00,$11,$01,$0D,$07,$01,$07,$0C
        .BYTE $01,$07,$00,$06,$03,$06,$03,$06
        .BYTE $03,$06,$FF,$00,$07,$07,$04,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset10
        .BYTE $00,$01,$02,$1F,$02,$09,$04,$08
        .BYTE $01,$07,$00,$06,$02,$02,$04,$0A
        .BYTE $08,$09,$FF,$01,$00,$00,$04,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset11
        .BYTE $00,$01,$01,$13,$06,$01,$07,$08
        .BYTE $05,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$FF,$00,$0F,$0F,$04,$FF
        .BYTE $00,$FF,$FF,$00,$FF,$00,$EA,$10
;preset12
        .BYTE $00,$0C,$02,$28,$01,$02,$07,$09
        .BYTE $01,$07,$00,$06,$0E,$03,$0D,$07
        .BYTE $04,$02,$00,$00,$0A,$0A,$01,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset13
        .BYTE $00,$0B,$01,$1C,$02,$0A,$07,$09
        .BYTE $01,$07,$00,$07,$03,$0E,$06,$02
        .BYTE $04,$0A,$00,$00,$03,$03,$04,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset14
        .BYTE $00,$0C,$02,$2B,$01,$0A,$07,$08
        .BYTE $01,$07,$00,$02,$09,$08,$04,$02
        .BYTE $07,$0A,$FF,$00,$04,$04,$02,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset15
        .BYTE $00,$03,$01,$1F,$06,$01,$07,$00
        .BYTE $01,$07,$00,$06,$02,$04,$05,$03
        .BYTE $07,$01,$FF,$00,$04,$04,$04,$00
        .BYTE $FF,$00,$00,$FF,$00,$FF,$15,$EF
        .BYTE $01,$0C,$07,$06,$07,$11,$0D,$07
        .BYTE $06,$11,$07,$FF,$0B,$07,$FF,$00
        .BYTE $FF,$21,$06,$00,$06,$01,$06,$41
        .BYTE $FF,$00,$06,$01,$06,$01,$06,$00
        .BYTE $01,$0C,$13,$08,$00,$07,$0F,$00
        .BYTE $FF,$00,$06,$01,$2A,$41,$02,$00
        .BYTE $04,$62,$FF,$41,$06,$40,$00,$6B
        .BYTE $04,$41,$FF,$00,$FF,$00,$FF,$00
        .BYTE $04,$01,$08,$01,$02,$FF,$01,$02
        .BYTE $08,$01,$02,$08,$01,$02,$08,$01
        .BYTE $02,$08,$01,$02,$08,$01,$02,$FF
        .BYTE $03,$02,$08,$03,$02,$08,$03,$02
        .BYTE $00,$11,$12,$09,$08,$12,$09,$08
        .BYTE $FF,$08,$03,$02,$08,$03,$02,$08
        .BYTE $03,$02,$FF,$00,$00,$00,$00,$01
        .BYTE $24,$00,$05,$01,$00,$00,$00,$00
        .BYTE $00,$BD,$00,$B9,$00,$BD,$00,$BD
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
        .BYTE $01,$0B,$04,$04,$07,$08,$09,$07
        .BYTE $0C,$0C,$07,$10,$11,$07,$14,$13
        .BYTE $07,$17,$13,$07,$FF,$01,$06,$41
        .BYTE $FF,$00,$06,$01,$06,$01,$06,$00
        .BYTE $00,$FF,$06,$00,$02,$00,$FF,$41
        .BYTE $46,$00,$06,$81,$AA,$41,$02,$00
        .BYTE $04,$62,$FF,$41,$06,$40,$00,$6B
        .BYTE $04,$C1,$FF,$00,$FF,$00,$FF,$00
        .BYTE $42,$02,$AE,$01,$00,$07,$1C,$80
        .BYTE $FF,$05,$06,$01,$02,$07,$02,$05
        .BYTE $00,$85,$06,$01,$02,$05,$02,$41
        .BYTE $00,$00,$06,$03,$BD,$00,$BF,$00
        .BYTE $BF,$C5,$BF,$01,$00,$42,$02,$40
        .BYTE $00,$40,$06,$01,$FF,$00,$02,$40
        .BYTE $FF,$05,$02,$00,$00,$00,$00,$01
        .BYTE $20,$00,$8D,$01,$00,$00,$00,$00
        .BYTE $00,$BD,$00,$BD,$00,$BD,$40,$BD
        .BYTE $81,$BD,$81,$FF,$00,$FF,$F1,$FF
        .BYTE $00,$20,$81,$FF,$81,$AE,$C3,$EE
        .BYTE $00,$FF,$81,$EE,$81,$AC,$C1,$FD
        .BYTE $D1,$24,$81,$FF,$C1,$FF,$00,$AE
        .BYTE $81,$FF,$C5,$EE,$41,$EC,$E1,$FF
        .BYTE $C3,$37,$00,$EE,$C1,$BF,$C3,$AE
        .BYTE $C1,$AE,$00,$FF,$00,$FF,$00,$FD
        .BYTE $05,$DD,$03,$EE,$85,$EC,$C7,$4C
        .BYTE $00,$60,$81,$EC,$87,$EE,$81,$EE
        .BYTE $8D,$62,$85,$EE,$85,$EE,$87,$EA
        .BYTE $85,$FD,$83,$ED,$42,$EF,$00,$FF
        .BYTE $40,$28,$02,$EE,$C1,$BD,$85,$FF
        .BYTE $81,$FF,$85,$EE,$00,$FF,$A7,$BF
        .BYTE $00,$EE,$87,$FF,$81,$FF,$A7,$FE
        .BYTE $01,$FF,$00,$EE,$FD,$FF,$FF,$FF
        .BYTE $FF,$00,$F7,$00,$FF,$00,$BF,$40
        .BYTE $46,$00,$06,$00,$FF,$00,$06,$00
        .BYTE $FF,$01,$06,$00,$06,$01,$06,$41
        .BYTE $FF,$00,$06,$01,$06,$01,$06,$00
        .BYTE $00,$FF,$06,$00,$02,$00,$FF,$41
        .BYTE $46,$00,$06,$01,$2A,$41,$02,$00
        .BYTE $04,$6A,$FF,$41,$06,$40,$00,$4B
        .BYTE $04,$89,$FF,$00,$FF,$00,$FF,$00
        .BYTE $42,$02,$BF,$01,$00,$07,$1C,$00
        .BYTE $FF,$05,$06,$01,$02,$07,$02,$05
        .BYTE $00,$05,$06,$01,$02,$05,$02,$01
        .BYTE $00,$00,$06,$02,$BD,$00,$BF,$00
        .BYTE $FF,$C5,$BF,$01,$00,$42,$02,$40
        .BYTE $00,$40,$06,$01,$FF,$00,$02,$40
        .BYTE $FF,$45,$02,$00,$00,$00,$02,$01
        .BYTE $24,$00,$05,$01,$00,$00,$00,$00
        .BYTE $00,$BD,$00,$B9,$00,$BD,$40,$BD
        .BYTE $81,$BD,$81,$FF,$00,$FD,$F1,$FF
        .BYTE $00,$20,$81,$FF,$C1,$AE,$83,$EE
        .BYTE $00,$FF,$81,$EE,$81,$AC,$C1,$BD
        .BYTE $C1,$24,$C1,$FF,$C1,$FF,$00,$EE
        .BYTE $81,$FD,$C5,$EE,$C1,$EC,$E1,$FF
        .BYTE $C3,$37,$00,$EE,$C1,$BF,$C3,$AE
        .BYTE $C1,$AE,$00,$FF,$00,$FF,$00,$FD
        .BYTE $81,$DD,$03,$EA,$81,$EC,$C7,$CC
        .BYTE $00,$60,$81,$EC,$83,$EE,$81,$EE
        .BYTE $85,$62,$81,$EE,$81,$EE,$87,$EA
        .BYTE $85,$FD,$83,$ED,$42,$EF,$00,$FF
        .BYTE $00,$28,$02,$EE,$81,$FD,$85,$FF
        .BYTE $81,$FF,$85,$EE,$00,$FD,$85,$FF
        .BYTE $00,$EE,$87,$FF,$81,$FF,$A7,$FF
        .BYTE $01,$FF,$80,$EE,$FD,$FF,$FF,$FF
        .BYTE $FF,$00,$F7,$00,$FF,$00,$BF,$40
        .BYTE $06,$00,$06,$00,$FF,$00,$06,$00
        .BYTE $FF,$21,$06,$00,$06,$01,$06,$01
        .BYTE $BF,$00,$06,$01,$06,$01,$06,$00
        .BYTE $00,$FF,$06,$00,$02,$00,$FF,$41
        .BYTE $46,$00,$06,$01,$2A,$01,$02,$00
        .BYTE $04,$62,$FF,$01,$06,$40,$00,$6B
        .BYTE $04,$91,$BF,$00,$FF,$00,$FF,$00
        .BYTE $42,$02,$BF,$01,$00,$07,$1C,$80
        .BYTE $FF,$25,$06,$01,$02,$07,$02,$05
        .BYTE $00,$85,$06,$01,$02,$05,$02,$01
        .BYTE $00,$00,$06,$03,$BD,$00,$BF,$00
        .BYTE $BF,$C5,$BF,$01,$00,$42,$02,$40
        .BYTE $00,$00,$06,$01,$FF,$00,$02,$40
        .BYTE $FF,$05,$02,$00,$00,$00,$00,$01
        .BYTE $20,$00,$8D,$01,$00,$00,$00,$00
        .BYTE $00,$BD,$00,$B9,$00,$BD,$40,$BD
        .BYTE $81,$BD,$81,$FF,$00,$BF,$F9,$FF
        .BYTE $00,$28,$81,$FF,$81,$AE,$83,$AE
        .BYTE $00,$FF,$81,$EE,$81,$AC,$C1,$BD
        .BYTE $A1,$24,$C1,$FF,$C1,$FF,$00,$AE
        .BYTE $81,$BF,$C5,$EE,$C1,$EC,$E1,$BF
        .BYTE $83,$3F,$00,$EE,$C1,$BF,$E3,$AE
        .BYTE $C1,$AE,$20,$FF,$00,$FF,$00,$BD
        .BYTE $05,$DD,$03,$EA,$81,$EC,$C7,$4C
        .BYTE $00,$68,$81,$EC,$87,$EE,$81,$EE
        .BYTE $AD,$62,$85,$EE,$81,$EE,$87,$EA
        .BYTE $85,$FD,$83,$EC,$42,$EF,$00,$FF
        .BYTE $00,$28,$02,$EE,$81,$BD,$A5,$BF
        .BYTE $81,$BF,$85,$EE,$00,$BF,$AF,$BF
        .BYTE $00,$EC,$87,$FF,$81,$FF,$A7,$EE
        .BYTE $01,$FF,$80,$EE,$FD,$FF,$FF,$FF
        .BYTE $FF,$00,$F7,$00,$FF,$00,$BF,$40
        .BYTE $46,$00,$06,$00,$FF,$00,$06,$00
        .BYTE $FF,$A1,$06,$00,$06,$01,$06,$41
        .BYTE $FF,$00,$06,$01,$06,$01,$06,$00
        .BYTE $00,$FF,$06,$00,$02,$00,$FF,$41
        .BYTE $46,$00,$06,$81,$2A,$01,$02,$00
        .BYTE $04,$62,$FF,$41,$06,$40,$00,$6B
        .BYTE $04,$B1,$FB,$00,$FF,$00,$FF,$00
        .BYTE $42,$02,$B6,$01,$00,$07,$1C,$80
        .BYTE $FF,$25,$06,$01,$02,$07,$02,$05
        .BYTE $00,$85,$06,$01,$02,$05,$02,$01
        .BYTE $00,$00,$06,$03,$BD,$00,$BF,$00
        .BYTE $BF,$C5,$BF,$01,$00,$42,$02,$40
        .BYTE $00,$40,$06,$01,$FF,$00,$02,$40
        .BYTE $FF,$45,$02,$00,$02,$00,$00,$01
        .BYTE $A0,$00,$8F,$01,$00,$00,$00,$00
        .BYTE $00,$BD,$00,$BD,$00,$BD,$40,$BD
        .BYTE $81,$BD,$81,$FF,$00,$FD,$F1,$FF
        .BYTE $00,$20,$81,$FF,$81,$AC,$83,$EE
        .BYTE $00,$FF,$81,$EE,$81,$AC,$C1,$BD
        .BYTE $C1,$24,$C1,$FF,$C1,$FF,$00,$EE
        .BYTE $81,$FD,$C5,$AE,$C1,$EC,$E1,$BF
        .BYTE $C3,$3F,$00,$EE,$C1,$BF,$C3,$AE
        .BYTE $C1,$EE,$00,$FF,$00,$FF,$00,$FD
        .BYTE $85,$DD,$03,$EE,$85,$EC,$C7,$CC
        .BYTE $00,$E8,$81,$EC,$87,$EE,$81,$EE
        .BYTE $8D,$62,$81,$EE,$81,$EE,$87,$EA
        .BYTE $85,$FD,$83,$CC,$42,$EF,$00,$FF
        .BYTE $00,$28,$02,$EE,$C1,$FD,$85,$FF
        .BYTE $81,$FF,$85,$EE,$00,$FD,$85,$BF
        .BYTE $00,$EE,$87,$FF,$81,$FF,$87,$FE
        .BYTE $01,$FF,$80,$EE,$FD,$FF,$FF,$FF
        .BYTE $FF,$00,$F7,$00,$FF,$00,$BF,$40
        .BYTE $46,$00,$06,$00,$FF,$00,$06,$00
        .BYTE $FF,$11,$06,$00,$06,$01,$06,$41
        .BYTE $FF,$00,$06,$01,$06,$01,$06,$00
        .BYTE $00,$FF,$06,$00,$02,$00,$FF,$41
        .BYTE $46,$00,$06,$01,$AB,$41,$02,$00
        .BYTE $04,$62,$FF,$41,$06,$40,$00,$6B
        .BYTE $04,$91,$FF,$00,$FF,$00,$FF,$00
        .BYTE $42,$02,$27,$01,$00,$07,$1C,$00
        .BYTE $FF,$25,$06,$05,$02,$07,$02,$05
        .BYTE $00,$05,$06,$01,$02,$05,$02,$41
        .BYTE $00,$00,$06,$03,$BD,$00,$BF,$00
        .BYTE $BD,$C5,$BF,$01,$00,$42,$02,$41
        .BYTE $00,$40,$06,$01,$FF,$00,$02,$41
        .BYTE $FF,$45,$02,$00,$00,$00,$00,$01
        .BYTE $24,$00,$0D,$01,$00,$00,$00,$00
        .BYTE $00,$BD,$00,$FD,$00,$FD,$40,$BD
        .BYTE $81,$BD,$81,$FF,$00,$FF,$F1,$FF
        .BYTE $00,$20,$81,$FF,$81,$AE,$C3,$EE
        .BYTE $00,$FF,$81,$EE,$81,$AC,$C1,$FD
        .BYTE $81,$24,$C1,$FF,$C1,$FF,$00,$EE
        .BYTE $81,$FF,$C5,$EE,$41,$EC,$E1,$FF
        .BYTE $C3,$37,$00,$EE,$C1,$BF,$C3,$A6
        .BYTE $C1,$A6,$00,$FF,$00,$FF,$00,$BF
        .BYTE $05,$FD,$03,$EA,$85,$EC,$C7,$DD
        .BYTE $00,$60,$81,$EC,$87,$EE,$81,$EE
        .BYTE $85,$62,$81,$EE,$81,$EE,$87,$EA
        .BYTE $85,$FD,$83,$EC,$40,$EF,$00,$FF
        .BYTE $00,$28,$02,$EA,$C1,$AC,$85,$BF
        .BYTE $81,$FF,$85,$EE,$00,$FF,$C7,$BF
        .BYTE $00,$EE,$87,$FF,$81,$FF,$87,$FE
        .BYTE $01,$FF,$00,$EE,$FD,$FF,$FF,$FF
        .BYTE $00,$00,$00,$FF,$FE,$FD,$01,$02
        .BYTE $55,$00,$03,$55,$00,$00,$00,$00
        .BYTE $00,$55,$00,$FF,$FE,$FC,$FB,$FC
        .BYTE $01,$02,$55,$00,$04,$05,$04,$FF
        .BYTE $01,$55,$00,$FD,$FB,$03,$05,$02
        .BYTE $FE,$55,$00,$55,$00,$00,$00,$00
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
        .BYTE $00,$FF,$FE,$01,$02,$03,$01,$02
        .BYTE $55,$00,$03,$55,$00,$01,$02,$03
        .BYTE $04,$55,$00,$FE,$FE,$FF,$01,$03
        .BYTE $FE,$FE,$55,$00,$FF,$01,$03,$04
        .BYTE $04,$55,$00,$FF,$00,$FF,$00,$04
        .BYTE $04,$55,$00,$55,$00,$00,$00,$00
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
        .BYTE $00,$00,$FF,$01,$55,$00,$FE,$02
        .BYTE $55,$00,$00,$FA,$06,$03,$FD,$55
        .BYTE $00,$FD,$03,$FB,$05,$55,$00,$00
        .BYTE $00,$55,$00,$00,$FC,$04,$03,$FD
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
        .BYTE $00,$FF,$01,$01,$55,$00,$01,$01
        .BYTE $55,$00,$FC,$FF,$FF,$05,$05,$55
        .BYTE $00,$FD,$FD,$02,$02,$55,$00,$05
        .BYTE $FD,$55,$00,$FE,$02,$02,$02,$02
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
        .BYTE $00,$55,$00,$FD,$03,$55,$00,$F9
        .BYTE $07,$55,$00,$FB,$05,$55,$00,$00
        .BYTE $55,$00,$00,$55,$00,$55,$FE,$02
        .BYTE $55,$00,$55,$55,$00,$00,$00,$00
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
        .BYTE $00,$55,$00,$00,$00,$55,$00,$00
        .BYTE $00,$55,$00,$FD,$FD,$55,$00,$FB
        .BYTE $55,$00,$04,$55,$00,$55,$FC,$FC
        .BYTE $55,$00,$55,$55,$00,$00,$00,$00
a2AA0   .BYTE $00,$00,$00,$00,$00,$00,$00,$00
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
        .BYTE $00,$01,$01,$02,$55,$00,$00,$01
        .BYTE $02,$02,$55,$00,$00,$00,$02,$55
        .BYTE $00,$FF,$FE,$55,$00,$FE,$FE,$55
        .BYTE $00,$FD,$FE,$55,$00,$55,$00,$00
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
        .BYTE $00,$FF,$00,$00,$55,$00,$01,$01
        .BYTE $01,$02,$55,$00,$02,$03,$03,$55
        .BYTE $00,$01,$00,$55,$00,$FF,$FE,$55
        .BYTE $00,$FF,$FF,$55,$00,$55,$00,$00
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
        .BYTE $00,$00,$00,$ED,$14,$55,$00,$F2
        .BYTE $0F,$55,$00,$00,$55,$00,$00,$55
        .BYTE $00,$00,$55,$00,$00,$FF,$01,$55
        .BYTE $00,$55,$02,$55,$00,$FC,$FD,$03
        .BYTE $04,$55,$00,$55,$00,$00,$00,$00
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
        .BYTE $00,$0B,$F4,$00,$00,$55,$00,$00
        .BYTE $00,$55,$00,$F9,$55,$00,$FC,$55
        .BYTE $00,$FE,$55,$00,$FF,$00,$00,$55
        .BYTE $00,$55,$00,$55,$00,$00,$00,$00
        .BYTE $00,$55,$00,$55,$00,$00,$00,$00
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
        .BYTE $00,$00,$01,$01,$55,$00,$FF,$FF
        .BYTE $FE,$55,$00,$FD,$FC,$FB,$55,$00
        .BYTE $FD,$FE,$FF,$55,$00,$00,$01,$02
        .BYTE $55,$00,$03,$04,$55,$00,$55,$00
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
        .BYTE $00,$FF,$FE,$FD,$55,$00,$01,$02
        .BYTE $03,$55,$00,$04,$04,$03,$55,$00
        .BYTE $FC,$FC,$FC,$55,$00,$FC,$FC,$FC
        .BYTE $55,$00,$FC,$FC,$55,$00,$55,$00
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
        .BYTE $00,$01,$02,$55,$00,$F6,$F6,$55
        .BYTE $00,$FB,$FA,$FB,$FC,$55,$00,$FD
        .BYTE $FD,$FE,$FE,$55,$00,$05,$07,$55
        .BYTE $00,$F9,$F7,$FB,$55,$00,$55,$00
        .BYTE $55,$00,$00,$00,$00,$00,$00,$00
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
        .BYTE $00,$FF,$FE,$55,$00,$FC,$FD,$55
        .BYTE $00,$FA,$FB,$FC,$FB,$55,$00,$05
        .BYTE $06,$06,$05,$55,$00,$03,$02,$55
        .BYTE $00,$01,$03,$03,$55,$00,$55,$00
        .BYTE $55,$00,$00,$00,$00,$00,$00,$00
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
        .BYTE $00,$55,$00,$55,$00,$55,$00,$55
        .BYTE $00,$55,$00,$55,$00,$55,$00,$00
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
        .BYTE $00,$55,$00,$55,$00,$55,$00,$55
        .BYTE $00,$55,$00,$55,$00,$55,$00,$00
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
        .BYTE $00,$00,$00,$00,$00,$00,$00
        .BYTE $FF
dynamicStorage
        .BYTE $00
a3001
