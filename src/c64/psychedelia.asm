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
pixelXPositionZP              = $02
pixelYPositionZP              = $03
currentIndexToColorValues     = $04
colorRamTableLoPtr2           = $05
colorRamTableHiPtr2           = $06
previousPixelXPositionZP      = $08
previousPixelYPositionZP      = $09
colorRamTableLoPtr            = $0A
colorRamTableHiPtr            = $0B
currentColorToPaint           = $0C
xPosLoPtr                     = $0D
xPosHiPtr                     = $0E
currentPatternElement         = $0F
yPosLoPtr                     = $10
yPosHiPtr                     = $11
timerBetweenKeyStrokes        = $12
shouldDrawCursor              = $13
currentSymmetrySettingForStep = $14
currentSymmetrySetting        = $15
offsetForYPos                           = $16
a17                           = $17
colorBarColorRamLoPtr         = $18
colorBarColorRamHiPtr         = $19
currentColorSet               = $1A
presetSequenceDataLoPtr       = $1B
presetSequenceDataHiPtr       = $1C
currentSequencePtrLo          = $1D
currentSequencePtrHi          = $1E
lastJoystickInput             = $21
customPresetLoPtr             = $22
customPresetHiPtr             = $23
a24                           = $24
a25                           = $25
a26                           = $26
lastKeyPressed                = $C5
presetLoPtr                   = $FE
presetHiPtr                   = $FF

SCREEN_RAM                    = $0400
COLOR_RAM                     = $D800
CURRENT_CHAR_COLOR            = $0286
shiftKey                      = $028D
a7FFF                         = $7FFF
presetSequenceData      = $C000

eEA31                         = $EA31

ROM_IOINIT                    = $FF84
ROM_READST                    = $FFB7
ROM_SETLFS                    = $FFBA
ROM_SETNAM                    = $FFBD
ROM_LOAD                      = $FFD5
ROM_SAVE                      = $FFD8
ROM_CLALL                     = $FFE7

BLACK        = $00
WHITE        = $01
RED          = $02
CYAN         = $03
PURPLE       = $04
GREEN        = $05
BLUE         = $06
YELLOW       = $07
ORANGE       = $08
BROWN        = $09
LTRED        = $0A
GRAY1        = $0B
GRAY2        = $0C
LTGREEN      = $0D
LTBLUE       = $0E
GRAY3        = $0F
* = $0801
;-----------------------------------------------------------------------------------
; Start program at InitializeProgram (SYS 2064)
;-----------------------------------------------------------------------------------
        .BYTE $0B,$08,$C1,$07,$9E,$32,$30,$36,$34
        .BYTE $00,$00,$00,$F9
        .BYTE $02,$F9

colorRamLoPtr = $FB
colorRamHiPtr = $FC
;-------------------------------------------------------
; InitializeProgram
;-------------------------------------------------------
InitializeProgram
        ; Set border and background to black
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0

        JSR MovePresetDataIntoPosition

        STA shouldDrawCursor

        ; Create a Hi/Lo pointer to $D800
        LDA #>COLOR_RAM
        STA colorRamHiPtr
        LDA #<COLOR_RAM
        STA colorRamLoPtr

        ; Populate a table of hi/lo ptrs to the color RAM
        ; of each line on the screen (e.g. $D800,
        ; $D828, $D850 etc). Each entry represents a single
        ; line 40 bytes long and there are nineteen lines.
        ; The last line is reserved for configuration messages.
        LDX #$00
b0827   LDA colorRamHiPtr
        STA colorRAMLineTableHiPtrArray,X
        LDA colorRamLoPtr
        STA colorRAMLineTableLoPtrArray,X
        CLC 
        ADC #$28
        STA colorRamLoPtr
        LDA colorRamHiPtr
        ADC #$00
        STA colorRamHiPtr
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
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00
colorRAMLineTableHiPtrArray
        .BYTE $00,$00,$00,$00,$00,$00,$BF,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00

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

tempIndex = $FD
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
        STA tempIndex
        LDX currentIndexToColorValues
        INX 
        CPX tempIndex
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
        STA countToMatchCurrentIndex

        LDA pixelXPositionZP
        STA previousPixelXPositionZP
        LDA pixelYPositionZP
        STA previousPixelYPositionZP

        LDX patternIndex
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

        DEC countToMatchCurrentIndex
        LDA countToMatchCurrentIndex
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

starOneXPosArray
        .BYTE $00,$01,$01,$01,$00,$FF,$FF,$FF
        .BYTE $55,$00,$02,$00,$FE,$55,$00,$03
        .BYTE $00,$FD,$55,$00,$04,$00,$FC,$55
        .BYTE $FF,$01,$05,$05,$01,$FF,$FB,$FB
        .BYTE $55,$00,$07,$00,$F9,$55,$55
starOneYPosArray
        .BYTE $FF,$FF,$00,$01,$01,$01,$00,$FF
        .BYTE $55,$FE,$00,$02,$00,$55,$FD,$00
        .BYTE $03,$00,$55,$FC,$00,$04,$00,$55
        .BYTE $FB,$FB,$FF,$01,$05,$05,$01,$FF
        .BYTE $55,$F9,$00,$07,$00,$55,$55

countToMatchCurrentIndex   .BYTE $00

;-------------------------------------------------------
; PutRandomByteInAccumulator
;-------------------------------------------------------
PutRandomByteInAccumulator   
randomByteAddress   =*+$01
        LDA $E199,X
        INC randomByteAddress
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
        LDA currentSymmetrySettingForStep
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
        LDY currentSymmetrySettingForStep
        CPY #$02
        BEQ b0A25
        JSR PaintPixel
        LDA currentSymmetrySettingForStep
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
        .BYTE $00,$00,$FF,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$FF,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
pixelYPositionArray
        .BYTE $00,$00,$FD,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
currentIndexForCurrentStepArray
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
initialFramesRemainingToNextPaintForStep
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
framesRemainingToNextPaintForStep
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
nextPixelYPositionArray
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
symmetrySettingForStepCount
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

;-------------------------------------------------------
; ReinitializeSequences
;-------------------------------------------------------
ReinitializeSequences
        LDX #$00
        TXA 
b0BF9   STA pixelXPositionArray,X
        STA pixelYPositionArray,X
        LDA #$FF
        STA currentIndexForCurrentStepArray,X
        LDA #$00
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        STA nextPixelYPositionArray,X
        STA symmetrySettingForStepCount,X
        INX 
p0C13   CPX #$40
        BNE b0BF9
        STA timerBetweenKeyStrokes
        STA currentPatternElement
        STA shouldDrawCursor
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
        CMP bufferLength
        BNE b0C77
        LDA #$00
        STA stepCount
b0C77   LDX stepCount
        LDA currentIndexForCurrentStepArray,X
        CMP #$FF
        BNE b0C86
        STX shouldDrawCursor
        JMP MainPaintRoutine

