;
; **** PREDEFINED LABELS **** 
;
DOSVEC = $000A
VDSLST = $0200
SDMCTL = $022F
SDLSTL = $0230
SDLSTH = $0231
COLDST = $0244
GPRIOR = $026F
STICK0 = $0278
STICK1 = $0279
STRIG0 = $0284
STRIG1 = $0285
BOTSCR = $02BF
PCOLR0 = $02C0
COLOR2 = $02C6
COLOR4 = $02C8
inputCharacter = $02FC
PRNBUF = $03C0
CIOV = $E456
SETBV = $E45C
XITBV = $E462
WARMSV = $E474

; Keycodes
KEY_A  = $3F
KEY_B  = $15
KEY_C  = $12
KEY_D  = $3A
KEY_E  = $2A
KEY_F  = $38
KEY_G  = $3D
KEY_H  = $39
KEY_I  = $0D
KEY_J  = $01
KEY_K  = $05
KEY_L  = $00
KEY_M  = $25
KEY_N  = $23
KEY_O  = $08
KEY_P  = $0A
KEY_Q  = $2F
KEY_R  = $28
KEY_S  = $3E
KEY_T  = $2D
KEY_U  = $0B
KEY_V  = $10
KEY_W  = $2E
KEY_X  = $16
KEY_Y  = $2B
KEY_Z  = $17
KEY_0  = $32
KEY_1  = $1F
KEY_2  = $1E
KEY_3  = $1A
KEY_4  = $18
KEY_5  = $1D
KEY_6  = $1B
KEY_7  = $33
KEY_8  = $35
KEY_9  = $30
KEY_HELP  = $11
KEY_DOWN  = $8F
KEY_LEFT  = $86
KEY_RIGHT  = $87
KEY_UP  = $8E
KEY_BACKSPACE  = $34
KEY_DELETE_CHAR  = $B4
KEY_DELETE_LINE  = $74
KEY_INSERT_CHAR  = $B7
KEY_INSERT_LINE  = $77
KEY_ESCAPE  = $1C
KEY_ATARI  = $27
KEY_CAPSLOCK  = $7C
KEY_CAPSTOGGLE  = $3C
KEY_TAB  = $2C
KEY_SETTAB  = $6C
KEY_CLRTAB  = $AC
KEY_RETURN  = $0C
KEY_SPACE  = $21
KEY_EXCLAMATION  = $5F
KEY_DBLQUOTE  = $5E
KEY_HASH  = $5A
KEY_DOLLAR  = $58
KEY_PERCENT  = $5D
KEY_AMPERSAND  = $5B
KEY_QUOTE  = $73
KEY_AT  = $75
KEY_PARENLEFT  = $70
KEY_PARENRIGHT  = $72
KEY_LESS  = $36
KEY_GREATER  = $37
KEY_EQUAL  = $0F
KEY_QUESTION  = $66
KEY_MINUS  = $0E
KEY_PLUS  = $06
KEY_ASTERISK  = $07
KEY_SLASH  = $26
KEY_COLON  = $42
KEY_SEMICOLON  = $02
KEY_COMMA  = $20
KEY_FULLSTOP  = $22
KEY_UNDERSCORE  = $4E
KEY_BRACKETLEFT  = $60
KEY_BRACKETRIGHT  = $62
KEY_CIRCUMFLEX  = $47
KEY_BACKSLASH  = $46
KEY_BAR  = $4F
KEY_F1  = $03
KEY_F2  = $04
KEY_F3  = $13
KEY_F4  = $14

KEY_SHIFT = $40
KEY_CTRL = $80
KEY_SHIFT_Z = KEY_SHIFT | KEY_Z

; MODE STATES
FOREGROUND_GRAPHICS_ON = $02
FOREGROUND_GRAPHICS_OFF = $01
START_PARM_SAVE = $03
START_PARM_LOAD = $04
START_DYNAMICS_SAVE = $05
START_DYNAMICS_LOAD = $06

