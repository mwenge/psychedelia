; "BURST GENERATORS
; SHIFT plus fkey to program, fkey alone to activate. These allow you to
; preprogram and recall at will instantaneous flashes on the screen. Set up
; symmetry and smoothing delay as required, then press SHIFT plus the fkey to
; which you want to assign your FX. Move the cursor to where you want a burst
; then press Left-Arrow to enter that point. Do this up to 16 times. Press
; RETURN when done. Pressing the fkey thus assigned stuffs all the points you
; defined into the buffer instantaneously. Don’t worry about it - try the ones
; I've defined!"
; -- Psychedelia Manual

; These are the default burst generators the manual is referring to.

; Notes on the data structure:
; - An $FF in the first byte of 'X/y Co-ordinates' indicates the end of the data, e.g.
;   in 'Burst Position 4' below.
; burstGeneratorF1
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $01
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX)
        ; though. Suck it and see.'
        .BYTE $0C

        ; Burst Position 1
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $07,$06
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $07

        ; Burst Position 2
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $11,$0D
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $07

        ; Burst Position 3
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$11
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $07

        ; Burst Position 4
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$0B
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $07

        ; Burst Position 5
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $FF

        ; Burst Position 6
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $21,$06
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00

        ; Burst Position 7
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $06

        ; Burst Position 8
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $41,$FF
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00

        ; Burst Position 9
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $06

        ; Burst Position 10
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $01,$06
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00

; burstGeneratorF2
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $01
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX)
        ; though. Suck it and see.'
        .BYTE $0C

        ; Burst Position 1
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $13,$08
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00

        ; Burst Position 2
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $07,$0F
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00

        ; Burst Position 3
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $06

        ; Burst Position 4
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $01,$2A
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $41

        ; Burst Position 5
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$00
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $04

        ; Burst Position 6
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $62,$FF
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $41

        ; Burst Position 7
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$40
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00

        ; Burst Position 8
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $6B,$04
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $41

        ; Burst Position 9
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $FF

        ; Burst Position 10
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$FF
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00

; burstGeneratorF3
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $04
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX)
        ; though. Suck it and see.'
        .BYTE $01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$03
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$03
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$03
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $02

; burstGeneratorF4
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX)
        ; though. Suck it and see.'
        .BYTE $11
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $12,$09
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $12,$09
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$08
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $03
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$08
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $03
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$08
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $03
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$FF
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$00
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $01,$24
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $05,$01
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$00
        ; Index to pattern in pixelXPositionLoPtrArray/pixelXPositionHiPtrArray
        .BYTE $00