b0C86   STA currentIndexToColorValues
        DEC framesRemainingToNextPaintForStep,X
        BNE b0CB8

        LDA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X

        LDA pixelXPositionArray,X
        STA pixelXPositionZP
        LDA pixelYPositionArray,X
        STA pixelYPositionZP

        LDA nextPixelYPositionArray,X
        STA patternIndex

        LDA symmetrySettingForStepCount,X
        STA currentSymmetrySettingForStep
        LDA currentIndexToColorValues
        AND #$80
        BNE b0CBC
        TXA 
        PHA 
        JSR LoopThroughPixelsAndPaint
        PLA 
        TAX 
        DEC currentIndexForCurrentStepArray,X
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

        LDA sequencerSpeed
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
        LDA cursorSpeed
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
        JMP DrawCursorAndReturnFromInterrupt
        ; Returns

        ; Player hasn't pressed fire.
b0D7B   LDA a0E3D
        BEQ b0D8B
        LDA stepsSincePressedFire
        BEQ b0D88
        JMP DrawCursorAndReturnFromInterrupt

b0D88   INC stepsSincePressedFire
b0D8B   LDA patternUpdateDisplayInterval
        BEQ b0D98
        DEC patternUpdateDisplayInterval
        BEQ b0D98
        JMP UpdateDisplayedPattern

b0D98   DEC currentDrawCursorInterval
        BEQ b0DA0
        JMP DrawCursorAndReturnFromInterrupt

b0DA0   LDA pulseSpeed
        STA currentDrawCursorInterval
        LDA pulseWidth
        STA patternUpdateDisplayInterval

UpdateDisplayedPattern    
        INC currentStepCount
        LDA currentStepCount
        CMP bufferLength
        BNE b0DBC

        LDA #$00
        STA currentStepCount

b0DBC   TAX 
        LDA currentIndexForCurrentStepArray,X
        CMP #$FF
        BEQ b0DD6
        LDA shouldDrawCursor
        AND trackingActivated
        BEQ DrawCursorAndReturnFromInterrupt
        TAX 
        LDA currentIndexForCurrentStepArray,X
        CMP #$FF
        BNE DrawCursorAndReturnFromInterrupt

        STX currentStepCount
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
        STA currentIndexForCurrentStepArray,X
        JMP j0E00

b0DF5   LDA baseLevel
        STA currentIndexForCurrentStepArray,X
        LDA currentPatternElement
        STA nextPixelYPositionArray,X

j0E00    
        LDA smoothingDelay
a0E03   STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        LDA currentSymmetrySetting
        STA symmetrySettingForStepCount,X

DrawCursorAndReturnFromInterrupt    
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


pixelXPosition                           .BYTE $0A
colorRAMLineTableIndex                   .BYTE $0A
currentStepCount                         .BYTE $00
stepsSincePressedFire                    .BYTE $00
a0E3D                                    .BYTE $00

COLOR_BAR_CURRENT = $00
SMOOTHING_DELAY   = $01
CURSOR_SPEED      = $02
BUFFER_LENGTH     = $03
PULSE_SPEED       = $04
COLOR_CHANGE      = $05
LINE_WIDTH        = $06
SEQUENCER_SPEED   = $07
PULSE_WIDTH       = $08
BASE_LEVEL        = $09
; This is where the presets get loaded to. It represents
; the data structure for the presets.
; currentVariableMode is an index into this data structure
; when the user adjusts settings.
presetValueArray
colorBarCurrentValueForModePtr .BYTE $00
smoothingDelay                 .BYTE $0C
cursorSpeed                    .BYTE $02
bufferLength                   .BYTE $1F
pulseSpeed                     .BYTE $01
indexForPresetColorValues      .BYTE $01
lineWidth                      .BYTE $07
sequencerSpeed                 .BYTE $04
pulseWidth                     .BYTE $01
baseLevel                      .BYTE $07
presetColorValuesArray         .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
trackingActivated              .BYTE $FF
lineModeActivated              .BYTE $00
patternIndex                   .BYTE $05


customPreset0 = $C800
customPreset1 = $C900
customPreset2 = $CA00
customPreset3 = $CB00
customPreset4 = $CC00
customPreset5 = $CD00
customPreset6 = $CE00
customPreset7 = $CF00
customPreset8 = $C880
customPreset9 = $C980
customPreset10 = $CA80
customPreset11 = $CB80
customPreset12 = $CC80
customPreset13 = $CD80
customPreset14 = $CE80
customPreset15 = $CF80

; A pair of arrays together consituting a list of pointers
; to positions in memory containing X position data.
; (i.e. $097C, $0E93,$0EC3, $0F07, $0F23, $0F57, $1161, $11B1)
pixelXPositionLoPtrArray .BYTE <starOneXPosArray,<theTwistXPosArray,<laLlamitaXPosArray
                         .BYTE <starTwoXPosArray,<deltoidXPosArray,<diffusedXPosArray
                         .BYTE <multicrossXPosArray,<pulsarXPosArray

customPresetLoPtrArray   .BYTE <customPreset0,<customPreset1,<customPreset2,<customPreset3
                         .BYTE <customPreset4,<customPreset5,<customPreset6,<customPreset7

pixelXPositionHiPtrArray .BYTE >starOneXPosArray,>theTwistXPosArray,>laLlamitaXPosArray
                         .BYTE >starTwoXPosArray,>deltoidXPosArray,>diffusedXPosArray
                         .BYTE >multicrossXPosArray,>pulsarXPosArray

customPresetHiPtrArray   .BYTE >customPreset0,>customPreset1,>customPreset2,>customPreset3
                         .BYTE >customPreset4,>customPreset5,>customPreset6,>customPreset7

; A pair of arrays together consituting a list of pointers
; to positions in memory containing Y position data.
; (i.e. $097C, $0E93,$0EC3, $0F07, $0F23, $0F57, $1161, $11B1)
pixelYPositionLoPtrArray .BYTE <starOneYPosArray,<theTwistYPosArray,<laLlamitaYPosArray
                         .BYTE <starTwoYPosArray,<deltoidYPosArray,<diffusedYPosArray
                         .BYTE <multicrossYPosArray,<pulsarYPosArray

                         .BYTE <customPreset8,<customPreset9,<customPreset10,<customPreset11
                         .BYTE <customPreset12,<customPreset13,<customPreset14,<customPreset15

pixelYPositionHiPtrArray .BYTE >starOneYPosArray,>theTwistYPosArray,>laLlamitaYPosArray
                         .BYTE >starTwoYPosArray,>deltoidYPosArray,>diffusedYPosArray
                         .BYTE >multicrossYPosArray,>pulsarYPosArray

                         .BYTE >customPreset8,>customPreset9,>customPreset10,>customPreset11
                         .BYTE >customPreset12,>customPreset13,>customPreset14,>customPreset15