; Colors
BLACK0 = $00
BLACK1 = $01
BLACK2 = $02
BLACK3 = $03
BLACK4 = $04
BLACK5 = $05
BLACK6 = $06
BLACK7 = $07
BLACK8 = $08
BLACK9 = $09
BLACK10 = $0A
BLACK11 = $0B
BLACK12 = $0C
BLACK13 = $0D
BLACK14 = $0E
BLACK15 = $0F
RUST0 = $10
RUST1 = $11
RUST2 = $12
RUST3 = $13
RUST4 = $14
RUST5 = $15
RUST6 = $16
RUST7 = $17
RUST8 = $18
RUST9 = $19
RUST10 = $1A
RUST11 = $1B
RUST12 = $1C
RUST13 = $1D
RUST14 = $1E
RUST15 = $1F
RED_ORANGE0 = $20
RED_ORANGE1 = $21
RED_ORANGE2 = $22
RED_ORANGE3 = $23
RED_ORANGE4 = $24
RED_ORANGE5 = $25
RED_ORANGE6 = $26
RED_ORANGE7 = $27
RED_ORANGE8 = $28
RED_ORANGE9 = $29
RED_ORANGE10 = $2A
RED_ORANGE11 = $2B
RED_ORANGE12 = $2C
RED_ORANGE13 = $2D
RED_ORANGE14 = $2E
RED_ORANGE15 = $2F
DARK_ORANGE0 = $30
DARK_ORANGE1 = $31
DARK_ORANGE2 = $32
DARK_ORANGE3 = $33
DARK_ORANGE4 = $34
DARK_ORANGE5 = $35
DARK_ORANGE6 = $36
DARK_ORANGE7 = $37
DARK_ORANGE8 = $38
DARK_ORANGE9 = $39
DARK_ORANGE10 = $3A
DARK_ORANGE11 = $3B
DARK_ORANGE12 = $3C
DARK_ORANGE13 = $3D
DARK_ORANGE14 = $3E
DARK_ORANGE15 = $3F
RED0 = $40
RED1 = $41
RED2 = $42
RED3 = $43
RED4 = $44
RED5 = $45
RED6 = $46
RED7 = $47
RED8 = $48
RED9 = $49
RED10 = $4A
RED11 = $4B
RED12 = $4C
RED13 = $4D
RED14 = $4E
RED15 = $4F
DARK_LAVENDER0 = $50
DARK_LAVENDER1 = $51
DARK_LAVENDER2 = $52
DARK_LAVENDER3 = $53
DARK_LAVENDER4 = $54
DARK_LAVENDER5 = $55
DARK_LAVENDER6 = $56
DARK_LAVENDER7 = $57
DARK_LAVENDER8 = $58
DARK_LAVENDER9 = $59
DARK_LAVENDER10 = $5A
DARK_LAVENDER11 = $5B
DARK_LAVENDER12 = $5C
DARK_LAVENDER13 = $5D
DARK_LAVENDER14 = $5E
DARK_LAVENDER15 = $5F
COBALT_BLUE0 = $60
COBALT_BLUE1 = $61
COBALT_BLUE2 = $62
COBALT_BLUE3 = $63
COBALT_BLUE4 = $64
COBALT_BLUE5 = $65
COBALT_BLUE6 = $66
COBALT_BLUE7 = $67
COBALT_BLUE8 = $68
COBALT_BLUE9 = $69
COBALT_BLUE10 = $6A
COBALT_BLUE11 = $6B
COBALT_BLUE12 = $6C
COBALT_BLUE13 = $6D
COBALT_BLUE14 = $6E
COBALT_BLUE15 = $6F
ULTRAMARINE_BLUE0 = $70
ULTRAMARINE_BLUE1 = $71
ULTRAMARINE_BLUE2 = $72
ULTRAMARINE_BLUE3 = $73
ULTRAMARINE_BLUE4 = $74
ULTRAMARINE_BLUE5 = $75
ULTRAMARINE_BLUE6 = $76
ULTRAMARINE_BLUE7 = $77
ULTRAMARINE_BLUE8 = $78
ULTRAMARINE_BLUE9 = $79
ULTRAMARINE_BLUE10 = $7A
ULTRAMARINE_BLUE11 = $7B
ULTRAMARINE_BLUE12 = $7C
ULTRAMARINE_BLUE13 = $7D
ULTRAMARINE_BLUE14 = $7E
ULTRAMARINE_BLUE15 = $7F
MEDIUM_BLUE0 = $80
MEDIUM_BLUE1 = $81
MEDIUM_BLUE2 = $82
MEDIUM_BLUE3 = $83
MEDIUM_BLUE4 = $84
MEDIUM_BLUE5 = $85
MEDIUM_BLUE6 = $86
MEDIUM_BLUE7 = $87
MEDIUM_BLUE8 = $88
MEDIUM_BLUE9 = $89
MEDIUM_BLUE10 = $8A
MEDIUM_BLUE11 = $8B
MEDIUM_BLUE12 = $8C
MEDIUM_BLUE13 = $8D
MEDIUM_BLUE14 = $8E
MEDIUM_BLUE15 = $8F
DARK_BLUE0 = $90
DARK_BLUE1 = $91
DARK_BLUE2 = $92
DARK_BLUE3 = $93
DARK_BLUE4 = $94
DARK_BLUE5 = $95
DARK_BLUE6 = $96
DARK_BLUE7 = $97
DARK_BLUE8 = $98
DARK_BLUE9 = $99
DARK_BLUE10 = $9A
DARK_BLUE11 = $9B
DARK_BLUE12 = $9C
DARK_BLUE13 = $9D
DARK_BLUE14 = $9E
DARK_BLUE15 = $9F
DARK_BLUE16 = $A0
DARK_BLUE17 = $A1
DARK_BLUE18 = $A2
DARK_BLUE19 = $A3
DARK_BLUE20 = $A4
DARK_BLUE21 = $A5
BLUE_GREY0 = $A6
BLUE_GREY1 = $A7
BLUE_GREY2 = $A8
BLUE_GREY3 = $A9
BLUE_GREY4 = $AA
BLUE_GREY5 = $AB
BLUE_GREY6 = $AC
BLUE_GREY7 = $AD
BLUE_GREY8 = $AE
BLUE_GREY9 = $AF
OLIVE_GREEN0 = $B0
OLIVE_GREEN1 = $B1
OLIVE_GREEN2 = $B2
OLIVE_GREEN3 = $B3
OLIVE_GREEN4 = $B4
OLIVE_GREEN5 = $B5
OLIVE_GREEN6 = $B6
OLIVE_GREEN7 = $B7
OLIVE_GREEN8 = $B8
OLIVE_GREEN9 = $B9
OLIVE_GREEN10 = $BA
OLIVE_GREEN11 = $BB
OLIVE_GREEN12 = $BC
OLIVE_GREEN13 = $BD
OLIVE_GREEN14 = $BE
OLIVE_GREEN15 = $BF
MEDIUM_GREEN0 = $C0
MEDIUM_GREEN1 = $C1
MEDIUM_GREEN2 = $C2
MEDIUM_GREEN3 = $C3
MEDIUM_GREEN4 = $C4
MEDIUM_GREEN5 = $C5
MEDIUM_GREEN6 = $C6
MEDIUM_GREEN7 = $C7
MEDIUM_GREEN8 = $C8
MEDIUM_GREEN9 = $C9
MEDIUM_GREEN10 = $CA
MEDIUM_GREEN11 = $CB
MEDIUM_GREEN12 = $CC
MEDIUM_GREEN13 = $CD
MEDIUM_GREEN14 = $CE
MEDIUM_GREEN15 = $CF
DARK_GREEN0 = $D0
DARK_GREEN1 = $D1
DARK_GREEN2 = $D2
DARK_GREEN3 = $D3
DARK_GREEN4 = $D4
DARK_GREEN5 = $D5
DARK_GREEN6 = $D6
DARK_GREEN7 = $D7
DARK_GREEN8 = $D8
DARK_GREEN9 = $D9
DARK_GREEN10 = $DA
DARK_GREEN11 = $DB
DARK_GREEN12 = $DC
DARK_GREEN13 = $DD
DARK_GREEN14 = $DE
DARK_GREEN15 = $DF
ORANGE_GREEN0 = $E0
ORANGE_GREEN1 = $E1
ORANGE_GREEN2 = $E2
ORANGE_GREEN3 = $E3
ORANGE_GREEN4 = $E4
ORANGE_GREEN5 = $E5
ORANGE_GREEN6 = $E6
ORANGE_GREEN7 = $E7
ORANGE_GREEN8 = $E8
ORANGE_GREEN9 = $E9
ORANGE_GREEN10 = $EA
ORANGE_GREEN11 = $EB
ORANGE_GREEN12 = $EC
ORANGE_GREEN13 = $ED
ORANGE_GREEN14 = $EE
ORANGE_GREEN15 = $EF
ORANGE0 = $F0
ORANGE1 = $F1
ORANGE2 = $F2
ORANGE3 = $F3
ORANGE4 = $F4
ORANGE5 = $F5
ORANGE6 = $F6
ORANGE7 = $F7
ORANGE8 = $F8
ORANGE9 = $F9
ORANGE10 = $FA
ORANGE11 = $FB
ORANGE12 = $FC
ORANGE13 = $FD
ORANGE14 = $FE
ORANGE15 = $FF

