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

pixelXPosition                   = $02
pixelYPosition                   = $03
baseLevelForCurrentPixel         = $04
currentLineInColorRamLoPtr2      = $05
currentLineInColorRamHiPtr2      = $06
previousCursorXPositionZP        = $08
previousPixelYPositionZP         = $09
currentLineInColorRamLoPtr       = $0A
currentLineInColorRamHiPtr       = $0B
currentColorToPaint              = $0C
xPosLoPtr                        = $0D
xPosHiPtr                        = $0E
currentPatternElement            = $0F
yPosLoPtr                        = $10
yPosHiPtr                        = $11
timerBetweenKeyStrokes           = $12
previousIndexToPixelBuffers                 = $13
currentSymmetrySettingForStep    = $14
currentSymmetrySetting           = $15
offsetForYPos                    = $16
skipPixel                        = $17
colorBarColorRamLoPtr            = $18
colorBarColorRamHiPtr            = $19
currentColorSet                  = $1A
presetSequenceDataLoPtr          = $1B
presetSequenceDataHiPtr          = $1C
currentSequencePtrLo             = $1D
currentSequencePtrHi             = $1E
lastJoystickInput                = $21
customPatternLoPtr               = $22
customPatternHiPtr               = $23
minIndexToColorValues            = $24
initialBaseLevelForCustomPresets = $25
currentIndexToPresetValue        = $26
lastKeyPressed                   = $C5
presetLoPtr                      = $FE
presetHiPtr                      = $FF
shiftKey                         = $028D
storageOfSomeKind                = $7FFF
presetSequenceData               = $C000
colorRamLoPtr                    = $FB
colorRamHiPtr                    = $FC


.include "constants.asm"

* = $0801
;-----------------------------------------------------------------------------------
; Start program at InitializeProgram (SYS 2064)
; SYS 2064 ($0810)
; $9E = SYS
; $32,$30,$36,$34 = 2064
;-----------------------------------------------------------------------------------
        .BYTE $0B,$08,$C1,$07,$9E,$32,$30,$36,$34

        .BYTE $00,$00,$00,$F9,$02,$F9

;-------------------------------------------------------
; InitializeProgram
;-------------------------------------------------------
InitializeProgram
        ; Set border and background to black
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0

        JSR MovePresetDataIntoPosition

        STA previousIndexToPixelBuffers

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
InitScreenLoop   
        LDA #$CF
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
        BNE InitScreenLoop
        RTS 

presetKeyCodes
        .BYTE KEY_LEFT,KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7
        .BYTE KEY_8,KEY_9,KEY_0,KEY_PLUS,KEY_MINUS,KEY_POUND
        .BYTE KEY_CLR_HOME,KEY_INST_DEL


;-------------------------------------------------------
; LoadXAndYPosition
;-------------------------------------------------------
LoadXAndYPosition   
        LDX pixelYPosition
        LDA colorRAMLineTableLoPtrArray,X
        STA currentLineInColorRamLoPtr2
        LDA colorRAMLineTableHiPtrArray,X
        STA currentLineInColorRamHiPtr2
        LDY pixelXPosition
ReturnEarlyFromRoutine   
        RTS 

tempIndex = $FD
;-------------------------------------------------------
; PaintPixel
;-------------------------------------------------------
PaintPixel   
        ; Return early if the index or offset are invalid
        LDA pixelXPosition
        AND #$80
        BNE ReturnEarlyFromRoutine
        LDA pixelXPosition
        CMP #$28
        BPL ReturnEarlyFromRoutine
        LDA pixelYPosition
        AND #$80
        BNE ReturnEarlyFromRoutine
        LDA pixelYPosition
        CMP #$18
        BPL ReturnEarlyFromRoutine

        JSR LoadXAndYPosition
        LDA skipPixel
        BNE ActuallyPaintPixel

        LDA (currentLineInColorRamLoPtr2),Y
        AND #$0F

        LDX #$00
GetIndexInPresetsLoop   
        CMP presetColorValuesArray,X
        BEQ FoundMatchingIndex
        INX 
        CPX #$08
        BNE GetIndexInPresetsLoop

FoundMatchingIndex   
        TXA 
        STA tempIndex
        LDX baseLevelForCurrentPixel
        INX 
        CPX tempIndex
        BEQ ActuallyPaintPixel
        BPL ActuallyPaintPixel
        RTS 

        ; Actually paint the pixel to color ram.
ActuallyPaintPixel   
        LDX baseLevelForCurrentPixel
        LDA presetColorValuesArray,X
        STA (currentLineInColorRamLoPtr2),Y
        RTS 

;-------------------------------------------------------
; LoopThroughPixelsAndPaint
;-------------------------------------------------------
LoopThroughPixelsAndPaint   
        JSR PaintPixelForCurrentSymmetry
        LDY #$00
        LDA baseLevelForCurrentPixel
        CMP #$07
        BNE CanLoopAndPaint
        RTS 

CanLoopAndPaint   
        LDA #$07
        STA countToMatchCurrentIndex

        LDA pixelXPosition
        STA previousCursorXPositionZP
        LDA pixelYPosition
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
PixelPaintLoop   
        LDA previousCursorXPositionZP
        CLC 
        ADC (xPosLoPtr),Y
        STA pixelXPosition
        LDA previousPixelYPositionZP
        CLC 
        ADC (yPosLoPtr),Y
        STA pixelYPosition

        ; Push Y to the stack.
        TYA 
        PHA 

        JSR PaintPixelForCurrentSymmetry

        ; Pull Y back from the stack and increment
        PLA 
        TAY 
        INY 

        LDA (xPosLoPtr),Y
        CMP #$55
        BNE PixelPaintLoop

        DEC countToMatchCurrentIndex
        LDA countToMatchCurrentIndex
        CMP baseLevelForCurrentPixel
        BEQ RestorePositionsAndReturn
        CMP #$01
        BEQ RestorePositionsAndReturn
        INY 
        JMP PixelPaintLoop

RestorePositionsAndReturn   
        LDA previousCursorXPositionZP
        STA pixelXPosition
        LDA previousPixelYPositionZP
        STA pixelYPosition
        RTS 

; The pattern data structure consists of up to 7 rows, each
; one defining a stage in the creation of the pattern. Each
; row is assigned a unique color. The X and Y positions given
; in each array refer to the position relative to the cursor
; at the centre. 'Minus' values relative to the cursor are
; given by values such as FF (-1), FE (-2), and so on.
;
; In this illustration the number used represents which row
; the 'pixel' comes from. So for example the first row
; in starOneXPosArray and starOneYPosArray 
; draws the square of 0s at the centre of the star.
;

starOneXPosArray  .BYTE $00,$01,$01,$01,$00,$FF,$FF,$FF,$55       ;        5       
                  .BYTE $00,$02,$00,$FE,$55                       ;                
                  .BYTE $00,$03,$00,$FD,$55                       ;       4 4      
                  .BYTE $00,$04,$00,$FC,$55                       ;        3       
                  .BYTE $FF,$01,$05,$05,$01,$FF,$FB,$FB,$55       ;        2       
                  .BYTE $00,$07,$00,$F9,$55                       ;        1       
                  .BYTE $55                                       ;   4   000   4  
starOneYPosArray  .BYTE $FF,$FF,$00,$01,$01,$01,$00,$FF,$55       ; 5  3210 0123  5
                  .BYTE $FE,$00,$02,$00,$55                       ;   4   000   4  
                  .BYTE $FD,$00,$03,$00,$55                       ;        1       
                  .BYTE $FC,$00,$04,$00,$55                       ;        2       
                  .BYTE $FB,$FB,$FF,$01,$05,$05,$01,$FF,$55       ;        3       
                  .BYTE $F9,$00,$07,$00,$55                       ;       4 4      
                  .BYTE $55                                       ;                
                                                                  ;        5       

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
; PaintPixelForCurrentSymmetry
;-------------------------------------------------------
PaintPixelForCurrentSymmetry   
        ; First paint the normal pattern without any
        ; symmetry.
        LDA pixelXPosition
        PHA 
        LDA pixelYPosition
        PHA 
        JSR PaintPixel

        LDA currentSymmetrySettingForStep
        BNE HasSymmetry