theTwistXPosArray
        .BYTE $00,$55,$01,$02,$55,$01,$02,$03
        .BYTE $55,$01,$02,$03,$04,$55,$00,$00
        .BYTE $00,$55,$FF,$FE,$55,$FF,$55,$55
theTwistYPosArray
        .BYTE $FF,$55,$FF,$FE,$55,$00,$00,$00
        .BYTE $55,$01,$02,$03,$04,$55,$01,$02
        .BYTE $03,$55,$01,$02,$55,$00,$55,$55

laLlamitaXPosArray
        .BYTE $00,$FF,$00,$55,$00,$00,$55,$01
        .BYTE $02,$03,$00,$01,$02,$03,$55,$04
        .BYTE $05,$06,$04,$00,$01,$02,$55,$04
        .BYTE $00,$04,$00,$04,$55,$FF,$03,$55
        .BYTE $00,$55
laLlamitaYPosArray
        .BYTE $FF,$00,$01,$55,$02,$03,$55,$03
        .BYTE $03,$03,$04,$04,$04,$04,$55,$03
        .BYTE $02,$03,$04,$05,$05,$05,$55,$05
        .BYTE $06,$06,$07,$07,$55,$07,$07,$55
        .BYTE $00,$55

starTwoXPosArray
        .BYTE $FF,$55,$00,$55,$02,$55,$01,$55
        .BYTE $FD,$55,$FE,$55,$00,$55
starTwoYPosArray
        .BYTE $FF,$55,$FE,$55,$FF,$55,$02,$55
        .BYTE $01,$55,$FC,$55,$00,$55
deltoidXPosArray
        .BYTE $00,$01,$FF,$55,$00,$55,$00,$01
        .BYTE $02,$FE,$FF,$55,$00,$03,$FD,$55
        .BYTE $00,$04,$FC,$55,$00,$06,$FA,$55
        .BYTE $00,$55
deltoidYPosArray
        .BYTE $FF,$00,$00,$55,$00,$55,$FE,$FF
        .BYTE $00,$00,$FF,$55,$FD,$01,$01,$55
        .BYTE $FC,$02,$02,$55,$FA,$04,$04,$55
        .BYTE $00,$55
diffusedXPosArray
        .BYTE $FF,$01,$55,$FE,$02,$55,$FD,$03
        .BYTE $55,$FC,$04,$FC,$FC,$04,$04,$55
        .BYTE $FB,$05,$55,$FA,$06,$FA,$FA,$06
        .BYTE $06,$55,$00,$55
diffusedYPosArray
        .BYTE $01,$FF,$55,$FE,$02,$55,$03,$FD
        .BYTE $55,$FC,$04,$FF,$01,$FF,$01,$55
        .BYTE $05,$FB,$55,$FA,$06,$FE,$02,$FE
        .BYTE $02,$55,$00,$55


;-------------------------------------------------------
; CheckKeyboardInput
;-------------------------------------------------------
CheckKeyboardInput   
        LDA currentVariableMode
        BEQ CheckForGeneralKeystrokes
        JMP CheckKeyboardInputForActiveVariable

        ; Allow a bit of time to elapse between detected key strokes.
CheckForGeneralKeystrokes   
        LDA timerBetweenKeyStrokes
        BEQ CheckForKeyStroke
        DEC timerBetweenKeyStrokes
        BNE ReturnFromKeyboardCheck

CheckForKeyStroke   
        LDA lastKeyPressed
        CMP #$40
        BNE ProcessKeyStroke

        ; No key was pressed. Return early.
        LDA #$00
        STA timerBetweenKeyStrokes
        JSR DisplayDemoModeMessage
ReturnFromKeyboardCheck   
        RTS 

        ; A key was pressed. Figure out which one.
ProcessKeyStroke   
        LDY initialTimeBetweenKeyStrokes
        STY timerBetweenKeyStrokes
        LDY shiftKey
        STY shiftPressed

        CMP #$3C ; Space pressed?
        BNE MaybeSPressed

        ; Space pressed. Selects a new pattern element. " There are eight permanent ones,
        ; and eight you can define for yourself (more on this later!). The latter eight
        ; are all set up when you load, so you can always choose from 16 shapes."
        INC currentPatternElement
        LDA currentPatternElement
        AND #$0F
        STA currentPatternElement
        AND #$08
        BEQ UpdateCurrentPattern
        ; The first 8 patterns are standard, the rest are custom.
        JMP GetCustomPatternElement

UpdateCurrentPattern   
        JSR ClearLastLineOfScreen
        LDA currentPatternElement
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 

        LDX #$00
txtPresetLoop   
        LDA txtPresetPatternNames,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE txtPresetLoop
        JMP WriteLastLineBufferToScreen
        ; Returns

MaybeSPressed   
        CMP #$0D ; 'S' pressed.
        BNE MaybeLPressed

        ; 'S' pressed. "This changes the 'symmetry'. The pattern gets reflected
        ; in various planes, or not at all according to the setting."
        LDA shiftPressed
        AND #$01
        BEQ JustSPressed
        LDA a1EAA
        BNE JustSPressed
        ; Shift + S pressed, save.
        JMP PromptToSave
        ; Returns

        ; Just 'S' pressed.
        ; Briefly display the new symmetry setting on the bottom of the screen.
JustSPressed   
        INC currentSymmetrySetting
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
txtSymmLoop   
        LDA txtSymmetrySettingDescriptions,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE txtSymmLoop

        JMP WriteLastLineBufferToScreen
        ;Returns

MaybeLPressed   
        CMP #$2A ; 'L' pressed?
        BNE MaybeDPressed

        ; 'L' pressed.
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

MaybeDPressed   
        CMP #$12 ; 'D' pressed?
        BNE MaybeCPressed

        ; Smoothing Delay, D to activate: Because of the time taken to draw
        ; larger patterns speed increase/decrease is not linear. You can adjust
        ; the ‘compensating delay’ which often smooths out jerky patterns. Can
        ; be used just for special FX, though. Suck it and see.
        LDA #SMOOTHING_DELAY
        STA currentVariableMode
        RTS 

MaybeCPressed   
        CMP #$14 ; C pressed?
        BNE MaybeBPressed
        ; C pressed.
        ; Cursor Speed C to activate: Just that. Gives you a slow r fast little
        ; cursor, according to setting.

        LDA #CURSOR_SPEED
        STA currentVariableMode
        RTS 

MaybeBPressed   
        CMP #$1C ; B pressed?
        BNE MaybePPressed

        ; B pressed.
        ; Buffer Length B to activate: Larger patterns flow more smoothly with a
        ; shorter Buffer Length - not so many positions are retained so less
        ; plotting to do. Small patterns with a long Buffer Length are good for
        ; ‘steamer’ effects. N.B. Cannot be adjusted whilst patterns are
        ; actually onscreen.
        LDA #BUFFER_LENGTH
        STA currentVariableMode
        RTS 

