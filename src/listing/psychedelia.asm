; This is the reverse-engineered source code for the listing of 'Psychedelia'
; written by Jeff Minter in 1984. It first appeared in the December 1984 issue
; of 'Popular Computing Weekly':
; https://archive.org/details/popular-computing-weekly-1984-12-13/page/n31/mode/2up?view=theater
;
; The code in this file was created by disassembling the machine code in the listing.
;
; The original code from which this source is derived is the copyright of Jeff Minter.
;
; The original home of this file is at: https://github.com/mwenge/psychedelia-listing
;
; To the extent to which any copyright may apply to the act of disassembling and reconstructing
; the code from its binary, the author disclaims copyright to this source code.  In place of
; a legal notice, here is a blessing:
;
;    May you do good and not evil.
;    May you find forgiveness for yourself and forgive others.
;    May you share freely, never taking more than you give.

pixelXPosition              = $02
pixelYPosition              = $03
baseLevelForCurrentPixel    = $04
currentLineInColorRamLoPtr2 = $05
currentLineInColorRamHiPtr2 = $06
previousCursorXPositionZP   = $08
previousPixelYPositionZP    = $09
currentLineInColorRamLoPtr  = $0A
currentLineInColorRamHiPtr  = $0B
currentColorToPaint         = $0C
colorRamLoPtr               = $FB
colorRamHiPtr               = $FC
RAM0835LoPtr                = $FD
RAM0835HiPtr                = $FE
RAM4000HiPtr                = $FC
RAM4000LoPtr                = $FB
colorRAMLineTableLoPtrArray = $0340
colorRAMLineTableHiPtrArray = $0360
SCREEN_RAM                  = $0400
COLOR_RAM                   = $D800
RETURN_FROM_INTERRUPT       = $EA31

* = $0801
;-----------------------------------------------------------------------------------
; Start program at CopyCodeToRAM (SYS 2064)
; SYS 2064 ($0810)
; $9E = SYS
; $32,$30,$36,$34 = 2064
;-----------------------------------------------------------------------------------

        .BYTE $0B,$08,$0A,$00,$9E,$32,$30,$36
        .BYTE $34,$00,$00,$00,$00,$00,$00

;-----------------------------------------------------------------------------------
; CopyCodeToRAM
; Copies the code into position from $0835 to $4000.
; We skip this function and just go to InitializeProgram
; directly.
;-----------------------------------------------------------------------------------
CopyCodeToRAM
        LDA #$40
        STA RAM4000HiPtr
        LDA #$08
        STA RAM0835HiPtr
        LDA #$00
        STA RAM4000LoPtr
        LDA #$35
        STA RAM0835LoPtr
        LDY #$00
        LDX #$06
b3FEF   LDA (RAM0835LoPtr),Y
        STA (RAM4000LoPtr),Y
        DEY 
        BNE b3FEF
        INC RAM4000HiPtr
        INC RAM0835HiPtr
        DEX 
        BNE b3FEF
        JMP InitializeProgram

;-------------------------------------------------------
; InitializeProgram
;-------------------------------------------------------
InitializeProgram   
        LDA #$00
        STA $D020    ;Border Color
        STA $D021    ;Background Color 0

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
b4012   LDA colorRamHiPtr
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
        BNE b4012

        JSR InitializeScreenAndText
        JMP LaunchPsychedelia

;-------------------------------------------------------
; InitializeScreenWithInitCharacter
;-------------------------------------------------------
InitializeScreen   
        LDX #$00
b4034   LDA #$CF
        STA SCREEN_RAM + $0000,X
        STA SCREEN_RAM + $0100,X
        STA SCREEN_RAM + $0200,X
        STA SCREEN_RAM + $0300,X
        LDA #$00
        STA COLOR_RAM + $0000,X
        STA COLOR_RAM + $0100,X
        STA COLOR_RAM + $0200,X
        STA COLOR_RAM + $0300,X
        DEX 
        BNE b4034
        RTS 

presetColorValuesArray   .BYTE $00,$06,$02,$04,$05,$03,$07,$01
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
b406A   RTS 

tempIndex = $FD
;-------------------------------------------------------
; PaintPixel
;-------------------------------------------------------
PaintPixel   
        LDA pixelXPosition
        AND #$80
        BNE b406A
        LDA pixelXPosition
        CMP #$28
        BPL b406A
        LDA pixelYPosition
        AND #$80
        BNE b406A
        LDA pixelYPosition
        CMP #$18
        BPL b406A

        JSR LoadXAndYPosition
        LDA (currentLineInColorRamLoPtr2),Y
        AND #$07

        LDX #$00