CleanUpAndReturnFromSymmetry   
        PLA 
        STA pixelYPosition
        PLA 
        STA pixelXPosition
        RTS 

        RTS

HasSymmetry   
        CMP #X_AXIS_SYMMETRY
        BEQ XAxisSymmetry

        ; Has a pattern to paint on the Y axis
        ; symmetry so prepare for that.
        LDA #$27
        SEC 
        SBC pixelXPosition
        STA pixelXPosition

        ; If it has X_Y_SYMMETRY then we just 
        ; need to paint that, and we're done.
        LDY currentSymmetrySettingForStep
        CPY #X_Y_SYMMETRY
        BEQ XYSymmetry

        ; If we're here it's either Y_AXIS_SYMMETRY
        ; or QUAD_SYMMETRY so we can paint a pattern
        ; on the Y axis.
        JSR PaintPixel

        ; If it's Y_AXIS_SYMMETRY we're done and can 
        ; return.
        LDA currentSymmetrySettingForStep
        CMP #Y_AXIS_SYMMETRY
        BEQ CleanUpAndReturnFromSymmetry

        ; Has QUAD_SYMMETRY so the remaining steps are
        ; to paint two more: one on our X axis and one
        ; on our Y axis.

        ; First we do the Y axis.
        LDA #$17
        SEC 
        SBC pixelYPosition
        STA pixelYPosition
        JSR PaintPixel

        ; Paint one on the X axis.
PaintXAxisPixelForSymmetry    
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

XAxisSymmetry   
        LDA #$17
        SEC 
        SBC pixelYPosition
        STA pixelYPosition
        JMP PaintXAxisPixelForSymmetry

XYSymmetry   
        LDA #$17
        SEC 
        SBC pixelYPosition
        STA pixelYPosition
        JSR PaintPixel
        PLA 
        STA pixelYPosition
        PLA 
        STA pixelXPosition
        RTS 

; The pixel buffers that contain the next 64
; pixels to be painted. These are filled by
; MainInterruptHandler, which adds a new byte
; to each buffer every 3/4 seconds.
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
currentColorIndexArray
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
patternIndexArray
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
_Loop   STA pixelXPositionArray,X
        STA pixelYPositionArray,X
        LDA #$FF
        STA currentColorIndexArray,X
        LDA #$00
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        STA patternIndexArray,X
        STA symmetrySettingForStepCount,X
        INX 
        CPX #$40
        BNE _Loop

        STA timerBetweenKeyStrokes
        STA currentPatternElement
        STA previousIndexToPixelBuffers
        STA skipPixel
        LDA #$01
        STA currentSymmetrySetting
        RTS 

;-------------------------------------------------------
; LaunchPsychedelia
;-------------------------------------------------------
LaunchPsychedelia    
        JSR SetUpInterruptHandlers

        ; Clear down the interrupt handler code for some reason.
        LDX #$10
_Loop   TXA 
        STA SetUpInterruptHandlers,X
        DEX 
        BNE _Loop

        JSR ReinitializeScreen
        JSR ReinitializeSequences
        JSR ClearLastLineOfScreen

;-------------------------------------------------------
; MainPaintLoop
;-------------------------------------------------------
MainPaintLoop    
        INC currentIndexToPixelBuffers

        LDA lastKeyPressed
        CMP #$02 ; Left/Right cursor key
        BNE HandleAnyCurrentModes

        ; Left/Right cursor key pauses the paint animation.
        ; This section just loops around if the left/right keys
        ; are pressed and keeps looping until they're pressed again.
_Loop   LDA lastKeyPressed
        CMP #$40 ;  No key pressed
        BNE _Loop

_Loop2  LDA lastKeyPressed
        CMP #$02 ; Left/Right cursor key
        BNE _Loop2

        ; Keep looping until key pressed again.
_Loop3  LDA lastKeyPressed
        CMP #$40 ;No key pressed
        BNE _Loop3

        ; Check if we can just do a normal paint or if
        ; we have to handle a customer preset mode or
        ; save/prompt mode. 
HandleAnyCurrentModes   
        LDA currentModeActive
        BEQ DoANormalPaint

        ; Handle if we're in a specific mode.
        CMP #$17 ; Custom Preset active?
        BNE MaybeInSavePromptMode

        ; Custom Preset active.
        JMP HandleCustomPreset

MaybeInSavePromptMode   
        CMP #$18 ; Current Mode is 'Save/Prompt'
        BNE InitializeScreenAndPaint
        JMP DisplaySavePromptScreen

        ; The main paint work.
InitializeScreenAndPaint   
        JSR ReinitializeScreen

        ; currentIndexToPixelBuffers is our index into the 
        ; pixel buffers. It gets incremented every
        ; pass through MainPaintLoop until it reaches
        ; the value set by bufferLength. So it determines
        ; how much of each pixel buffer we paint.
DoANormalPaint   
        LDA currentIndexToPixelBuffers
        CMP bufferLength
        BNE CheckCurrentBuffer

        ; Reset the index back to the start of the pixel buffers.
        LDA #$00
        STA currentIndexToPixelBuffers
CheckCurrentBuffer   
        LDX currentIndexToPixelBuffers
        LDA currentColorIndexArray,X
        CMP #$FF
        BNE ShouldDoAPaint

        ; 
        STX previousIndexToPixelBuffers
        JMP MainPaintLoop

ShouldDoAPaint   
        STA baseLevelForCurrentPixel
        ; X is currentIndexToPixelBuffers
        DEC framesRemainingToNextPaintForStep,X
        BNE GoBackToStartOfLoop

        ; Actually paint some pixels to the screen.

        ; Reset the delay for this step.
        ; X is currentIndexToPixelBuffers
        LDA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X

        ; Get the x and y positions for this pixel.
        ; X is currentIndexToPixelBuffers
        LDA pixelXPositionArray,X
        STA pixelXPosition
        LDA pixelYPositionArray,X
        STA pixelYPosition

        LDA patternIndexArray,X
        STA patternIndex

        LDA symmetrySettingForStepCount,X
        STA currentSymmetrySettingForStep

        ; Line Mode sets the top bit of baseLevelForCurrentPixel
        LDA baseLevelForCurrentPixel
        AND #$80
        BNE PaintLineModeAndLoop

        TXA 
        PHA 
        JSR LoopThroughPixelsAndPaint
        PLA 
        TAX 

        DEC currentColorIndexArray,X
GoBackToStartOfLoop   
        JMP MainPaintLoop

currentIndexToPixelBuffers   .BYTE $00

PaintLineModeAndLoop
        ; Loops back to MainPaintLoop
        JMP PaintLineMode

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
        STA cursorXPosition
        STA cursorYPosition

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
; By default this runs every 1/60th of a second. 
; Its main job is to fill the pixel buffers (e.g.
; pixelXPositionArray, pixelYPositionArray and so on)
; so that the MainPaintLoop can use them to paint the
; screen. The counter countStepsBeforeCheckingJoystickInput
; ensures that we only update the pixel buffers every 256th
; time the interrupt is called. stepsRemainingInSequencerSequence
; does the same for the sequencer. 
;-------------------------------------------------------
MainInterruptHandler
        ; The sequencer is played by the interrupt handler.
        ; Check if it's active.
        LDA stepsRemainingInSequencerSequence
        BEQ SequencerNotActiveCheckJoystickInput
        DEC stepsRemainingInSequencerSequence
        BNE SequencerNotActiveCheckJoystickInput

        ; If the sequencer is active we'll end up here and
        ; load a byte from the sequencer data to the pixel
        ; buffers.
        LDA sequencerSpeed
        STA stepsRemainingInSequencerSequence

CalledFromNMI
        JSR LoadDataForSequencer

SequencerNotActiveCheckJoystickInput   
        ; Our counter reaches zero every 256 interrupts,
        ; otherwise we just return early.
        DEC countStepsBeforeCheckingJoystickInput
        BEQ CanUpdatePixelBuffers

        ; No need to do anything so return early.
        JMP CheckKeyboardAndReturnFromInterrupt

        ; Once in every 256 interrupts, check the joystick
        ; for input and act on it.