MaybePPressed   
        CMP #$29 ; P pressed
        BNE MaybeHPressed

        ; P pressed.
        ; Pulse Speed P to activate: Usually if you hold down the button you
        ; get a continuous stream. Setting the Pulse Speed allows you to
        ; generate a pulsed stream, as if you were rapidly pressing and
        ; releasing the FIRE button.
        LDA #PULSE_SPEED
        STA currentVariableMode
        RTS 

MaybeHPressed   
        CMP #$1D ; H pressed.
        BNE MaybeTPressed

        ; H pressed. Select a change to the pattern colors.
        ; COLOUR CHANGE H to activate: Allows you to set the colour for each of
        ; the seven pattern steps. Set up the colour you want, press RETURN,
        ; and the command offers the next colour along, up to no. 7, then ends.
        ; Cannot be adjusted while patterns being generated.
        LDA #$01
        STA currentColorSet
        LDA #COLOR_CHANGE
        STA currentVariableMode
        RTS 

MaybeTPressed   
        CMP #$16 ; T pressed.
        BNE CheckIfPresetKeysPressed

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
txtTrackingLoop   
        LDA txtTrackingOnOff,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE txtTrackingLoop

        JMP WriteLastLineBufferToScreen
        RTS 

        ; Check if one of the presets has been selected.
CheckIfPresetKeysPressed   
        LDX #$00
presetKeyLoop   
        CMP presetKeyCodes,X
        BEQ UpdateDisplayedPreset
        INX 
        CPX #$10
        BNE presetKeyLoop

        JMP MaybeWPressed

UpdateDisplayedPreset   
        JMP DisplayPresetMessage

MaybeWPressed    
        CMP #$09 ; W pressed?
        BNE MaybeFunctionKeysPressed

        ; W pressed
        ; Line Width W to activate: Sets the width of the lines produced in
        ; Line Mode.
        LDA #LINE_WIDTH
        STA currentVariableMode
        RTS 

        ; Was one of the function keys pressed?
MaybeFunctionKeysPressed   
        LDX #$00
FnKeyLoop   
        CMP functionKeys,X
        BEQ FunctionKeyWasPressed ; One of them was pressed!
        INX 
        CPX #$04
        BNE FnKeyLoop
        ; Continue checking
        JMP MaybeQPressed

        ; A Function key was pressed, only valid if the sequencer is active.
FunctionKeyWasPressed   
        STX functionKeyIndex
        LDA sequencerActive
        BNE MaybeQPressed
        LDA #$80
        STA currentVariableMode
        JSR UpdateSequencer
        RTS 

MaybeQPressed    
        CMP #$3E ; Q pressed?
        BNE MaybeVPressed

        ; Q was presed. Toggle the sequencer on or off.
        LDA sequencerActive
        BNE TurnSequenceOff
        LDA #$80
        STA currentVariableMode
        JMP ActivateSequencer
        ;Returns

        ;Turn the sequencer off.
TurnSequenceOff   
        LDA #$00
        STA sequencerActive
        STA stepsRemainingInSequencerSequence
        JMP DisplaySequencerState

MaybeVPressed   
        CMP #$1F ; V pressed?
        BNE MaybeOPressed

        ; V pressed.
        ; Sequencer Speed V to activate: Controls the rate at which sequencer
        ; feeds in its data. See the SEQUENCER bit.
        LDA #SEQUENCER_SPEED
        STA currentVariableMode
        RTS 

MaybeOPressed   
        CMP #$26 ; O pressed.
        BNE MaybeAsteriskPressed

        ; O pressed.
        ; Pulse Width : Sets the length of the pulses in a pulsed
        ; stream output. Don’t worry about what that means - just get in there
        ; and mess with it.
        LDA #PULSE_WIDTH
        STA currentVariableMode
        RTS 

MaybeAsteriskPressed   
        CMP #$31 ; * pressed?
        BNE MaybeRPressed

        ; * pressed.
        ; BASE LEVEL : Controls how many ‘levels’ of pattern are
        ; plotted.
        LDA #BASE_LEVEL
        STA currentVariableMode
        RTS 

MaybeRPressed   
        CMP #$11 ; R pressed?
        BNE MaybeUpArrowPressed
        ; R was pressed. Stop or start recording.
        JMP StopOrStartRecording

MaybeUpArrowPressed   
        CMP #$36 ; Up arrow
        BNE MaybeAPressed
        ; Up arrow pressed. "Press UP-ARROW to change the shape of the little pixels on the screen."
        INC pixelShapeIndex
        LDA pixelShapeIndex
        AND #$0F
        TAY 
        LDA pixelShapeArray,Y

        ; Rewrite the screen using the new pixel.
        LDX #$00
UpdatePixelLoop   
        STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02C0,X
        DEX 
        BNE UpdatePixelLoop
        STA currentPixel
        RTS 

MaybeAPressed   
        CMP #$0A ; 'A' pressed
        BNE FinalReturnFromKeyboardCheck

        ; Activate demo mode.
        LDA demoModeActive
        EOR #$01
        STA demoModeActive
        RTS 

FinalReturnFromKeyboardCheck   
        RTS 


initialTimeBetweenKeyStrokes   .BYTE $10
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
dataFreeDigitOne
        .BYTE $FF
dataFreeDigitTwo
        .BYTE $FF
dataFreeDigitThree
        .BYTE $FF,$FF,$FF,$FF,$FF
customPatternValueBufferPtr
        .BYTE $FF,$FF,$FF
customPatternValueBufferMessage
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

.enc "petscii"  ;define an ascii->petscii encoding
        .cdef "  ", $A0  ;characters
        .cdef "--", $AD  ;characters
        .cdef ",,", $2c  ;characters
        .cdef "..", $ae  ;characters
        .cdef "AZ", $c1
        .cdef "az", $41
        .cdef "11", $31
.enc "none"

txtPresetPatternNames
.enc "petscii" 
        .TEXT 'STAR ONE        '
        .TEXT 'THE TWIST       '
        .TEXT 'LA LLAMITA      '
        .TEXT 'STAR TWO        '
        .TEXT 'DELTOIDS        '
        .TEXT 'DIFFUSED        '
        .TEXT 'MULTICROSS      '
        .TEXT 'PULSAR          '
txtSymmetrySettingDescriptions 
        .TEXT 'NO SYMMETRY     '
        .TEXT 'Y-AXIS SYMMETRY '
        .TEXT 'X-Y SYMMETRY    '
        .TEXT 'X-AXIS SYMMETRY '
        .TEXT 'QUAD SYMMETRY   '
.enc "none"