CCKEYS___COLOURS = $00
CCKEYS__OOZE_RATES = $01
CCKEYS__OOZE_STEPS = $02
CCKEYS_OOZE_CYCLES = $03

; Status line constants
THE_TWIST = $00
THE_SMOOTH_CROSSFLOW = $01
THE_DENTURES = $02
DELTOIDS = $03
PULSAR_CROSSES = $04
SLOTHFUL_MULTICROSS = $05
CROSS_AND_A_BIT = $06
STAR2_SMALL_AND_FAST = $07
NO_SYMMETRY_AT_ALL = $08
BUGGER_OFF_NOSEY = $09
X_Y_SYMMETRY = $0A
X_AXIS_SYMMETRY = $0B
QUAD_MODE_SYMMETRY = $0C
VARIABLE_RESOLUTION = $0D
HIRES_HARD_REFLECT = $0E
CURVED_COLOURSPACE_1 = $0F
CURVED_COLOURSPACE_2 = $10
CURVE_HARD_REFLECT = $11
HOOPY_4X_CURVYREFLEX = $12
ZARJAZ_INTERLACE_RES = $13
STROBOSCOPICS_ON = $14
STROBOSCOPICS_OFF = $15
STROBO_ZAP_RATE_000 = $16
BASE_COLOUR_0__000 = $17
OOZE_RATE_0__000 = $18
OOZE_STEP_0__000 = $19
OOZE_CYCLE_0__000 = $1A
CKEYS___COLOURS = $1B
CKEYS__OOZE_RATES = $1C
CKEYS__OOZE_STEPS = $1D
CKEYS_OOZE_CYCLES = $1E
COLOURFLOW_RESYNCHED = $1F
PULSE_FLOW_RATE_000 = $20
SPEED_BOOST___000 = $21
CURSOR_SPEED__000 = $22
EIGHT_WAY_MODE_ENGAGED = $23
VECTOR_MODE_ENGAGED = $24
LOGIC_TRACKING_OFF = $25
LOGIC_TRACKING_ON = $26
SMOOTHING_DELAY_000 = $27
BUFFER_LENGTH__000 = $28
RUNNING_PRESET_000 = $29
STASHING_PRESET_000 = $2A
PULSE_WIDTH___000 = $2B
RUN_PRESET_BANK_000 = $2C
RECORDING_INITIATED = $2D
PLAYBACK_INITIATED = $2E
T_E_R_M_I_N_A_T_E_D = $2F
ZARJAZ_SLOTH_DISABLE = $30
ZARJAZ_SLOTH_ENABLE = $31
MIX_RECLIVE_PLAY = $32
MIXED_MODE_OFF = $33
DUAL_INPUT_MODE_ON = $34
USER_LIGHTFORM_000 = $35
LEVEL_0__FREE_000 = $36
AUTO_DEMO_MODE_ON = $37
PIXEL_COLOUR__000 = $38
COLOUR_0__FREE_000 = $39
STATUS_DISPLAYS_ON = $3A
SIML_ADDER_VALUE000 = $3B
NORMAL_PATTERN_MODE = $3C
EXPLOSION_MODE_ON = $3D
Y_AXIS_SYMMETRY = $3E