b408C   CMP presetColorValuesArray,X
        BEQ b4096
        INX 
        CPX #$08
        BNE b408C

b4096   TXA 
        STA tempIndex
        LDX baseLevelForCurrentPixel
        INX 
        CPX tempIndex
        BEQ ActuallyPaintPixel
        BPL ActuallyPaintPixel
        RTS 

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

PixelPaintLoop   
        LDA previousCursorXPositionZP
        CLC 
        ADC starOneXPosArray,Y
        STA pixelXPosition
        LDA previousPixelYPositionZP
        CLC 
        ADC starOneYPosArray,Y
        STA pixelYPosition

        TYA 
        PHA 

        JSR PaintPixelForCurrentSymmetry

        PLA 
        TAY 
        INY 

        LDA starOneXPosArray,Y
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

countToMatchCurrentIndex   .BYTE $01

;-------------------------------------------------------
; PutRandomByteInAccumulator
;-------------------------------------------------------
PutRandomByteInAccumulator   
randomByteAddress=$414E
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
        ; Has a pattern to paint on the Y axis
        ; symmetry so prepare for that.
        LDA #$28
        SEC 
        SBC pixelXPosition
        STA pixelXPosition

        JSR PaintPixel

        LDA currentSymmetrySettingForStep
        CMP #$01
        BEQ CleanUpAndReturnFromSymmetry

        LDA #$18
        SEC 
        SBC pixelYPosition
        STA pixelYPosition
        JSR PaintPixel

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

currentSymmetrySettingForStep   .BYTE $01
pixelXPositionArray   
        .BYTE $0F,$0E,$0D,$0C,$0B,$0A,$09,$04
        .BYTE $05,$06,$07,$08,$09,$0A,$0B,$0C
        .BYTE $0D,$0E,$0F,$10,$11,$12,$13,$14
        .BYTE $15,$16,$17,$14,$13,$12,$11,$10
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
pixelYPositionArray   
        .BYTE $0C,$0D,$0E,$0F,$0F,$0F,$0E,$04
        .BYTE $04,$04,$04,$04,$04,$04,$04,$05
        .BYTE $06,$07,$08,$09,$0A,$0B,$0C,$0D
        .BYTE $0D,$0D,$0D,$07,$09,$09,$0A,$0B
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
baseLevelArray   
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
initialFramesRemainingToNextPaintForStep   
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
framesRemainingToNextPaintForStep   
        .BYTE $04,$07,$01,$02,$03,$06,$07,$06
        .BYTE $0C,$02,$03,$06,$07,$01,$02,$02
        .BYTE $04,$04,$07,$01,$02,$03,$06,$07
        .BYTE $0C,$02,$03,$02,$03,$07,$01,$02
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00

;-------------------------------------------------------
; ReinitializeSequences
;-------------------------------------------------------
ReinitializeSequences   
        LDX #$00
        TXA 
b42D9   STA pixelXPositionArray,X
        STA pixelYPositionArray,X
        STA baseLevelArray,X
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X
        INX 
        CPX #$40
        BNE b42D9
        RTS 

;-------------------------------------------------------
; LaunchPsychedelia
;-------------------------------------------------------
LaunchPsychedelia   
        JSR ReinitializeSequences
        JSR SetUpIntteruptHandlers

;-------------------------------------------------------
; MainPaintLoop
;-------------------------------------------------------
MainPaintLoop   
        INC currentIndexToPixelBuffers
        LDA currentIndexToPixelBuffers
        AND maskForFireOffset
        STA currentIndexToPixelBuffers
        TAX 
        DEC framesRemainingToNextPaintForStep,X
        BNE GoBackToStartOfLoop

        LDA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X

        LDA baseLevelArray,X
        CMP #$FF
        BEQ GoBackToStartOfLoop

        STA baseLevelForCurrentPixel
        LDA pixelXPositionArray,X
        STA pixelXPosition
        LDA pixelYPositionArray,X
        STA pixelYPosition
        JSR LoopThroughPixelsAndPaint
        LDX currentIndexToPixelBuffers
        DEC baseLevelArray,X
GoBackToStartOfLoop   
        JMP MainPaintLoop

currentIndexToPixelBuffers   .BYTE $08 

;-------------------------------------------------------
; SetUpInterruptHandlers
;-------------------------------------------------------
SetUpIntteruptHandlers   
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
        CLI 
        RTS 