CanUpdatePixelBuffers   
        LDA #$00
        STA currentColorToPaint
        LDA cursorSpeed
        STA countStepsBeforeCheckingJoystickInput
        JSR PaintCursorAtCurrentPosition

        JSR GetJoystickInput
        LDA lastJoystickInput
        AND #$03
        CMP #$03
        BEQ CheckIfCursorMovedLeftOrRight ; Neither up nor down have been pushed.

        CMP #$02
        BEQ PlayerHasPressedDown ; Player has pressed down.
        
        ; Player has pressed up. Incremeent up two lines
        ; so that when we decrement down one, we're still
        ; one up!
        INC cursorYPosition
        INC cursorYPosition

        ; Player has pressed down.
PlayerHasPressedDown   
        DEC cursorYPosition
        LDA cursorYPosition
        CMP #$FF
        BNE CheckIfCursorAtBottom

        ; Cursor has reached the top of the screen, so loop
        ; around to bottom.
        LDA #$17
        STA cursorYPosition
        JMP CheckIfCursorMovedLeftOrRight

CheckIfCursorAtBottom   
        CMP #$18
        BNE CheckIfCursorMovedLeftOrRight
        ; Cursor has reached the bottom of the screen, so loop
        ; around to top
        LDA #$00
        STA cursorYPosition

        ; Player has pressed left or right?
CheckIfCursorMovedLeftOrRight   
        LDA lastJoystickInput
        AND #$0C
        CMP #$0C
        BEQ CheckIfPlayerPressedFire ; Player has pressed neither left nor right.

        CMP #$08
        BEQ CursorMovedLeft ; Player has pressed left.

        ; Player has pressed right.
        INC cursorXPosition
        INC cursorXPosition

        ; Player has pressed left.
CursorMovedLeft   
        DEC cursorXPosition
        ; Handle any wrap around from left to right.
        LDA cursorXPosition
        CMP #$FF
        BNE CheckIfCursorAtExtremeRight

        ; Cursor has wrapped around, move it to the extreme
        ; right of the screen.
        LDA #$27
        STA cursorXPosition
        JMP CheckIfPlayerPressedFire

        ; Handle any wrap around from right to left.
CheckIfCursorAtExtremeRight   
        CMP #$28
        BNE CheckIfPlayerPressedFire
        LDA #$00
        STA cursorXPosition

CheckIfPlayerPressedFire   
        LDA lastJoystickInput
        AND #$10
        BEQ PlayerHasPressedFire

        ; Player has not pressed fire.
        LDA #$00
        STA stepsSincePressedFire
        JMP DrawCursorAndReturnFromInterrupt
        ; Returns

        ; Player has pressed fire.
PlayerHasPressedFire   
        LDA stepsExceeded255
        BEQ DecrementPulseWidthCounter
        LDA stepsSincePressedFire
        BEQ IncrementStepsSincePressedFire
        JMP DrawCursorAndReturnFromInterrupt

IncrementStepsSincePressedFire   
        INC stepsSincePressedFire

DecrementPulseWidthCounter   
        LDA currentPulseWidth
        BEQ DecrementPulseSpeedCounter
        DEC currentPulseWidth
        BEQ DecrementPulseSpeedCounter
        JMP UpdatePixelBuffersForPattern

DecrementPulseSpeedCounter   
        DEC currentPulseSpeedCounter
        BEQ RefreshPulseSpeed
        JMP DrawCursorAndReturnFromInterrupt

RefreshPulseSpeed   
        LDA pulseSpeed
        STA currentPulseSpeedCounter
        LDA pulseWidth
        STA currentPulseWidth

        ; Finally, update the pixel buffers with a byte
        ; each for the current pattern.        
UpdatePixelBuffersForPattern    
        INC currentStepCount
        LDA currentStepCount
        CMP bufferLength
        BNE UpdateBaseLevelArray

        LDA #$00
        STA currentStepCount

UpdateBaseLevelArray   
        TAX 
        LDA currentColorIndexArray,X
        CMP #$FF
        BEQ UpdatePositionArrays
        LDA previousIndexToPixelBuffers
        AND trackingActivated
        BEQ DrawCursorAndReturnFromInterrupt
        TAX 
        LDA currentColorIndexArray,X
        CMP #$FF
        BNE DrawCursorAndReturnFromInterrupt

        STX currentStepCount

UpdatePositionArrays   
        LDA cursorXPosition
        STA pixelXPositionArray,X
        LDA cursorYPosition
        STA pixelYPositionArray,X

        LDA lineModeActivated
        BEQ LineModeNotActive

        ; Line Mode Active
        LDA #$19
        SEC 
        SBC cursorYPosition
        ORA #$80
        STA currentColorIndexArray,X
        JMP ApplySmoothingDelay

LineModeNotActive   
        LDA baseLevel
        STA currentColorIndexArray,X
        LDA currentPatternElement
        STA patternIndexArray,X

ApplySmoothingDelay    
        LDA smoothingDelay
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        LDA currentSymmetrySetting
        STA symmetrySettingForStepCount,X

DrawCursorAndReturnFromInterrupt    
        LDA #$01
        STA currentColorToPaint
        JSR PaintCursorAtCurrentPosition
        ; Falls through

;-------------------------------------------------------
; CheckKeyboardAndReturnFromInterrupt
;-------------------------------------------------------
CheckKeyboardAndReturnFromInterrupt    
        JSR CheckKeyboardInput
        ; This returns control to the KERNAL so it can
        ; do whatver it normally does during an interrupt.
        JMP RETURN_INTERRUPT

;-------------------------------------------------------
; LoadXAndYOfCursorPosition
;-------------------------------------------------------
LoadXAndYOfCursorPosition   
        LDX cursorYPosition
        LDA colorRAMLineTableLoPtrArray,X
        STA currentLineInColorRamLoPtr
        LDA colorRAMLineTableHiPtrArray,X
        STA currentLineInColorRamHiPtr
        LDY cursorXPosition
ReturnEarlyFromCursorPaint   
        RTS 

;-------------------------------------------------------
; PaintCursorAtCurrentPosition
;-------------------------------------------------------
PaintCursorAtCurrentPosition   
        LDA displaySavePromptActive
        BNE ReturnEarlyFromCursorPaint
        JSR LoadXAndYOfCursorPosition
        LDA currentColorToPaint
        STA (currentLineInColorRamLoPtr),Y
        RTS 


cursorXPosition       .BYTE $0A
cursorYPosition       .BYTE $0A
currentStepCount      .BYTE $00
stepsSincePressedFire .BYTE $00
stepsExceeded255      .BYTE $00

; This is where the presets get loaded to. It represents
; the data structure for the presets.
; currentVariableMode is an index into this data structure
; when the user adjusts settings.
presetValueArray
unusedPresetByte        .BYTE $00
smoothingDelay          .BYTE $0C
cursorSpeed             .BYTE $02
bufferLength            .BYTE $1F
pulseSpeed              .BYTE $01
indexForColorBarDisplay .BYTE $01
lineWidth               .BYTE $07
sequencerSpeed          .BYTE $04
pulseWidth              .BYTE $01
baseLevel               .BYTE $07
presetColorValuesArray  .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
trackingActivated       .BYTE $FF
lineModeActivated       .BYTE $00
patternIndex            .BYTE $05


customPattern0XPosArray = $C800
customPattern1XPosArray = $C900
customPattern2XPosArray = $CA00
customPattern3XPosArray = $CB00
customPattern4XPosArray = $CC00
customPattern5XPosArray = $CD00
customPattern6XPosArray = $CE00
customPattern7XPosArray = $CF00
customPattern0YPosArray = $C880
customPattern1YPosArray = $C980
customPattern2YPosArray = $CA80
customPattern3YPosArray = $CB80
customPattern4YPosArray = $CC80
customPattern5YPosArray = $CD80
customPattern6YPosArray = $CE80
customPattern7YPosArray = $CF80

