; This is the reverse-engineered source code for the game 'Colourspace'
; written by Jeff Minter in 1985.
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
;
; **** ZP FIELDS **** 
;
HOLDinputCharacter = $7C
;
; **** ZP ABSOLUTE ADRESSES **** 
;
CASINI = $02
a03 = $03
RAMLO = $04
a05 = $05
WARMST = $08
BOOT = $09
DOSINI = $0C
a0D = $0D
ATRACT = $4D
aB0 = $B0
aB1 = $B1
aB2 = $B2
aB3 = $B3
aB4 = $B4
aB5 = $B5
displayListInstructionsLoPtr = $C0
displayListInstructionsHiPtr = $C1
verticalResolutionSPAC = $C2
foregroundPixelsLoPtr2 = $C3
foregroundPixelsHiPtr2 = $C4
aC6 = $C6
someKindOfLinePtrLo = $C7
someKindOfLinePtrHi = $C8
linePtrLo = $C9
linePtrHi = $CA
screenLoPtr = $CB
screenHiPtr = $CC
previousPixelXPosition = $CD
previousPixelYPosition = $CE
pixelValueToPaint = $CF
currentSymmetrySetting = $D0
bottomMostYPos = $D1
xPosLoPtr = $D2
xPosHiPtr = $D3
yPosLoPtr = $D4
yPosHiPtr = $D5
pixelsToPaint = $D6
currentPixelXPosition = $D7
currentPixelYPosition = $D8
currentPaintState = $D9
FR3 = $DA
pixelXPosition = $DB
pixelYPosition = $DC
aDD = $DD
aDE = $DE
aDF = $DF
lastJoystickInput = $E0
aE1 = $E1
currentPosInBuffer = $E2
aE3 = $E3
currentBufferLength = $E4
vectorMode = $E5
FR2 = $E6
speedBoostAdjust = $E8
patternIndex = $E9
currentPatternIndex = $EA
aEB = $EB
FPCOC = $EC
currentSymmetry = $ED
currentBottomMostYPos = $EE
presetLoPtr = $EF
presetHiPtr = $F0
storedPixelYPosition = $F1
alsoStoredPixelYPosition = $F2
pulseSpeed = $F3
pulseSpeed2 = $F4
smoothingDelay = $F5
aF6 = $F6
bufferLength = $F7
aF8 = $F8
currentPulseWidth = $F9
currentPulseWidth2 = $FA
DEGFLG = $FB
FLPTR = $FC
generalLoPtr = $FD
generalHiPtr = $FE
;
; **** ZP POINTERS **** 
;
keyboardInputArray = $C5
;
; **** FIELDS **** 
;
f1100 = $1100
f1200 = $1200
f1300 = $1300
someKindOfLinePtrLoArray = $9EA0
someKindOfLineHiPtrArray = $9F54
fA000 = $A000
fB000 = $B000
;
; **** ABSOLUTE ADRESSES **** 
;
a0201 = $0201
ICCOM = $0362
ICBAL = $0364
ICBAH = $0365
ICBLL = $0368
ICBLH = $0369
ICAX1 = $036A
ICAX2 = $036B
a1400 = $1400
foregroundPixelsLoPtr = $8003
displayListInstructions = $8000
;
; **** POINTERS **** 
;
p00 = $0000
p0F = $000F
p0102 = $0102
p0428 = $0428
p0FFF = $0FFF
foregroundPixelData = $1000
foregroundPixelsHiPtr = $8004
p8008 = $8008
p8280 = $8280

.include "constants.asm"

* = $1F00

;-------------------------------------------------------------------------
; ALoadRoutine   
;-------------------------------------------------------------------------
ALoadRoutine   
        SEC 
        LDY #$00
b1F03   LDA (aB0),Y
        STA (aB2),Y
        LDA aB4
        BNE SkipHere
        DEC aB5
SkipHere
        DEC aB4
        LDA aB4
        ORA aB5
        BEQ b1F1F
        TYA 
        BNE b1F1C
        DEC aB1
        DEC aB3
b1F1C   DEY 
        BCS b1F03
b1F1F   RTS 

;-------------------------------------------------------------------------
; AnotherLoadRoutine   
;-------------------------------------------------------------------------
AnotherLoadRoutine   
        SEC 
        LDY #$00
b1F23   LDA (aB0),Y
        STA (aB2),Y
        LDA aB4
        BNE b1F2D
        DEC aB5
b1F2D   DEC aB4
        LDA aB4
        ORA aB5
        BEQ b1F3E
        INY 
        BNE b1F3C
        INC aB1
        INC aB3
b1F3C   BCS b1F23
b1F3E   RTS 

;-------------------------------------------------------------------------
; Initialization
;-------------------------------------------------------------------------
Initialization
        LDA #$02
        STA BOOT     ;BOOT?   boot flag; 0 if none, 1 for disk, 2 for cassette
        LDA #<SomeKindOfSetupRoutine
        STA CASINI   ;CASINI  cassette initialization vector
        LDA #>SomeKindOfSetupRoutine
        STA a03
        LDA #$00
        STA COLDST   ;COLDST  cold start flag
        JMP WARMSV   ;$E474 (jmp) WARMSV

;-------------------------------------------------------------------------
; SomeKindOfSetupRoutine   
;-------------------------------------------------------------------------
SomeKindOfSetupRoutine   
        LDA a1FC6
        ASL 
        BCS b1F68

        LDY #$1E
b1F5B   LDA ALoadRoutine,Y
        STA PRNBUF,Y
        DEY 
        BPL b1F5B
        LDY #$1F
        BCC b1F75

b1F68   LDY #$1D
b1F6A   LDA AnotherLoadRoutine,Y
        STA PRNBUF,Y
        DEY 
        BPL b1F6A
        LDY #$1E
b1F75   LDX #$00
b1F77   LDA f1FC8,X
        STA PRNBUF,Y
        INY 
        INX 
        CPX a1FC7
        BCC b1F77

        LDA #$FF
        STA COLDST   ;COLDST  cold start flag
        LDA #$00
        STA WARMST   ;WARMST  warmstart flag
        LDA a1FD1
        STA aB0
        LDA a1FD2
        STA aB1
        LDA a1FD3
        STA aB2
        LDA a1FD4
        STA aB3
        LDA a1FD5
        STA aB4
        LDA a1FD6
        STA aB5
        LDA a1FCC
        STA DOSINI   ;DOSINI  
        STA CASINI   ;CASINI  cassette initialization vector
        LDA a1FCD
        STA a0D
        STA a03
        LDA a1FC9
        STA RAMLO    ;RAMLO   
        LDA a1FCA
        STA a05
        JMP PRNBUF

a1FC6   .BYTE $00
a1FC7   .BYTE $09

a1FC9   =*+$01
a1FCA   =*+$02
f1FC8   JSR DoSomethingWithTheCasette

a1FCC   =*+$01
a1FCD   =*+$02
        JSR LaunchColourspace
        JMP (DOSVEC) ;DOSVEC  

a1FD1   .BYTE $56
a1FD2   .BYTE $7C
a1FD3   .BYTE $60
a1FD4   .BYTE $7C
a1FD5   .BYTE $80
a1FD6   .BYTE $5C
        .BYTE $00
        .BYTE $B9,$E1,$1F,$00,$40,$A9
        .BYTE $3C,$8D,$02,$00,$B9,$E1,$1F,$00
        .BYTE $40
;-------------------------------------------------------------------------
; DoSomethingWithTheCasette
;-------------------------------------------------------------------------
DoSomethingWithTheCasette
        LDA #$3C
        STA $D302    ;PACTL
        LDA #$02
        STA BOOT     ;BOOT?   boot flag; 0 if none, 1 for disk, 2 for cassette
        LDA #$00
        STA COLDST   ;COLDST  cold start flag
        LDA DOSINI   ;DOSINI  
        STA CASINI   ;CASINI  cassette initialization vector
        LDA a0D
        STA a03
        JMP (DOSINI) ;DOSINI  

.include "patterns.asm"
;-------------------------------------------------------------------------
; PaintForegroundPoint
;-------------------------------------------------------------------------
PaintForegroundPoint
        LDA foregroundPixelsHiPtr2
        CMP #$0F
        BNE b2C09
        JMP ClearAndProcessForeground

b2C09   LDY #$00
        LDA (foregroundPixelsLoPtr2),Y
        STA previousPixelXPosition
        LDA foregroundPixelsHiPtr2
        PHA 
        CLC 
        ADC #$04
        STA foregroundPixelsHiPtr2
        LDA (foregroundPixelsLoPtr2),Y
        STA previousPixelYPosition
        LDA #$00
        STA currentPaintState
        JSR PaintPixelForCurrentSymmetry
        PLA 
        STA foregroundPixelsHiPtr2
        LDA #$FF
        STA (foregroundPixelsLoPtr2),Y
        DEC foregroundPixelsLoPtr2
        LDA foregroundPixelsLoPtr2
        CMP #$FF
        BNE ClearAndProcessForeground
        DEC foregroundPixelsHiPtr2

ClearAndProcessForeground
        LDA #$00
        STA foregroundDrawState
        JMP ProcessForegroundDrawState

;-------------------------------------------------------------------------
; PaintForeground
; Initially the foreground data contains the 'Colorspace by
; Jeff Minter' banner. See foreground.asm
;-------------------------------------------------------------------------
PaintForeground
        LDA textOutputControl
        CMP #FOREGROUND_GRAPHICS_ON
        BEQ ForegroundIsOn
        CMP #FOREGROUND_GRAPHICS_OFF
        BEQ ForegroundIsOff
        JMP LoadOrProcessParameters

ForegroundIsOff   
        JSR ClearExplosionModeArray
        JSR ClearLinePtrArrays
        LDA #$00
        STA textOutputControl
        JMP MainGameLoop

ForegroundIsOn   
        LDA #>foregroundPixelData
        SEI 
        STA foregroundPixelsHiPtr2
        LDA #<foregroundPixelData
        STA foregroundPixelsLoPtr2
        LDA symmetryForeground
        STA currentSymmetrySetting

ForegroundPaintLoop   
        LDY #$00
        LDA (foregroundPixelsLoPtr2),Y
        CMP #$FF
        BNE HasAForegroundPixelToPaint

ExitForegroundPaintLoop   
        LDA #$00
        STA textOutputControl
        CLI 
        JMP MainGameLoop

HasAForegroundPixelToPaint   
        CLC 
        ADC drawForegroundAtXPos
        STA previousPixelXPosition
        
        ; Get the Y position for this pixel.
        LDA foregroundPixelsHiPtr2
        PHA 
        CLC 
        ADC #$04
        STA foregroundPixelsHiPtr2
        LDA (foregroundPixelsLoPtr2),Y
        CLC 
        ADC drawForegroundAtYPos
        STA previousPixelYPosition

        ; Get the color value for this pixel.
        LDA foregroundPixelsHiPtr2
        CLC 
        ADC #$04
        STA foregroundPixelsHiPtr2
        LDA (foregroundPixelsLoPtr2),Y
        ORA #$40
        STA currentPaintState
        
        ; Now paint the pixel.
        JSR PaintPixelForCurrentSymmetry

        ; Reset the hi ptr back to the X position
        ; array.
        PLA 
        STA foregroundPixelsHiPtr2
        INC foregroundPixelsLoPtr2
        BNE ForegroundPaintLoop

        ; Check if we've read all the pixels.
        INC foregroundPixelsHiPtr2
        LDA foregroundPixelsHiPtr2
        CMP #$14
        BEQ ExitForegroundPaintLoop
        JMP ForegroundPaintLoop

a2CAE   .BYTE $00
explosionMode   .BYTE $00
;-------------------------------------------------------------------------
; PaintExplosionMode
;-------------------------------------------------------------------------
PaintExplosionMode
        LDA currentPaintState
        AND #$77
        STA currentPaintState
        LDA #$0A
        SEC 
        SBC pixelsToPaint
        STA paintOffset
        JSR PaintSomePixels
        DEC paintOffset
        LDA #$10
        STA currentPaintState
        STA ATRACT   ;ATRACT  screen attract counter
        JSR PaintSomePixels
        RTS 

paintOffset   .BYTE $00
;-------------------------------------------------------------------------
; PaintSomePixels
;-------------------------------------------------------------------------
PaintSomePixels
        LDA currentPixelXPosition
        PHA 
        STA previousPixelXPosition
        LDA currentPixelYPosition
        PHA 
        SEC 
        SBC paintOffset
        STA previousPixelYPosition
        STA currentPixelYPosition
        JSR PaintPixelForCurrentSymmetry
        LDA currentPixelXPosition
        CLC 
        ADC paintOffset
        STA currentPixelXPosition
        STA previousPixelXPosition
        LDA currentPixelYPosition
        STA previousPixelYPosition
        JSR PaintPixelForCurrentSymmetry
        LDA currentPixelXPosition
        STA previousPixelXPosition
        PLA 
        PHA 
        STA previousPixelYPosition
        JSR PaintPixelForCurrentSymmetry
        LDA currentPixelXPosition
        STA previousPixelXPosition
        PLA 
        PHA 
        CLC 
        ADC paintOffset
        STA previousPixelYPosition
        STA currentPixelYPosition
        JSR PaintPixelForCurrentSymmetry
        LDA currentPixelXPosition
        SEC 
        SBC paintOffset
        STA currentPixelXPosition
        STA previousPixelXPosition
        LDA currentPixelYPosition
        STA previousPixelYPosition
        JSR PaintPixelForCurrentSymmetry
        LDA currentPixelXPosition
        SEC 
        SBC paintOffset
        STA currentPixelXPosition
        STA previousPixelXPosition
        LDA currentPixelYPosition
        STA previousPixelYPosition
        JSR PaintPixelForCurrentSymmetry
        LDA currentPixelXPosition
        STA previousPixelXPosition
        LDA currentPixelYPosition
        SEC 
        SBC paintOffset
        STA currentPixelYPosition
        STA previousPixelYPosition
        JSR PaintPixelForCurrentSymmetry
        LDA currentPixelXPosition
        STA previousPixelXPosition
        LDA currentPixelYPosition
        SEC 
        SBC paintOffset
        STA previousPixelYPosition
        JSR PaintPixelForCurrentSymmetry
        PLA 
        STA currentPixelYPosition
        PLA 
        STA currentPixelXPosition
        RTS 

p2D58   .BYTE $43,$3A,$9B
;-------------------------------------------------------------------------
; OpenDeviceForSaving
;-------------------------------------------------------------------------
OpenDeviceForSaving
        LDA #$03
        STA ICCOM
        LDA #<p2D58
        STA ICBAL
        LDA #>p2D58
        STA ICBAH
        LDA #<p8008
        STA ICAX1
        LDA #>p8008
        STA ICAX2
        LDX #$20
        JMP CIOV     ;$E456 (jmp) CIOV

;-------------------------------------------------------------------------
; CloseDevice
;-------------------------------------------------------------------------
CloseDevice
        LDA #$0C
        STA ICCOM
        LDX #$20
        JSR CIOV     ;$E456 (jmp) CIOV
        LDA #$00
        STA textOutputControl
        JMP ClearLoadSaveText

;-------------------------------------------------------------------------
; WriteScreenStateToDevice
;-------------------------------------------------------------------------
WriteScreenStateToDevice
        LDA #$03
        STA ICCOM
        LDA #<p2D58
        STA ICBAL
        LDA #>p2D58
        STA ICBAH
        LDA #<foregroundPixelsHiPtr
        STA ICAX1
        LDA #>foregroundPixelsHiPtr
        STA ICAX2
        LDX #$20
        JMP CIOV     ;$E456 (jmp) CIOV
        ;Returns

PUT_CHARACTER = $0B
a20A0 = $20A0
;-------------------------------------------------------------------------
; LoadOrProcessParameters
;-------------------------------------------------------------------------
LoadOrProcessParameters
        JSR UpdateLoadSaveText
        LDA textOutputControl
        CMP #START_PARM_SAVE
        BNE MaybeStartParameterLoad
        JSR OpenDeviceForSaving
        LDA #PUT_CHARACTER
        STA ICCOM

ProcessParameters
        LDA #<foregroundPixelData
        STA ICBAL
        LDA #>foregroundPixelData
        STA ICBAH
        LDA #<presets
        STA ICBLL
        LDA #>presets
        STA ICBLH
        LDX #$20
        JSR CIOV     ;$E456 (jmp) CIOV
        JSR CloseDevice
        JMP MainGameLoop

MaybeStartParameterLoad   
        CMP #START_PARM_LOAD
        BNE MaybeSaveDynamics
        JSR WriteScreenStateToDevice
        LDA #$07
        STA ICCOM
        JMP ProcessParameters

MaybeSaveDynamics   
        CMP #START_DYNAMICS_SAVE
        BNE StartDynamicsLoad

        ; Save dynamics.
        JSR OpenDeviceForSaving
        LDA #PUT_CHARACTER
        STA ICCOM

ProcessDynamics
        LDA #$00
        STA ICBAL
        STA ICBLL
        LDA #<a20A0
        STA ICBAH
        LDA #>a20A0
        STA ICBLH
        LDX #$20
        JSR CIOV     ;$E456 (jmp) CIOV
        JSR CloseDevice
        JMP MainGameLoop

