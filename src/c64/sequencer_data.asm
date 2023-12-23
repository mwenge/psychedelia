; SEQUENCER
; SHIFT-Q to program, Q to toggle on/off: Programming is as for the Burst Generators,
; but you have the freedom of 255 steps allowed played back at varying speeds via
; the Sequencer Speed control. You can leave the program mode in two ways: press
; SPACE, and next time you go back in with SHIFT-Q the stuff you already defined
; is not cleared and you add to the end of it, or press RETURN, and next time you
; go in the sequencer is cleared. Use the SPACE option to change pattern in
; mid-sequence, for example, or to ‘see how it looks so far’.
; -- Psychedelia Manual

startOfSequencerData = $C300
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
    .BYTE $0B

    ; Sequencer Position 1
    .BYTE $04,$04      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE PULSAR         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 2
    .BYTE $08,$09      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE PULSAR         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 3
    .BYTE $0C,$0C      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE PULSAR         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 4
    .BYTE $10,$11      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE PULSAR         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 5
    .BYTE $14,$13      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE PULSAR         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 6
    .BYTE $17,$13      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE PULSAR         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 7
    .BYTE $FF,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 8
    .BYTE $41,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 9
    .BYTE $06,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 10
    .BYTE $01,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 11
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 12
    .BYTE $00,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 13
    .BYTE $FF,$41      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $46          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 14
    .BYTE $00,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 15
    .BYTE $AA,$41      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 16
    .BYTE $00,$04      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $62          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 17
    .BYTE $FF,$41      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 18
    .BYTE $40,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $6B          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 19
    .BYTE $04,$C1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 20
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 21
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $42          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 22
    .BYTE $02,$AE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 23
    .BYTE $00,$07      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $1C          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 24
    .BYTE $80,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $05          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 25
    .BYTE $06,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 26
    .BYTE $07,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $05          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 27
    .BYTE $00,$85      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 28
    .BYTE $01,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $05          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 29
    .BYTE $02,$41      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 30
    .BYTE $00,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $03          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 31
    .BYTE $BD,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 32
    .BYTE $00,$BF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $C5          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 33
    .BYTE $BF,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 34
    .BYTE $42,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $40          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 35
    .BYTE $00,$40      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 36
    .BYTE $01,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 37
    .BYTE $02,$40      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 38
    .BYTE $05,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 39
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 40
    .BYTE $01,$20      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 41
    .BYTE $8D,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 42
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 43
    .BYTE $00,$BD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 44
    .BYTE $BD,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 45
    .BYTE $40,$BD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 46
    .BYTE $BD,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 47
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $F1          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 48
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $20          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 49
    .BYTE $81,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 50
    .BYTE $AE,$C3      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 51
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 52
    .BYTE $EE,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $AC          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 53
    .BYTE $C1,$FD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $D1          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 54
    .BYTE $24,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 55
    .BYTE $C1,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 56
    .BYTE $AE,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 57
    .BYTE $C5,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $41          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 58
    .BYTE $EC,$E1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 59
    .BYTE $C3,$37      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 60
    .BYTE $EE,$C1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 61
    .BYTE $C3,$AE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $C1          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 62
    .BYTE $AE,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 63
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 64
    .BYTE $FD,$05      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $DD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 65
    .BYTE $03,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $85          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 66
    .BYTE $EC,$C7      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $4C          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 67
    .BYTE $00,$60      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 68
    .BYTE $EC,$87      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 69
    .BYTE $81,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $8D          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 70
    .BYTE $62,$85      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 71
    .BYTE $85,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $87          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 72
    .BYTE $EA,$85      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 73
    .BYTE $83,$ED      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $42          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 74
    .BYTE $EF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 75
    .BYTE $40,$28      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 76
    .BYTE $EE,$C1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 77
    .BYTE $85,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 78
    .BYTE $FF,$85      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 79
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $A7          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 80
    .BYTE $BF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 81
    .BYTE $87,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 82
    .BYTE $FF,$A7      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 83
    .BYTE $01,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 84
    .BYTE $EE,$FD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 85
    .BYTE $FF,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 86
    .BYTE $00,$F7      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 87
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 88
    .BYTE $40,$46      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 89
    .BYTE $06,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 90
    .BYTE $00,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 91
    .BYTE $FF,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 92
    .BYTE $00,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 93
    .BYTE $06,$41      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 94
    .BYTE $00,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 95
    .BYTE $06,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 96
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 97
    .BYTE $06,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 98
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $41          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 99
    .BYTE $46,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 100
    .BYTE $01,$2A      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $41          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 101
    .BYTE $02,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $04          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 102
    .BYTE $6A,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $41          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 103
    .BYTE $06,$40      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 104
    .BYTE $4B,$04      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $89          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 105
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 106
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 107
    .BYTE $42,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 108
    .BYTE $01,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE PULSAR         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 109
    .BYTE $1C,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 110
    .BYTE $05,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 111
    .BYTE $02,$07      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 112
    .BYTE $05,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $05          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 113
    .BYTE $06,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 114
    .BYTE $05,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 115
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 116
    .BYTE $02,$BD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 117
    .BYTE $BF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 118
    .BYTE $C5,$BF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 119
    .BYTE $00,$42      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 120
    .BYTE $40,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $40          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 121
    .BYTE $06,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 122
    .BYTE $00,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $40          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 123
    .BYTE $FF,$45      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 124
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 125
    .BYTE $02,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $24          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 126
    .BYTE $00,$05      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 127
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 128
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 129
    .BYTE $00,$B9      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 130
    .BYTE $BD,$40      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 131
    .BYTE $81,$BD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 132
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 133
    .BYTE $F1,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 134
    .BYTE $20,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 135
    .BYTE $C1,$AE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $83          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 136
    .BYTE $EE,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 137
    .BYTE $81,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 138
    .BYTE $AC,$C1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 139
    .BYTE $C1,$24      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $C1          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 140
    .BYTE $FF,$C1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 141
    .BYTE $00,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 142
    .BYTE $FD,$C5      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 143
    .BYTE $C1,$EC      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $E1          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 144
    .BYTE $FF,$C3      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $37          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 145
    .BYTE $00,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $C1          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 146
    .BYTE $BF,$C3      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $AE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 147
    .BYTE $C1,$AE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 148
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 149
    .BYTE $00,$FD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 150
    .BYTE $DD,$03      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EA          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 151
    .BYTE $81,$EC      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $C7          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 152
    .BYTE $CC,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $60          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 153
    .BYTE $81,$EC      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $83          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 154
    .BYTE $EE,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 155
    .BYTE $85,$62      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 156
    .BYTE $EE,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 157
    .BYTE $87,$EA      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $85          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 158
    .BYTE $FD,$83      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $ED          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 159
    .BYTE $42,$EF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 160
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $28          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 161
    .BYTE $02,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 162
    .BYTE $FD,$85      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 163
    .BYTE $81,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $85          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 164
    .BYTE $EE,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 165
    .BYTE $85,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 166
    .BYTE $EE,$87      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 167
    .BYTE $81,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $A7          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 168
    .BYTE $FF,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 169
    .BYTE $80,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 170
    .BYTE $FF,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 171
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $F7          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 172
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 173
    .BYTE $BF,$40      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 174
    .BYTE $00,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 175
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 176
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $21          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 177
    .BYTE $06,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 178
    .BYTE $01,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 179
    .BYTE $BF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 180
    .BYTE $01,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 181
    .BYTE $06,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 182
    .BYTE $FF,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 183
    .BYTE $02,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 184
    .BYTE $41,$46      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 185
    .BYTE $06,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $2A          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 186
    .BYTE $01,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 187
    .BYTE $04,$62      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 188
    .BYTE $01,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $40          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 189
    .BYTE $00,$6B      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $04          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 190
    .BYTE $91,$BF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 191
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 192
    .BYTE $00,$42      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 193
    .BYTE $BF,$01      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 194
    .BYTE $07,$1C      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $80          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 195
    .BYTE $FF,$25      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE MULTICROSS         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 196
    .BYTE $01,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE PULSAR         ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 197
    .BYTE $02,$05      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 198
    .BYTE $85,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 199
    .BYTE $02,$05      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 200
    .BYTE $01,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 201
    .BYTE $06,$03      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 202
    .BYTE $00,$BF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 203
    .BYTE $BF,$C5      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 204
    .BYTE $01,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $42          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 205
    .BYTE $02,$40      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 206
    .BYTE $00,$06      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 207
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $02          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 208
    .BYTE $40,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $05          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 209
    .BYTE $02,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 210
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 211
    .BYTE $20,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $8D          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 212
    .BYTE $01,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 213
    .BYTE $00,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 214
    .BYTE $BD,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $B9          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 215
    .BYTE $00,$BD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $40          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 216
    .BYTE $BD,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 217
    .BYTE $81,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 218
    .BYTE $BF,$F9      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 219
    .BYTE $00,$28      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 220
    .BYTE $FF,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $AE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 221
    .BYTE $83,$AE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 222
    .BYTE $FF,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 223
    .BYTE $81,$AC      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $C1          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 224
    .BYTE $BD,$A1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $24          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 225
    .BYTE $C1,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $C1          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 226
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $AE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 227
    .BYTE $81,$BF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $C5          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 228
    .BYTE $EE,$C1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EC          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 229
    .BYTE $E1,$BF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $83          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 230
    .BYTE $3F,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 231
    .BYTE $C1,$BF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $E3          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 232
    .BYTE $AE,$C1      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $AE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 233
    .BYTE $20,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 234
    .BYTE $FF,$00      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BD          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 235
    .BYTE $05,$DD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $03          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 236
    .BYTE $EA,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EC          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 237
    .BYTE $C7,$4C      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 238
    .BYTE $68,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EC          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 239
    .BYTE $87,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 240
    .BYTE $EE,$AD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $62          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 241
    .BYTE $85,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $81          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 242
    .BYTE $EE,$87      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EA          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 243
    .BYTE $85,$FD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $83          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 244
    .BYTE $EC,$42      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 245
    .BYTE $00,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 246
    .BYTE $28,$02      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 247
    .BYTE $81,$BD      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $A5          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 248
    .BYTE $BF,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 249
    .BYTE $85,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $00          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 250
    .BYTE $BF,$AF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $BF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 251
    .BYTE $00,$EC      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $87          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 252
    .BYTE $FF,$81      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 253
    .BYTE $A7,$EE      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $01          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 254
    .BYTE $FF,$80      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $EE          ; Index to pattern in patternIndexArray   
    

    ; Sequencer Position 255
    .BYTE $FD,$FF      ; X/Y Co-ordinates: X/Y Position relative to cursor.   
    .BYTE $FF          ; Index to pattern in patternIndexArray   
    
    .BYTE $FF,$FF,$00,$F7,$00,$FF,$00,$BF
    .BYTE $40,$46,$00,$06,$00,$FF,$00,$06
    .BYTE $00,$FF,$A1,$06,$00,$06,$01,$06
    .BYTE $41,$FF,$00,$06,$01,$06,$01,$06
    .BYTE $00,$00,$FF,$06,$00,$02,$00,$FF
    .BYTE $41,$46,$00,$06,$81,$2A,$01,$02
    .BYTE $00,$04,$62,$FF,$41,$06,$40,$00
    .BYTE $6B,$04,$B1,$FB,$00,$FF,$00,$FF
    .BYTE $00,$42,$02,$B6,$01,$00,$07,$1C
    .BYTE $80,$FF,$25,$06,$01,$02,$07,$02
    .BYTE $05,$00,$85,$06,$01,$02,$05,$02
    .BYTE $01,$00,$00,$06,$03,$BD,$00,$BF
    .BYTE $00,$BF,$C5,$BF,$01,$00,$42,$02
    .BYTE $40,$00,$40,$06,$01,$FF,$00,$02
    .BYTE $40,$FF,$45,$02,$00,$02,$00,$00
    .BYTE $01,$A0,$00,$8F,$01,$00,$00,$00
    .BYTE $00,$00,$BD,$00,$BD,$00,$BD,$40
    .BYTE $BD,$81,$BD,$81,$FF,$00,$FD,$F1
    .BYTE $FF,$00,$20,$81,$FF,$81,$AC,$83
    .BYTE $EE,$00,$FF,$81,$EE,$81,$AC,$C1
    .BYTE $BD,$C1,$24,$C1,$FF,$C1,$FF,$00
    .BYTE $EE,$81,$FD,$C5,$AE,$C1,$EC,$E1
    .BYTE $BF,$C3,$3F,$00,$EE,$C1,$BF,$C3
    .BYTE $AE,$C1,$EE,$00,$FF,$00,$FF,$00
    .BYTE $FD,$85,$DD,$03,$EE,$85,$EC,$C7
    .BYTE $CC,$00,$E8,$81,$EC,$87,$EE,$81
    .BYTE $EE,$8D,$62,$81,$EE,$81,$EE,$87
    .BYTE $EA,$85,$FD,$83,$CC,$42,$EF,$00
    .BYTE $FF,$00,$28,$02,$EE,$C1,$FD,$85
    .BYTE $FF,$81,$FF,$85,$EE,$00,$FD,$85
    .BYTE $BF,$00,$EE,$87,$FF,$81,$FF,$87
    .BYTE $FE,$01,$FF,$80,$EE,$FD,$FF,$FF
    .BYTE $FF,$FF,$00,$F7,$00,$FF,$00,$BF
    .BYTE $40,$46,$00,$06,$00,$FF,$00,$06
    .BYTE $00,$FF,$11,$06,$00,$06,$01,$06
    .BYTE $41,$FF,$00,$06,$01,$06,$01,$06
    .BYTE $00,$00,$FF,$06,$00,$02,$00,$FF
    .BYTE $41,$46,$00,$06,$01,$AB,$41,$02
    .BYTE $00,$04,$62,$FF,$41,$06,$40,$00
    .BYTE $6B,$04,$91,$FF,$00,$FF,$00,$FF
    .BYTE $00,$42,$02,$27,$01,$00,$07,$1C
    .BYTE $00,$FF,$25,$06,$05,$02,$07,$02
    .BYTE $05,$00,$05,$06,$01,$02,$05,$02
    .BYTE $41,$00,$00,$06,$03,$BD,$00,$BF
    .BYTE $00,$BD,$C5,$BF,$01,$00,$42,$02
    .BYTE $41,$00,$40,$06,$01,$FF,$00,$02
    .BYTE $41,$FF,$45,$02,$00,$00,$00,$00
    .BYTE $01,$24,$00,$0D,$01,$00,$00,$00
    .BYTE $00,$00,$BD,$00,$FD,$00,$FD,$40
    .BYTE $BD,$81,$BD,$81,$FF,$00,$FF,$F1
    .BYTE $FF,$00,$20,$81,$FF,$81,$AE,$C3
    .BYTE $EE,$00,$FF,$81,$EE,$81,$AC,$C1
    .BYTE $FD,$81,$24,$C1,$FF,$C1,$FF,$00
    .BYTE $EE,$81,$FF,$C5,$EE,$41,$EC,$E1
    .BYTE $FF,$C3,$37,$00,$EE,$C1,$BF,$C3
    .BYTE $A6,$C1,$A6,$00,$FF,$00,$FF,$00
    .BYTE $BF,$05,$FD,$03,$EA,$85,$EC,$C7
    .BYTE $DD,$00,$60,$81,$EC,$87,$EE,$81
    .BYTE $EE,$85,$62,$81,$EE,$81,$EE,$87
    .BYTE $EA,$85,$FD,$83,$EC,$40,$EF,$00
    .BYTE $FF,$00,$28,$02,$EA,$C1,$AC,$85
    .BYTE $BF,$81,$FF,$85,$EE,$00,$FF,$C7
    .BYTE $BF,$00,$EE,$87,$FF,$81,$FF,$87
    .BYTE $FE,$01,$FF,$00,$EE,$FD,$FF,$FF
    .BYTE $FF