; A pair of arrays together consituting a list of pointers
; to positions in memory containing X position data.
; (i.e. $097C, $0E93,$0EC3, $0F07, $0F23, $0F57, $1161, $11B1)
pixelXPositionLoPtrArray .BYTE <starOneXPosArray,<theTwistXPosArray,<laLlamitaXPosArray
                         .BYTE <starTwoXPosArray,<deltoidXPosArray,<diffusedXPosArray
                         .BYTE <multicrossXPosArray,<pulsarXPosArray

customPatternLoPtrArray  .BYTE <customPattern0XPosArray,<customPattern1XPosArray
                         .BYTE <customPattern2XPosArray,<customPattern3XPosArray
                         .BYTE <customPattern4XPosArray,<customPattern5XPosArray
                         .BYTE <customPattern6XPosArray,<customPattern7XPosArray

pixelXPositionHiPtrArray .BYTE >starOneXPosArray,>theTwistXPosArray,>laLlamitaXPosArray
                         .BYTE >starTwoXPosArray,>deltoidXPosArray,>diffusedXPosArray
                         .BYTE >multicrossXPosArray,>pulsarXPosArray

customPatternHiPtrArray  .BYTE >customPattern0XPosArray,>customPattern1XPosArray
                         .BYTE >customPattern2XPosArray,>customPattern3XPosArray
                         .BYTE >customPattern4XPosArray,>customPattern5XPosArray
                         .BYTE >customPattern6XPosArray,>customPattern7XPosArray

; A pair of arrays together consituting a list of pointers
; to positions in memory containing Y position data.
; (i.e. $097C, $0E93,$0EC3, $0F07, $0F23, $0F57, $1161, $11B1)
pixelYPositionLoPtrArray .BYTE <starOneYPosArray,<theTwistYPosArray,<laLlamitaYPosArray
                         .BYTE <starTwoYPosArray,<deltoidYPosArray,<diffusedYPosArray
                         .BYTE <multicrossYPosArray,<pulsarYPosArray
                         .BYTE <customPattern0YPosArray,<customPattern1YPosArray
                         .BYTE <customPattern2YPosArray,<customPattern3YPosArray
                         .BYTE <customPattern4YPosArray,<customPattern5YPosArray
                         .BYTE <customPattern6YPosArray,<customPattern7YPosArray

pixelYPositionHiPtrArray .BYTE >starOneYPosArray,>theTwistYPosArray,>laLlamitaYPosArray
                         .BYTE >starTwoYPosArray,>deltoidYPosArray,>diffusedYPosArray
                         .BYTE >multicrossYPosArray,>pulsarYPosArray
                         .BYTE >customPattern0YPosArray,>customPattern1YPosArray
                         .BYTE >customPattern2YPosArray,>customPattern3YPosArray
                         .BYTE >customPattern4YPosArray,>customPattern5YPosArray
                         .BYTE >customPattern6YPosArray,>customPattern7YPosArray

; The pattern data structure consists of up to 7 rows, each
; one defining a stage in the creation of the pattern. Each
; row is assigned a unique color. The X and Y positions given
; in each array refer to the position relative to the cursor
; at the centre. 'Minus' values relative to the cursor are
; given by values such as FF (-1), FE (-2), and so on.
; An illustration of the pattern each data structure creates
; is given before it.

theTwistXPosArray .BYTE $00,$55                            ;     1  
                  .BYTE $01,$02,$55                        ;   01   
                  .BYTE $01,$02,$03,$55                    ;  6 222 
                  .BYTE $01,$02,$03,$04,$55                ;  543   
                  .BYTE $00,$00,$00,$55                    ; 5 4 3  
                  .BYTE $FF,$FE,$55                        ;   4  3 
                  .BYTE $FF,$55                            ;       3
                  .BYTE $55
theTwistYPosArray .BYTE $FF,$55
                  .BYTE $FF,$FE,$55
                  .BYTE $00,$00,$00,$55
                  .BYTE $01,$02,$03,$04,$55
                  .BYTE $01,$02,$03,$55
                  .BYTE $01,$02,$55
                  .BYTE $00,$55
                  .BYTE $55

laLlamitaXPosArray  .BYTE $00,$FF,$00,$55                    ;  0       
                    .BYTE $00,$00,$55                        ; 06      
                    .BYTE $01,$02,$03,$00,$01,$02,$03,$55    ;  0      
                    .BYTE $04,$05,$06,$04,$00,$01,$02,$55    ;  1    3 
                    .BYTE $04,$00,$04,$00,$04,$55            ;  12223 3
                    .BYTE $FF,$03,$55                        ;  22223  
                    .BYTE $00,$55                            ;  333 4  
laLlamitaYPosArray  .BYTE $FF,$00,$01,$55                    ;  4   4  
                    .BYTE $02,$03,$55                        ; 54  54  
                    .BYTE $03,$03,$03,$04,$04,$04,$04,$55
                    .BYTE $03,$02,$03,$04,$05,$05,$05,$55
                    .BYTE $05,$06,$06,$07,$07,$55
                    .BYTE $07,$07,$55
                    .BYTE $00,$55

starTwoXPosArray  .BYTE $FF,$55                  ;    1  
                  .BYTE $00,$55                  ;   0  2
                  .BYTE $02,$55                  ;    6  
                  .BYTE $01,$55                  ; 4     
                  .BYTE $FD,$55                  ;     3 
                  .BYTE $FE,$55                  ;  5    
                  .BYTE $00,$55
starTwoYPosArray  .BYTE $FF,$55
                  .BYTE $FE,$55
                  .BYTE $FF,$55
                  .BYTE $02,$55
                  .BYTE $01,$55
                  .BYTE $FC,$55
                  .BYTE $00,$55

deltoidXPosArray  .BYTE $00,$01,$FF,$55           ;       5      
                  .BYTE $00,$55                   ;              
                  .BYTE $00,$01,$02,$FE,$FF,$55   ;       4      
                  .BYTE $00,$03,$FD,$55           ;       3      
                  .BYTE $00,$04,$FC,$55           ;       2      
                  .BYTE $00,$06,$FA,$55           ;      202     
                  .BYTE $00,$55                   ;     20602    
deltoidYPosArray  .BYTE $FF,$00,$00,$55           ;    3     3   
                  .BYTE $00,$55                   ;   4       4  
                  .BYTE $FE,$FF,$00,$00,$FF,$55   ;              
                  .BYTE $FD,$01,$01,$55           ; 5           5
                  .BYTE $FC,$02,$02,$55
                  .BYTE $FA,$04,$04,$55
                  .BYTE $00,$55

diffusedXPosArray .BYTE $FF,$01,$55                  ; 5            
                  .BYTE $FE,$02,$55                  ;            4 
                  .BYTE $FD,$03,$55                  ;   3          
                  .BYTE $FC,$04,$FC,$FC,$04,$04,$55  ;          2   
                  .BYTE $FB,$05,$55                  ; 5   1       5
                  .BYTE $FA,$06,$FA,$FA,$06,$06,$55  ;   3    0  3  
                  .BYTE $00,$55                      ;       6      
diffusedYPosArray .BYTE $01,$FF,$55                  ;   3  0    3  
                  .BYTE $FE,$02,$55                  ; 5       1   5
                  .BYTE $03,$FD,$55                  ;    2         
                  .BYTE $FC,$04,$FF,$01,$FF,$01,$55  ;           3  
                  .BYTE $05,$FB,$55                  ;  4           
                  .BYTE $FA,$06,$FE,$02,$FE,$02,$55  ;             5
                  .BYTE $00,$55


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

        CMP #KEY_SPACE ; Space pressed?
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
        CMP #KEY_S ; 'S' pressed.
        BNE MaybeLPressed

        ; Check if shift was pressed too.
        LDA shiftPressed
        AND #$01
        BEQ JustSPressed

        LDA tapeSavingInProgress
        BNE JustSPressed
        ; Shift + S pressed: Save.
        JMP PromptToSave
        ; Returns

        ; 'S' pressed. "This changes the 'symmetry'. The pattern gets reflected
        ; in various planes, or not at all according to the setting."
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
        CMP #KEY_L ; 'L' pressed?
        BNE MaybeDPressed

        ; Don't do anything if already saving to tape.
        LDA tapeSavingInProgress
        BNE JustLPressed

        ; Check if shift was pressed too.
        LDA shiftPressed
        AND #$01
        BEQ JustLPressed

        ; Shift + L pressed. Display load message
        JMP DisplayLoadOrAbort
        ; Returns

        ; 'L' pressed. Turn line mode on or off.