countStepsBeforeCheckingJoystickInput .BYTE $01
lastColorPainted                      .BYTE $00

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
        DEC countStepsBeforeCheckingJoystickInput
        BEQ b4353
        JMP RETURN_FROM_INTERRUPT

b4353   LDA #$02
        STA countStepsBeforeCheckingJoystickInput
        LDA #$00
        STA currentColorToPaint

        JSR PaintCursorAtCurrentPosition
        LDA $DC00    ;CIA1: Data Port Register A
        AND #$03
        CMP #$03
        BEQ CheckIfCursorMovedLeftOrRight

        CMP #$02
        BEQ PlayerHasPressedDown

        ; Player has pressed up. Incremeent up two lines
        ; so that when we decrement down one, we're still
        ; one up!
        INC cursorYPosition
        INC cursorYPosition

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

CheckIfCursorMovedLeftOrRight   
        LDA $DC00    ;CIA1: Data Port Register A
        AND #$0C
        CMP #$0C
        BEQ CheckIfPlayerPressedFire

        CMP #$08
        BEQ CursorMovedLeft

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
        LDA $DC00    ;CIA1: Data Port Register A
        AND #$10
        BEQ PlayerHasntPressedFire

        ; Player has pressed fire.
        LDA #$00
        STA stepsSincePressedFire
        JMP DrawCursorAndReturnFromInterrupt

PlayerHasntPressedFire   
        LDA stepsExceeded255
        BEQ b43D7
        LDA stepsSincePressedFire
        BNE DrawCursorAndReturnFromInterrupt

        INC stepsSincePressedFire
b43D7   SBC offsetSincePressedFire
        LDA offsetSincePressedFire
        AND maskForFireOffset
        STA offsetSincePressedFire

UpdateBaseLevelArray   
        TAX 
        LDA baseLevelArray,X
        CMP #$FF
        BNE DrawCursorAndReturnFromInterrupt

        LDA cursorXPosition
        STA pixelXPositionArray,X
        LDA cursorYPosition
        STA pixelYPositionArray,X
        LDA #$07
        STA baseLevelArray,X

        LDA smoothingDelay
        STA initialFramesRemainingToNextPaintForStep,X
        STA framesRemainingToNextPaintForStep,X

DrawCursorAndReturnFromInterrupt   
        JSR LoadXAndYOfCursorPosition
        LDA (currentLineInColorRamLoPtr),Y
        AND #$07
        STA lastColorPainted
        LDA #$01
        STA currentColorToPaint
        JSR PaintCursorAtCurrentPosition
        JMP RETURN_FROM_INTERRUPT

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
        RTS 

;-------------------------------------------------------
; PaintCursorAtCurrentPosition
;-------------------------------------------------------
PaintCursorAtCurrentPosition   
        JSR LoadXAndYOfCursorPosition
        LDA currentColorToPaint
        STA (currentLineInColorRamLoPtr),Y
        RTS 

cursorXPosition        .BYTE $1E
cursorYPosition        .BYTE $0D
offsetSincePressedFire .BYTE $1A
maskForFireOffset      .BYTE $1F
stepsSincePressedFire  .BYTE $00
stepsExceeded255       .BYTE $00
smoothingDelay         .BYTE $0C

        .BYTE $00,$00,$00,$00,$00,$00,$00
        .BYTE $5B,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $FF,$00,$00,$00,$00,$00,$00,$00
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
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00,$00
        .BYTE $00,$00,$00,$00,$00,$00,$00
.enc "petscii"  ;define an ascii->petscii encoding
        .cdef "..", $2E  ;characters
        .cdef "  ", $20  ;characters
        .cdef "AZ", $01
; The listing for this part is cut off so some
; of the text has to be restored.
bannerText   
        .TEXT $00,"PSYCHEDELIA...A FORETASTE BY JEFF MINTER"
.enc "none"

;-------------------------------------------------------
; InitializeScreenAndText
;-------------------------------------------------------
InitializeScreenAndText   
        JSR InitializeScreen

        LDX #$28
b452D   LDA bannerText,X
        STA SCREEN_RAM + $03BF,X
        LDA #$0C
        STA COLOR_RAM + $03BF,X
        DEX 
        BNE b452D
        RTS 

        .BYTE $00,$00,$00,$BF,$00,$9D,$00,$FF
        .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$DF
        .BYTE $FF,$FF,$FF,$FF,$00
