
;----------------------------------------------------------------------------
; This is the main data driving the sequences in
; Psychedelia. It's copied from this position to $C000
; (presetSequenceData)  when the game is loaded.
;
; The data for the 16 presets. Each chunk contains the following values:
;  unusedPresetByte  
;  smoothingDelay                       
;  cursorSpeed            
;  bufferLength                    
;  displayCursorInitialValue       
;  indexForColorBarDisplay       
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
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0C
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $1F
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $01
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $04
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $00
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $00
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $00
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $01
        ; Unused Data.
        .BYTE $FF,$00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset1
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0C
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $28
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $0E
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $08
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BROWN,RED,ORANGE,PURPLE,LTRED,BLUE,LTBLUE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $01
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $01
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $04
        ; Unused Data.
        .BYTE $FF,$00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset2
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0B
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $28
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $01
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $0B
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BLUE,LTBLUE,CYAN,LTGREEN,GREEN,LTBLUE,BLUE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $05
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $05
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $01
        ; Unused Data.
        .BYTE $FF,$00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset3
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $04
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $26
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $01
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $0A
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,RED,PURPLE,LTRED,LTGREEN,CYAN,LTBLUE,BLUE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $00
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $0E
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $0E
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $02
        ; Unused Data.
        .BYTE $FF,$00,$FF,$FF,$00,$FF,$00,$EA,$10
;preset4
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0C
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $01
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $2B
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $07
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $08
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,GRAY1,BLUE,GRAY2,PURPLE,GRAY3,CYAN,WHITE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $00
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $01
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $01
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $01
        ; Unused Data.
        .BYTE $00,$FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset5
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0C
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $2B
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $07
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $0C
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,GRAY1,BLUE,GRAY2,PURPLE,GRAY3,CYAN,WHITE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $00
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $06
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $06
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $03
        ; Unused Data.
        .BYTE $00,$FF,$00,$00,$FF,$00,$FF,$00,$F7
;preset6
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0F
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $3F
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $01
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $0F
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $03
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $03
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $04
        ; Unused Data.
        .BYTE $00,$FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset7
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0B
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $01
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $1C
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $02
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $0A
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $09
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,YELLOW,CYAN,LTBLUE,BLUE,RED,PURPLE,LTRED
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $00
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $07
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $07
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $01
        ; Unused Data.
        .BYTE $00,$FF,$00,$00,$FF,$00,$FF,$15,$EF
;preset8
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $04
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $01
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $28
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $02
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $01
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $0A
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,ORANGE,BROWN,GREEN,CYAN,LTGREEN,LTBLUE,BLUE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $01
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $01
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $03
        ; Unused Data.
        .BYTE $FF,$00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset9
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $11
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $01
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $0D
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $07
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $01
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $0C
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BLUE,CYAN,BLUE,CYAN,BLUE,CYAN,BLUE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $07
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $07
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $04
        ; Unused Data.
        .BYTE $FF,$00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset10
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $01
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $1F
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $02
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $09
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $04
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $08
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BLUE,RED,RED,PURPLE,LTRED,ORANGE,BROWN
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $01
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $00
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $00
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $04
        ; Unused Data.
        .BYTE $FF,$00,$FF,$FF,$00,$FF,$00,$FF,$00
;preset11
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $01
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $01
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $13
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $06
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $01
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $08
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $05
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $0F
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $0F
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $04
        ; Unused Data.
        .BYTE $FF,$00,$FF,$FF,$00,$FF,$00,$EA,$10
;preset12
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0C
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $28
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $02
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $09
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BLUE,LTBLUE,CYAN,LTGREEN,YELLOW,PURPLE,RED
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $00
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $0A
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $0A
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $01
        ; Unused Data.
        .BYTE $00,$FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset13
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0B
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $01
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $1C
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $02
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $0A
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $09
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,YELLOW,CYAN,LTBLUE,BLUE,RED,PURPLE,LTRED
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $00
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $03
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $03
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $04
        ; Unused Data.
        .BYTE $00,$FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset14
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $0C
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $02
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $2B
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $01
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $0A
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $08
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,RED,BROWN,ORANGE,PURPLE,RED,YELLOW,LTRED
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $04
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $04
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $02
        ; Unused Data.
        .BYTE $00,$FF,$00,$00,$FF,$00,$FF,$00,$FF
;preset15
        ; unusedPresetByte: Unused Byte
        .BYTE $00
        ; smoothingDelay: 'Because of the time taken to draw larger patterns speed
        ; increase/decrease is not linear. You can adjust the ‘compensating delay’
        ; which often smooths out jerky patterns. Can be used just for special FX),
        ; though. Suck it and see.'
        .BYTE $03
        ; cursorSpeed: 'Gives you a slow or fast little cursor, according to setting.'
        .BYTE $01
        ; bufferLength: 'Larger patterns flow more smoothly with a shorter
        ; Buffer Length - not so many positions are retained so less plotting to do.
        ; Small patterns with a long Buffer Length are good for ‘steamer’ effects.
        ; N.B. Cannot be adjusted whilst patterns are actually onscreen.'
        .BYTE $1F
        ; pulseSpeed: 'Usually if you hold down the button you get a continuous
        ; stream. Setting the Pulse Speed allows you to generate a pulsed stream, as
        ; if you were rapidly pressing and releasing the FIRE button.'
        .BYTE $06
        ; indexForColorBarDisplay: 'The initial index for the color displayed
        ; in the color bar when adjusting the colors for each step.'
        .BYTE $01
        ; lineWidth: 'Sets the width of the lines produced in Line Mode.'
        .BYTE $07
        ; sequencerSpeed: 'Controls the rate at which sequencer feeds in its data. '
        .BYTE $00
        ; pulseWidth: 'Sets the length of the pulses in a pulsed stream output.
        ; Don’t worry about what that means - just get in there and mess with it.'
        .BYTE $01
        ; baseLevel: 'Controls how many ‘levels’ of pattern are plotted.'
        .BYTE $07
        ; presetColorValuesArray: 'Allows you to set the colour for each of the
        ; seven pattern steps. Set up the colour you want, press RETURN, and the
        ; command offers the next colour along, up to no. 7, then ends. Cannot be
        ; adjusted while patterns being generated.'
        .BYTE BLACK,BLUE,RED,PURPLE,GREEN,CYAN,YELLOW,WHITE
        ; trackingActivated: 'Controls whether logic-seeking is used in the
        ; buffer or not. The upshot of this for you is a slightly different feel -
        ; continuous but fragmented when ON, or together-ish bursts when OFF. Try it.'
        .BYTE $FF
        ; lineModeActivated: 'A bit like drawing with the Aurora Borealis'
        .BYTE $00
        ; patternIndex: 'This calls in one of the 16 presets, stored Lightsynth
        ; parameters which give different effects. Try them all out io see some uf
        ; the multitude of effects which you cai achieve using the system. Some are
        ; fast, some slow, some pulse, others swirl. Play with them all, try them to
        ; different music.'
        .BYTE $04
        ; currentPatternElement: 'Initial pattern used by this preset.'
        .BYTE $04
        ; currentSymmetrySetting: 'Current symmetry setting.'
        ; Possible values are 0 - 4:
        ; 'NO SYMMETRY     '
        ; 'Y-AXIS SYMMETRY '
        ; 'X-Y SYMMETRY    '
        ; 'X-AXIS SYMMETRY '
        ; 'QUAD SYMMETRY   '
        .BYTE $04
        ; Unused Data.
        .BYTE $00,$FF,$00,$00,$FF,$00,$FF,$15,$EF
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