JustLPressed   
        LDA lineModeActivated
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
_Loop   LDA lineModeSettingDescriptions,Y
        STA lastLineBufferPtr,X
        INY 
        INX 
        CPX #$10
        BNE _Loop
        JMP WriteLastLineBufferToScreen
        ; Returns

MaybeDPressed   
        CMP #KEY_D ; 'D' pressed?
        BNE MaybeCPressed

        ; Smoothing Delay, D to activate: Because of the time taken to draw
        ; larger patterns speed increase/decrease is not linear. You can adjust
        ; the ‘compensating delay’ which often smooths out jerky patterns. Can
        ; be used just for special FX, though. Suck it and see.
        LDA #SMOOTHING_DELAY
        STA currentVariableMode
        RTS 

MaybeCPressed   
        CMP #KEY_C ; C pressed?
        BNE MaybeBPressed
        ; C pressed.
        ; Cursor Speed C to activate: Just that. Gives you a slow r fast little
        ; cursor, according to setting.

        LDA #CURSOR_SPEED
        STA currentVariableMode
        RTS 

MaybeBPressed   
        CMP #KEY_B ; B pressed?
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
        CMP #KEY_P ; P pressed
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
        CMP #KEY_H ; H pressed.
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
        CMP #KEY_T ; T pressed.
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
        CMP #KEY_W ; W pressed?
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

        ; A Function key was pressed, ignore if the sequencer is active.
FunctionKeyWasPressed   
        STX functionKeyIndex
        LDA sequencerActive
        BNE MaybeQPressed
        LDA #SEQUENCER_ACTIVE
        STA currentVariableMode
        JSR UpdateBurstGenerator
        RTS 

MaybeQPressed    
        CMP #KEY_Q ; Q pressed?
        BNE MaybeVPressed

        ; Q was presed. Toggle the sequencer on or off.
        LDA sequencerActive
        BNE TurnSequenceOff
        LDA #SEQUENCER_ACTIVE
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
        CMP #KEY_V ; V pressed?
        BNE MaybeOPressed

        ; V pressed.
        ; Sequencer Speed V to activate: Controls the rate at which sequencer
        ; feeds in its data. See the SEQUENCER bit.
        LDA #SEQUENCER_SPEED
        STA currentVariableMode
        RTS 

MaybeOPressed   
        CMP #KEY_O ; O pressed.
        BNE MaybeAsteriskPressed

        ; O pressed.
        ; Pulse Width : Sets the length of the pulses in a pulsed
        ; stream output. Don’t worry about what that means - just get in there
        ; and mess with it.
        LDA #PULSE_WIDTH
        STA currentVariableMode
        RTS 

MaybeAsteriskPressed   
        CMP #KEY_ASTERISK ; * pressed?
        BNE MaybeRPressed

        ; * pressed.
        ; BASE LEVEL : Controls how many ‘levels’ of pattern are
        ; plotted.
        LDA #BASE_LEVEL
        STA currentVariableMode
        RTS 

MaybeRPressed   
        CMP #KEY_R ; R pressed?
        BNE MaybeUpArrowPressed
        ; R was pressed. Stop or start recording.
        JMP StopOrStartRecording

MaybeUpArrowPressed   
        CMP #KEY_UP ; Up arrow
        BNE MaybeAPressed
        ; Up arrow pressed. "Press UP-ARROW to change the shape of the little pixels on the screen."
        INC pixelShapeIndex
        LDA pixelShapeIndex
        AND #$0F
        TAY 
        LDA pixelShapeArray,Y

        ; Rewrite the screen using the new pixel.
        LDX #$00
_Loop   STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $02C0,X
        DEX 
        BNE _Loop
        STA currentPixel
        RTS 

MaybeAPressed   
        CMP #KEY_A ; 'A' pressed
        BNE FinalReturnFromKeyboardCheck

        ; Activate demo mode.
        LDA demoModeActive
        EOR #$01
        STA demoModeActive
        RTS 

FinalReturnFromKeyboardCheck   
        RTS 


initialTimeBetweenKeyStrokes   .BYTE $10

multicrossXPosArray .BYTE $01,$01,$FF,$FF,$55                    ;
                    .BYTE $02,$02,$FE,$FE,$55                    ;   5     5  
                    .BYTE $01,$03,$03,$01,$FF,$FD,$FD,$FF,$55    ;  4       4 
                    .BYTE $03,$03,$FD,$FD,$55                    ; 5 3 2 2 3 5
                    .BYTE $04,$04,$FC,$FC,$55                    ;    1   1   
                    .BYTE $03,$05,$05,$03,$FD,$FB,$FB,$FD,$55    ;   2 0 0 2  
                    .BYTE $00,$55                                ;      6     
multicrossYPosArray .BYTE $FF,$01,$01,$FF,$55                    ;   2 0 0 2  
                    .BYTE $FE,$02,$02,$FE,$55                    ;    1   1   
                    .BYTE $FD,$FF,$01,$03,$03,$01,$FF,$FD,$55    ; 5 3 2 2 3 5
                    .BYTE $FD,$03,$03,$FD,$55                    ;  4       4 
                    .BYTE $FC,$04,$04,$FC,$55                    ;   5     5  
                    .BYTE $FB,$FD,$03,$05,$05,$03,$FD,$FB,$55    ;
                    .BYTE $00,$55


pulsarXPosArray .BYTE $00,$01,$00,$FF,$55       ;
                .BYTE $00,$02,$00,$FE,$55       ;       5      
                .BYTE $00,$03,$00,$FD,$55       ;       4      
                .BYTE $00,$04,$00,$FC,$55       ;       3      
                .BYTE $00,$05,$00,$FB,$55       ;       2      
                .BYTE $00,$06,$00,$FA,$55       ;       1      
                .BYTE $00,$55                   ;       0      
pulsarYPosArray .BYTE $FF,$00,$01,$00,$55       ; 5432106012345
                .BYTE $FE,$00,$02,$00,$55       ;       0      
                .BYTE $FD,$00,$03,$00,$55       ;       1      
                .BYTE $FC,$00,$04,$00,$55       ;       2      
                .BYTE $FB,$00,$05,$00,$55       ;       3      
                .BYTE $FA,$00,$06,$00,$55       ;       4      
                .BYTE $00,$55                   ;       5      

lastLineBufferPtr               .BYTE $FF,$FF,$FF,$FF,$FF,$FF
dataFreeDigitOne                .BYTE $FF
dataFreeDigitTwo                .BYTE $FF
dataFreeDigitThree              .BYTE $FF,$FF,$FF,$FF,$FF
customPatternValueBufferPtr     .BYTE $FF,$FF,$FF
customPatternValueBufferMessage .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                                .BYTE $00,$00,$00,$00,$00,$00,$00,$00


;-------------------------------------------------------
; ClearLastLineOfScreen
;-------------------------------------------------------
ClearLastLineOfScreen   
        
        LDX #$28
b121B   LDA #$20
        STA lastLineBufferPtr - $01,X
        STA SCREEN_RAM + $03BF,X
        DEX 
        BNE b121B
        RTS 

;-------------------------------------------------------
; WriteLastLineBufferToScreen
;-------------------------------------------------------
WriteLastLineBufferToScreen    
        LDX #$28
b1229   LDA lastLineBufferPtr - $01,X
        AND #$3F
        STA SCREEN_RAM + $03BF,X
        LDA #$0C
        STA COLOR_RAM + $03BF,X
        DEX 
        BNE b1229
        RTS 