StartDynamicsLoad   
        JSR WriteScreenStateToDevice
        LDA #$07
        STA ICCOM
        JMP ProcessDynamics

.enc "atascii"
parameterSaveLoadText
        .TEXT 'PARAMETER'
loadSaveText
        .TEXT ' SAVE MODE PARAMETER'
        .TEXT ' LOAD MODE DYNAMICS '
        .TEXT 'SAVE MODE  DYNAMICS '
        .TEXT 'LOAD MODE  '
.enc "none"
;-------------------------------------------------------------------------
; UpdateLoadSaveText
;-------------------------------------------------------------------------
UpdateLoadSaveText
        LDA textOutputControl
        SEC 
        SBC #START_PARM_SAVE
        BEQ b2E7E
        TAX 
        LDA #$00
b2E78   CLC 
        ADC #$14
        DEX 
        BNE b2E78
b2E7E   TAX 
        LDY #$00
b2E81   LDA parameterSaveLoadText,X
        STA statusTextLineOne,Y
        STA statusTextLineTwo,Y
        INX 
        INY 
        CPY #$14
        BNE b2E81
        RTS 

;-------------------------------------------------------------------------
; ClearLoadSaveText
;-------------------------------------------------------------------------
ClearLoadSaveText
        LDX #$00
        LDA loadSaveText
b2E96   STA statusTextLineOne,X
        STA statusTextLineTwo,X
        INX 
        CPX #$14
        BNE b2E96
        RTS 

        .BYTE $55,$55,$55,$55,$55,$55,$55,$55
        .BYTE $55,$55,$55,$55,$55,$55,$55,$10
        .BYTE $10,$13,$A2,$00
;-------------------------------------------------------------------------
; WriteCreditsText
;-------------------------------------------------------------------------
WriteCreditsText
        LDX #$00
b2EB8   LDY a2ED8
        LDA creditsText,Y
        STA statusTextLineOne,X
        STA statusTextLineTwo,X
        INX 
        INC a2ED8
        CPX #$14
        BNE b2EB8
        INY 
        LDA creditsText,Y
        BNE b2ED7
        LDA #$00
        STA a2ED8
b2ED7   RTS 

a2ED8   .BYTE $00

.enc "atascii2"  ;define an ascii->atascii encoding
        .cdef " Z", $80
.enc "none"

.enc "atascii"
creditsText   
        .TEXT 'COLOURSPACE WAS MADE'
        .TEXT 'BY YAK THE HAIRY    '
        .TEXT 'IN MAR/APR 1985.... '
        .TEXT 'I RECOMMEND LARGE   '
        .TEXT 'AMOUNTS OF FLOYD,   '
        .TEXT 'GENESIS AND '
.enc "atascii2"
        .TEXT 'STEVE   '
        .TEXT 'HILLAGE'
.enc "atascii"
        .TEXT ' TO GO WITH  THE ZARJ'
        .TEXT 'AZ DISPLAYS.SPECIAL '
        .TEXT 'THANXX TO:  RICHIE, '
        .TEXT 'RONNIE,     ROG, DAV'
        .TEXT 'E, STEVE ETCAND ALSO'
        .TEXT ' THE SLOTHS  '
.enc "none"

a2FCA   .BYTE $00,$55,$55,$55,$55,$55,$55,$55
        .BYTE $55,$55,$55,$55,$55,$55,$55,$55
        .BYTE $55,$55,$55,$55,$55,$55,$55,$55
        .BYTE $55,$55,$55,$55,$55,$55,$55,$55
        .BYTE $55,$55,$55,$55,$55,$55,$55,$55
        .BYTE $55,$55,$55,$55,$55,$55,$55,$55
        .BYTE $55,$55,$55,$55,$55,$55

.include "presets.asm"
;-------------------------------------------------------------------------
; LaunchColourspace
;-------------------------------------------------------------------------
LaunchColourspace
        LDX #$00
        LDA a2FCA
        BNE b4032
        INC a2FCA

        ; Copy the banner data into the RAM
        ; used for foreground data.
b400A   LDA #$CC
        STA fA000,X
        STA fB000,X
        LDX #$00
a4015   =*+$01
a4016   =*+$02
        LDA foregroundPixelsOriginalLocation
a4018   =*+$01
a4019   =*+$02
        STA foregroundPixelData
        INC a4015
        BNE b4022
        INC a4016
b4022   INC a4018
        BNE b402A
        INC a4019
b402A   LDA a4019
        INX 
        CMP #$1C
        BNE b400A

b4032   JSR CreateLinePtrArrays
        JSR ClearLinePtrArrays
        JSR UpdateDefaultColors
        JMP InitializeColourSpace

        .BYTE $00
a403F   .BYTE $00
;-------------------------------------------------------------------------
; GenerateDisplayList
;-------------------------------------------------------------------------
GenerateDisplayList
        LDA #>displayListInstructions
        STA displayListInstructionsHiPtr
        LDA #<displayListInstructions
        STA displayListInstructionsLoPtr
        LDA #>foregroundPixelsOriginalLocation
        STA foregroundPixelsHiPtr2
        LDA #<foregroundPixelsOriginalLocation
        STA foregroundPixelsLoPtr2

        LDX verticalResolutionSPAC
        LDA verticalResolutionArray,X
        STA a403F

        LDY #$00
        STY bottomMostYPos

        LDA #$70 ; 8 blank lines
        JSR WriteValueToDisplayList
        JSR WriteValueToDisplayList

        ; Mode 6 setting screen memory to foregroundPixelsLoPtr
        ; and foregroundPixelsHiPtr
        LDA #$46
        JSR WriteValueToDisplayList
        LDA foregroundPixelsLoPtr
        JSR WriteValueToDisplayList
        LDA foregroundPixelsHiPtr
        JSR WriteValueToDisplayList

        ; Not sure what this is, more blank lines.
        LDA #$90
        JSR WriteValueToDisplayList

        LDA screenMode
        BEQ NoScreenModeSelected
        JMP MaybeHIResHardReflectMode


        ; Mode 15 setting screen memory to foregroundPixelsLoPtr
        ; and foregroundPixelsHiPtr
NoScreenModeSelected   
        LDX verticalResolutionSPAC
b4084   LDA #$4F
        JSR WriteValueToDisplayList
        LDA foregroundPixelsLoPtr2
        JSR WriteValueToDisplayList
        LDA foregroundPixelsHiPtr2
        JSR WriteValueToDisplayList
        DEX 
        BNE b4084

        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$28
        STA foregroundPixelsLoPtr2
        LDA foregroundPixelsHiPtr2
        ADC #$00
        STA foregroundPixelsHiPtr2
        INC bottomMostYPos
        DEC a403F
        BNE NoScreenModeSelected

WriteDisplayListFooter
        ; JVB, restart same display list on next frame
        LDA #$41
        JSR WriteValueToDisplayList
        LDA #<displayListInstructions
        JSR WriteValueToDisplayList
        LDA #>displayListInstructions
        JSR WriteValueToDisplayList

        LDA #<p00
        STA SDMCTL   ;SDMCTL  shadow for DMACTL ($D400)

        LDA #<displayListInstructions
        STA SDLSTL   ;SDLSTL  shadow for DLISTL ($D402)
        LDA #>displayListInstructions
        STA SDLSTH   ;SDLSTH  shadow for DLISTH ($D403)

        LDA #$22
        STA SDMCTL   ;SDMCTL  shadow for DMACTL ($D400)
        LDA dualJoystickMode
        BEQ b40D7
        LDA bottomMostYPos
        JMP j40DD

b40D7   LDA bottomMostYPos
        CMP pixelYPosition
        BPL b40E9

j40DD
        LDX pixelYPosition
        STX storedPixelYPosition
        STX alsoStoredPixelYPosition      ;alsoStoredPixelYPosition     
        STA pixelYPosition
        DEC pixelYPosition
        DEC pixelYPosition
b40E9   RTS 

;-------------------------------------------------------------------------
; WriteValueToDisplayList
;-------------------------------------------------------------------------
WriteValueToDisplayList
        STA (displayListInstructionsLoPtr),Y
        INC displayListInstructionsLoPtr
        BNE b40F2
        INC displayListInstructionsHiPtr
b40F2   RTS 

;-------------------------------------------------------------------------
; InitializeColourSpace
;-------------------------------------------------------------------------
InitializeColourSpace
        LDX #>VerticalBlankInterruptHandler
        LDY #<VerticalBlankInterruptHandler
        LDA #$07
        JSR SETBV    ;$E45C (jmp) SETBV
        LDA #$10
        STA smoothingDelay
        LDA #<DisplayListInterrupt
        STA VDSLST   ;VDSLST  display list interrupt vector
        LDA #>DisplayListInterrupt
        STA a0201
        LDA #<p0428
        STA pixelXPosition
        LDA #>p0428
        STA pixelYPosition
        LDA #THE_SMOOTH_CROSSFLOW
        STA currentSymmetry
        TAX 
        JSR UpdateStatusLine
        LDA #$00
        STA screenMode
        STA alsoStoredPixelYPosition      ;alsoStoredPixelYPosition     
        STA pulseSpeed   ;pulseSpeed  
        STA pulseSpeed2
        STA FR2
        STA currentPulseWidth
        STA currentPulseWidth2
        STA textOutputControl
        LDA #$FF
        STA aDF
        LDA #$01
        STA currentPatternIndex
        JSR ClearExplosionModeArray
        LDA #$40
        STA currentBufferLength
        STA bufferLength
        STA aF6
        LDA #$01
        STA speedBoostAdjust
        LDA #$C0
        STA $D40E    ;NMIEN
        LDX #$00
        LDA #$01
        STA vectorMode
        LDA #$18
        STA bottomMostYPos
        LDA #$05
        STA verticalResolutionSPAC
        JSR GenerateDisplayList
        JMP MainGameLoop

foregroundPixelsLoPtrArray = $7E10
foregroundPixelsHiPtrArray = $7EC4
;-------------------------------------------------------------------------
; CreateLinePtrArrays
;-------------------------------------------------------------------------
CreateLinePtrArrays
        LDA #<foregroundPixelsOriginalLocation
        STA foregroundPixelsLoPtr2
        LDA #>foregroundPixelsOriginalLocation
        STA foregroundPixelsHiPtr2
        LDA #<p8280
        STA someKindOfLinePtrLo
        LDA #>p8280
        STA someKindOfLinePtrHi

        LDX #$00
b4170   LDA foregroundPixelsLoPtr2
        STA foregroundPixelsLoPtrArray,X
        LDA foregroundPixelsHiPtr2
        STA foregroundPixelsHiPtrArray,X

        LDA someKindOfLinePtrLo
        STA someKindOfLinePtrLoArray,X
        LDA someKindOfLinePtrHi
        STA someKindOfLineHiPtrArray,X

        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$28
        STA foregroundPixelsLoPtr2

        LDA foregroundPixelsHiPtr2
        ADC #$00
        STA foregroundPixelsHiPtr2

        LDA someKindOfLinePtrLo
        CLC 
        ADC #$50
        STA someKindOfLinePtrLo

        LDA someKindOfLinePtrHi
        ADC #$00
        STA someKindOfLinePtrHi

        INX 
        CPX #$5A
        BNE b4170
        RTS 

b41A4   PLA 
        RTS 

;-------------------------------------------------------------------------
; PaintRestOfCurrentSymmetry
;-------------------------------------------------------------------------
PaintRestOfCurrentSymmetry
        LDX previousPixelYPosition
        PHA 
        LDY previousPixelXPosition
        TXA 
        AND #$80
        BNE b41A4
        CPX #$5A
        BPL b41A4
        TYA 
        AND #$80
        BNE b41A4
        CPY #$50
        BPL b41A4
        LDA someKindOfLinePtrLoArray,X
        STA linePtrLo
        LDA someKindOfLineHiPtrArray,X
        STA linePtrHi
        LDA foregroundPixelsLoPtrArray,X
        STA screenLoPtr
        LDA foregroundPixelsHiPtrArray,X
        STA screenHiPtr
        PLA 
        STA pixelValueToPaint
        LDA beginDrawingForeground
        BNE b41E7
        LDA (linePtrLo),Y
        AND #$EF
        SEC 
        SBC pixelValueToPaint
        BMI b41E7
        CMP #$01
        BEQ b41E7
        RTS 

b41E7   LDA pixelValueToPaint
        STA (linePtrLo),Y
        AND #$0F
        PHA 
        TYA 
        CLC 
        ROR 
        BCC b4200
        TAY 
        PLA 
        STA pixelValueToPaint
        LDA (screenLoPtr),Y
        AND #$F0
        ORA pixelValueToPaint
        STA (screenLoPtr),Y
        RTS 

b4200   TAY 
        PLA 
        CLC 
        ROL 
        ROL 
        ROL 
        ROL 
        STA pixelValueToPaint
        LDA (screenLoPtr),Y
        AND #$0F
        ORA pixelValueToPaint
        STA (screenLoPtr),Y
        RTS 

verticalResolutionArray   
        .BYTE $00,$B4,$5A,$3C,$2D,$24,$1E,$19
        .BYTE $16,$14,$12,$10,$0F,$0E,$0D,$0C
        .BYTE $0B,$0B,$0A

tempLoPtr = displayListInstructionsLoPtr
tempHiPtr = displayListInstructionsHiPtr
;-------------------------------------------------------------------------
; ClearLinePtrArrays
;-------------------------------------------------------------------------
ClearLinePtrArrays
        LDX #$00
b4227   LDA foregroundPixelsLoPtrArray,X
        STA tempLoPtr
        LDA foregroundPixelsHiPtrArray,X
        STA tempHiPtr

        LDY #$00
b4233   LDA #$00
        STA (tempLoPtr),Y
        INY 
        CPY #$28
        BNE b4233

        LDA someKindOfLinePtrLoArray,X
        STA tempLoPtr
        LDA someKindOfLineHiPtrArray,X
        STA tempHiPtr

        LDY #$00
        LDA #$00
b424A   STA (tempLoPtr),Y
        INY 
        CPY #$50
        BNE b424A

        INX 
        CPX #$5A
        BNE b4227
        RTS 

;-------------------------------------------------------------------------
; UpdateDefaultColors
;-------------------------------------------------------------------------
UpdateDefaultColors
        LDX #$00
b4259   LDA defaultColorArray,X
        STA PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
        INX 
        CPX #$08
        BNE b4259
        RTS 

defaultColorArray   .BYTE $00,$18,$38,$58,$78,$98,$B8,$D8
;-------------------------------------------------------------------------
; PaintPixelForCurrentSymmetry
;-------------------------------------------------------------------------
PaintPixelForCurrentSymmetry
        LDA currentPaintState
        PHA 
        JSR PaintRestOfCurrentSymmetry
        LDA currentSymmetrySetting
        BNE b4279
        PLA 
        RTS 

b4279   CMP #$01
        BNE MaybeXYSymmetry

YAxisSymmetry
        LDA #$4F
        SEC 
        SBC previousPixelXPosition
        STA previousPixelXPosition
        PLA 
        JMP PaintRestOfCurrentSymmetry

MaybeXYSymmetry   
        CMP #$02
        BNE b4296

        ; X-Y Symmetry
        LDA currentBottomMostYPos
        SEC 
        SBC previousPixelYPosition
        STA previousPixelYPosition
        JMP YAxisSymmetry

b4296   CMP #$03
        BNE b42A5
        LDA currentBottomMostYPos
        SEC 
        SBC previousPixelYPosition
        STA previousPixelYPosition
        PLA 
        JMP PaintRestOfCurrentSymmetry

b42A5   LDA currentBottomMostYPos
        SEC 
        SBC previousPixelYPosition
        STA previousPixelYPosition
        PLA 
        PHA 
        JSR PaintRestOfCurrentSymmetry
        LDA #$4F
        SEC 
        SBC previousPixelXPosition
        STA previousPixelXPosition
        PLA 
        PHA 
        JSR PaintRestOfCurrentSymmetry
        LDA currentBottomMostYPos
        SEC 
        SBC previousPixelYPosition
        STA previousPixelYPosition
        PLA 
        JMP PaintRestOfCurrentSymmetry

;-------------------------------------------------------------------------
; LoopThroughPixelsAndPaint
;-------------------------------------------------------------------------
LoopThroughPixelsAndPaint
        LDA currentPixelXPosition
        STA previousPixelXPosition
        LDA currentPixelYPosition
        STA previousPixelYPosition
        LDA currentPaintState
        AND #$80
        BEQ b42D9
        JMP PaintExplosionMode

b42D9   JSR PaintPixelForCurrentSymmetry
        LDA pixelsToPaint
        CMP #$07
        BNE b42E3
        RTS 

b42E3   LDX patternIndex
        LDA pixelXPositionLoPtrArray,X
        STA xPosLoPtr
        LDA pixelXPositionHiPtrArray,X
        STA xPosHiPtr
        LDA pixelYPositionLoPtrArray,X
        STA yPosLoPtr      ;yPosLoPtr     floating point register 0
        LDA pixelYPositionHiPtrArray,X
        STA yPosHiPtr

        LDA #$07
        STA FR3
        LDY #$00