;-------------------------------------------------------
; ResetAndReenterMainPaint
;-------------------------------------------------------
ResetAndReenterMainPaint 
        LDA currentIndexToColorValues
        AND #$7F
        STA offsetForYPos
        LDA #$19
        SEC 
        SBC offsetForYPos
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
        LDA lineWidth
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
        DEC currentIndexForCurrentStepArray,X
        LDA currentIndexForCurrentStepArray,X
        CMP #$80
        BEQ b135B
        JMP MainPaintRoutine

b135B   LDA #$FF
        STA currentIndexForCurrentStepArray,X
        STX shouldDrawCursor
        JMP MainPaintRoutine

.enc "petscii" 
lineModeSettingDescriptions
        .TEXT 'LINE MODE',$BA,' OFF  '
        .TEXT 'LINE MODE',$BA,' ON   '
.enc "none"
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
        STA currentNodeInColorBar
        STA currentCountInDrawingColorBar
        STA offsetToColorBar
        LDA maxToDrawOnColorBar
        BEQ b13D8

b13AC   LDA offsetToColorBar
        CLC 
        ADC currentColorBarOffset
        STA offsetToColorBar
        LDX offsetToColorBar
        LDY currentNodeInColorBar
        LDA nodeTypeArray,X
        STA (colorBarColorRamLoPtr),Y
        CPX #$08
        BNE b13CD
        LDA #$00
        STA offsetToColorBar
        INC currentNodeInColorBar
b13CD   INC currentCountInDrawingColorBar
        LDA currentCountInDrawingColorBar
        CMP maxToDrawOnColorBar
        BNE b13AC
b13D8   RTS 

currentColorBarOffset         .BYTE $FF
currentNodeInColorBar         .BYTE $FF
maxToDrawOnColorBar           .BYTE $FF
currentCountInDrawingColorBar .BYTE $FF
offsetToColorBar              .BYTE $FF
; Different size of nodes for the color bar, graded from a full cell to an empty cell.
nodeTypeArray                 .BYTE $20,$65,$74,$75,$61,$F6,$EA,$E7
                              .BYTE $A0

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
        CMP #COLOR_CHANGE
        BEQ UpdateColorChange
        CMP #BUFFER_LENGTH
        BNE UpdateVariableDisplay

        ; The active mode is 'Color Change'.
UpdateColorChange   
        LDX #$00
b1417   LDA currentIndexForCurrentStepArray,X
        CMP #$FF
        BNE ResetSelectedVariableAndReturn

        INX 
        CPX bufferLength
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
        STA currentStepCount

UpdateVariableDisplay   
        LDA #>SCREEN_RAM + $03D0
        STA colorBarColorRamHiPtr
        LDA #<SCREEN_RAM + $03D0
        STA colorBarColorRamLoPtr

        LDX currentVariableMode
        LDA lastKeyPressed
        CMP #$2C ; > pressed?
        BNE MaybeLeftArrowPressed

        ; > pressed, increase the value bar.
        INC presetValueArray,X
        LDA presetValueArray,X
        ; Make sure we don't exceed the max value.
        CMP maxValueForPresetValueArray,X
        BNE MaybeInColorMode
        DEC presetValueArray,X
        JMP MaybeInColorMode

MaybeLeftArrowPressed   
        CMP #$2F ; < pressed?
        BNE MaybeInColorMode

        ; < pressed, decrease the value bar.
        DEC presetValueArray,X
        LDA presetValueArray,X
        ; Make sure we don't exceed the min value.
        CMP minValueForPresetValueArray,X
        BNE MaybeInColorMode
        INC presetValueArray,X

MaybeInColorMode   
        CPX #$05 ; Color Mode?
        BNE MaybeEnterPressed

        ; For Color Mode update some variables.
        LDX indexForPresetColorValues
        LDY currentColorSet
        LDA colorValuesPtr,X
        STA presetColorValuesArray,Y

MaybeEnterPressed   
        JSR DisplayVariableSelection
        JMP CheckIfEnterPressed
        ;Returns

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

b14A8   STY indexForPresetColorValues
        LDX currentVariableMode

b14AE   LDA increaseOffsetForPresetValueArray,X
        STA currentColorBarOffset
        LDA colorBarCurrentValueForModePtr,X
        STA maxToDrawOnColorBar
        TXA 
        PHA 
        LDA enterWasPressed
        BNE b14C9
        LDA #$01
        STA enterWasPressed
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
        STA dataFreeDigitTwo
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
        STA enterWasPressed
        RTS 


maxValueForPresetValueArray   
        .BYTE $00,$40,$08,$40,$10,$10,$08
        .BYTE $20,$10,$08
minValueForPresetValueArray   
        .BYTE $00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00
increaseOffsetForPresetValueArray   
        .BYTE $00,$01,$08
        .BYTE $01,$04,$08,$08,$02,$04,$08
currentVariableMode   
        .BYTE $00
currentDrawCursorInterval   
        .BYTE $01
txtVariableLabels   
.enc "petscii" 
        .TEXT '                '
        .TEXT 'SMOOTHING DELAY',$BA
        .TEXT 'CURSOR SPEED   ',$BA
        .TEXT 'BUFFER LENGTH  ',$BA
        .TEXT 'PULSE SPEED    ',$BA
        .TEXT 'COLOUR ',$B0,' SET   ',$BA
        .TEXT 'WIDTH OF LINE  ',$BA
        .TEXT 'SEQUENCER SPEED',$BA
        .TEXT 'PULSE WIDTH    ',$BA
        .TEXT 'BASE LEVEL     ',$BA
.enc "none" 
colorValuesPtr   
        .BYTE $00
colorBarValues   
        .BYTE $06,$02,$04,$05,$03,$07
        .BYTE $01,$08,$09,$0A,$0B,$0C,$0D,$0E
        .BYTE $0F
txtTrackingOnOff   
.enc "petscii" 
        .TEXT 'TRACKING',$BA,' OFF   '
        .TEXT 'TRACKING',$BA,' ON    '
.enc "none" 


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
b1623   INC dataFreeDigitThree
        LDA dataFreeDigitThree
        CMP #$BA
        BNE b1635
        LDA #$30
        STA dataFreeDigitThree
        INC dataFreeDigitTwo
b1635   DEX 
        BNE b1623

b1638   JMP RefreshPresetDataActivatedMessage

WriteLastLineBufferAndReturn    
        JSR WriteLastLineBufferToScreen
        RTS 

.enc "petscii" 
txtPreset
        .TEXT 'PRESET ',$B0,$B0,'      ',$BA
txtPresetActivatedStored
        .TEXT ' ACTIVATED       '
        .TEXT 'DATA STORED    '
.enc "none" 
shiftPressed
        .BYTE $00

;-------------------------------------------------------
; RefreshPresetDataActivatedMessage
;-------------------------------------------------------
RefreshPresetDataActivatedMessage    
        LDA shiftPressed
        AND #$01
        ASL 
        ASL 
        ASL 
        ASL 
        TAY 

        LDX #$00