.enc "petscii"  ;define an ascii->petscii encoding
        .cdef "{{", $A8  ;characters
        .cdef "}}", $A9  ;characters
        .cdef "@@", $AC  ;characters
        .cdef "??", $BF  ;characters
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
; PaintLineMode
;-------------------------------------------------------
PaintLineMode 
        LDA baseLevelForCurrentPixel
        AND #$7F
        STA offsetForYPos
        LDA #$19
        SEC 
        SBC offsetForYPos
        STA pixelYPosition
        DEC pixelYPosition
        LDA #$00
        STA baseLevelForCurrentPixel
        LDA #$01
        STA skipPixel
        JSR PaintPixelForCurrentSymmetry
        INC pixelYPosition
        LDA #$00
        STA skipPixel

        LDA lineWidth
        EOR #$07
        STA baseLevelForCurrentPixel
LineModeLoop   
        JSR PaintPixelForCurrentSymmetry
        INC pixelYPosition
        INC baseLevelForCurrentPixel
        LDA baseLevelForCurrentPixel
        CMP #$08
        BNE ResetLineModeColorValue
        JMP CleanUpAndExitLineModePaint

        INC baseLevelForCurrentPixel
ResetLineModeColorValue   
        STA baseLevelForCurrentPixel
        LDA pixelYPosition
        CMP #$19
        BNE LineModeLoop

CleanUpAndExitLineModePaint    
        LDX currentIndexToPixelBuffers
        DEC currentColorIndexArray,X
        LDA currentColorIndexArray,X
        CMP #$80
        BEQ ResetIndexAndExitLineModePaint
        JMP MainPaintLoop

ResetIndexAndExitLineModePaint   
        LDA #$FF
        STA currentColorIndexArray,X
        STX previousIndexToPixelBuffers
        JMP MainPaintLoop

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
b1417   LDA currentColorIndexArray,X
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
        LDX indexForColorBarDisplay
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
        CPX #COLOR_CHANGE
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

b14A8   STY indexForColorBarDisplay
        LDX currentVariableMode

b14AE   LDA increaseOffsetForPresetValueArray,X
        STA currentColorBarOffset
        LDA presetValueArray,X
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
        CMP #COLOR_CHANGE
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
        CMP #$01 ; Enter Pressed
        BEQ EnterHasBeenPressed
        RTS 

        ; Enter pressed
EnterHasBeenPressed   
        LDA currentVariableMode
        CMP #COLOR_CHANGE
        BNE ReachedLastColor

        ; In Color Change mode, move to the next color set
        ; until you reach the last one.
        INC currentColorSet
        LDA currentColorSet
        CMP #$08
        BEQ ReachedLastColor
        RTS 

        ; Enter was pressed, so exit variable mode.
ReachedLastColor   
        LDA #$00
        STA currentVariableMode
        STA enterWasPressed
        RTS 


maxValueForPresetValueArray       .BYTE $00,$40,$08,$40,$10,$10,$08
                                  .BYTE $20,$10,$08
minValueForPresetValueArray       .BYTE $00,$00,$00,$00,$00
                                  .BYTE $00,$00,$00,$00,$00
increaseOffsetForPresetValueArray .BYTE $00,$01,$08
                                  .BYTE $01,$04,$08,$08,$02,$04,$08
currentVariableMode               .BYTE $00
currentPulseSpeedCounter         .BYTE $01

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

colorBarValues  .BYTE BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE,ORANGE
                .BYTE BROWN,LTRED,GRAY1,GRAY2,LTGREEN,LTBLUE,GRAY3

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
        JMP EditCustomPattern

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

b1638   JMP UpdateCurrentActivePreset

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
; UpdateCurrentActivePreset
;-------------------------------------------------------
UpdateCurrentActivePreset    
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
        STA currentIndexToPixelBuffers
        STA previousIndexToPixelBuffers

        LDX #$00
        LDA #$FF
b172a   STA currentColorIndexArray,X
        INX
        CPX #$40
        BNE b172A

        LDA #$00
        STA currentModeActive
        JMP InitializeScreenWithInitCharacter
        ; Returns

enterWasPressed  .BYTE $00
functionKeyIndex .BYTE $00

;-------------------------------------------------------
; UpdateBurstGenerator
;-------------------------------------------------------
UpdateBurstGenerator   
        JSR ClearLastLineOfScreen
        LDA shiftPressed
        AND #$01
        BEQ PointToBurstData

        ; Display data free
        LDX #$00
b1748   LDA txtDataFree,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$10
        BNE b1748
        JSR WriteLastLineBufferToScreen

PointToBurstData   
        LDA #>burstGeneratorF1
        STA currentSequencePtrHi
        LDX functionKeyIndex
        LDA functionKeyToSequenceArray,X
        STA currentSequencePtrLo

        LDA shiftPressed
        AND #$01
        BEQ b177B

        ; Set the current data free to 16
        LDA #$10
        STA currentDataFree

        ; Store the current symmetry setting and smoothing delay
        ; in the storage selected by the function key. 
        LDY #$00
        LDA currentSymmetrySetting
        STA (currentSequencePtrLo),Y
        LDA smoothingDelay
        INY 
        STA (currentSequencePtrLo),Y
        RTS 

b177B   LDA #$FF
        STA sequencerActive
        JMP LoadBurstData

functionKeyToSequenceArray   .BYTE <burstGeneratorF1,<burstGeneratorF2
                             .BYTE <burstGeneratorF3,<burstGeneratorF4

.enc "petscii" 
txtDataFree
        .TEXT 'DATA',$BA,' ',$B0,$B0,$B0,' FREE  '
.enc "none" 
functionKeys
        .BYTE $04,$05,$06,$03

currentDataFree   .BYTE $FF,$60

;-------------------------------------------------------
; CheckKeyboardWhilePromptActive
;-------------------------------------------------------
CheckKeyboardWhilePromptActive 
        LDA currentVariableMode
        CMP #CUSTOM_PRESET_ACTIVE
        BNE b17A7
        JMP CheckKeyboardInputForCustomPresets

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
        LDX currentDataFree
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
        LDA customPromptsActive
        BEQ b1801
        LDA lastKeyPressed
        CMP #$40
        BEQ b17FB
        RTS 

b17FB   LDA #$00
        STA customPromptsActive
b1800   RTS 

b1801   LDA lastKeyPressed
        CMP #$40
        BEQ b1800
        LDX #$01
        STX customPromptsActive
        CMP #$39
        BEQ b183D
        CMP #$01
        BEQ ReturnPressed
        CMP #$3C
        BNE b183C
        JSR UpdateDataFreeDisplay

        LDA currentDataFree
        STA dataFreeForSequencer

        LDA currentSequencePtrLo
        STA prevSequencePtrLo
        LDA currentSequencePtrHi
        STA prevSequencePtrHi

        LDA #$00
        STA currentVariableMode
        STA customPromptsActive
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
        JMP j184E

b184B   LDA cursorXPosition

j184E    
        STA (currentSequencePtrLo),Y
        LDA cursorYPosition
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
        DEC currentDataFree
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
        STA customPromptsActive
        STA dataFreeForSequencer
        STA sequencerActive
        RTS 

customPromptsActive   .BYTE $00
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
; LoadBurstData
;-------------------------------------------------------
LoadBurstData    
        LDA #$00
        STA currentVariableMode
        TAY 
        LDA (currentSequencePtrLo),Y
        STA prevSymmetrySetting
        INY 
        LDA (currentSequencePtrLo),Y
        STA burstSmoothingDelay

LoadNextBurstPosition    
        LDY #$02
        INC currentStepCount
        LDA currentStepCount
        CMP bufferLength
        BNE DontResetStepCountToZero

        LDA #$00
        STA currentStepCount

DontResetStepCountToZero
        LDX currentStepCount
        LDA currentColorIndexArray,X
        CMP #$FF
        BEQ LoadBurstToBuffers

        LDA previousIndexToPixelBuffers
        AND trackingActivated
        BEQ MoveToNextBurstPosition

        STA currentStepCount
        TAX 
        LDA currentColorIndexArray,X
        CMP #$FF
        BNE MoveToNextBurstPosition