;-------------------------------------------------------------------------
; PixelPaintLoop
;-------------------------------------------------------------------------
PixelPaintLoop
        LDA (xPosLoPtr),Y
        CMP #$55
        BEQ b431C
        CLC 
        ADC currentPixelXPosition
        STA previousPixelXPosition
        LDA (yPosLoPtr),Y  ;yPosLoPtr     floating point register 0
        CLC 
        ADC currentPixelYPosition
        STA previousPixelYPosition
        TYA 
        PHA 
        JSR PaintPixelForCurrentSymmetry
        PLA 
        TAY 
        INY 
        JMP PixelPaintLoop

b431C   DEC FR3
        INY 
        LDA pixelsToPaint
        CMP FR3
        BNE PixelPaintLoop
        STA ATRACT   ;ATRACT  screen attract counter
        RTS 

; Some patterns
theTwistXPosArray
        .BYTE $00,$55
        .BYTE $01,$02,$55
        .BYTE $01,$02,$03,$55
        .BYTE $01,$02,$03,$04,$55
        .BYTE $00,$00,$00,$55
        .BYTE $FF,$FE,$55
        .BYTE $55
theTwistYPosArray
        .BYTE $FF,$55
        .BYTE $FF,$FE,$55
        .BYTE $00,$00,$00,$55
        .BYTE $01,$02,$03,$04,$55
        .BYTE $01,$02,$03,$55
        .BYTE $01,$02,$55
        .BYTE $55
smoothCrossflowXPosArray
        .BYTE $FF,$01,$55
        .BYTE $FE,$02,$55
        .BYTE $FD,$03,$55
        .BYTE $FC,$04,$55
        .BYTE $FB,$05,$55
        .BYTE $FA,$06,$55
        .BYTE $55
smoothCrossflowYPosArray
        .BYTE $02,$FE,$55
        .BYTE $FF,$01,$55
        .BYTE $04,$FC,$55
        .BYTE $FE,$02,$55
        .BYTE $06,$FA,$55
        .BYTE $FD,$03,$55
        .BYTE $55
denturesXPosArray
        .BYTE $01,$55
        .BYTE $02,$55
        .BYTE $03,$55
        .BYTE $04,$55
        .BYTE $05,$55
        .BYTE $06,$55
        .BYTE $55
denturesYPosArray
        .BYTE $FE,$55
        .BYTE $02,$55
        .BYTE $FD,$55
        .BYTE $03,$55
        .BYTE $FC,$55
        .BYTE $04,$55
        .BYTE $55
deltoidsXPosArray
        .BYTE $FF,$00,$01,$55
        .BYTE $55
        .BYTE $FE,$FF,$00,$01,$02,$55
        .BYTE $FD,$00,$03,$55
        .BYTE $FC,$00,$04,$55
        .BYTE $FA,$00,$06,$55
        .BYTE $55
deltoidsYPosArray
        .BYTE $00,$FF,$00,$55
        .BYTE $55
        .BYTE $00,$FF,$FE,$FF,$00,$55
        .BYTE $01,$FD,$01,$55
        .BYTE $02,$FC,$02,$55
        .BYTE $04,$FA,$04,$55
        .BYTE $55
pulsarCrossXPosArray
        .BYTE $00,$01,$00,$FF,$55
        .BYTE $00,$02,$00,$FE,$55
        .BYTE $00,$03,$00,$FD,$55
        .BYTE $00,$04,$00,$FC,$55
        .BYTE $00,$05,$00,$FB,$55
        .BYTE $00,$06,$00,$FA,$55
        .BYTE $55
pulsarCrossYPosArray
        .BYTE $FF,$00,$01,$00,$55
        .BYTE $FE,$00,$02,$00,$55
        .BYTE $FD,$00,$03,$00,$55
        .BYTE $FC,$00,$04,$00,$55
        .BYTE $FB,$00,$05,$00,$55
        .BYTE $FA,$00,$06,$00,$55
        .BYTE $55
slothMultiCrossXPosArray
        .BYTE $FF,$01,$01,$FF,$55
        .BYTE $FE,$02,$02,$FE,$55
        .BYTE $FD,$FF,$01,$03,$03,$01,$FF,$FD,$55
        .BYTE $FD,$03,$03,$FD,$55
        .BYTE $FC,$04,$04,$FC,$55
        .BYTE $FB,$FD,$03,$05,$05,$03,$FD,$FB,$55
        .BYTE $55
slothMultiCrossYPosArray
        .BYTE $FF,$FF,$01,$01,$55
        .BYTE $FE,$FE,$02,$02,$55
        .BYTE $FF,$FD,$FD,$FF,$01,$03,$03,$01,$55
        .BYTE $FD,$FD,$03,$03,$55
        .BYTE $FC,$FC,$04,$04,$55
        .BYTE $FD,$FB,$FB,$FD,$03,$05,$05,$03,$55
        .BYTE $55
crossAndABitXPosArray
        .BYTE $FF,$01,$55
        .BYTE $FD,$03,$55
        .BYTE $FE,$02,$55
        .BYTE $FB,$05,$55
        .BYTE $08,$08,$55
        .BYTE $08,$08,$55
        .BYTE $55
crossAndABitYPosArray
        .BYTE $FF,$01,$55
        .BYTE $FD,$03,$55
        .BYTE $01,$FF,$55
        .BYTE $02,$FE,$55
        .BYTE $0B,$0F,$55
        .BYTE $0C,$0E,$55
        .BYTE $55
star2XPosArray
        .BYTE $FF,$55
        .BYTE $01,$55
        .BYTE $FE,$55
        .BYTE $02,$55
        .BYTE $01,$55
        .BYTE $FF,$55
        .BYTE $55
start2YPosArray
        .BYTE $FD,$55
        .BYTE $FE,$55
        .BYTE $FF,$55
        .BYTE $00,$55
        .BYTE $02,$55
        .BYTE $02,$55
        .BYTE $55

;-------------------------------------------------------------------------
; VerticalBlankInterruptHandler
;-------------------------------------------------------------------------
VerticalBlankInterruptHandler
        PHA 
        TXA 
        PHA 
        TYA 
        PHA 

        LDA $D01B    ;PRIOR
        AND #$3F
        STA $D01B    ;PRIOR
        LDA PCOLR0   ;PCOLR0  shadow for COLPM0 ($D012)
        STA $D01A    ;COLBK

        JSR LookForKeyboardInput

        DEC newCursorSpeed
        BNE b44B4

        LDA cursorSpeed
        STA newCursorSpeed

        JSR GetJoystickInput

b44B4   INC COLOR4   ;COLOR4  shadow for COLBK ($D01A)
        JSR CheckStrobesAndColorFlow

        PLA 
        TAY 
        PLA 
        TAX 
        PLA 
        JMP XITBV    ;$E462 (jmp) XITBV

b44C2   RTS 

;-------------------------------------------------------------------------
; FetchValuesForPlayback
;-------------------------------------------------------------------------
FetchValuesForPlayback
        LDA autoDemoEnabled
        CMP #PLAYBACK_ENABLED
        BEQ b44C2

        TYA 
        PHA 
        TXA 
        PHA 
        LDX pixelYPosition
        LDY pixelXPosition
        LDA someKindOfLinePtrLoArray,X
        STA aDD
        LDA someKindOfLineHiPtrArray,X
        STA aDE
        LDA (aDD),Y
        AND #$40
        BEQ b44E7
        PLA 
        TAX 
        PLA 
        TAY 
        RTS 

b44E7   LDX pixelYPosition
        LDA pixelXPosition
        CLC 
        ROR 
        TAY 
        LDA foregroundPixelsLoPtrArray,X
        STA aDD
        LDA foregroundPixelsHiPtrArray,X
        STA aDE
        LDA aDF
        BEQ b4526

        LDA #$08
b44FE   STA aE1
        LDA pixelXPosition
        AND #$01
        BEQ b4511
        LDA (aDD),Y
        AND #$F0
        ORA aE1
        STA (aDD),Y
        JMP j4521

b4511   LDA aE1
        ASL 
        ASL 
        ASL 
        ASL 
        STA aE1
        LDA (aDD),Y
        AND #$0F
        ORA aE1
        STA (aDD),Y

j4521
        PLA 
        TAX 
        PLA 
        TAY 
        RTS 

b4526   LDA #$00
        BEQ b44FE

;-------------------------------------------------------------------------
; GetJoystickInput
;-------------------------------------------------------------------------
GetJoystickInput
        LDA alsoStoredPixelYPosition      ;alsoStoredPixelYPosition     
        BEQ b4549

        LDA #$00
        STA alsoStoredPixelYPosition      ;alsoStoredPixelYPosition     
        STA aDF

        LDA pixelYPosition
        PHA 
        LDA storedPixelYPosition
        STA pixelYPosition

        JSR FetchValuesForPlayback
        PLA 
        STA pixelYPosition
        JSR DuplicatePixelPosition
        LDA #$0A
        STA a5CF7
b4549   LDA #$00
        STA aDF
        JSR FetchValuesForPlayback

        LDX speedBoostAdjust

        LDA STICK0   ;STICK0  shadow for PORTA lo ($D300)
        AND slothMode
        LDY STRIG0   ;STRIG0  shadow for TRIG0 ($D001)
        BNE b455F

        ORA #$80
b455F   STA lastJoystickInput      ;lastJoystickInput     floating point register 1
        LDA autoDemoEnabled
        BEQ b456E

        CMP #RECORDING_ENABLED
        BEQ b456E

        LDA FLPTR
        STA lastJoystickInput      ;lastJoystickInput     floating point register 1

b456E   LDA dualJoystickMode
        BEQ b4580

        INC a58A4
        LDA a58A4
        AND #$01
        BEQ b4580

        JSR SomethingToDoWithSecondJoystick

b4580   LDA a4ECC
        BEQ JoystickLoop

        LDA #$FA
        STA lastJoystickInput      ;lastJoystickInput     floating point register 1

JoystickLoop   
        LDA vectorMode
        AND #$02
        BEQ MaybeJoystickPressedUp

        TXA 
        PHA 
        JSR ProcessJoystickMovementInVectorMode
        JMP UpdateStateFromJoystickMovement

MaybeJoystickPressedUp   
        LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$01
        BNE MaybeJoystickPressedDown

        DEC pixelYPosition
        BPL MaybeJoystickPressedDown
        LDA bottomMostYPos
        STA pixelYPosition
        DEC pixelYPosition

MaybeJoystickPressedDown   
        LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$02
        BNE MaybeJoystickPressedLeft

        INC pixelYPosition
        LDA pixelYPosition
        CMP bottomMostYPos
        BNE MaybeJoystickPressedLeft
        LDA #$00
        STA pixelYPosition

MaybeJoystickPressedLeft   
        LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$04
        BNE MaybeJoystickPressedRight

        DEC pixelXPosition
        BPL MaybeJoystickPressedRight
        LDA #$4F
        STA pixelXPosition

MaybeJoystickPressedRight   
        LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$08
        BNE ProcessJoystick

        INC pixelXPosition
        LDA pixelXPosition
        CMP #$50
        BNE ProcessJoystick

        LDA #$00
        STA pixelXPosition
        
ProcessJoystick   
        TXA 
        PHA 

UpdateStateFromJoystickMovement
        JSR UpdateStateArrays
        PLA 
        TAX 
        DEX 
        BNE JoystickLoop

        LDA #$01
        STA aDF
        JSR FetchValuesForPlayback
        LDA secondJoystickMadeAMovememnt
        BEQ b4614

        LDA #$00
        STA secondJoystickMadeAMovememnt
        LDA pixelXPosition
        STA a5CF6
        LDA pixelYPosition
        STA a5CF7
        LDA a5CF3
        STA pixelXPosition
        LDA a5CF4
        STA pixelYPosition
        LDA currentPatternIndex
        PHA 
        LDA secondUserLightform
        STA currentPatternIndex
        PLA 
        STA secondUserLightform

b4614   RTS 

pixelXPositionArray   
        .BYTE $4B,$45,$59,$36,$09,$3A,$4E,$C0
        .BYTE $01,$0C,$4B,$36,$31,$0B,$6B,$4E
        .BYTE $C0,$3B,$0E,$42,$4F,$54,$52,$4F
        .BYTE $09,$48,$4E,$C0,$15,$0C,$4B,$36
        .BYTE $32,$0B,$9B,$54,$C0,$96,$0C,$4D
        .BYTE $43,$48,$45,$43,$09,$4C,$4E,$C0
        .BYTE $1E,$0C,$4B,$5A,$4F,$09,$56,$4E
        .BYTE $C0,$33,$0C,$4B,$36,$33,$0C,$39
pixelYPositionArray   
        .BYTE $54,$C0,$3D,$0C,$53,$48,$4F,$43
        .BYTE $4F,$4C,$0A,$A3,$4E,$C0,$6F,$0C
        .BYTE $4B,$45,$59,$37,$0A,$A2,$4E,$C0
        .BYTE $63,$0C,$53,$54,$52,$4F,$09,$86
        .BYTE $4E,$C0,$5A,$0C,$5A,$58,$5A,$0A
        .BYTE $80,$54,$C0,$04,$0D,$47,$45,$54
        .BYTE $41,$09,$9F,$4E,$C0,$8C,$0D,$5A
        .BYTE $58,$59,$0C,$52,$54,$C0,$E8,$0C
patternIndexArray   
        .BYTE $53,$48,$4F,$4E,$55,$4D,$0A,$CE
        .BYTE $4E,$C0,$79,$0C,$4B,$45,$59,$38
        .BYTE $08,$BC,$4E,$C0,$8B,$0C,$4B,$37
        .BYTE $0A,$CD,$4E,$C0,$5D,$0E,$54,$43
        .BYTE $4F,$4C,$0B,$F3,$54,$C0,$6D,$0D
        .BYTE $4B,$45,$59,$38,$38,$0C,$4D,$4F
        .BYTE $C0,$A2,$0C,$4D,$45,$53,$47,$45
        .BYTE $53,$0B,$4A,$4F,$C0,$AD,$0C,$4D
initialFramesRemainingToNextPaintForStep   
        .BYTE $53,$47,$4C,$4F,$0B,$4B,$4F,$C0
        .BYTE $C1,$0C,$4D,$53,$47,$48,$49,$09
        .BYTE $20,$4F,$C0,$25,$0F,$4E,$4F,$4D
        .BYTE $0A,$38,$4F,$C0,$CB,$0C,$4D,$45
        .BYTE $53,$31,$0A,$24,$4F,$C0,$DE,$0C
        .BYTE $4D,$45,$53,$30,$09,$19,$51,$C0
        .BYTE $E4,$12,$56,$4C,$49,$0A,$C5,$54
        .BYTE $C0,$23,$0D,$4D,$4F,$44,$45,$0A
framesRemainingToNextPaintForStep   
        .BYTE $7E,$54,$C0,$F2,$0C,$53,$48,$4F
        .BYTE $45,$09,$65,$54,$C0,$FB,$0C,$53
        .BYTE $48,$31,$09,$7B,$54,$C0,$82,$0D
        .BYTE $53,$48,$32,$0A,$92,$54,$C0,$F6
        .BYTE $0E,$47,$4D,$55,$54,$09,$8D,$54
        .BYTE $C0,$90,$0F,$48,$49,$58,$0C,$A2
        .BYTE $2E,$C0,$0A,$11,$46,$41,$4C,$53
        .BYTE $49,$45,$0A,$A3,$54,$C0,$2D,$0D
symmetrySettingForStepCount   
        .BYTE $4D,$43,$48,$31,$0A,$C6,$54,$C0
        .BYTE $37,$0D,$4D,$43,$48,$32,$0B,$B1
        .BYTE $54,$C0,$42,$0D,$4D,$43,$48,$31
        .BYTE $31,$0B,$BA,$54,$C0,$4D,$0D,$4D
        .BYTE $43,$48,$45,$4E,$0A,$DD,$54,$C0
        .BYTE $57,$0D,$4D,$43,$48,$33,$0B,$D4
        .BYTE $54,$C0,$62,$0D,$4D,$43,$48,$32
        .BYTE $31,$0B,$E7,$54,$C0,$7C,$12,$4D
explosionModeArray   
        .BYTE $43,$48,$33,$31,$0A,$09,$55,$C0
        .BYTE $77,$0D,$4B,$45,$59,$39,$0B,$30
        .BYTE $55,$C0,$97,$0D,$4B,$45,$59,$31
        .BYTE $30,$0A,$0D,$55,$C0,$91,$0E,$53
        .BYTE $59,$4E,$43,$0B,$0F,$55,$C0,$7D
        .BYTE $0F,$5A,$5A,$54,$4F,$50,$08,$3B
        .BYTE $55,$C0,$9F,$0D,$4B,$54,$0B,$65
        .BYTE $55,$C0,$AA,$0D,$4B,$45,$59,$31