b167C   LDA txtPresetActivatedStored,Y
        STA customPatternValueBufferMessage,X
        INY 
        INX 
        CPX #$10
        BNE b167C

        LDA shiftPressed
        AND #$01
        BNE b1692
        JMP RefreshPresetData

b1692   PLA 
        TAX 
        JSR GetPresetPointersUsingXRegister

        LDY #$00
        LDX #$00
b169B   LDA presetValueArray,X
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

;-------------------------------------------------------------------------
; RefreshPresetData
;-------------------------------------------------------------------------
RefreshPresetData    
        PLA 
        TAX 
        JSR GetPresetPointersUsingXRegister
        LDY #BUFFER_LENGTH
        LDA (presetSequenceDataLoPtr),Y
        CMP bufferLength
        BEQ b16C6

        JSR ResetCurrentActiveMode
        JMP LoadSelectedPresetSequence
        ; Returns

        ; Check the preset against current data
        ; and reload if different.
b16C6   LDX #$00
        LDY #SEQUENCER_SPEED
b16CA   LDA (presetSequenceDataLoPtr),Y
        CMP presetColorValuesArray,X
        BNE LoadSelectedPresetSequence
        INY 
        INX 
        CPX #$08
        BNE b16CA

        JMP LoadSelectedPresetSequence

;-------------------------------------------------------------------------
; LoadSelectedPresetSequence
;-------------------------------------------------------------------------
LoadSelectedPresetSequence    
        LDA #$FF
        STA currentModeActive

        ; Copy the value from the preset sequence into 
        ; current storage.
        LDY #COLOR_BAR_CURRENT
b16E1   LDA (presetSequenceDataLoPtr),Y
        STA presetValueArray,Y
        INY 
        CPY #$15
        BNE b16E1

        LDA (presetSequenceDataLoPtr),Y
        STA currentPatternElement
        INY 
        LDA (presetSequenceDataLoPtr),Y
        STA currentSymmetrySetting
        JMP WriteLastLineBufferAndReturn
        ; Returns

;-------------------------------------------------------
; GetPresetPointersUsingXRegister
;-------------------------------------------------------
GetPresetPointersUsingXRegister   
        LDA #>presetSequenceData
        STA presetSequenceDataHiPtr
        LDA #<presetSequenceData
        STA presetSequenceDataLoPtr
        TXA 
        BEQ b1712

        ; Skip through the preset data until we get to the position
        ; storing the preset data for the sequence indicated by the X
        ; register.
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
        STA currentStepCount
        RTS 

currentModeActive  .BYTE $00
;-------------------------------------------------------
; ReinitializeScreen
;-------------------------------------------------------
ReinitializeScreen
        LDA #$00
        STA stepCount
        STA shouldDrawCursor

        LDX #$00
        LDA #$FF
b172a   STA currentIndexForCurrentStepArray,X
        INX
        CPX #$40
        BNE b172A

        LDA #$00
        STA currentModeActive
        JMP InitializeScreenWithInitCharacter
        ; Returns

enterWasPressed   .BYTE $00
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
        STA sequenceCounterOfSomeSort

        ; Store the current symmetry setting at one of $C200,
        ; $C220, $C240, $C260 depending on the Function key
        ; selected.
        LDY #$00
        LDA currentSymmetrySetting
        STA (currentSequencePtrLo),Y
        LDA smoothingDelay
        INY 
        STA (currentSequencePtrLo),Y
        RTS 

b177B   LDA #$FF
        STA sequencerActive
        JMP InitializeSequencer

functionKeyToSequenceArray   .BYTE $00,$20,$40,$60

.enc "petscii" 
txtDataFree
        .TEXT 'DATA',$BA,' ',$B0,$B0,$B0,' FREE  '
.enc "none" 
functionKeys
        .BYTE $04,$05
        .BYTE $06,$03

sequenceCounterOfSomeSort   .BYTE $FF,$60

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
        STA dataFreeDigitOne
        STA dataFreeDigitTwo
        STA dataFreeDigitThree
        LDX sequenceCounterOfSomeSort
        BNE b17C8
        JMP ReturnPressed
        ; Returns

b17C8   INC dataFreeDigitThree
        LDA dataFreeDigitThree
        CMP #$3A
        BNE b17E9
        LDA #$30
        STA dataFreeDigitThree
        INC dataFreeDigitTwo
        LDA dataFreeDigitTwo
        CMP #$3A
        BNE b17E9
        LDA #$30
        STA dataFreeDigitTwo
        INC dataFreeDigitOne
b17E9   DEX 
        BNE b17C8

        JSR UpdateDataFreeDisplay
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
        JSR UpdateDataFreeDisplay
        LDA sequenceCounterOfSomeSort
        STA currentSequenceCounterMaybe
        LDA currentSequencePtrLo
        STA prevSequencePtrLo
        LDA currentSequencePtrHi
        STA prevSequencePtrHi
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
        DEC sequenceCounterOfSomeSort
        RTS 

;-------------------------------------------------------
; ReturnPressed
;-------------------------------------------------------
ReturnPressed    
        JSR UpdateDataFreeDisplay
        LDA #$FF
        LDY #$02
        STA (currentSequencePtrLo),Y
        LDA #$00
        STA currentVariableMode
        STA a1884
        STA currentSequenceCounterMaybe
        STA sequencerActive
        RTS 

a1884   .BYTE $00
;-------------------------------------------------------
; UpdateDataFreeDisplay
;-------------------------------------------------------
UpdateDataFreeDisplay
        LDA dataFreeDigitOne
        STA SCREEN_RAM + $03C6
        LDA dataFreeDigitTwo
        STA SCREEN_RAM + $03C7
        LDA dataFreeDigitThree
        STA SCREEN_RAM + $03C8
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
        INC currentStepCount
        LDA currentStepCount
        CMP bufferLength
        BNE b18BB

        LDA #$00
        STA currentStepCount
b18BB   LDX currentStepCount
        LDA currentIndexForCurrentStepArray,X
        CMP #$FF
        BEQ b18D7
        LDA shouldDrawCursor
        AND trackingActivated
        BEQ b1901
        STA currentStepCount
        TAX 
        LDA currentIndexForCurrentStepArray,X
        CMP #$FF
        BNE b1901
b18D7   LDA baseLevel
        STA currentIndexForCurrentStepArray,X
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
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        LDA a1920
        STA symmetrySettingForStepCount,X
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
        LDA sequencerSpeed
        STA stepsRemainingInSequencerSequence
        LDA #$00
        STA currentVariableMode
        JSR DisplaySequencerState
        RTS 