LoadBurstToBuffers
        LDA baseLevel
        STA currentColorIndexArray,X
        LDA (currentSequencePtrLo),Y
        CMP #$C0
        BEQ MoveToNextBurstPosition

        STA pixelXPositionArray,X
        INY 
        LDA (currentSequencePtrLo),Y
        STA pixelYPositionArray,X
        INY 
        LDA (currentSequencePtrLo),Y
        STA patternIndexArray,X
        LDA burstSmoothingDelay
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        LDA prevSymmetrySetting
        STA symmetrySettingForStepCount,X

MoveToNextBurstPosition
        LDA currentSequencePtrLo
        CLC 
        ADC #$03
        STA currentSequencePtrLo
        LDA currentSequencePtrHi
        ADC #$00
        STA currentSequencePtrHi
        LDY #$02
        LDA (currentSequencePtrLo),Y
        CMP #$FF
        BEQ FinishedLoadingBurstData
        JMP LoadNextBurstPosition

FinishedLoadingBurstData
        LDA #$00
        STA sequencerActive
        RTS 

burstSmoothingDelay   .BYTE $00
prevSymmetrySetting .BYTE $00
sequencerActive     .BYTE $00
;-------------------------------------------------------
; ActivateSequencer
;-------------------------------------------------------
ActivateSequencer 
        LDA #>startOfSequencerData
        STA currentSequencePtrHi
        LDA #<startOfSequencerData
        STA currentSequencePtrLo
        LDA #$FF
        STA sequencerActive
        LDA shiftPressed
        AND #$01
        BNE ShiftPressedSoProgramSequencer

        ; Start Playing the Sequencer
        LDA sequencerSpeed
        STA stepsRemainingInSequencerSequence
        LDA #$00
        STA currentVariableMode
        JSR DisplaySequencerState
        RTS 

ShiftPressedSoProgramSequencer   
        LDA dataFreeForSequencer
        BEQ SetUpNewSequencer
        LDA dataFreeForSequencer
        STA currentDataFree
        LDA prevSequencePtrLo
        STA currentSequencePtrLo
        LDA prevSequencePtrHi
        STA currentSequencePtrHi
        JMP DisplaySequFree
        ;Returns

SetUpNewSequencer   
        LDA #$FF
        STA currentDataFree
        LDA currentSymmetrySetting
        LDY #$00
        STA (currentSequencePtrLo),Y
        LDA smoothingDelay
        INY 
        STA (currentSequencePtrLo),Y

DisplaySequFree    
        JSR ClearLastLineOfScreen

        LDX #$00
SequencerTextLoop   
        LDA txtSequFree,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$10
        BNE SequencerTextLoop

        JSR WriteLastLineBufferToScreen
        RTS 

;-------------------------------------------------------
; LoadDataForSequencer
;-------------------------------------------------------
LoadDataForSequencer   
        INC currentStepCount
        LDA currentStepCount
        CMP bufferLength
        BNE b1992

        LDA #$00
        STA currentStepCount
b1992   TAX 
        LDA currentColorIndexArray,X
        CMP #$FF
        BEQ LoadValuesFromSequencerData

        LDA previousIndexToPixelBuffers
        AND trackingActivated
        BEQ MoveToNextPositionInSequencer
        TAX 
        LDA currentColorIndexArray,X
        CMP #$FF
        BNE MoveToNextPositionInSequencer

LoadValuesFromSequencerData   
        LDY #$02
        LDA (currentSequencePtrLo),Y
        CMP #$C0
        BEQ MoveToNextPositionInSequencer

        LDA baseLevel
        STA currentColorIndexArray,X

        LDA startOfSequencerData + $01
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X

        LDA startOfSequencerData
        STA symmetrySettingForStepCount,X

        LDY #$02
        LDA (currentSequencePtrLo),Y
        STA pixelXPositionArray,X
        INY 
        LDA (currentSequencePtrLo),Y
        STA pixelYPositionArray,X
        INY 
        LDA (currentSequencePtrLo),Y
        STA patternIndexArray,X

MoveToNextPositionInSequencer   
        LDA currentSequencePtrLo
        CLC 
        ADC #$03
        STA currentSequencePtrLo
        LDA currentSequencePtrHi
        ADC #$00
        STA currentSequencePtrHi
        LDY #$02
        LDA (currentSequencePtrLo),Y
        CMP #$FF
        BEQ ResetSequencerToStart
        RTS 

ResetSequencerToStart   
        LDA #<startOfSequencerData
        STA currentSequencePtrLo
        LDA #>startOfSequencerData
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
dataFreeForSequencer
      .BYTE $00
prevSequencePtrLo
      .BYTE $00
prevSequencePtrHi
      .BYTE $00
currentPulseWidth
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
        LDA cursorXPosition
        STA previousCursorXPosition
        LDA cursorYPosition
        STA previousCursorYPosition
        RTS 

b1AC5   LDA #$00
        STA currentColorToPaint
        JSR PaintCursorAtCurrentPosition
        LDA previousCursorXPosition
        STA cursorXPosition
        LDA previousCursorYPosition
        STA cursorYPosition
        LDA #$FF
        STA displaySavePromptActive
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
        STA displaySavePromptActive
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
        STA storageOfSomeKind
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
        JSR PaintCursorAtCurrentPosition
        LDA previousCursorXPosition
        STA cursorXPosition
        LDA previousCursorYPosition
        STA cursorYPosition
        RTS 

recordingOffset
        .BYTE $00
previousCursorXPosition
        .BYTE $0C
previousCursorYPosition
        .BYTE $0C
customPatternIndex
        .BYTE $00
displaySavePromptActive
        .BYTE $00
.enc "petscii" 
txtDefineAllLevelPixels
        .TEXT 'DEFINE ALL LEVEL ',$B2,' PIXELS'
.enc "none" 

;-------------------------------------------------------
; EditCustomPattern
;-------------------------------------------------------
EditCustomPattern 
        TXA
        AND #$08
        BEQ b1C0B
        RTS 

b1C0B   LDA #CUSTOM_PRESET_ACTIVE
        STA currentVariableMode

        ; Custom patterns are stored between $C800 and
        ; $CFFF. See custom_patterns.asm
        LDA #$00
        STA customPatternLoPtr
        STA displaySavePromptActive
        LDA customPatternHiPtrArray,X
        STA customPatternHiPtr

        TXA 
        CLC 
        ADC #$08
        STA customPatternIndex
        JSR ClearLastLineOfScreen

        LDX #$00
b1C28   LDA txtDefineAllLevelPixels,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$19
        BNE b1C28

        JSR WriteLastLineBufferToScreen

        LDA #$06
        STA initialBaseLevelForCustomPresets

        ; Write $00,$55 to the first two bytes
        ; of the custom pattern.
        LDY #$00
        TYA 
        STA (customPatternLoPtr),Y
        INY 
        LDA #$55
        STA (customPatternLoPtr),Y

        ; Write $00,$55 to the last two bytes
        ; of the custom pattern.
        LDY #$81
        STA (customPatternLoPtr),Y
        DEY 
        LDA #$00
        STA (customPatternLoPtr),Y

        LDA #$07
        STA minIndexToColorValues

        LDA #$01
        STA currentIndexToPresetValue

        LDA #$17
        STA currentModeActive

        RTS 

;-------------------------------------------------------
; HandleCustomPreset
;-------------------------------------------------------
HandleCustomPreset    
        LDA #$13
        STA cursorXPosition
        LDA #$0C
        STA cursorYPosition
        JSR ReinitializeScreen

b1C68   LDA customPatternIndex
        STA patternIndex
        LDA initialBaseLevelForCustomPresets
        STA baseLevelForCurrentPixel
        LDA #$00
        STA currentSymmetrySettingForStep
        LDA #$13
        STA pixelXPosition
        LDA #$0C
        STA pixelYPosition
        JSR LoopThroughPixelsAndPaint
        LDA initialBaseLevelForCustomPresets
        BNE b1C68

        JSR ReinitializeScreen
        LDA #$00
        STA currentModeActive
        JMP MainPaintLoop

