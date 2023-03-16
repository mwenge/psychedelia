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
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0C
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $07,$06
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $07,$11
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $0D,$07
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$11
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $07,$FF
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $0B,$07
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$21
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$41
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$00

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
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0C
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $13,$08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$07
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $0F,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $2A,$41
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $04,$62
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$41
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $06,$40
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$6B
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $04,$41
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00

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
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$FF
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $01,$02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $01,$02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $01,$02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$FF
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $03,$02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$03
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $03,$02

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
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $11
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $12,$09
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$12
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $09,$08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $03,$02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $08,$03
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $02,$08
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $03,$02
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $FF,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $24,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $05,$01
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$00
        ; X/Y Co-ordinates: X/Y Position relative to cursor to place the burst.
        .BYTE $00,$00