b1945   LDA currentSequenceCounterMaybe
        BEQ b195D
        LDA currentSequenceCounterMaybe
        STA sequenceCounterOfSomeSort
        LDA prevSequencePtrLo
        STA currentSequencePtrLo
        LDA prevSequencePtrHi
        STA currentSequencePtrHi
        JMP DisplaySequFree
        ;Returns

b195D   LDA #$FF
        STA sequenceCounterOfSomeSort
        LDA currentSymmetrySetting
        LDY #$00
        STA (currentSequencePtrLo),Y
        LDA smoothingDelay
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
        INC currentStepCount
        LDA currentStepCount
        CMP bufferLength
        BNE b1992

        LDA #$00
        STA currentStepCount
b1992   TAX 
        LDA currentIndexForCurrentStepArray,X
        CMP #$FF
        BEQ b19A9
        LDA shouldDrawCursor
        AND trackingActivated
        BEQ b19D9
        TAX 
        LDA currentIndexForCurrentStepArray,X
        CMP #$FF
        BNE b19D9
b19A9   LDY #$02
        LDA (currentSequencePtrLo),Y
        CMP #$C0
        BEQ b19D9
        LDA baseLevel
        STA currentIndexForCurrentStepArray,X
        LDA presetSequenceData + $0301
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        LDA presetSequenceData + $0300
        STA symmetrySettingForStepCount,X
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

b19EF   LDA #<presetSequenceData + $0300
        STA currentSequencePtrLo
        LDA #>presetSequenceData + $0300
        STA currentSequencePtrHi
        RTS 

stepsRemainingInSequencerSequence   .BYTE $00
.enc "petscii" 
txtSequFree
        .TEXT 'SEQU',$BA,' ',$B0,$B0,$B0,' FREE  '
.enc "none" 

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

.enc "petscii" 
txtSequencer
      .TEXT 'SEQUENCER OFF   '
      .TEXT 'SEQUENCER ON    '
.enc "none" 
currentSequenceCounterMaybe
      .BYTE $00
prevSequencePtrLo
      .BYTE $00
prevSequencePtrHi
      .BYTE $00
patternUpdateDisplayInterval
      .BYTE $00

recordingStorageLoPtr = $1F
recordingStorageHiPtr = $20
;-------------------------------------------------------
; StopOrStartRecording
;-------------------------------------------------------
StopOrStartRecording    
        LDA #>dynamicStorage
        STA recordingStorageHiPtr

        LDA #<dynamicStorage
        STA recordingStorageLoPtr

        LDA #$01
        STA recordingOffset

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

dynamicStorageLoPtr                       = $FB
dynamicStorageHiPtr                       = $FC
;-------------------------------------------------------
; InitializeDynamicStorage
;-------------------------------------------------------
InitializeDynamicStorage   
        LDA #<dynamicStorage
        STA dynamicStorageLoPtr
        LDA #>dynamicStorage
        STA dynamicStorageHiPtr
        LDY #$00
        TYA 

        LDX #$50
b1AA4   STA (dynamicStorageLoPtr),Y
        DEY 
        BNE b1AA4
        INC dynamicStorageHiPtr
        DEX 
b1AAC   BNE b1AA4

        LDA #$FF
        STA dynamicStorage
        LDA #$01
        STA dynamicStorage + $01
        LDA pixelXPosition
        STA previousPixelXPosition
        LDA colorRAMLineTableIndex
        STA previousColorRAMLineTableIndex
        RTS 

b1AC5   LDA #$00
        STA currentColorToPaint
        JSR UpdateLineinColorRAMUsingIndex
        LDA previousPixelXPosition
        STA pixelXPosition
        LDA previousColorRAMLineTableIndex
        STA colorRAMLineTableIndex
        LDA #$FF
        STA a1BEB
        RTS 

.enc "petscii" 
txtPlayBackRecord
        .TEXT 'PLAYING BACK',$AE,$AE,$AE,$AE,'RECORDING',$AE,$AE,$AE,$AE,$AE,$AE,$AE
.enc "none" 

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

.enc "petscii" 
txtStopped
        .TEXT 'STOPPED         '
.enc "none" 
playbackOrRecordActive
        .BYTE $00

;-------------------------------------------------------
; RecordJoystickMovements
;-------------------------------------------------------
RecordJoystickMovements    
        LDA $DC00    ;CIA1: Data Port Register A
        STA lastJoystickInput
        LDY #$00
        CMP (recordingStorageLoPtr),Y
        BEQ b1B70
b1B37   LDA recordingStorageLoPtr
        CLC 
        ADC #$02
        STA recordingStorageLoPtr
        LDA recordingStorageHiPtr
        ADC #$00
        STA recordingStorageHiPtr
        CMP #$80
        BNE b1B50
        LDA #$00
        STA a7FFF
        JMP DisplayStoppedRecording

b1B50   LDY #$01
        TYA 
        STA (recordingStorageLoPtr),Y
        LDA $DC00    ;CIA1: Data Port Register A
        DEY 
        STA (recordingStorageLoPtr),Y
        LDA recordingStorageHiPtr
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
        LDA (recordingStorageLoPtr),Y
        CLC 
        ADC #$01
        STA (recordingStorageLoPtr),Y
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
        DEC recordingOffset
        BEQ b1BA6

        LDY #$00
        LDA (recordingStorageLoPtr),Y
        STA lastJoystickInput
        RTS 

b1BA6   LDA recordingStorageLoPtr
        CLC 
        ADC #$02
        STA recordingStorageLoPtr
        LDA recordingStorageHiPtr
        ADC #$00
        STA recordingStorageHiPtr
        CMP #$80
        BEQ b1BC6
        LDY #$01
        LDA (recordingStorageLoPtr),Y
        BEQ b1BC6

        STA recordingOffset
        DEY 
        LDA (recordingStorageLoPtr),Y
        STA lastJoystickInput
        RTS 

b1BC6   LDA #>dynamicStorage
        STA recordingStorageHiPtr
        LDA #<dynamicStorage
        STA recordingStorageLoPtr
        LDA #$01
        STA recordingOffset
        LDA #$00
        STA currentColorToPaint
        JSR UpdateLineinColorRAMUsingIndex
        LDA previousPixelXPosition
        STA pixelXPosition
        LDA previousColorRAMLineTableIndex
        STA colorRAMLineTableIndex
        RTS 

recordingOffset
        .BYTE $00
previousPixelXPosition
        .BYTE $0C
previousColorRAMLineTableIndex
        .BYTE $0C
a1BEA
        .BYTE $00
a1BEB
        .BYTE $00
.enc "petscii" 
txtDefineAllLevelPixels
        .TEXT 'DEFINE ALL LEVEL ',$B2,' PIXELS'
.enc "none" 

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
        LDA #$13
        STA pixelXPosition
        LDA #$0C
        STA colorRAMLineTableIndex
        JSR ReinitializeScreen