bottomMostYPosArray   
        .BYTE $31,$0A,$64,$55,$C0,$B4,$0D,$4B
        .BYTE $54,$45,$4E,$09,$48,$55,$C0,$BD
        .BYTE $0D,$4B,$54,$49,$09,$4E,$55,$C0
        .BYTE $C6,$0D,$4B,$4B,$4B,$0B,$7D,$55
        .BYTE $C0,$D1,$0D,$4B,$45,$59,$31,$32
        .BYTE $08,$73,$55,$C0,$D9,$0D,$4B,$45
        .BYTE $0B,$9F,$55,$C0,$E4,$0D,$4B,$45
        .BYTE $59,$31,$33,$09,$91,$55,$C0,$ED

;-------------------------------------------------------------------------
; ClearExplosionModeArray
;-------------------------------------------------------------------------
ClearExplosionModeArray
        LDX #$40
b4817   LDA #$FF
        STA explosionModeArray - 1,X
        DEX 
        BNE b4817
        LDA #$00
        STA aE3
        STA currentPosInBuffer
        RTS 

;-------------------------------------------------------------------------
; MainGameLoop
;-------------------------------------------------------------------------
MainGameLoop
        INC currentPosInBuffer
        LDA currentPosInBuffer
        CMP currentBufferLength
        BNE b484E
        LDA #$00
        STA currentPosInBuffer
        LDA aF8
        BEQ b483E
        DEC aF8
        BNE b483E
        LDA bufferLength
        STA currentBufferLength
b483E   LDA beginDrawingForeground
        BEQ b4846
        JMP ForegroundPixelsMaybe

b4846   LDA textOutputControl
        BEQ b484E
        JMP PaintForeground

b484E   LDX currentPosInBuffer
        DEC framesRemainingToNextPaintForStep,X
        BNE GoBackToStartOfLoop

        LDA explosionModeArray,X
        AND #$0F
        CMP #$0F
        BNE b4862
        STX FR2
        BEQ GoBackToStartOfLoop

b4862   LDA explosionModeArray,X
        STA currentPaintState
        AND #$07
        STA pixelsToPaint
        LDA pixelXPositionArray,X
        STA currentPixelXPosition
        LDA pixelYPositionArray,X
        STA currentPixelYPosition
        LDA patternIndexArray,X
        STA patternIndex
        LDA symmetrySettingForStepCount,X
        STA currentSymmetrySetting
        LDA bottomMostYPosArray,X
        STA currentBottomMostYPos
        LDA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        DEC explosionModeArray,X
        JSR LoopThroughPixelsAndPaint

GoBackToStartOfLoop
        LDA selectedModePreventsForegroundDrawing
        BEQ MainGameLoop
        LDA #$00
        STA SDMCTL   ;SDMCTL  shadow for DMACTL ($D400)
        JSR GenerateDisplayList
        LDA #$00
        STA selectedModePreventsForegroundDrawing
        JMP MainGameLoop

;-------------------------------------------------------------------------
; UpdateStateArrays
;-------------------------------------------------------------------------
UpdateStateArrays
        LDA beginDrawingForeground
        BEQ b48AD
        JMP UpdatePixelsForeground

b48AD   LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$80
        BNE b48B9
        LDA a4ECC
        BNE b48B9
b48B8   RTS 

b48B9   LDA pulseSpeed   ;pulseSpeed  
        BEQ b48D9
        DEC pulseSpeed2
        BEQ b48C2
        RTS 

b48C2   LDA currentPulseWidth
        BEQ b48D1
        DEC currentPulseWidth2
        BEQ b48D1
        LDA #$01
        STA pulseSpeed2
        JMP b48D9

b48D1   LDA currentPulseWidth
        STA currentPulseWidth2
        LDA pulseSpeed   ;pulseSpeed  
        STA pulseSpeed2
b48D9   INC aE3
        LDA aE3
        CMP aF6
        BNE b48E9
        LDA #$00
        STA aE3
        LDA bufferLength
        STA aF6
b48E9   LDX aE3
        LDA explosionModeArray,X
        AND #$0F
        CMP #$0F
        BEQ b490D
        LDA vectorMode
        AND #$01
        BEQ b48B8
        LDA aF8
        BNE b48B8
        LDA FR2
        CMP #$FF
        BEQ b48B8
        STA aE3
        LDA #$FF
        STA FR2
        JMP b48E9

b490D   LDA pixelXPosition
        STA pixelXPositionArray,X
        LDA pixelYPosition
        STA pixelYPositionArray,X
        LDA smoothingDelay
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        LDA currentSymmetry
        STA symmetrySettingForStepCount,X
        LDA currentPatternIndex
        STA patternIndexArray,X
        LDA bottomMostYPos
        STA bottomMostYPosArray,X
        LDA #$07
        ORA explosionMode
        STA explosionModeArray,X
        RTS 

vectorModeOffsets   
        .BYTE $00,$08,$04,$02,$01,$01,$01,$01
        .BYTE $01,$01,$01,$01,$01,$02,$04,$08
a4947   .BYTE $00
a4948   .BYTE $08
a4949   .BYTE $00
a494A   .BYTE $01
;-------------------------------------------------------------------------
; ProcessJoystickMovementInVectorMode
;-------------------------------------------------------------------------
ProcessJoystickMovementInVectorMode
        LDA a4949
        BEQ b4980
        DEC a4949
        BNE b4980
        LDA a4947
        AND #$0F
        TAX 
        LDA vectorModeOffsets,X
        STA a4949
        LDA a4947
        AND #$10
        BNE b496C
        INC pixelXPosition
        INC pixelXPosition
b496C   DEC pixelXPosition
        BPL b4976
        LDA #$4F
        STA pixelXPosition
        BNE b4980
b4976   LDA pixelXPosition
        CMP #$50
        BNE b4980
        LDA #$00
        STA pixelXPosition
b4980   LDA a494A
        BEQ b49B7
        DEC a494A
        BNE b49B7
        LDA a4948
        AND #$0F
        TAX 
        LDA vectorModeOffsets,X
        STA a494A
        LDA a4948
        AND #$10
        BNE b49A1
        INC pixelYPosition
        INC pixelYPosition
b49A1   DEC pixelYPosition
        BPL b49AD
        LDA bottomMostYPos
        STA pixelYPosition
        DEC pixelYPosition
        BNE b49B7
b49AD   LDA pixelYPosition
        CMP bottomMostYPos
        BNE b49B7
        LDA #$00
        STA pixelYPosition
b49B7   LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$0C
        CMP #$0C
        BNE b49C1
        BEQ b49FC
b49C1   CMP #$04
        BEQ b49D1
        INC a4947
        INC a4948
        INC a4947
        INC a4948
b49D1   DEC a4947
        DEC a4948
        LDA a4947
        AND #$1F
        STA a4947
        LDA a4948
        AND #$1F
        STA a4948
        AND #$0F
        TAX 
        LDA vectorModeOffsets,X
        STA a494A
        LDA a4947
        AND #$0F
        TAX 
        LDA vectorModeOffsets,X
        STA a4949
b49FC   LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$01
        BNE b4A0A
        DEC cursorSpeed
        BNE b4A0A
        INC cursorSpeed
b4A0A   LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$02
        BNE b4A1D
        INC cursorSpeed
        LDA cursorSpeed
        CMP #$08
        BNE b4A1D
        DEC cursorSpeed
b4A1D   RTS 

a2C00 = $2C00
a2C80 = $2C80
a2D00 = $2D00
a2D80 = $2D80
a2E00 = $2E00
a2E80 = $2E80
a2F00 = $2F00
a2F80 = $2F80
a2C40 = $2C40
a2CC0 = $2CC0
a2D40 = $2D40
a2DC0 = $2DC0
a2E40 = $2E40
a2EC0 = $2EC0
a2F40 = $2F40
a2FC0 = $2FC0

cursorSpeed   .BYTE $01
newCursorSpeed   .BYTE $01
pixelXPositionLoPtrArray   
        .BYTE <theTwistXPosArray,<smoothCrossflowXPosArray,<denturesXPosArray,<deltoidsXPosArray
        .BYTE <pulsarCrossXPosArray,<slothMultiCrossXPosArray,<crossAndABitXPosArray,<star2XPosArray
        .BYTE <a2000,<a2080,<a2100,<a2180,<a2200,<a2280,<a2300,<a2380
        .BYTE <a2400,<a2480,<a2500,<a2580,<a2600,<a2680,<a2700,<a2780
        .BYTE <a2800,<a2880,<a2900,<a2980,<a2A00,<a2A80,<a2B00,<a2B80
        .BYTE <a2C00,<a2C80,<a2D00,<a2D80,<a2E00,<a2E80,<a2F00,<a2F80


pixelXPositionHiPtrArray   
        .BYTE >theTwistXPosArray,>smoothCrossflowXPosArray,>denturesXPosArray,>deltoidsXPosArray
        .BYTE >pulsarCrossXPosArray,>slothMultiCrossXPosArray,>crossAndABitXPosArray,>star2XPosArray
        .BYTE >a2000,>a2080,>a2100,>a2180,>a2200,>a2280,>a2300,>a2380
        .BYTE >a2400,>a2480,>a2500,>a2580,>a2600,>a2680,>a2700,>a2780
        .BYTE >a2800,>a2880,>a2900,>a2980,>a2A00,>a2A80,>a2B00,>a2B80
        .BYTE >a2C00,>a2C80,>a2D00,>a2D80,>a2E00,>a2E80,>a2F00,>a2F80

pixelYPositionLoPtrArray   
        .BYTE <theTwistYPosArray,<smoothCrossflowYPosArray,<denturesYPosArray,<deltoidsYPosArray
        .BYTE <pulsarCrossYPosArray,<slothMultiCrossYPosArray,<crossAndABitYPosArray,<start2YPosArray
        .BYTE <a2040,<a20C0,<a2140,<a21C0,<a2240,<a22C0,<a2340,<a23C0
        .BYTE <a2440,<a24C0,<a2540,<a25C0,<a2640,<a26C0,<a2740,<a27C0
        .BYTE <a2840,<a28C0,<a2940,<a29C0,<a2A40,<a2AC0,<a2B40,<a2BC0
        .BYTE <a2C40,<a2CC0,<a2D40,<a2DC0,<a2E40,<a2EC0,<a2F40,<a2FC0


pixelYPositionHiPtrArray   
        .BYTE >theTwistYPosArray,>smoothCrossflowYPosArray,>denturesYPosArray,>deltoidsYPosArray
        .BYTE >pulsarCrossYPosArray,>slothMultiCrossYPosArray,>crossAndABitYPosArray,>start2YPosArray
        .BYTE >a2040,>a20C0,>a2140,>a21C0,>a2240,>a22C0,>a2340,>a23C0
        .BYTE >a2440,>a24C0,>a2540,>a25C0,>a2640,>a26C0,>a2740,>a27C0
        .BYTE >a2840,>a28C0,>a2940,>a29C0,>a2A40,>a2AC0,>a2B40,>a2BC0
        .BYTE >a2C40,>a2CC0,>a2D40,>a2DC0,>a2E40,>a2EC0,>a2F40,>a2FC0

;-------------------------------------------------------------------------
; MaybeHIResHardReflectMode
;-------------------------------------------------------------------------
MaybeHIResHardReflectMode
        CMP #HIRES_HARD_REFLECT_MODE
        BEQ b4AC7
        JMP MaybeCurvedColorspace1Mode

b4AC7   LDX #$59
b4AC9   JSR WriteValuesFromMemoryToDisplayList
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$28
        STA foregroundPixelsLoPtr2
        LDA foregroundPixelsHiPtr2
        ADC #$00
        STA foregroundPixelsHiPtr2
        DEX 
        BNE b4AC9

        LDX #$59
b4ADE   JSR WriteValuesFromMemoryToDisplayList
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$D8
        STA foregroundPixelsLoPtr2
        LDA foregroundPixelsHiPtr2
        ADC #$FF
        STA foregroundPixelsHiPtr2
        DEX 
        BNE b4ADE
        LDA #$5A
        STA bottomMostYPos
        JMP WriteDisplayListFooter

;-------------------------------------------------------------------------
; WriteValuesFromMemoryToDisplayList
;-------------------------------------------------------------------------
WriteValuesFromMemoryToDisplayList
        LDA #$4F
        JSR WriteValueToDisplayList
        LDA foregroundPixelsLoPtr2
        JSR WriteValueToDisplayList
        LDA foregroundPixelsHiPtr2
        JSR WriteValueToDisplayList
        RTS 

screenMode   .BYTE $02
;-------------------------------------------------------------------------
; MaybeCurvedColorspace1Mode
;-------------------------------------------------------------------------
MaybeCurvedColorspace1Mode
        CMP #CURVED_COLOURSPACE_1_MODE
        BEQ CurvedColorspace1Mode
        JMP MaybeCurvedColorspace2Mode

CurvedColorspace1Mode   
        LDA #$01
        STA a403F
        LDA #$00
        STA bottomMostYPos
b4B19   LDX #$04
b4B1B   LDA a403F
        STA a4B48
b4B21   JSR WriteValuesFromMemoryToDisplayList
        DEC a4B48
        BNE b4B21
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$28
        STA foregroundPixelsLoPtr2
        LDA foregroundPixelsHiPtr2
        ADC #$00
        STA foregroundPixelsHiPtr2
        INC bottomMostYPos
        DEX 
        BNE b4B1B
        INC a403F
        LDA a403F
        CMP #$0A
        BNE b4B19
        JMP WriteDisplayListFooter

a4B48   .BYTE $01

MaybeCurvedColorspace2Mode
        LDX #$00
        STX a4BD3
        LDX #$02
        STX CurvedInnerLoopCounter
        LDX #$01
        STX CurvedOuterLoopCounter

        CMP #CURVED_COLOURSPACE_2_MODE
        BEQ CurvedColorspace2Mode
        JMP MaybeCurveHardReflectMode

CurvedColorspace2Mode   
        LDA #$01
        STA a403F
        LDA #$00
        STA bottomMostYPos
b4B68   LDX CurvedInnerLoopCounter
b4B6B   LDA a403F
        STA a4B48
b4B71   JSR WriteValuesFromMemoryToDisplayList
        DEC a4B48
        BNE b4B71
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$28
        STA foregroundPixelsLoPtr2
        LDA foregroundPixelsHiPtr2
        ADC #$00
        STA foregroundPixelsHiPtr2
        INC bottomMostYPos
        DEX 
        BNE b4B6B
        INC a403F
        LDA a403F
        CMP #$0A
        BNE b4B68
        DEC a403F
b4B98   LDX CurvedInnerLoopCounter
b4B9B   LDA a403F
        STA a4B48
b4BA1   JSR WriteValuesFromMemoryToDisplayList
        DEC a4B48
        BNE b4BA1
        LDA a4BD3
        BEQ IncrementLowPointers
        JSR IncrementScreenMemoryPointers
        JMP UpdateStuffAndMaybeReturn
        ;Returns

IncrementLowPointers   
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$28
        STA foregroundPixelsLoPtr2
        LDA foregroundPixelsHiPtr2
        ADC #$00
        STA foregroundPixelsHiPtr2
        INC bottomMostYPos

UpdateStuffAndMaybeReturn
        DEX 
        BNE b4B9B
        DEC a403F
        BNE b4B98
        DEC CurvedOuterLoopCounter
        BNE CurvedColorspace2Mode
        JMP WriteDisplayListFooter

a4BD3   .BYTE $01
;-------------------------------------------------------------------------
; IncrementScreenMemoryPointers
;-------------------------------------------------------------------------
IncrementScreenMemoryPointers
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$D8
        STA foregroundPixelsLoPtr2
        LDA foregroundPixelsHiPtr2
        ADC #$FF
        STA foregroundPixelsHiPtr2
        RTS 

;-------------------------------------------------------------------------
; MaybeCurveHardReflectMode
;-------------------------------------------------------------------------
MaybeCurveHardReflectMode
        CMP #CURVE_HARD_REFLECT_MODE
        BEQ CurveHardReflectMode
        JMP MaybeHoopyCurvyMode

CurveHardReflectMode   
        LDA #$01
        STA a4BD3
        LDA #$02
        STA CurvedInnerLoopCounter
        LDA #$01
        STA CurvedOuterLoopCounter
        JSR CurvedColorspace2Mode
        INC bottomMostYPos
        RTS 

CurvedInnerLoopCounter   .BYTE $02
CurvedOuterLoopCounter   .BYTE $01
;-------------------------------------------------------------------------
; MaybeHoopyCurvyMode
;-------------------------------------------------------------------------
MaybeHoopyCurvyMode
        CMP #HOOPY_4X_CURVYREFLEX_MODE
        BEQ HoopyCurvyMode
        JMP MaybeZarjazInterlaceMode

HoopyCurvyMode   
        LDA #$01
        STA a4BD3
        LDA #$01
        STA CurvedInnerLoopCounter
        LDA #$02
        STA CurvedOuterLoopCounter
        JSR CurvedColorspace2Mode
        INC bottomMostYPos
        RTS 