; #THE_TWIST = $00
; #THE_SMOOTH_CROSSFLOW = $01
; #THE_DENTURES = $02
; #DELTOIDS = $03
; #PULSAR_CROSSES = $04
; #SLOTHFUL_MULTICROSS = $05
; #CROSS_AND_A_BIT = $06
; #STAR2_SMALL_AND_FAST = $07
; #NO_SYMMETRY_AT_ALL = $08
; #BUGGER_OFF_NOSEY = $09
; #X_Y_SYMMETRY = $0A
; #X_AXIS_SYMMETRY = $0B
; #QUAD_MODE_SYMMETRY = $0C
; #VARIABLE_RESOLUTION = $0D
; #HIRES_HARD_REFLECT = $0E
; #CURVED_COLOURSPACE_1 = $0F
; #CURVED_COLOURSPACE_2 = $10
; #CURVE_HARD_REFLECT = $11
; #HOOPY_4X_CURVYREFLEX = $12
; #ZARJAZ_INTERLACE_RES = $13
; #STROBOSCOPICS_ON = $14
; #STROBOSCOPICS_OFF = $15
; #STROBO_ZAP_RATE_000 = $16
; #BASE_COLOUR_0__000 = $17
; #OOZE_RATE_0__000 = $18
; #OOZE_STEP_0__000 = $19
; #OOZE_CYCLE_0__000 = $1A
; #CKEYS___COLOURS = $1B
; #CKEYS__OOZE_RATES = $1C
; #CKEYS__OOZE_STEPS = $1D
; #CKEYS_OOZE_CYCLES = $1E
; #COLOURFLOW_RESYNCHED = $1F
; #PULSE_FLOW_RATE_000 = $20
; #SPEED_BOOST___000 = $21
; #CURSOR_SPEED__000 = $22
; #EIGHT_WAY_MODE_ENGAGED = $23
; #VECTOR_MODE_ENGAGED = $24
; #LOGIC_TRACKING_OFF = $25
; #LOGIC_TRACKING_ON = $26
; #SMOOTHING_DELAY_000 = $27
; #BUFFER_LENGTH__000 = $28
; #RUNNING_PRESET_000 = $29
; #STASHING_PRESET_000 = $2A
; #PULSE_WIDTH___000 = $2B
; #RUN_PRESET_BANK_000 = $2C
; #RECORDING_INITIATED = $2D
; #PLAYBACK_INITIATED = $2E
; #T_E_R_M_I_N_A_T_E_D = $2F
; #ZARJAZ_SLOTH_DISABLE = $30
; #ZARJAZ_SLOTH_ENABLE = $31
; #MIX_RECLIVE_PLAY = $32
; #MIXED_MODE_OFF = $33
; #DUAL_INPUT_MODE_ON = $34
; #USER_LIGHTFORM_000 = $35
; #LEVEL_0__FREE_000 = $36
; #AUTO_DEMO_MODE_ON = $37
; #PIXEL_COLOUR__000 = $38
; #COLOUR_0__FREE_000 = $39
; #STATUS_DISPLAYS_ON = $3A
; #SIML_ADDER_VALUE000 = $3B
; #NORMAL_PATTERN_MODE = $3C
; #EXPLOSION_MODE_ON = $3D
; #Y_AXIS_SYMMETRY = $3E
; #