b1C68   LDA a1BEA
        STA patternIndex
        LDA a25
        STA currentIndexToColorValues
        LDA #$00
        STA currentSymmetrySettingForStep
        LDA #$13
        STA pixelXPositionZP
        LDA #$0C
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
        STA SCREEN_RAM + $03D1
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

.enc "petscii" 
txtCustomPatterns
        .TEXT 'USER SHAPE '
.enc "none" 
        .BYTE $A3,$B0
pixelShapeIndex
        .BYTE $00
pixelShapeArray
        .BYTE $CF,$51,$53,$5A,$5B,$5F,$57,$7F
        .BYTE $56,$61,$4F,$66,$6C,$EC,$A0,$2A
        .BYTE $47,$4F,$41,$54,$53,$53,$48,$45
        .BYTE $45,$50

presetTempLoPtr                       = $FB
presetTempHiPtr                       = $FC
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
        STA CURRENT_CHAR_COLOR
        LDA #>presetSequenceData
        STA presetHiPtr
        LDA #<presetSequenceData
        STA presetLoPtr
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
        STA CURRENT_CHAR_COLOR
        LDA #$30
        STA presetHiPtr
        STA presetTempHiPtr
        LDA #$00
        STA presetLoPtr
        STA presetTempLoPtr
        LDY #$00
b1DCD   LDA (presetTempLoPtr),Y
        BEQ b1DDA
        INC presetTempLoPtr
        BNE b1DCD
        INC presetTempHiPtr
        JMP b1DCD

b1DDA   LDX presetTempLoPtr
        LDY presetTempHiPtr
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
        STA CURRENT_CHAR_COLOR
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

.enc "petscii" 
txtContinueLoadOrAbort
        .TEXT $A8,'C',$A9,'ONTINUE LO'
        .TEXT 'AD',$AC,' OR ',$A8,'A',$A9,'BORT',$BF,' '
        .TEXT '           '
.enc "none" 
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


copyFromLoPtr = $FB
copyFromHiPtr = $FC
copyToLoPtr   = $FD
copyToHiPtr   = $FE
;-------------------------------------------------------
; MovePresetDataIntoPosition
;-------------------------------------------------------
MovePresetDataIntoPosition   
        LDY #$00
        TYA 
        STA copyFromLoPtr
        STA copyToLoPtr
        LDA #>presetSequenceDataSource
        STA copyFromHiPtr
        LDA #>presetSequenceData
        STA copyToHiPtr

        LDX #$10
b1FC8   LDA (copyFromLoPtr),Y
        STA (copyToLoPtr),Y
        DEY 
        BNE b1FC8

        INC copyFromHiPtr
        INC copyToHiPtr
        DEX 
        BNE b1FC8

        LDX #$09
b1FD8   LDA f1FE1,X
        STA a7FFF,X
        DEX 
        BNE b1FD8
        RTS 

f1FE1=*-$01   
        .BYTE $30,$0C,$30,$0C,$C3,$C2,$CD,$38
        .BYTE $30,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00

;-------------------------------------------------------
; This is the main data driving the sequences in
; Psychedelia. It's copied from this position to $C000
; (presetSequenceData)  when the game is loaded.
;
; The data for the 16 presets. Each chunk contains the following values:
;  colorBarCurrentValueForModePtr  
;  smoothingDelay                       
;  cursorSpeed            
;  bufferLength                    
;  displayCursorInitialValue       
;  indexForPresetColorValues       
;  pulseWidth 
;  baseLevel      
;  presetColorValuesArray          
;  trackingActivated               
;  lineModeActivated               
;  patternIndex                    
;  currentPatternElement
;  currentSymmetrySetting
;--------------------------------------------------------------------------
presetSequenceDataSource
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
; customPreset0
        .BYTE $01,$0C,$07,$06,$07,$11,$0D,$07
        .BYTE $06,$11,$07,$FF,$0B,$07,$FF,$00
        .BYTE $FF,$21,$06,$00,$06,$01,$06,$41
        .BYTE $FF,$00,$06,$01,$06,$01,$06,$00
; customPreset0
        .BYTE $01,$0C,$13,$08,$00,$07,$0F,$00
        .BYTE $FF,$00,$06,$01,$2A,$41,$02,$00
        .BYTE $04,$62,$FF,$41,$06,$40,$00,$6B
        .BYTE $04,$41,$FF,$00,$FF,$00,$FF,$00
; customPreset0
        .BYTE $04,$01,$08,$01,$02,$FF,$01,$02
        .BYTE $08,$01,$02,$08,$01,$02,$08,$01
        .BYTE $02,$08,$01,$02,$08,$01,$02,$FF
        .BYTE $03,$02,$08,$03,$02,$08,$03,$02
; customPreset0
        .BYTE $00,$11,$12,$09,$08,$12,$09,$08
        .BYTE $FF,$08,$03,$02,$08,$03,$02,$08
        .BYTE $03,$02,$FF,$00,$00,$00,$00,$01
        .BYTE $24,$00,$05,$01,$00,$00,$00,$00
; customPreset0
        .BYTE $00,$BD,$00,$B9,$00,$BD,$00,$BD
        .BYTE $81,$BD,$81,$FF,$00,$BD,$F1,$FF
        .BYTE $00,$28,$81,$FF,$81,$AE,$83,$AE
        .BYTE $00,$FF,$81,$EE,$81,$AC,$C1,$BD
; customPreset0
        .BYTE $C1,$24,$81,$FF,$C1,$FF,$00,$EE
        .BYTE $81,$BF,$85,$AE,$81,$EC,$E1,$BF
        .BYTE $83,$37,$00,$EE,$81,$BF,$C3,$2E
        .BYTE $81,$2E,$00,$FF,$00,$FF,$00,$FD
; customPreset0
        .BYTE $05,$DC,$02,$EE,$81,$EC,$C7,$0C
        .BYTE $00,$68,$81,$EC,$03,$EE,$81,$EE
        .BYTE $85,$62,$81,$EE,$01,$EC,$87,$EA
        .BYTE $85,$FD,$83,$CD,$42,$EF,$00,$FF
; customPreset0
        .BYTE $00,$28,$02,$EA,$81,$BD,$85,$BF
        .BYTE $81,$FF,$85,$EE,$00,$BF,$87,$BF
        .BYTE $00,$EE,$87,$FF,$81,$FF,$A7,$FE
        .BYTE $01,$FF,$80,$EE,$FD,$FF,$FF,$FF
        .BYTE $01,$0B,$04,$04,$07,$08,$09,$07
; customPreset0
        .BYTE $0C,$0C,$07,$10,$11,$07,$14,$13
        .BYTE $07,$17,$13,$07,$FF,$01,$06,$41
        .BYTE $FF,$00,$06,$01,$06,$01,$06,$00
        .BYTE $00,$FF,$06,$00,$02,$00,$FF,$41
; customPreset0
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