;-------------------------------------------------------------------------
; MaybeZarjazInterlaceMode
;-------------------------------------------------------------------------
MaybeZarjazInterlaceMode
        CMP #ZARJAZ_INTERLACE_RES_MODE
        BEQ ZarjazInterlaceMode
        RTS 

ZarjazInterlaceMode   
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$E8
        STA aEB
        LDA foregroundPixelsHiPtr2
        ADC #$0D
        STA FPCOC

        LDX #$5A
b4C30   JSR WriteValuesFromMemoryToDisplayList
        LDA #$4F
        JSR WriteValueToDisplayList
        LDA aEB
        JSR WriteValueToDisplayList
        LDA FPCOC
        JSR WriteValueToDisplayList
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$28
        STA foregroundPixelsLoPtr2
        LDA foregroundPixelsHiPtr2
        ADC #$00
        STA foregroundPixelsHiPtr2
        LDA aEB
        CLC 
        ADC #$D8
        STA aEB
        LDA FPCOC
        ADC #$FF
        STA FPCOC
        DEX 
        BNE b4C30

        LDA #$59
        STA bottomMostYPos
        JMP WriteDisplayListFooter
        ; Returns

randomKeyInputCounter      .BYTE $01
randomJoystickInputCounter .BYTE $01
colorValuesOfSomeSort      .BYTE $00,$18,$38,$58,$78,$98,$B8,$D8
oozeRates                  .BYTE $00,$00,$00,$00,$00,$00,$00,$00
oozeSteps                  .BYTE $01,$01,$01,$01,$01,$01,$01,$01
oozeCycles                 .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
oozeRates2                 .BYTE $00,$00,$00,$00,$00,$00,$00,$00
oozeCycles2                .BYTE $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
oozeRateTracker            .BYTE $00,$00,$00,$00,$00,$00,$00,$00
;-------------------------------------------------------------------------
; CheckStrobesAndColorFlow
;-------------------------------------------------------------------------
CheckStrobesAndColorFlow
        LDA stroboscopicsEnabled
        BEQ UpdateOoze
        JMP UpdateStrobo

UpdateOoze   
        LDX #$00
b4CAA   LDA oozeRates,X
        BEQ b4CB7
        DEC oozeRates2,X
        BNE b4CB7
        JSR UpdateOozeRatesAndSteps
b4CB7   INX 
        CPX #$08
        BNE b4CAA
        RTS 

;-------------------------------------------------------------------------
; UpdateOozeRatesAndSteps
;-------------------------------------------------------------------------
UpdateOozeRatesAndSteps
        LDA oozeRates,X
        STA oozeRates2,X
        LDA oozeSteps,X
        BEQ b4CE7
        LDY oozeRateTracker,X
        BNE b4CE8
        CLC 
        ADC PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)

OozeUpdateLoop
        STA PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
        DEC oozeCycles2,X
        BNE b4CE7
        LDA oozeCycles,X
        STA oozeCycles2,X
        LDA oozeRateTracker,X
        EOR #$FF
        STA oozeRateTracker,X
b4CE7   RTS 

b4CE8   LDA PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
        SEC 
        SBC oozeSteps,X
        JMP OozeUpdateLoop

stroboscopicsEnabled    .BYTE $00
somethingToDoWithStrobo .BYTE $00
;-------------------------------------------------------------------------
; UpdateStrobo
;-------------------------------------------------------------------------
UpdateStrobo
        LDA stroboscopicsEnabled
        BNE b4CFA
        RTS 

b4CFA   DEC somethingToDoWithStrobo
        LDA somethingToDoWithStrobo
        CMP #$FE
        BNE b4D1B

        LDX #$08
b4D06   LDA BOTSCR,X ;BOTSCR  number of text rows in text window
        STA f4D2A,X
        LDA #$00
        STA BOTSCR,X ;BOTSCR  number of text rows in text window
        DEX 
        BNE b4D06

        LDA stroboscopicsEnabled
        STA somethingToDoWithStrobo
b4D1A   RTS 

b4D1B   CMP #$00
        BNE b4D1A

;-------------------------------------------------------------------------
; RestoreStrobo
;-------------------------------------------------------------------------
RestoreStrobo
        LDX #$08
b4D21   LDA f4D2A,X
        STA BOTSCR,X ;BOTSCR  number of text rows in text window
        DEX 
        BNE b4D21
        RTS 

f4D2A   =*-$01
        .BYTE $54,$09,$6B,$5C,$C0,$B1,$13,$4E
;-------------------------------------------------------------------------
; LookForKeyboardInput
;-------------------------------------------------------------------------
LookForKeyboardInput
        LDA autoDemoEnabled
        BEQ b4D3B

        JSR GetInputForDemo

b4D3B   LDA slothModeRelated
        BEQ b4D57
        DEC slothModeRelated
        BNE b4D57
        LDA slothMode
        EOR #$0F
        STA slothMode
        JSR GetProceduralValue
        AND #$07
        ORA #$04
        STA slothModeRelated

b4D57   LDA inputCharacter       ;inputCharacter      keyboard FIFO byte
        CMP #$FF
        BNE MaybeCheckKeyboardInput

        LDA beginDrawingForeground
        BEQ b4D66

        JMP ComposeForeground

b4D66   LDA a4ECC
        BEQ b4D6E
        DEC a4ECC
b4D6E   LDA a4F4C
        BEQ b4D87
        DEC a4F4C
        BNE b4D87
        LDA disableStatusLine
        BEQ b4D88

RepointTextMaybe
        LDA #<statusTextLineOne
        STA foregroundPixelsLoPtr
        LDA #>statusTextLineOne
        STA foregroundPixelsHiPtr
b4D87   RTS 

b4D88   LDA #<statusTextLineTwo
        STA foregroundPixelsLoPtr
        LDA #>statusTextLineTwo
        STA foregroundPixelsHiPtr
        RTS 

MaybeCheckKeyboardInput   
        LDY #$FF
        STY inputCharacter       ;inputCharacter      keyboard FIFO byte

        LDY beginDrawingForeground
        BEQ MaybeSKeyPressed

        JMP ComposeForeground
        ; Returns;

MaybeSKeyPressed   
        CMP #KEY_S
        BNE MaybeMKeyPressed

        ; S=Symmetry change 
        LDA currentSymmetry
        CLC 
        ADC #$01
        CMP #$05
        BNE b4DAF
        LDA #$00
b4DAF   STA currentSymmetry
        CLC 
        ADC #$08
        TAX 
        CPX #$09
        BNE b4DBB
        LDX #Y_AXIS_SYMMETRY
b4DBB   JSR UpdateStatusLine
        RTS 

MaybeMKeyPressed   
        CMP #KEY_M
        BNE MaybeZKeyPressed

        ; M=Screen Mode 
        LDA screenMode
        CLC 
        ADC #$01
        CMP #$07
        BNE b4DCF
        LDA #$00
b4DCF   STA screenMode
        CLC 
        ADC #$0D
        TAX 
        JSR UpdateStatusLine

        LDA #$01
        STA selectedModePreventsForegroundDrawing

        RTS 

selectedModePreventsForegroundDrawing   .BYTE $00
MaybeZKeyPressed   
        CMP #KEY_Z
        BNE MaybeShiftZPressed

        ; Z/SHIFT - Z=Vary Vertical Resolution SPAC
        INC verticalResolutionSPAC
        LDA verticalResolutionSPAC
        CMP #$12
        BNE b4DEE
        DEC verticalResolutionSPAC
b4DEE   LDA #$01
        STA selectedModePreventsForegroundDrawing
        RTS 

MaybeShiftZPressed   
        CMP #KEY_SHIFT | KEY_Z
        BNE MaybeSpaceKeyPressed

        ; Z/SHIFT - Z=Vary Vertical Resolution SPAC
        DEC verticalResolutionSPAC
        LDA verticalResolutionSPAC
        CMP #$01
        BNE b4DEE
        INC verticalResolutionSPAC
        JMP b4DEE

MaybeSpaceKeyPressed   
        CMP #KEY_SPACE
        BNE MaybeShiftOrControlPressed

        ; Update selected pattern.
        INC currentPatternIndex
        LDA currentPatternIndex
        CMP #$18
        BNE b4E15
        LDA #$00
        STA currentPatternIndex
b4E15   AND #$18
        BEQ b4E26
        LDA currentPatternIndex
        SEC 
        SBC #$08
        STA lastKeyPressed
        LDX #USER_LIGHTFORM_000
        JMP UpdateStatusLineAndDisplaySelectedValue

b4E26   LDX currentPatternIndex
        JMP UpdateStatusLine

MaybeShiftOrControlPressed   
        PHA 
        AND #$C0
        BNE MaybeColorVariableKeyPressed
        PLA 
        JMP MaybeFullStopPressed