DRAW_FOREGROUND = $02
CLEAR_FOREGROUND = $03
FOREGROUND_POINT_SELECTED = $03
FOREGROUND_POINT_RECORDED = $01
DELETE_FOREGROUND_POINT = $02
; #FOREGROUND_POINT_RECORDED = $01
; #DELETE_FOREGROUND_POINT = $02
; #FOREGROUND_POINT_SELECTED = $03
; #CLEAR_FOREGROUND = $03
; #DRAW_FOREGROUND = $02

; Screen modes

HIRES_HARD_REFLECT_MODE = $01
CURVED_COLOURSPACE_1_MODE = $02
CURVED_COLOURSPACE_2_MODE = $03
CURVE_HARD_REFLECT_MODE = $04
HOOPY_4X_CURVYREFLEX_MODE = $05
ZARJAZ_INTERLACE_RES_MODE = $06

; #HIRES_HARD_REFLECT_MODE = $01
; #CURVED_COLOURSPACE_1_MODE = $02
; #CURVED_COLOURSPACE_2_MODE = $03
; #CURVE_HARD_REFLECT_MODE = $04
; #HOOPY_4X_CURVYREFLEX_MODE = $05
; #ZARJAZ_INTERLACE_RES_MODE = $06

DEMO_DISABLED = $00
DEMO_ENABLED = $03
RECORDING_ENABLED = $01
PLAYBACK_ENABLED = $02