;-------------------------------------------------------
; CheckKeyboardInputForCustomPresets
;-------------------------------------------------------
CheckKeyboardInputForCustomPresets    
        LDA customPromptsActive
        BEQ b1CA2
        LDA lastKeyPressed
        CMP #$40
        BEQ b1C9C
        RTS 

b1C9C   LDA #$00
        STA customPromptsActive
ReturnFromOtherPrompts   
        RTS 

b1CA2   LDA lastKeyPressed
        CMP #$40
        BEQ ReturnFromOtherPrompts

        LDA #$FF
        STA customPromptsActive

        LDA lastKeyPressed
        CMP #$01 ; Return pressed?
        BEQ EnterPressed

        JMP MaybeLeftArrowPressed2

EnterPressed   
        INC currentIndexToPresetValue
        LDA #$00
        LDY currentIndexToPresetValue
        STA (customPatternLoPtr),Y
        PHA 
        TYA 
        CLC 
        ADC #$80
        TAY 
        PLA 
        STA (customPatternLoPtr),Y
        INY 
        LDA #$55
        STA (customPatternLoPtr),Y
        LDY currentIndexToPresetValue
        INY 
        STA (customPatternLoPtr),Y
        STY currentIndexToPresetValue
        LDA #$07
        STA minIndexToColorValues
        DEC initialBaseLevelForCustomPresets
        BEQ b1CE6
        LDA initialBaseLevelForCustomPresets
        EOR #$07
        CLC 
        ADC #$31
        STA SCREEN_RAM + $03D1
        RTS 

b1CE6   LDA #$00
        STA currentVariableMode
        JSR ClearLastLineOfScreen
b1CEE   RTS 

MaybeLeftArrowPressed2
        CMP #KEY_LEFT ; Left arrow pressed.
        BNE b1CEE

        LDY currentIndexToPresetValue
        LDA cursorXPosition
        SEC 
        SBC #$13
        STA (customPatternLoPtr),Y
        INY 
        LDA #$55
        STA (customPatternLoPtr),Y
        STY currentIndexToPresetValue
        TYA 
        CLC 
        ADC #$7F
        TAY 
        LDA cursorYPosition
        SEC 
b1D0D   SBC #$0C
        STA (customPatternLoPtr),Y
        INY 
        LDA #$55
        STA (customPatternLoPtr),Y
        DEC minIndexToColorValues
        BEQ b1D1B
        RTS 

b1D1B   JMP EnterPressed

;-------------------------------------------------------
; GetCustomPatternElement
;-------------------------------------------------------
GetCustomPatternElement    
        JSR ClearLastLineOfScreen

        LDX #$00
txtPatternLoop   
        LDA txtCustomPatterns,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$0E
        BNE txtPatternLoop

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

PRINT = $FFD2
;-------------------------------------------------------
; DisplaySavePromptScreen
;-------------------------------------------------------
DisplaySavePromptScreen 
        LDA #$13
        JSR PRINT
        LDA #$FF
        STA displaySavePromptActive
        JSR InitializeScreenWithInitCharacter
b1D70   LDA tapeSavingInProgress
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
        STA displaySavePromptActive
        STA tapeSavingInProgress
        JSR ROM_CLALL ;$FFE7 - close or abort all files         
        JSR ReinitializeScreen
        JMP MainPaintLoop

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

        LDA #SAVING_ACTIVE
        STA currentVariableMode

        LDX #$00
b1E30   LDA txtSavePrompt,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$28
        BNE b1E30

        LDA #$00
        STA tapeSavingInProgress
        JSR WriteLastLineBufferToScreen
b1E43   RTS 

txtSavePrompt   .TEXT " SAVE (P)ARAMETERS, (M)OTION, (A)BORT?  "

;-------------------------------------------------------
; CheckKeyboardInputWhileSavePromptActive
;-------------------------------------------------------
CheckKeyboardInputWhileSavePromptActive    
        LDA currentVariableMode
        CMP #SAVING_ACTIVE
        BEQ b1E74
        RTS 

b1E74   LDA lastKeyPressed
        CMP #$0A ; 'A' pressed?
        BNE MaybeM_Pressed

        ; 'A' pressed.
        LDA #$00
        STA currentModeActive

j1E7F    
        LDA #$00
        STA currentVariableMode
        JMP ClearLastLineOfScreen

MaybeM_Pressed   
        CMP #$24 ; 'M' pressed?
        BNE MaybeP_Pressed

        ; Selecting MOTION saves the stored sequence of joystick moves used in
        ; the Record option. (Long performances take a little while!). The
        ; parameters are saved as GOATS and the motion as SHEEP (| suggest you
        ; use opposite sides of a short cassette to store these on). 
        LDA #$02
        STA tapeSavingInProgress
        LDA #$18
        STA currentModeActive
        JMP j1E7F

MaybeP_Pressed   
        CMP #$29 ; 'P' pressed?
        BNE b1EA9

        ; Selecting PARAMETERS saves all presets, burst gens and sequencer,
        ; plus all user-defined shapes.
        LDA #$01
        STA tapeSavingInProgress
        LDA #$18
        STA currentModeActive
        JMP j1E7F

b1EA9   RTS 

tapeSavingInProgress   .BYTE $00
;-------------------------------------------------------
; DisplayLoadOrAbort
;-------------------------------------------------------
DisplayLoadOrAbort    
        
        LDA stepsRemainingInSequencerSequence
        BNE b1EA9
        LDA playbackOrRecordActive
        CMP #$02
        BEQ b1EA9
        LDA #LOADING_ACTIVE
        STA currentVariableMode
        LDX #$00
b1EBE   LDA txtContinueLoadOrAbort,X
        STA lastLineBufferPtr,X
        INX 
        CPX #$28
        BNE b1EBE
        LDA #$00
        STA tapeSavingInProgress
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
        STA tapeSavingInProgress
        STA currentModeActive
        JMP ClearLastLineOfScreen

b1EE5   CMP #$14 ; 'C'
        BNE b1EFB

        ; 'C' pressed
        LDA #$03
        STA tapeSavingInProgress
        LDA #$00
        STA currentVariableMode
        LDA #$18
        STA currentModeActive
        JMP ClearLastLineOfScreen

b1EFB   RTS 

.enc "petscii" 
txtContinueLoadOrAbort
        .TEXT '{C}ONTINUE LOAD@ OR {A}BORT? '
        .TEXT '           '
.enc "none" 
demoModeActive          .BYTE $00
joystickInputDebounce   .BYTE $01
joystickInputRandomizer .BYTE $10

;-------------------------------------------------------
; PerformRandomJoystickMovement
;-------------------------------------------------------
PerformRandomJoystickMovement 
        DEC joystickInputDebounce
        BEQ b1F2D
        RTS 

b1F2D   JSR PutRandomByteInAccumulator
        AND #$1F
        ORA #$01
        STA joystickInputDebounce
        LDA joystickInputRandomizer
        EOR #$10
        STA joystickInputRandomizer
        JSR PutRandomByteInAccumulator
        AND #$0F
        ORA joystickInputRandomizer
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

;-------------------------------------------------------
; NMIInterruptHandler
; Not really sure of the purpose of the values being
; pushed to the stack here. Is it all to prevent the
; RESTORE key from resetting things?
;-------------------------------------------------------
NMIInterruptHandler
        LDX #<CalledFromNMI
        TXS
        LDA #>CalledFromNMI
        PHA
        LDA #$30
        PHA
        LDA #$23
        PHA
        RTI


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
_Loop   LDA (copyFromLoPtr),Y
        STA (copyToLoPtr),Y
        DEY 
        BNE _Loop

        INC copyFromHiPtr
        INC copyToHiPtr
        DEX 
        BNE _Loop

        LDX #$09
_Loop2  LDA originalStorageOfSomeKind,X
        STA storageOfSomeKind,X
        DEX 
        BNE _Loop2
        RTS 

originalStorageOfSomeKind=*-$01   
        .BYTE $30,$0C,$30,$0C,$C3,$C2,$CD,$38
        .BYTE $30,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00

.include "presets.asm"
.include "burst_generators.asm"
.include "sequencer_data.asm"
.include "custom_patterns.asm"