MaybeColorVariableKeyPressed   
        PLA 
        PHA 
        AND #$3F
        ; H,C,V,B,N,M,[=Individual colour Variable Keys 
        LDX #$00
b4E3A   CMP colorVariableKeys,X
        BEQ ColorVariableKeyPressed
        INX 
        CPX #$08
        BNE b4E3A

        ; No matches, keep checking other keys.
        PLA 
        JMP MaybeFullStopPressed

        ; Update a color control value selected.
ColorVariableKeyPressed   
        PLA 
        JMP UpdateColorControlValues

;-------------------------------------------------------------------------
; UpdateColorsInSomeWay
;-------------------------------------------------------------------------
UpdateColorsInSomeWay
        AND #$80
        BNE b4E56
        DEC PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
        DEC PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
b4E56   INC PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
        LDA PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
        STA lastKeyPressed
        STA colorValuesOfSomeSort,X
        LDA #$30
        STA a4ECC
        JSR IncrementColorValue
        RTS 

; H,C,V,B,N,M,[=Individual colour Variable Keys 
colorVariableKeys   .BYTE $27,$16,$12,$10,$15,$23,$25,$20
;-------------------------------------------------------------------------
; MaybeFullStopPressed
;-------------------------------------------------------------------------
MaybeFullStopPressed
        CMP #KEY_FULLSTOP
        BNE MaybeSlashPressed

        ; ]=Set strobo flash rate 
        INC stroboFlashRate
        LDA stroboFlashRate
        CMP #$08
        BNE b4E86

        LDA #$01
        STA stroboFlashRate

b4E86   LDA stroboFlashRate
        STA lastKeyPressed

        LDX #STROBO_ZAP_RATE_000
        JSR UpdateStatusLine
        JSR WriteStatusLine

        LDA stroboscopicsEnabled
        BEQ b4E9F
        LDA stroboFlashRate
        STA stroboscopicsEnabled
b4E9F   JMP IncrementDisplayedValue

stroboFlashRate   .BYTE $02
;-------------------------------------------------------------------------
; MaybeSlashPressed
;-------------------------------------------------------------------------
MaybeSlashPressed
        CMP #KEY_SLASH
        BNE b4ECE
        ; ?=Turn stroboscopics on/off 
        LDA stroboscopicsEnabled
        BNE b4EBC
        LDA stroboFlashRate
        STA stroboscopicsEnabled
        LDA #$00
        STA somethingToDoWithStrobo
        LDX #STROBOSCOPICS_ON
        JMP UpdateStatusLine

b4EBC   LDA #$00
        STA stroboscopicsEnabled
        STA somethingToDoWithStrobo
        LDX #STROBOSCOPICS_OFF
        JSR UpdateStatusLine
        JMP RestoreStrobo

a4ECC   BRK #$00
b4ECE   JMP MaybeAsteriskPressed

statusTextLineOne   
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00
statusTextLineTwo   
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00
DisplayListInterrupt   
        PHA 
        LDA GPRIOR   ;GPRIOR  shadow for PRIOR ($D01B)
        ORA #$80
        STA $D01B    ;PRIOR
        LDA COLOR4   ;COLOR4  shadow for COLBK ($D01A)
        STA $D01A    ;COLBK
        LDA COLOR2   ;COLOR2  shadow for COLPF2 ($D018)
        STA $D018    ;COLPF2
        PLA 
        RTI 

;-------------------------------------------------------------------------
; UpdateStatusLine
;-------------------------------------------------------------------------
UpdateStatusLine
        LDA #<statusLineText
        STA statusLineTextLoByte
        LDA #>statusLineText
        STA statusLineTextHiByte
        LDA disableStatusLine
        BEQ b4F20
        RTS 

b4F20   CPX #$00
        BEQ b4F38
b4F24   LDA statusLineTextLoByte
        CLC 
        ADC #$14
        STA statusLineTextLoByte
        LDA statusLineTextHiByte
        ADC #$00
        STA statusLineTextHiByte
        DEX 
        BNE b4F24
b4F38   LDA statusLineTextLoByte
        STA foregroundPixelsLoPtr
        LDA statusLineTextHiByte
        STA foregroundPixelsHiPtr
        LDA #$30
        STA a4F4C
        RTS 

.enc "atascii"  ;define an ascii->atascii encoding
        .cdef " Z", $00
.enc "none"

statusLineTextLoByte   .BYTE $01
statusLineTextHiByte   .BYTE $01
a4F4C   .BYTE $14

.enc "atascii" 
statusLineText
        .TEXT 'THE TWIST           '
        .TEXT 'THE SMOOTH CROSSFLOW'
        .TEXT 'THE DENTURES        '
        .TEXT 'DELTOIDS            '
        .TEXT 'PULSAR CROSSES      '
        .TEXT 'SLOTHFUL MULTICROSS '
        .TEXT 'CROSS-AND-A-BIT     '
        .TEXT 'STAR2-SMALL AND FAST'
        .TEXT 'NO SYMMETRY AT ALL  '
        .TEXT 'BUGGER OFF, NOSEY!! '
        .TEXT 'X-Y SYMMETRY        '
        .TEXT 'X-AXIS SYMMETRY     '
        .TEXT 'QUAD MODE SYMMETRY  '
        .TEXT 'VARIABLE RESOLUTION '
        .TEXT 'HIRES + HARD REFLECT'
        .TEXT 'CURVED COLOURSPACE 1'
        .TEXT 'CURVED COLOURSPACE 2'
        .TEXT 'CURVE + HARD REFLECT'
        .TEXT 'HOOPY 4X CURVYREFLEX'
        .TEXT 'ZARJAZ INTERLACE RES'
        .TEXT 'STROBOSCOPICS ON    '
        .TEXT 'STROBOSCOPICS OFF   '
        .TEXT 'STROBO ZAP RATE  000'
        .TEXT 'BASE COLOUR #0   000'
        .TEXT 'OOZE  RATE  #0   000'
        .TEXT 'OOZE  STEP  #0   000'
        .TEXT 'OOZE CYCLE  #0   000'
        .TEXT 'C.KEYS:      COLOURS'
        .TEXT 'C.KEYS:   OOZE RATES'
        .TEXT 'C.KEYS:   OOZE STEPS'
        .TEXT 'C.KEYS:  OOZE CYCLES'
        .TEXT 'COLOURFLOW RESYNCHED'
        .TEXT 'PULSE FLOW RATE: 000'
        .TEXT 'SPEED BOOST:     000'
        .TEXT 'CURSOR SPEED:    000'
        .TEXT '8-WAY MODE ENGAGED  '
        .TEXT 'VECTOR MODE ENGAGED '
        .TEXT 'LOGIC TRACKING OFF  '
        .TEXT 'LOGIC TRACKING ON   '
        .TEXT 'SMOOTHING DELAY: 000'
        .TEXT 'BUFFER LENGTH:   000'
        .TEXT 'RUNNING PRESET # 000'
        .TEXT 'STASHING PRESET# 000'
        .TEXT 'PULSE WIDTH:     000'
        .TEXT 'RUN PRESET BANK: 000'
        .TEXT 'RECORDING INITIATED '
        .TEXT 'PLAYBACK  INITIATED '
        .TEXT 'T E R M I N A T E D '
        .TEXT 'ZARJAZ SLOTH DISABLE'
        .TEXT 'ZARJAZ SLOTH ENABLE '
        .TEXT 'MIX REC/LIVE PLAY   '
        .TEXT 'MIXED MODE OFF      '
        .TEXT 'DUAL INPUT MODE ON  '
        .TEXT 'USER-LIGHTFORM # 000'
        .TEXT 'LEVEL: 0   FREE: 000'
        .TEXT 'AUTO DEMO MODE ON   '
        .TEXT 'PIXEL COLOUR #   000'
        .TEXT 'COLOUR 0   FREE: 000'
        .TEXT 'STATUS DISPLAYS ON  '
        .TEXT 'SIML ADDER VALUE:000'
        .TEXT 'NORMAL PATTERN MODE '
        .TEXT 'EXPLOSION MODE ON   '
        .TEXT 'Y-AXIS SYMMETRY.    '
.enc "none" 
;-------------------------------------------------------------------------
; IncrementColorValue
;-------------------------------------------------------------------------
IncrementColorValue
        TXA
        TAY 
        LDA #BASE_COLOUR_0__000
        CLC 
        ADC currentColourControlEffect
        TAX 
        JSR UpdateStatusLine
        TYA 
        PHA 
        JSR WriteStatusLine
        PLA 
        CLC 
        ADC #$10
        LDY #$0D
        STA (presetLoPtr),Y

;-------------------------------------------------------------------------
; IncrementDisplayedValue
;-------------------------------------------------------------------------
IncrementDisplayedValue
        LDX lastKeyPressed
        LDA #$10
        LDY #$11
        STA (presetLoPtr),Y
        INY 
        STA (presetLoPtr),Y
        INY 
        STA (presetLoPtr),Y
        CPX #$00
        BEQ b547E
b5465   LDY #$13
b5467   LDA (presetLoPtr),Y
        CLC 
        ADC #$01
        STA (presetLoPtr),Y
        CMP #$1A
        BNE b547B
        LDA #$10
        STA (presetLoPtr),Y
        DEY 
        CPY #$10
        BNE b5467
b547B   DEX 
        BNE b5465
b547E   RTS 

lastKeyPressed   .BYTE $00
;-------------------------------------------------------------------------
; WriteStatusLine
;-------------------------------------------------------------------------
WriteStatusLine
        LDA disableStatusLine
        BNE b5492
        LDA foregroundPixelsLoPtr
        STA presetLoPtr
        LDA foregroundPixelsHiPtr

WriteStatusReturn
        STA presetHiPtr
        LDY #$00
        RTS 

b5492   LDA #$A2
        STA presetLoPtr
        LDA #$2E
        JMP WriteStatusReturn

;-------------------------------------------------------------------------
; UpdateColorControlValues
;-------------------------------------------------------------------------
UpdateColorControlValues
        LDY currentColourControlEffect
        BNE MaybeUpdateOozeRates
        JMP UpdateColorsInSomeWay

MaybeUpdateOozeRates   
        CPY #CCKEYS__OOZE_RATES
        BNE MaybeUpdateOozeSteps

        ; Update Ooze Rates
        AND #$80
        BNE b54B1
        DEC oozeRates,X
        DEC oozeRates,X
b54B1   INC oozeRates,X
        LDA oozeRates,X
        STA oozeRates2,X

WriteColorValueAndReturn
        STA lastKeyPressed
        LDA #$30
        STA a4ECC
        JMP IncrementColorValue
        ; Returns

currentColourControlEffect   .BYTE $00

MaybeUpdateOozeSteps   
        CPY #CCKEYS__OOZE_STEPS
        BNE UpdateOozeCycles
        AND #$80
        BNE b54D4
        DEC oozeSteps,X
        DEC oozeSteps,X
b54D4   INC oozeSteps,X
        LDA oozeSteps,X
        JMP WriteColorValueAndReturn

UpdateOozeCycles   
        AND #$80
        BNE b54E7
        DEC oozeCycles,X
        DEC oozeCycles,X
b54E7   INC oozeCycles,X
        LDA oozeCycles,X
        STA oozeCycles2,X
        JMP WriteColorValueAndReturn

;-------------------------------------------------------------------------
; MaybeAsteriskPressed
;-------------------------------------------------------------------------
MaybeAsteriskPressed
        CMP #KEY_ASTERISK
        BNE MaybeShiftAsteriskPressed

        INC currentColourControlEffect
        LDA currentColourControlEffect
        AND #$03
        STA currentColourControlEffect

        CLC 
        ADC #CKEYS___COLOURS
        TAX 
        JMP UpdateStatusLine

MaybeShiftAsteriskPressed   
        CMP #KEY_SHIFT | KEY_ASTERISK
        BNE MaybePPressed

        ; SHIFT-*=Colourflow resync
;-------------------------------------------------------------------------
; ColourFlowResync
;-------------------------------------------------------------------------
ColourFlowResync
        LDX #$00
b550F   LDA colorValuesOfSomeSort,X
        STA PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
        LDA oozeCycles,X
        STA oozeCycles2,X
        LDA oozeRates,X
        STA oozeRates2,X
        LDA #$00
        STA oozeRateTracker,X
        INX 
        CPX #$08
        BNE b550F
        LDX #COLOURFLOW_RESYNCHED
        JMP UpdateStatusLine

MaybePPressed
        PHA 
        AND #$3F
        CMP #KEY_P
        BEQ MaybeShiftCtrlPressedWithP

        ; P=Pulse Speed variable key
        PLA 
        JMP MaybeXPressed

MaybeShiftCtrlPressedWithP   
        PLA 
        AND #KEY_SHIFT | KEY_CTRL
        BEQ ReturnFromThisKeyboardCheck
        CMP #KEY_CTRL
        BEQ CtrlPPressed

        DEC pulseSpeed   ;pulseSpeed  
        DEC pulseSpeed   ;pulseSpeed  
CtrlPPressed   
        INC pulseSpeed   ;pulseSpeed  
        BNE b554E
        INC pulseSpeed   ;pulseSpeed  
b554E   LDA pulseSpeed   ;pulseSpeed  
        AND #$0F
        STA pulseSpeed2
        STA pulseSpeed   ;pulseSpeed  
        STA lastKeyPressed
        LDX #$20
;-------------------------------------------------------------------------
; UpdateStatusLineAndDisplaySelectedValue
;-------------------------------------------------------------------------
UpdateStatusLineAndDisplaySelectedValue
        JSR UpdateStatusLine
        JSR WriteStatusLine
        JMP IncrementDisplayedValue

ReturnFromThisKeyboardCheck
        RTS 

;-------------------------------------------------------------------------
; MaybeXPressed
;-------------------------------------------------------------------------
MaybeXPressed
        CMP #KEY_X
        BNE MaybeCKeyPressed

        ; X=Speed Boost adjust 
        INC speedBoostAdjust
        LDA speedBoostAdjust
        CMP #$10
        BNE b5573
        LDA #$01
b5573   STA speedBoostAdjust
        STA lastKeyPressed
        LDX #SPEED_BOOST___000
        JMP UpdateStatusLineAndDisplaySelectedValue

MaybeCKeyPressed   
        CMP #KEY_C
        BNE MaybeVKeyPressed

        ; C=Cursor Speed adjust
        INC cursorSpeed
        LDA cursorSpeed
        AND #$0F
        STA cursorSpeed
        BNE b5591
        INC cursorSpeed
b5591   LDA cursorSpeed
        STA newCursorSpeed
        STA lastKeyPressed

        LDX #CURSOR_SPEED__000
        JMP UpdateStatusLineAndDisplaySelectedValue
        ; Returns

MaybeVKeyPressed   
        CMP #KEY_V
        BNE MaybeTKeyPressed

        ; V=Vector Mode on/off 
        LDA vectorMode
        EOR #$02
        STA vectorMode
        AND #$02
        CLC 
        ROR 
        ADC #$23
        TAX 
        JMP UpdateStatusLine

MaybeTKeyPressed   
        CMP #KEY_T
        BNE MaybeDPressed
        ; T=Tracking on/off 
        LDA vectorMode
        EOR #$01
        STA vectorMode
        AND #$01
        CLC 
        ADC #LOGIC_TRACKING_OFF
        TAX 
        JMP UpdateStatusLine

MaybeDPressed   
        PHA 
        AND #$3F
        CMP #KEY_D
        BEQ DKeyPressed
        PLA 
        JMP MaybeBPressed

        ; D=Smoothing Delay variable key 
DKeyPressed   
        PLA 
        AND #$C0
        BEQ b55EA
        CMP #$80
        BEQ b55DE
        DEC smoothingDelay
        DEC smoothingDelay
b55DE   INC smoothingDelay
        LDA smoothingDelay
        STA lastKeyPressed
        LDX #SMOOTHING_DELAY_000
        JMP UpdateStatusLineAndDisplaySelectedValue

b55EA   RTS 

;-------------------------------------------------------------------------
; MaybeBPressed
;-------------------------------------------------------------------------
MaybeBPressed
        CMP #KEY_B
        BNE MaybePresetKeysPressed

        ; B=Buffer Length adjust 
        LDA bufferLength
        CLC 
        ADC #$01
        CMP #$41
        BNE b55FA
        LDA #$01
b55FA   STA bufferLength
        STA lastKeyPressed
        JSR PropagateNewBufferLength
        JMP UpdateBufferStatusAndReturn

;-------------------------------------------------------------------------
; PropagateNewBufferLength
;-------------------------------------------------------------------------
PropagateNewBufferLength
        LDA #$09
        STA aF8
        LDX bufferLength
        CPX #$40
        BEQ b561C
b560F   LDA #$01
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        INX 
        CPX #$40
        BNE b560F
b561C   RTS 

;-------------------------------------------------------------------------
; UpdateBufferStatusAndReturn
;-------------------------------------------------------------------------
UpdateBufferStatusAndReturn
        LDX #BUFFER_LENGTH__000
        JMP UpdateStatusLineAndDisplaySelectedValue

MaybePresetKeysPressed   
        PHA 
        AND #$3F

        LDX #$00
b5627   CMP presetKeys,X
        BEQ PresetKeyPressed
        INX 
        CPX #$10
        BNE b5627

        PLA 
        JMP MaybeOKeyPressed

        ; ESC,1,2,3,4,5,6,7,8,9,0, , ,DEL,-=,are preset keys
PresetKeyPressed   
        PLA 
        AND #$C0
        CMP #$40
        BEQ SaveNewPreset
        CMP #$80
        BNE b5641
        RTS 

b5641   STX lastKeyPressed
        STX selectedPreset
        JSR LoadPreset
        LDX #RUNNING_PRESET_000
        JMP UpdateStatusLineAndDisplaySelectedValue
        ; Rertuns

SaveNewPreset   
        STX lastKeyPressed
        JSR StorePresetValues
        LDX #STASHING_PRESET_000
        JMP UpdateStatusLineAndDisplaySelectedValue

presetKeys   .BYTE $1C,$1F,$1E,$1A,$18,$1D,$1B,$33
             .BYTE $35,$30,$32,$36,$37,$34,$0E,$0F
;-------------------------------------------------------------------------
; LoadSelectedPresetPointers
;-------------------------------------------------------------------------
LoadSelectedPresetPointers
        ; Selected preset is in X register.
        LDY selectedPresetBank
        LDA presetHiPtrArray,Y
        CLC 
        ADC #$30
        STA presetHiPtr
        TXA 
        BEQ b568A
        LDA #$00
b567A   CLC 
        ADC #$30
        STA presetLoPtr
        LDA presetHiPtr
        ADC #$00
        STA presetHiPtr
        LDA presetLoPtr
        DEX 
        BNE b567A
b568A   STA presetLoPtr
        LDY #$00
        RTS 

;-------------------------------------------------------------------------
; StorePresetValues
;-------------------------------------------------------------------------
StorePresetValues
        JSR LoadSelectedPresetPointers
        LDA cursorSpeed
        JSR StorePresetByte
        LDA vectorMode
        JSR StorePresetByte
        LDA speedBoostAdjust
        JSR StorePresetByte
        LDA currentPatternIndex
        JSR StorePresetByte
        LDA verticalResolutionSPAC
        JSR StorePresetByte
        LDA pulseSpeed   ;pulseSpeed  
        JSR StorePresetByte
        LDA currentPulseWidth
        JSR StorePresetByte
        LDA smoothingDelay
        JSR StorePresetByte
        LDA currentSymmetry
        JSR StorePresetByte
        LDA screenMode
        JSR StorePresetByte
        LDA bufferLength
        JSR StorePresetByte
        LDA stroboscopicsEnabled
        JSR StorePresetByte
        LDA stroboFlashRate
        JSR StorePresetByte

        LDX #$00
b56D9   LDA colorValuesOfSomeSort,X
        JSR StorePresetByte
        INX 
        CPX #$21
        BNE b56D9

        LDA explosionMode
        JSR StorePresetByte
        RTS 

;-------------------------------------------------------------------------
; StorePresetByte
;-------------------------------------------------------------------------
StorePresetByte
        STA (presetLoPtr),Y
        INY 
        RTS 

selectedPresetBank   .BYTE $00
presetHiPtrArray   .BYTE $00,$03,$06,$09,$0C
;-------------------------------------------------------------------------
; LoadPreset
;-------------------------------------------------------------------------
LoadPreset
        ; Selected preset is in X register.
        JSR LoadSelectedPresetPointers
        JSR GetByteFromPreset
        STA cursorSpeed
        JSR GetByteFromPreset
        STA vectorMode
        JSR GetByteFromPreset
        STA speedBoostAdjust
        JSR GetByteFromPreset
        STA currentPatternIndex
        JSR GetByteFromPreset
        STA verticalResolutionSPAC
        JSR GetByteFromPreset
        STA pulseSpeed   ;pulseSpeed  
        STA pulseSpeed2
        JSR GetByteFromPreset
        STA currentPulseWidth
        STA currentPulseWidth2
        JSR GetByteFromPreset
        STA smoothingDelay
        JSR GetByteFromPreset
        STA currentSymmetry
        JSR GetByteFromPreset
        STA screenMode
        JSR GetByteFromPreset
        STA bufferLength
        JSR GetByteFromPreset
        STA stroboscopicsEnabled
        LDA #$00
        STA somethingToDoWithStrobo
        JSR GetByteFromPreset
        STA stroboFlashRate

        LDX #$00
b5748   JSR GetByteFromPreset
        STA colorValuesOfSomeSort,X
        INX 
        CPX #$21
        BNE b5748

        JSR GetByteFromPreset
        AND #$80
        STA explosionMode

        LDX #$00
b575D   LDA colorValuesOfSomeSort,X
        STA PCOLR0,X ;PCOLR0  shadow for COLPM0 ($D012)
        LDA oozeRates,X
        STA oozeRates2,X
        LDA oozeCycles,X
        STA oozeCycles2,X
        LDA #$00
        STA oozeRateTracker,X
        INX 
        CPX #$08
        BNE b575D

        LDA oozeRates
        STA COLOR4   ;COLOR4  shadow for COLBK ($D01A)
        LDA #$01
        STA selectedModePreventsForegroundDrawing
        JMP PropagateNewBufferLength
        ;Returns

;-------------------------------------------------------------------------
; GetByteFromPreset
;-------------------------------------------------------------------------
GetByteFromPreset
        LDA (presetLoPtr),Y
        INY 
        RTS 

;-------------------------------------------------------------------------
; MaybeOKeyPressed
;-------------------------------------------------------------------------
MaybeOKeyPressed
        PHA 
        AND #$3F
        CMP #KEY_O
        BEQ b5796
        PLA 
        JMP MaybeCapsKeyPressed

        ; O=Pulse Width variable key 
b5796   PLA 
        AND #$C0
        BNE b579C
        RTS 

b579C   CMP #$80
        BEQ b57A4
        DEC currentPulseWidth
        DEC currentPulseWidth
b57A4   INC currentPulseWidth
        LDA currentPulseWidth
        STA currentPulseWidth2
        STA lastKeyPressed

        LDX #PULSE_WIDTH___000
        JMP UpdateStatusLineAndDisplaySelectedValue
        ; Returns

;-------------------------------------------------------------------------
; MaybeCapsKeyPressed
;-------------------------------------------------------------------------
MaybeCapsKeyPressed
        CMP #KEY_CAPSTOGGLE
        BNE MaybeRKeyPressed

        ; CAPS=Preset Bank Select 
        INC selectedPresetBank
        LDA selectedPresetBank
        CMP #$05
        BNE b57C5
        LDA #$00
        STA selectedPresetBank
b57C5   LDA selectedPresetBank
        STA lastKeyPressed
        LDX #RUN_PRESET_BANK_000
        JMP UpdateStatusLineAndDisplaySelectedValue
        ; Returns

MaybeRKeyPressed   
        PHA 
        AND #$3F
        CMP #KEY_R
        BEQ RKeyPressed
        PLA 
        JMP MaybeQKeyPressed

        ; R=Stop Record Mode/Begin Playback/Stop Playback CTRL
RKeyPressed   
        PLA 
        AND #KEY_SHIFT | KEY_CTRL
        BEQ MixedModeOnOff
        CMP #KEY_SHIFT
        BEQ BeginRecordMode
        LDA autoDemoEnabled
        CMP #RECORDING_ENABLED
        BNE StopRecordPlayback
        RTS 

StopRecordPlayback   
        LDA dualJoystickMode
        BEQ MixRecordAndLivePlay

DisableDualJoystics
        LDA #$00
        STA dualJoystickMode
        JSR DuplicatePixelPosition
        JMP UpdateStatusLineForPlayback

;-------------------------------------------------------------------------
; DuplicatePixelPosition
;-------------------------------------------------------------------------
DuplicatePixelPosition
        LDA pixelXPosition
        PHA 
        LDA pixelYPosition
        PHA 
        LDA a5CF6
        STA pixelXPosition
        LDA a5CF7
        STA pixelYPosition
        LDA #$00
        STA aDF
        JSR FetchValuesForPlayback
        PLA 
        STA pixelYPosition
        PLA 
        STA pixelXPosition
        RTS 

;-------------------------------------------------------------------------
; UpdateStatusLineForPlayback
;-------------------------------------------------------------------------
UpdateStatusLineForPlayback
        ;Mixed Mode off
        LDX #MIXED_MODE_OFF
        JMP UpdateStatusLine
        ;Returns

MixRecordAndLivePlay   
        LDX #MIX_RECLIVE_PLAY
        LDA #$01
        STA dualJoystickMode
        JSR StorePixelPositions
        JMP UpdateStatusLine
        ;Returns

BeginRecordMode   
        LDA autoDemoEnabled
        BNE ClearAndDisableDemoMode
        LDA dualJoystickMode
        BEQ InitiateRecording
        RTS 

InitiateRecording   
        JSR StartRecording
        LDX #RECORDING_INITIATED
        JMP UpdateStatusLine
        ; Returns

MixedModeOnOff   
        LDA autoDemoEnabled
        CMP #RECORDING_ENABLED
        BEQ ClearAndDisableDemoMode

        CMP #DEMO_DISABLED
        BNE DisableDemoMode

        LDA fA000
        CMP #$CC
        BNE InitiatePlayback
        RTS 

InitiatePlayback   
        JSR StartPlayback
        LDX #PLAYBACK_INITIATED
        JMP UpdateStatusLine
        ; Returns

ClearAndDisableDemoMode   
        LDY #$00
        LDA #$CC
        STA (generalLoPtr),Y
        STA (keyboardInputArray),Y

DisableDemoMode   
        LDX #T_E_R_M_I_N_A_T_E_D
        LDA #DEMO_DISABLED
        STA autoDemoEnabled
        JMP UpdateStatusLine
        ; Returns

slothMode   .BYTE $0F
slothModeRelated   .BYTE $00
;-------------------------------------------------------------------------
; GetProceduralValue
;-------------------------------------------------------------------------
GetProceduralValue
offsetForProceduralValue   =*+$01
        LDA LaunchColourspace
        INC offsetForProceduralValue
        RTS 

;-------------------------------------------------------------------------
; MaybeQKeyPressed
;-------------------------------------------------------------------------
MaybeQKeyPressed
        CMP #KEY_Q
        BNE MaybeJPressed

        ; Q=Sloth Mode on/off 
        LDA slothMode
        CMP #$0F
        BEQ b588F
        LDA #$0F
        STA slothMode
        LDA #$00
        STA slothModeRelated
        LDX #ZARJAZ_SLOTH_DISABLE
        JMP UpdateStatusLine

b588F   LDA #$03
        STA slothMode
        JSR GetProceduralValue
        AND #$07
        ORA #$01
        STA slothModeRelated
        LDX #ZARJAZ_SLOTH_ENABLE
        JMP UpdateStatusLine

dualJoystickMode   .BYTE $00
a58A4   .BYTE $00

MaybeJPressed   
        CMP #KEY_J
        BNE MaybeSemiColonPressed

        ; J=Dual Joystick mode off/on 
        LDA dualJoystickMode
        BEQ EnableDualJoystics
        JMP DisableDualJoystics

EnableDualJoystics   
        JSR StorePixelPositions
        LDA #$02
        STA dualJoystickMode
        LDX #DUAL_INPUT_MODE_ON
        JMP UpdateStatusLine

MaybeSemiColonPressed   
        CMP #KEY_SEMICOLON
        BNE MaybeUPressed

        ; ;=Select second user's lightform 
        INC secondUserLightform
        LDA secondUserLightform
        CMP #$18
        BNE b58CE
        LDA #$00
b58CE   STA secondUserLightform
        AND #$18
        BEQ UpdateStatusForSecondUserLightForm

        LDA secondUserLightform
        SEC 
        SBC #$08
        STA lastKeyPressed

        LDX #USER_LIGHTFORM_000
        JMP UpdateStatusLineAndDisplaySelectedValue
        ;Returns

UpdateStatusForSecondUserLightForm   
        LDX secondUserLightform
        JMP UpdateStatusLine
        ;Returns

secondUserLightform   .BYTE $00

MaybeUPressed   
        CMP #KEY_U
        BNE JumpToMaybeAPressed

        ; U=Define User-Definable Lightform 
        LDA autoDemoEnabled
        BNE b58F9
        LDA currentPatternIndex
        AND #$18
        BNE ClearDownCurrentPattern
b58F9   RTS 

JumpToMaybeAPressed   
        JMP MaybeAPressed

beginDrawingForeground   .BYTE $00
;-------------------------------------------------------------------------
; ClearDownCurrentPattern   
;-------------------------------------------------------------------------
ClearDownCurrentPattern   
        LDA #CLEAR_FOREGROUND
        STA beginDrawingForeground
        LDX currentPatternIndex
        LDA pixelXPositionLoPtrArray,X
        STA generalLoPtr
        LDA pixelXPositionHiPtrArray,X
        STA generalHiPtr

        LDY #$00
        LDA #$55
b5913   STA (generalLoPtr),Y
        INY 
        CPY #$40
        BNE b5913

        LDA #$06
        STA pixelsToPaint
        LDA #$00
        STA a5966
        RTS 

;-------------------------------------------------------------------------
; ComposeForeground
;-------------------------------------------------------------------------
ComposeForeground
        LDY beginDrawingForeground
        CPY #DRAW_FOREGROUND
        BNE b592E
        JMP ProcessKeyStrokesDuringForegroundDrawing
        ; Returns

b592E   CMP #KEY_RETURN
        BNE b5946

        DEC pixelsToPaint
        LDA pixelsToPaint
        BEQ b5946

        INC a5966
        LDA a5966

        CMP #$3A
        BNE b5946

        LDA #$00
        STA pixelsToPaint

b5946   LDA #$3A
        SEC 
        SBC a5966
        STA lastKeyPressed

        LDX #LEVEL_0__FREE_000
        JSR UpdateStatusLine
        JSR WriteStatusLine

        LDA #$08
        SEC 
        SBC pixelsToPaint
        CLC 
        ADC #$10
        LDY #$07
        STA (presetLoPtr),Y
        JMP IncrementDisplayedValue
        ; Returns

a5966   .BYTE $00
;-------------------------------------------------------------------------
; MaybeAPressed
;-------------------------------------------------------------------------
MaybeAPressed
        CMP #KEY_A
        BNE MaybeShiftFPressed

        ; A=Auto Demo on/off 
        LDA autoDemoEnabled
        BNE b597D

        LDA #DEMO_ENABLED
        STA autoDemoEnabled

        JSR EnableDemoMode

        LDX #AUTO_DEMO_MODE_ON
        JMP UpdateStatusLine
        ;Returns

b597D   JMP DisableDemoMode

;-------------------------------------------------------------------------
; ProcessKeyStrokesDuringForegroundDrawing
;-------------------------------------------------------------------------
ProcessKeyStrokesDuringForegroundDrawing
        CMP #KEY_SPACE
        BNE MaybeReturnKeyPressed

        ; Change the plot color
        INC foregroundDrawPlotColor
        LDA foregroundDrawPlotColor
        CMP #$09
        BNE b5990
        LDA #$00
b5990   STA foregroundDrawPlotColor
        JMP UpdateColorStatusForDrawingForeground

MaybeReturnKeyPressed   
        CMP #KEY_RETURN
        BNE MaybeBackspacePressed

        ; Forground point selected
        LDA #FOREGROUND_POINT_SELECTED
        STA foregroundDrawState
        RTS 

UpdateColorStatusForDrawingForeground
        LDX #PIXEL_COLOUR__000
        LDA foregroundDrawPlotColor
        STA lastKeyPressed
        LDA foregroundPixelsHiPtr2
        CMP #$13
        BEQ b59D3
        JMP UpdateStatusLineAndDisplaySelectedValue
        ;Returns

MaybeBackspacePressed   
        CMP #KEY_BACKSPACE
        BNE UpdateColorStatusForDrawingForeground

        LDA #DELETE_FOREGROUND_POINT
        STA foregroundDrawState
        RTS 

MaybeShiftFPressed   
        CMP #KEY_SHIFT | KEY_F
        BNE MaybeShiftGPressed

        ; SHIFT-F=Begin drawing on foreground screen 
        LDY selectedModePreventsForegroundDrawing
        BNE MaybeShiftGPressed
        LDY autoDemoEnabled
        BNE MaybeShiftGPressed

        LDA #DRAW_FOREGROUND
        STA beginDrawingForeground
        LDX #PIXEL_COLOUR__000
        JMP UpdateStatusLine
        ;Returns

b59D3   LDA foregroundPixelsLoPtr2
        AND #$80
        BNE b59DC
        JMP UpdateStatusLineAndDisplaySelectedValue

b59DC   LDX #COLOUR_0__FREE_000
        JSR UpdateStatusLine
        JSR WriteStatusLine
        LDY #$07
        LDA #$10
        CLC 
        ADC foregroundDrawPlotColor
        STA (presetLoPtr),Y
        LDA #$00
        SEC 
        SBC foregroundPixelsLoPtr2
        STA lastKeyPressed
        JMP IncrementDisplayedValue

MaybeShiftGPressed   
        CMP #KEY_SHIFT | KEY_G
        BNE MaybeGPressed

        ; SHIFT-G=Change symmetry of foreground graphics plot 
        INC symmetryForeground
        LDA symmetryForeground
        CMP #$05
        BNE b5A09
        LDA #$00
b5A09   STA symmetryForeground
        CLC 
        ADC #$08
        TAX 
        CPX #BUGGER_OFF_NOSEY
        BEQ b5A17
        JMP UpdateStatusLine

b5A17   LDX #Y_AXIS_SYMMETRY
        JMP UpdateStatusLine

MaybeGPressed   
        CMP #KEY_G
        BNE MaybeWPressed

        ; G=Draw foreground graphics at current cursor position 
        LDA pixelXPosition
        SEC 
        SBC foregroundPixelData
        STA drawForegroundAtXPos
        LDA pixelYPosition
        SEC 
        SBC a1400
        STA drawForegroundAtYPos
        LDA #FOREGROUND_GRAPHICS_ON 
        STA textOutputControl
        RTS 

MaybeWPressed   
        CMP #KEY_W
        BNE MaybeFPressed

        ;W=Wipe off foreground graphics 
        LDA #FOREGROUND_GRAPHICS_OFF
        STA textOutputControl
        RTS 

symmetryForeground   .BYTE $00
drawForegroundAtXPos   .BYTE $00
drawForegroundAtYPos   .BYTE $00
textOutputControl   .BYTE FOREGROUND_GRAPHICS_ON

MaybeFPressed   
        CMP #KEY_F
        BNE MaybeHPressed

        ; F=Draw foreground graphics in original place 
        LDA #FOREGROUND_GRAPHICS_ON
        STA textOutputControl
        LDA #$00
        STA drawForegroundAtXPos
        STA drawForegroundAtYPos
        RTS 

MaybeHPressed   
        PHA 
        AND #$3F
        CMP #KEY_H
        BEQ b5A63
        PLA 
        JMP MaybeYPressed

        ; H,C,V,B,N,M,[=Individual colour Variable Keys 
b5A63   LDA #$00
        LDY currentColourControlEffect
        BEQ b5A70
b5A6A   CLC 
        ADC #$08
        DEY 
        BNE b5A6A
b5A70   TAX 
        PLA 
        AND #$40
        BEQ b5A85
        INX 
        LDY #$07
b5A79   LDA #$00
        STA colorValuesOfSomeSort,X
        INX 
        DEY 
        BNE b5A79
        JMP ColourFlowResync

b5A85   LDY #$07
        INX 
b5A88   LDA colorValuesOfSomeSort,X
        CLC 
        ADC simlAdder
        STA colorValuesOfSomeSort,X
        INX 
        DEY 
        BNE b5A88
        JMP ColourFlowResync

MaybeYPressed
        CMP #KEY_Y
        BNE MaybeCtrlJPressed

        ; Y=enable/disable status line
        LDA disableStatusLine
        BNE b5AB2
        LDA #$01
        STA disableStatusLine
        LDA #<statusTextLineTwo
        STA foregroundPixelsLoPtr
        LDA #>statusTextLineTwo
        STA foregroundPixelsHiPtr
        RTS 

b5AB2   LDA #$00
        STA disableStatusLine
        JSR RepointTextMaybe
        LDX #STATUS_DISPLAYS_ON
        JMP UpdateStatusLine

disableStatusLine .BYTE $00
simlAdder         .BYTE $10

MaybeCtrlJPressed   
        CMP #KEY_CTRL | KEY_J
        BNE MaybeShiftJPressed
        .BYTE $EE,$C0,$5A

UpdateSimlAdderStatus
        LDA simlAdder
        STA lastKeyPressed
        LDX #SIML_ADDER_VALUE000
        JMP UpdateStatusLineAndDisplaySelectedValue
        ; Returns

MaybeShiftJPressed
        CMP #KEY_SHIFT | KEY_J
        BNE MaybeEKeyPressed
        DEC simlAdder
        JMP UpdateSimlAdderStatus

MaybeEKeyPressed   
        CMP #KEY_E
        BNE MaybeCtrlQPressed

        ; E=Explosion mode on/off 
        LDA explosionMode
        EOR #$80
        STA explosionMode
        AND #$80
        BNE UpdateExplosionModeStatus
        LDX #NORMAL_PATTERN_MODE
        JMP UpdateStatusLine

UpdateExplosionModeStatus   
        LDX #EXPLOSION_MODE_ON
        JMP UpdateStatusLine

MaybeCtrlQPressed   
        LDY beginDrawingForeground
        BNE b5B0A
        LDY autoDemoEnabled
        BNE b5B0A

        CMP #KEY_CTRL | KEY_Q
        BNE MaybeCtrlWPressed

        ; CTRL -Q=Start parameter save 
        LDA #START_PARM_SAVE
        STA textOutputControl
b5B0A   RTS 

MaybeCtrlWPressed   
        CMP #KEY_CTRL | KEY_W
        BNE MaybeCtrlAPressed
        ; CTRL -W=Start parameter load 
        LDA #START_PARM_LOAD
        STA textOutputControl
        RTS 

MaybeCtrlAPressed   
        CMP #KEY_CTRL | KEY_A
        BNE MaybeCtrlSPressed

        ; CTRL -A=Start dynamics save 
        LDA #START_DYNAMICS_SAVE
        STA textOutputControl
        RTS 

MaybeCtrlSPressed   
        CMP #KEY_CTRL | KEY_S
        BNE MaybeShiftCtrlCapsLockPressed

        ; CTRL -S=Start dynamics load 
        LDA #START_DYNAMICS_LOAD
        STA textOutputControl
ReturnFromKeyboardCheck   
        RTS 

MaybeShiftCtrlCapsLockPressed   
        CMP #KEY_CTRL | KEY_SHIFT | KEY_CAPSTOGGLE
        BNE ReturnFromKeyboardCheck
        ; Show Credits
        JMP WriteCreditsText

;-------------------------------------------------------------------------
; StartRecording
;-------------------------------------------------------------------------
StartRecording
        LDA #<fA000
        STA generalLoPtr
        LDA #>fA000
        STA generalHiPtr
        LDA #$01
        STA randomKeyInputCounter
        STA randomJoystickInputCounter
        LDA #<fB000
        STA keyboardInputArray
        LDA #>fB000
        STA aC6
        LDY #$00
        TYA 
        STA (generalLoPtr),Y
        STA fB000
        LDA #RECORDING_ENABLED
        STA autoDemoEnabled
        LDA pixelXPosition
        STA pixelXPositionForPlayback
        LDA pixelYPosition
        STA pixelYPositionForPlayback
        LDA selectedPreset
        STA selectedPresetForPlayback
b5B65   RTS 

autoDemoEnabled   .BYTE $00
;-------------------------------------------------------------------------
; GetInputForDemo
;-------------------------------------------------------------------------
GetInputForDemo
        LDA autoDemoEnabled
        BEQ b5B65
        CMP #RECORDING_ENABLED
        BEQ b5B73
        JMP GetRandomKeyboardInput

b5B73   LDY #$00
        LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        CMP (generalLoPtr),Y
        BNE b5B81
        INC randomJoystickInputCounter
        JMP GetKeyboardInput

b5B81   TAX 
        INY 
        LDA randomJoystickInputCounter
        STA (generalLoPtr),Y
        LDA generalLoPtr
        CLC 
        ADC #$02
        STA generalLoPtr
        LDA generalHiPtr
        ADC #$00
        STA generalHiPtr
        CMP #$B0
        BNE b5B9C
b5B99   JMP DisableDemoMode

b5B9C   TXA 
        LDY #$00
        STA (generalLoPtr),Y
        LDA #$01
        STA randomJoystickInputCounter

;-------------------------------------------------------------------------
; GetKeyboardInput
;-------------------------------------------------------------------------
GetKeyboardInput
        LDY #$00
        LDA inputCharacter       ;inputCharacter      keyboard FIFO byte
        CMP (keyboardInputArray),Y
        BNE b5BB4
        INC randomKeyInputCounter
        BNE b5BD7
b5BB4   INY 
        LDA randomKeyInputCounter
        STA (keyboardInputArray),Y
        LDA keyboardInputArray
        CLC 
        ADC #$02
        STA keyboardInputArray
        LDA aC6
        ADC #$00
        STA aC6
        CMP #$C0
        BEQ b5B99
        LDY #$00
        LDA inputCharacter       ;inputCharacter      keyboard FIFO byte
        STA (keyboardInputArray),Y
        LDA #$01
        STA randomKeyInputCounter
b5BD7   RTS 

;-------------------------------------------------------------------------
; StartPlayback
;-------------------------------------------------------------------------
StartPlayback
        LDA #<fA000
        STA generalLoPtr
        LDA #>fA000
        STA generalHiPtr
        LDA #<fB000
        STA keyboardInputArray
        LDA #>fB000
        STA aC6
        LDA #$01
        STA randomKeyInputCounter
        STA randomJoystickInputCounter
        LDA #$00
        STA aDF
        JSR FetchValuesForPlayback
        LDA pixelXPositionForPlayback
        STA pixelXPosition
        LDA pixelYPositionForPlayback
        STA pixelYPosition

        LDA #PLAYBACK_ENABLED
        STA autoDemoEnabled

        LDX selectedPresetForPlayback
        JSR LoadPreset
        RTS 

;-------------------------------------------------------------------------
; GetRandomKeyboardInput
;-------------------------------------------------------------------------
GetRandomKeyboardInput
        CMP #DEMO_ENABLED
        BNE b5C14

        JMP GetRandomJoytstickMovement
        ; Returns?

b5C14   DEC randomKeyInputCounter
        BNE b5C39
        LDA keyboardInputArray
        CLC 
        ADC #$02
        STA keyboardInputArray
        LDA aC6
        ADC #$00
        STA aC6
        CMP #$C0
        BNE b5C2D
        JMP b5B99

b5C2D   LDY #$00
        LDA (keyboardInputArray),Y
        STA DEGFLG
        INY 
        LDA (keyboardInputArray),Y
        STA randomKeyInputCounter
b5C39   DEC randomJoystickInputCounter
        BNE b5C5E
        LDA generalLoPtr
        CLC 
        ADC #$02
        STA generalLoPtr
        LDA generalHiPtr
        ADC #$00
        STA generalHiPtr
        CMP #$B0
        BNE b5C52
        JMP StartPlayback

b5C52   LDY #$00
        LDA (generalLoPtr),Y
        STA FLPTR
        INY 
        LDA (generalLoPtr),Y
        STA randomJoystickInputCounter
b5C5E   LDA DEGFLG
        CMP #$CC
        BEQ b5C72
        CMP #$FF
        BEQ b5C6B
        STA inputCharacter       ;inputCharacter      keyboard FIFO byte
b5C6B   LDA FLPTR
        CMP #$CC
        BEQ b5C72
        RTS 

b5C72   JMP StartPlayback

pixelXPositionForPlayback   .BYTE $00
pixelYPositionForPlayback   .BYTE $00
selectedPreset   .BYTE $00
selectedPresetForPlayback   .BYTE $00
;-------------------------------------------------------------------------
; StorePixelPositions
;-------------------------------------------------------------------------
StorePixelPositions
        LDA pixelXPosition
        STA a5CF6
        LDA pixelYPosition
        STA a5CF7
        LDA #$00
        STA a58A4
b5C88   LDA #<fA000
        STA generalLoPtr
        LDA #>fA000
        STA generalHiPtr
        LDA #$01
        STA randomJoystickInputCounter
        RTS 

;-------------------------------------------------------------------------
; SomethingToDoWithSecondJoystick
;-------------------------------------------------------------------------
SomethingToDoWithSecondJoystick
        LDA pixelXPosition
        STA a5CF3
        LDA pixelYPosition
        STA a5CF4
        LDA currentPatternIndex
        PHA 
        LDA secondUserLightform
        STA currentPatternIndex
        PLA 
        STA secondUserLightform
        LDA #$FF
        STA secondJoystickMadeAMovememnt
        LDA a5CF6
        STA pixelXPosition
        LDA a5CF7
        STA pixelYPosition
        LDA #$00
        STA aDF
        JSR FetchValuesForPlayback
        LDA dualJoystickMode
        CMP #$02
        BEQ GetInputFromSecondJoystick
        DEC randomJoystickInputCounter
        BNE b5CEE
        LDA generalLoPtr
        CLC 
        ADC #$02
        STA generalLoPtr
        LDA generalHiPtr
        ADC #$00
        STA generalHiPtr
        LDY #$00
        LDA (generalLoPtr),Y
        CMP #$CC
        BEQ b5C88
        STA lastJoystickInput      ;lastJoystickInput     floating point register 1
        STA FLPTR
        INY 
        LDA (generalLoPtr),Y
        STA randomJoystickInputCounter
        RTS 

b5CEE   LDA FLPTR
        STA lastJoystickInput      ;lastJoystickInput     floating point register 1
        RTS 

a5CF3   .BYTE $00
a5CF4   .BYTE $00
secondJoystickMadeAMovememnt   .BYTE $00
a5CF6   .BYTE $00
a5CF7   .BYTE $00

;-------------------------------------------------------------------------
; GetInputFromSecondJoystick   
;-------------------------------------------------------------------------
GetInputFromSecondJoystick   
        LDA STICK1   ;STICK1  shadow for PORTA hi ($D300)
        LDY STRIG1   ;STRIG1  shadow for TRIG1 ($D002)
        BNE b5D02
        ORA #$80
b5D02   STA lastJoystickInput      ;lastJoystickInput     floating point register 1
        RTS 

;-------------------------------------------------------------------------
; LooksUnusedRoutine   
;-------------------------------------------------------------------------
LooksUnusedRoutine   
        LDA #$55
a5D08   =*+$01
a5D09   =*+$02
        STA a2000
        INC a5D08
        BNE LooksUnusedRoutine
        INC a5D09
        LDA a5D09
        CMP #$30
        BNE LooksUnusedRoutine
        LDA #$20
        STA a5D09
        RTS 

;-------------------------------------------------------------------------
; ForegroundPixelsMaybe
;-------------------------------------------------------------------------
ForegroundPixelsMaybe
        JSR ClearLinePtrArrays
        JSR ClearExplosionModeArray

        LDA #$28
        STA currentPixelXPosition

        LDA bottomMostYPos
        CLC 
        ROR 
        STA currentPixelYPosition

        LDA beginDrawingForeground
        CMP #DRAW_FOREGROUND
        BNE b5D39

        JMP ProcessForegroundPointPaint
        ; Returns?

b5D39   LDA #$00
        STA currentSymmetrySetting
        LDA currentPatternIndex
        STA patternIndex

        LDA cursorSpeed
        PHA 
        LDA #$03
        STA cursorSpeed

b5D4A   LDA pixelsToPaint
        STA currentPaintState
        JSR LoopThroughPixelsAndPaint
        LDA pixelsToPaint
        BNE b5D4A
        LDA #$00
        STA beginDrawingForeground
        PLA 
        STA cursorSpeed
        JSR ClearLinePtrArrays
        JMP MainGameLoop

a5D64   .BYTE $00
b5D65   LDA a5D64
        BEQ b5D85
        DEC a5D64
        BEQ b5D85
        RTS 

;-------------------------------------------------------------------------
; UpdatePixelsForeground
;-------------------------------------------------------------------------
UpdatePixelsForeground
        LDA beginDrawingForeground
        CMP #DRAW_FOREGROUND
        BNE b5D7A
        JMP ShowCurrentForegroundPixelMaybe

b5D7A   LDA STRIG0   ;STRIG0  shadow for TRIG0 ($D001)
        BEQ b5D65
        LDA #$00
        STA a5D64
        RTS 

b5D85   LDA pixelsToPaint
        BEQ a5D64
        LDA #$30
        STA a5D64
        LDY a5966
        LDA pixelXPosition
        SEC 
        SBC #$28
        STA (generalLoPtr),Y
        TYA 
        CLC 
        ADC #$40
        TAY 
        LDA bottomMostYPos
        CLC 
        ROR 
        STA a5DBC
        LDA pixelYPosition
        SEC 
        SBC a5DBC
        STA (generalLoPtr),Y
        INC a5966
        LDA a5966
        CMP #$3A
        BEQ b5DB7
        RTS 

b5DB7   LDA #$00
        STA pixelsToPaint
        RTS 

a5DBC   .BYTE $00
;-------------------------------------------------------------------------
; GetRandomJoytstickMovement
;-------------------------------------------------------------------------
GetRandomJoytstickMovement
        LDA a5E1C
        BEQ b5DCD
        DEC a5E1C
        LDA a5E1D
        STA lastJoystickInput      ;lastJoystickInput     floating point register 1
        JMP GetRandomJoystickMovement2

b5DCD   LDA a5E1E
        BEQ EnableDemoMode
        LDA indexToRandomJoystickMovements
        AND #$07
        TAX 
        LDA randomJoystickMovememtArray,X
        STA lastJoystickInput      ;lastJoystickInput     floating point register 1
        DEC a5E20
        BNE GetRandomJoystickMovement2
        INC indexToRandomJoystickMovements
        LDA a5E21
        STA a5E20
        DEC a5E1E
        BNE GetRandomJoystickMovement2

;-------------------------------------------------------------------------
; EnableDemoMode
;-------------------------------------------------------------------------
EnableDemoMode
        JSR GetProceduralValue
        AND #$7F
        STA a5E1C
        JSR GetProceduralValue
        AND #$1F
        STA a5E1E
        JSR GetProceduralValue
        AND #$07
        ORA #$01
        STA a5E20
        STA a5E21
        JSR GetProceduralValue
        AND #$07
        TAX 
        LDA randomJoystickMovememtArray,X
        STA a5E1D
        JMP GetRandomJoystickMovement2

a5E1C   .BYTE $00
a5E1D   .BYTE $00
a5E1E   .BYTE $00
indexToRandomJoystickMovements   .BYTE $00
a5E20   .BYTE $00
a5E21   .BYTE $00
randomJoystickMovememtArray   .BYTE $0E,$06,$07,$05,$0D,$09,$0B,$0A
;-------------------------------------------------------------------------
; GetRandomJoystickMovement2
;-------------------------------------------------------------------------
GetRandomJoystickMovement2
        LDA a5E5B
        BEQ b5E39
        LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        ORA #$80
        STA FLPTR
        DEC a5E5B
        RTS 

b5E39   LDA a5E5C
        BEQ b5E48
        LDA lastJoystickInput      ;lastJoystickInput     floating point register 1
        AND #$7F
        STA FLPTR
        DEC a5E5C
        RTS 

b5E48   JSR GetProceduralValue
        AND #$7F
        STA a5E5B
        JSR GetProceduralValue
        AND #$1F
        STA a5E5C
        JMP SelectRandomPreset

a5E5B   .BYTE $0A
a5E5C   .BYTE $02   

SelectRandomPreset
        DEC a5EB6
        BEQ b5E63
        RTS 

b5E63   JSR GetProceduralValue
        AND #$1F
        ADC #$10
        STA a5EB6
        LDA #FOREGROUND_GRAPHICS_OFF
        STA textOutputControl
        INC a2CAE
        LDA a2CAE
        CMP #$03
        BNE b5E86
        LDA #FOREGROUND_GRAPHICS_ON
        STA textOutputControl
        LDA #$00
        STA a2CAE
b5E86   INC a5EB7
        LDA a5EB7
        AND #$0F
        TAX 
        BNE b5EA1
        INC selectedPresetBank
        LDA selectedPresetBank
        CMP #$05
        BNE b5EA1
        LDA #$00
        STA selectedPresetBank
        TAX 
b5EA1   JSR LoadPreset
        LDA screenMode
        CMP #$04
        BEQ b5EB0
        CMP #$05
        BEQ b5EB0
        RTS 

b5EB0   LDA #FOREGROUND_GRAPHICS_OFF
        STA textOutputControl
        RTS 

a5EB6   .BYTE $0A
a5EB7   .BYTE $00
;-------------------------------------------------------------------------
; ShowCurrentForegroundPixelMaybe
;-------------------------------------------------------------------------
ShowCurrentForegroundPixelMaybe
        LDA STRIG0   ;STRIG0  shadow for TRIG0 ($D001)
        BEQ b5EBE
        RTS 

b5EBE   LDA pixelXPosition
        STA foregroundRecordPixelXPos
        LDA pixelYPosition
        STA foregroundRecordPixelYPos
        LDA #FOREGROUND_POINT_RECORDED
        STA foregroundDrawState
        LDA foregroundDrawPlotColor
        STA foregroundPixelPaintState
        RTS 

foregroundDrawPlotColor   .BYTE $03
foregroundRecordPixelXPos   .BYTE $00
foregroundRecordPixelYPos   .BYTE $00
foregroundPixelPaintState   .BYTE $00
;-------------------------------------------------------------------------
; UpdateStateAfterClearingForegound
;-------------------------------------------------------------------------
UpdateStateAfterClearingForegound
        LDA foregroundRecordPixelXPos
        STA previousPixelXPosition
        LDA foregroundRecordPixelYPos
        STA previousPixelYPosition
        LDA foregroundPixelPaintState
        ORA #$40
        STA currentPaintState
        JSR PaintPixelForCurrentSymmetry

;-------------------------------------------------------------------------
; ProcessForegroundDrawState
;-------------------------------------------------------------------------
ProcessForegroundDrawState
        LDA foregroundDrawState
        BEQ ProcessForegroundDrawState
        CMP #FOREGROUND_POINT_RECORDED
        BEQ ForegroundPointRecorded
        CMP #FOREGROUND_POINT_SELECTED
        BEQ SelectForegroundPoint
        CMP #DELETE_FOREGROUND_POINT
        BNE ForegroundStateCleared

        JMP PaintForegroundPoint

ForegroundStateCleared   
        LDA #$00
        STA foregroundDrawState
        JMP UpdateStateAfterClearingForegound

;-------------------------------------------------------------------------
; ProcessForegroundPointPaint
;-------------------------------------------------------------------------
ProcessForegroundPointPaint
        LDA #>foregroundPixelData - $01
        STA foregroundPixelsHiPtr2
        LDA #<foregroundPixelData - $01
        STA foregroundPixelsLoPtr2
        LDA #$00
        STA foregroundDrawState
        LDA cursorSpeed
        PHA 

        ; Clear the pixel data.
        LDX #$00
b5F1B   LDA #$FF
        STA foregroundPixelData,X
        STA foregroundPixelData + $100,X
        STA foregroundPixelData + $200,X
        STA foregroundPixelData + $300,X
        DEX 
        BNE b5F1B

        LDA #$03
        STA cursorSpeed
        LDA symmetryForeground
        STA currentSymmetrySetting
        JMP ProcessForegroundDrawState

SelectForegroundPoint   
        PLA 
        STA cursorSpeed
        LDA #$00
        STA beginDrawingForeground
        JMP MainGameLoop

foregroundDrawState   .BYTE $00

ForegroundPointRecorded   
        LDY #$00
        LDA foregroundPixelsHiPtr2
        PHA 
        LDA (foregroundPixelsLoPtr2),Y
        CMP foregroundRecordPixelXPos
        BNE b5F6B
        PLA 
        PHA 
        CLC 
        ADC #$04
        STA foregroundPixelsHiPtr2
        LDA (foregroundPixelsLoPtr2),Y
        CMP foregroundRecordPixelYPos
        BNE b5F6B
        PLA 
        STA foregroundPixelsHiPtr2
        LDA #$00
        STA foregroundDrawState
        JMP ProcessForegroundDrawState

b5F6B   JMP PrepareAndStoreSelectedForegroundPoint

;-------------------------------------------------------------------------
; StoreSelectedForegroundPoint
;-------------------------------------------------------------------------
StoreSelectedForegroundPoint
        PLA 
        PHA 
        STA foregroundPixelsHiPtr2

        LDA foregroundRecordPixelXPos
        STA (foregroundPixelsLoPtr2),Y

        LDA foregroundPixelsHiPtr2
        CLC 
        ADC #$04
        STA foregroundPixelsHiPtr2

        LDA foregroundRecordPixelYPos
        STA (foregroundPixelsLoPtr2),Y

        LDA foregroundPixelsHiPtr2
        CLC 
        ADC #$04
        STA foregroundPixelsHiPtr2

        LDA foregroundPixelPaintState
        STA (foregroundPixelsLoPtr2),Y

        PLA 
        STA foregroundPixelsHiPtr2
        JMP ForegroundStateCleared

;-------------------------------------------------------------------------
; PrepareAndStoreSelectedForegroundPoint
;-------------------------------------------------------------------------
PrepareAndStoreSelectedForegroundPoint
        LDA foregroundPixelsLoPtr2
        CLC 
        ADC #$01
        STA foregroundPixelsLoPtr2
        PLA 
        ADC #$00
        STA foregroundPixelsHiPtr2
        PHA 
        CMP #$20
        BEQ b5FA9
        JMP StoreSelectedForegroundPoint

b5FA9   LDA #FOREGROUND_POINT_SELECTED
        STA foregroundDrawState
        PLA 
        STA foregroundPixelsHiPtr2
        JMP ProcessForegroundDrawState

        ; zero-byte padding
        .TEXT x'00' x 4172

.include "foreground.asm"

; Other data
        .BYTE $4F,$00,$00,$00,$00,$00,$00,$00
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
        .BYTE $00,$E0,$02,$E1,$02,$00,$40
