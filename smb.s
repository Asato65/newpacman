;===============================================================
;		Music file for NES Sound Driver & Library
;			for assembly language (ca65.exe)
;===============================================================

	.export		MARIOBGM0
	.export		MARIOBGM1
	.export		MARIOBGM2
	.export		MARIOSE0
	.export		MARIOSE1
	.export		MARIOSE2
	.export		MARIOSE3


.segment	"RODATA"
MARIOEnvelope0:
	.byte	$00 ,$02 ,$01 ,$08 ,$81 ,$00 ,$c5
MARIOEnvelope1:
	.byte	$00 ,$02 ,$01 ,$08 ,$07 ,$06 ,$05 ,$80 ,$04 ,$80 ,$00 ,$ca
MARIOEnvelope2:
MARIOSUB0:
	.byte	$3c
	.byte	$84
	.byte	$84
	.byte	$8f
	.byte	$84
	.byte	$8f
	.byte	$80
	.byte	$84
	.byte	$8f
	.byte	$87
	.byte	$af ,$12
	.byte	$af ,$18
	.byte	$00
MARIOSUB1:
	.byte	$3c
	.byte	$80
	.byte	$af ,$0c
	.byte	$28
	.byte	$87
	.byte	$af ,$0c
	.byte	$84
	.byte	$8f
	.byte	$8f
	.byte	$89
	.byte	$8f
	.byte	$8b
	.byte	$8f
	.byte	$8a
	.byte	$89
	.byte	$8f
	.byte	$4a
	.byte	$87
	.byte	$29
	.byte	$84
	.byte	$87
	.byte	$4b
	.byte	$89
	.byte	$8f
	.byte	$85
	.byte	$87
	.byte	$8f
	.byte	$84
	.byte	$8f
	.byte	$80
	.byte	$82
	.byte	$28
	.byte	$8b
	.byte	$af ,$0c
	.byte	$00
MARIOSUB2:
	.byte	$3c
	.byte	$af ,$0c
	.byte	$87
	.byte	$86
	.byte	$85
	.byte	$83
	.byte	$8f
	.byte	$84
	.byte	$8f
	.byte	$28
	.byte	$88
	.byte	$89
	.byte	$29
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$89
	.byte	$29
	.byte	$80
	.byte	$82
	.byte	$af ,$0c
	.byte	$87
	.byte	$86
	.byte	$85
	.byte	$83
	.byte	$8f
	.byte	$84
	.byte	$29
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$80
	.byte	$80
	.byte	$af ,$12
	.byte	$28
	.byte	$af ,$0c
	.byte	$87
	.byte	$86
	.byte	$85
	.byte	$83
	.byte	$8f
	.byte	$84
	.byte	$8f
	.byte	$28
	.byte	$88
	.byte	$89
	.byte	$29
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$89
	.byte	$29
	.byte	$80
	.byte	$82
	.byte	$af ,$0c
	.byte	$83
	.byte	$af ,$0c
	.byte	$82
	.byte	$af ,$0c
	.byte	$80
	.byte	$af ,$12
	.byte	$af ,$18
	.byte	$00
MARIOSUB3:
	.byte	$80
	.byte	$80
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$80
	.byte	$82
	.byte	$8f
	.byte	$84
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$89
	.byte	$87
	.byte	$af ,$12
	.byte	$29
	.byte	$80
	.byte	$80
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$80
	.byte	$82
	.byte	$84
	.byte	$af ,$30
	.byte	$80
	.byte	$80
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$80
	.byte	$82
	.byte	$8f
	.byte	$84
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$89
	.byte	$87
	.byte	$af ,$12
	.byte	$00
MARIOSUB4:
	.byte	$3c
	.byte	$84
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$87
	.byte	$af ,$0c
	.byte	$88
	.byte	$8f
	.byte	$89
	.byte	$29
	.byte	$85
	.byte	$8f
	.byte	$85
	.byte	$28
	.byte	$89
	.byte	$af ,$12
	.byte	$4a
	.byte	$8b
	.byte	$29
	.byte	$89
	.byte	$89
	.byte	$89
	.byte	$87
	.byte	$85
	.byte	$4b
	.byte	$84
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$89
	.byte	$87
	.byte	$af ,$12
	.byte	$29
	.byte	$84
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$87
	.byte	$af ,$0c
	.byte	$88
	.byte	$8f
	.byte	$89
	.byte	$29
	.byte	$85
	.byte	$8f
	.byte	$85
	.byte	$28
	.byte	$89
	.byte	$af ,$12
	.byte	$8b
	.byte	$29
	.byte	$85
	.byte	$8f
	.byte	$85
	.byte	$4a
	.byte	$85
	.byte	$84
	.byte	$82
	.byte	$4b
	.byte	$80
	.byte	$af ,$12
	.byte	$af ,$18
	.byte	$00
MARIOSUB5:
	.byte	$86
	.byte	$86
	.byte	$8f
	.byte	$86
	.byte	$8f
	.byte	$86
	.byte	$86
	.byte	$8f
	.byte	$8b
	.byte	$af ,$12
	.byte	$87
	.byte	$af ,$12
	.byte	$00
MARIOSUB6:
	.byte	$84
	.byte	$af ,$0c
	.byte	$80
	.byte	$af ,$0c
	.byte	$28
	.byte	$87
	.byte	$8f
	.byte	$29
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$82
	.byte	$8f
	.byte	$81
	.byte	$80
	.byte	$8f
	.byte	$4a
	.byte	$80
	.byte	$87
	.byte	$29
	.byte	$80
	.byte	$4b
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$89
	.byte	$8b
	.byte	$8f
	.byte	$89
	.byte	$8f
	.byte	$84
	.byte	$85
	.byte	$82
	.byte	$af ,$0c
	.byte	$00
MARIOSUB7:
	.byte	$3b
	.byte	$af ,$0c
	.byte	$84
	.byte	$83
	.byte	$82
	.byte	$28
	.byte	$8b
	.byte	$29
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$84
	.byte	$85
	.byte	$89
	.byte	$8f
	.byte	$80
	.byte	$84
	.byte	$85
	.byte	$29
	.byte	$af ,$0c
	.byte	$84
	.byte	$83
	.byte	$82
	.byte	$28
	.byte	$8b
	.byte	$29
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$85
	.byte	$8f
	.byte	$85
	.byte	$85
	.byte	$af ,$12
	.byte	$af ,$0c
	.byte	$84
	.byte	$83
	.byte	$82
	.byte	$28
	.byte	$8b
	.byte	$29
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$84
	.byte	$85
	.byte	$89
	.byte	$8f
	.byte	$80
	.byte	$84
	.byte	$85
	.byte	$af ,$0c
	.byte	$88
	.byte	$af ,$0c
	.byte	$85
	.byte	$af ,$0c
	.byte	$84
	.byte	$af ,$12
	.byte	$af ,$18
	.byte	$00
MARIOSUB8:
	.byte	$3b
	.byte	$88
	.byte	$88
	.byte	$8f
	.byte	$88
	.byte	$8f
	.byte	$88
	.byte	$8a
	.byte	$8f
	.byte	$87
	.byte	$84
	.byte	$8f
	.byte	$84
	.byte	$80
	.byte	$af ,$12
	.byte	$88
	.byte	$88
	.byte	$8f
	.byte	$88
	.byte	$8f
	.byte	$88
	.byte	$8a
	.byte	$87
	.byte	$af ,$30
	.byte	$88
	.byte	$88
	.byte	$8f
	.byte	$88
	.byte	$8f
	.byte	$88
	.byte	$8a
	.byte	$8f
	.byte	$87
	.byte	$84
	.byte	$8f
	.byte	$84
	.byte	$80
	.byte	$af ,$12
	.byte	$00
MARIOSUB9:
	.byte	$3c
	.byte	$80
	.byte	$28
	.byte	$87
	.byte	$8f
	.byte	$84
	.byte	$af ,$0c
	.byte	$84
	.byte	$8f
	.byte	$85
	.byte	$29
	.byte	$82
	.byte	$8f
	.byte	$82
	.byte	$28
	.byte	$85
	.byte	$af ,$12
	.byte	$4a
	.byte	$87
	.byte	$29
	.byte	$85
	.byte	$85
	.byte	$85
	.byte	$84
	.byte	$82
	.byte	$4b
	.byte	$80
	.byte	$28
	.byte	$89
	.byte	$8f
	.byte	$85
	.byte	$84
	.byte	$af ,$12
	.byte	$29
	.byte	$80
	.byte	$28
	.byte	$87
	.byte	$8f
	.byte	$84
	.byte	$af ,$0c
	.byte	$84
	.byte	$8f
	.byte	$85
	.byte	$29
	.byte	$82
	.byte	$8f
	.byte	$82
	.byte	$28
	.byte	$85
	.byte	$af ,$12
	.byte	$87
	.byte	$29
	.byte	$82
	.byte	$8f
	.byte	$82
	.byte	$4a
	.byte	$82
	.byte	$80
	.byte	$28
	.byte	$8b
	.byte	$4b
	.byte	$87
	.byte	$84
	.byte	$8f
	.byte	$84
	.byte	$80
	.byte	$af ,$12
	.byte	$00
MARIOSUB10:
	.byte	$3b
	.byte	$82
	.byte	$82
	.byte	$8f
	.byte	$82
	.byte	$8f
	.byte	$82
	.byte	$82
	.byte	$8f
	.byte	$29
	.byte	$87
	.byte	$af ,$12
	.byte	$28
	.byte	$87
	.byte	$af ,$12
	.byte	$00
MARIOSUB11:
	.byte	$87
	.byte	$af ,$0c
	.byte	$84
	.byte	$af ,$0c
	.byte	$80
	.byte	$8f
	.byte	$8f
	.byte	$85
	.byte	$8f
	.byte	$87
	.byte	$8f
	.byte	$86
	.byte	$85
	.byte	$8f
	.byte	$4a
	.byte	$84
	.byte	$29
	.byte	$80
	.byte	$84
	.byte	$4b
	.byte	$85
	.byte	$8f
	.byte	$82
	.byte	$84
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$89
	.byte	$8b
	.byte	$87
	.byte	$af ,$0c
	.byte	$00
MARIOSUB12:
	.byte	$80
	.byte	$af ,$0c
	.byte	$87
	.byte	$af ,$0c
	.byte	$29
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$85
	.byte	$af ,$0c
	.byte	$29
	.byte	$80
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$85
	.byte	$8f
	.byte	$80
	.byte	$af ,$0c
	.byte	$84
	.byte	$af ,$0c
	.byte	$87
	.byte	$29
	.byte	$80
	.byte	$8f
	.byte	$29
	.byte	$87
	.byte	$8f
	.byte	$87
	.byte	$87
	.byte	$8f
	.byte	$28
	.byte	$28
	.byte	$87
	.byte	$8f
	.byte	$80
	.byte	$af ,$0c
	.byte	$87
	.byte	$af ,$0c
	.byte	$29
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$85
	.byte	$af ,$0c
	.byte	$29
	.byte	$80
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$85
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$88
	.byte	$8f
	.byte	$8f
	.byte	$8a
	.byte	$af ,$0c
	.byte	$29
	.byte	$80
	.byte	$af ,$0c
	.byte	$28
	.byte	$87
	.byte	$87
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$00
MARIOSUB13:
	.byte	$3a
	.byte	$88
	.byte	$af ,$0c
	.byte	$29
	.byte	$83
	.byte	$af ,$0c
	.byte	$88
	.byte	$8f
	.byte	$87
	.byte	$af ,$0c
	.byte	$80
	.byte	$af ,$0c
	.byte	$28
	.byte	$87
	.byte	$8f
	.byte	$00
MARIOSUB14:
	.byte	$80
	.byte	$8f
	.byte	$8f
	.byte	$86
	.byte	$87
	.byte	$8f
	.byte	$29
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$85
	.byte	$8f
	.byte	$85
	.byte	$8f
	.byte	$29
	.byte	$80
	.byte	$80
	.byte	$28
	.byte	$85
	.byte	$8f
	.byte	$82
	.byte	$8f
	.byte	$8f
	.byte	$85
	.byte	$87
	.byte	$8f
	.byte	$8b
	.byte	$8f
	.byte	$87
	.byte	$8f
	.byte	$87
	.byte	$8f
	.byte	$29
	.byte	$80
	.byte	$80
	.byte	$28
	.byte	$87
	.byte	$8f
	.byte	$80
	.byte	$8f
	.byte	$8f
	.byte	$86
	.byte	$87
	.byte	$8f
	.byte	$29
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$85
	.byte	$8f
	.byte	$85
	.byte	$8f
	.byte	$29
	.byte	$80
	.byte	$80
	.byte	$28
	.byte	$85
	.byte	$8f
	.byte	$87
	.byte	$8f
	.byte	$8f
	.byte	$87
	.byte	$4a
	.byte	$87
	.byte	$89
	.byte	$8b
	.byte	$4b
	.byte	$29
	.byte	$80
	.byte	$8f
	.byte	$28
	.byte	$87
	.byte	$8f
	.byte	$80
	.byte	$af ,$12
	.byte	$00
MARIOSUB15:
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$55
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$55
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$59
	.byte	$2d
	.byte	$a0 ,$12
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$55
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$00
MARIOSUB16:
	.byte	$3a
	.byte	$ab ,$0c
	.byte	$3c
	.byte	$2d
	.byte	$a0 ,$08
	.byte	$2d
	.byte	$a0 ,$04
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$2d
	.byte	$a0 ,$08
	.byte	$53
	.byte	$2d
	.byte	$a0 ,$04
	.byte	$00
MARIOSUB17:
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$55
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$55
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$59
	.byte	$2d
	.byte	$a0 ,$12
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$55
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$00
MARIOSUB18:
	.byte	$2d
	.byte	$a0 ,$12
	.byte	$2d
	.byte	$a0 ,$06
	.byte	$56
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$00
MARIOBGM0:
	.byte	$04, $0
	.word	$000a ,$0050 ,$0096 ,$00df
	.byte	$08 ,$64
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$16 ,$2e
	.byte	$70
	.byte	$11 ,$a6 ,$fc
	.byte	$02 ,$af ,$fc
	.byte	$03 ,$02
	.byte	$02 ,$b9 ,$fc
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$02
	.byte	$02 ,$d7 ,$fc
	.byte	$05 ,$fc ,$ff
	.byte	$02 ,$19 ,$fd
	.byte	$02 ,$99 ,$fc
	.byte	$03 ,$02
	.byte	$02 ,$a3 ,$fc
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$02
	.byte	$02 ,$35 ,$fd
	.byte	$05 ,$fc ,$ff
	.byte	$02 ,$03 ,$fd
	.byte	$02 ,$83 ,$fc
	.byte	$03 ,$02
	.byte	$02 ,$27 ,$fd
	.byte	$05 ,$fc ,$ff
	.byte	$01 ,$c8 ,$ff
	.byte	$08 ,$64
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$16 ,$2e
	.byte	$70
	.byte	$11 ,$60 ,$fc
	.byte	$02 ,$59 ,$fd
	.byte	$03 ,$02
	.byte	$02 ,$63 ,$fd
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$02
	.byte	$02 ,$81 ,$fd
	.byte	$05 ,$fc ,$ff
	.byte	$02 ,$c2 ,$fd
	.byte	$02 ,$43 ,$fd
	.byte	$03 ,$02
	.byte	$02 ,$4d ,$fd
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$02
	.byte	$02 ,$dc ,$fd
	.byte	$05 ,$fc ,$ff
	.byte	$02 ,$ac ,$fd
	.byte	$02 ,$2d ,$fd
	.byte	$03 ,$02
	.byte	$02 ,$ce ,$fd
	.byte	$05 ,$fc ,$ff
	.byte	$01 ,$c8 ,$ff
	.byte	$08 ,$64
	.byte	$4b
	.byte	$58
	.byte	$70
	.byte	$02 ,$0a ,$fe
	.byte	$03 ,$02
	.byte	$02 ,$17 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$02
	.byte	$02 ,$33 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$03
	.byte	$02 ,$7a ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$02 ,$ef ,$fd
	.byte	$03 ,$02
	.byte	$02 ,$fc ,$fd
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$02
	.byte	$02 ,$7b ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$03
	.byte	$02 ,$5f ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$02 ,$d4 ,$fd
	.byte	$03 ,$02
	.byte	$02 ,$68 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$01 ,$be ,$ff
	.byte	$08 ,$64
	.byte	$6c
	.byte	$3c
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$70
	.byte	$11 ,$ca ,$fb
	.byte	$02 ,$a0 ,$fe
	.byte	$03 ,$18
	.byte	$02 ,$c2 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$04
	.byte	$02 ,$d1 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$08
	.byte	$02 ,$b2 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$10
	.byte	$02 ,$e8 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$04
	.byte	$02 ,$b9 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$03 ,$10
	.byte	$02 ,$d8 ,$fe
	.byte	$05 ,$fc ,$ff
	.byte	$01 ,$cc ,$ff
MARIOEnvelope3:
	.byte	$00 ,$0f ,$0d ,$0b ,$09 ,$07 ,$05 ,$03 ,$02 ,$01 ,$00 ,$ca
MARIOEnvelope4:
	.byte	$00 ,$0b ,$08 ,$05 ,$02 ,$00 ,$c5
MARIOEnvelope5:
	.byte	$00 ,$06 ,$80 ,$05 ,$04 ,$80 ,$03 ,$80 ,$02 ,$01 ,$00 ,$ca
MARIOEnvelope6:
	.byte	$00 ,$0a ,$09 ,$08 ,$07 ,$06 ,$05 ,$04 ,$03 ,$02 ,$01 ,$00 ,$cb
MARIOSUB19:
	.byte	$16 ,$94
	.byte	$53
	.byte	$aa ,$04
	.byte	$11 ,$ed ,$ff
	.byte	$ab ,$04
	.byte	$3c
	.byte	$a0 ,$04
	.byte	$11 ,$d2 ,$ff
	.byte	$0a ,$23
	.byte	$a0 ,$24
	.byte	$11 ,$de ,$ff
	.byte	$3b
	.byte	$5b
	.byte	$a7 ,$0c
	.byte	$3c
	.byte	$0a ,$17
	.byte	$a2 ,$18
	.byte	$5b
	.byte	$a2 ,$0c
	.byte	$5f
	.byte	$a2 ,$10
	.byte	$a0 ,$10
	.byte	$3b
	.byte	$ab ,$10
	.byte	$5b
	.byte	$a7 ,$0c
	.byte	$0a ,$17
	.byte	$a4 ,$18
	.byte	$5b
	.byte	$a4 ,$0c
	.byte	$0a ,$17
	.byte	$a0 ,$18
	.byte	$00
MARIOSUB20:
	.byte	$af ,$30
	.byte	$11 ,$97 ,$ff
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$3c
	.byte	$a5 ,$0c
	.byte	$11 ,$a1 ,$ff
	.byte	$a5 ,$0c
	.byte	$11 ,$89 ,$ff
	.byte	$a5 ,$0c
	.byte	$5f
	.byte	$a5 ,$10
	.byte	$a4 ,$10
	.byte	$a2 ,$10
	.byte	$0a ,$17
	.byte	$a0 ,$18
	.byte	$00
MARIOSUB21:
	.byte	$af ,$30
	.byte	$3a
	.byte	$0a ,$23
	.byte	$a7 ,$24
	.byte	$5b
	.byte	$a7 ,$0c
	.byte	$5f
	.byte	$a7 ,$10
	.byte	$a9 ,$10
	.byte	$ab ,$10
	.byte	$3b
	.byte	$0a ,$17
	.byte	$a0 ,$18
	.byte	$3a
	.byte	$a7 ,$18
	.byte	$a0 ,$18
	.byte	$00
MARIOBGM1:
	.byte	$03, $0
	.word	$0008 ,$0016 ,$0024
	.byte	$08 ,$c8
	.byte	$6c
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$16 ,$2e
	.byte	$70
	.byte	$02 ,$76 ,$ff
	.byte	$00
	.byte	$08 ,$c8
	.byte	$6c
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$16 ,$2e
	.byte	$70
	.byte	$02 ,$a2 ,$ff
	.byte	$00
	.byte	$08 ,$c8
	.byte	$4b
	.byte	$58
	.byte	$70
	.byte	$02 ,$ba ,$ff
	.byte	$00
MARIOEnvelope7:
	.byte	$00 ,$0f ,$0e ,$80 ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$80 ,$09 ,$80 ,$08 ,$07 ,$80 ,$06 ,$80 ,$05 ,$80 ,$04 ,$03 ,$80 ,$00 ,$d7
MARIOEnvelope8:
	.byte	$00 ,$0f ,$80 ,$0e ,$80 ,$0d ,$80 ,$0f ,$80 ,$0e ,$80 ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$80 ,$09 ,$80 ,$08 ,$07 ,$00 ,$d6
MARIOEnvelope9:
	.byte	$00 ,$0f ,$80 ,$0e ,$80 ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$80 ,$09 ,$80 ,$08 ,$07 ,$00 ,$d0
MARIOEnvelope10:
	.byte	$00 ,$0f ,$80 ,$0e ,$80 ,$0d ,$0c ,$80 ,$0b ,$80 ,$0a ,$80 ,$09 ,$08 ,$80 ,$07 ,$80 ,$06 ,$80 ,$05 ,$04 ,$80 ,$03 ,$80 ,$00 ,$d8
MARIOEnvelope11:
	.byte	$00 ,$0f ,$80 ,$0e ,$80 ,$0d ,$0c ,$0f ,$80 ,$0e ,$80 ,$0d ,$0c ,$80 ,$0b ,$80 ,$0a ,$80 ,$09 ,$08 ,$80 ,$00 ,$d5
MARIOEnvelope12:
	.byte	$00 ,$0f ,$8f ,$8f ,$8f ,$8f ,$8b ,$0e ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$09 ,$80 ,$08 ,$07 ,$80 ,$06 ,$00 ,$d4
MARIOEnvelope13:
	.byte	$00 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$82 ,$0b ,$82 ,$0a ,$82 ,$09 ,$82 ,$08 ,$82 ,$07 ,$82 ,$06 ,$82 ,$05 ,$82 ,$04 ,$82 ,$03 ,$82 ,$02 ,$82 ,$01 ,$81 ,$00 ,$df
MARIOEnvelope14:
	.byte	$00 ,$0f ,$82 ,$0e ,$80 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$82 ,$0b ,$82 ,$0a ,$82 ,$09 ,$82 ,$08 ,$82 ,$07 ,$82 ,$06 ,$82 ,$05 ,$82 ,$04 ,$00 ,$dc
MARIOEnvelope15:
	.byte	$00 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$82 ,$0b ,$82 ,$0a ,$82 ,$09 ,$82 ,$08 ,$80 ,$00 ,$d9
MARIOEnvelope16:
	.byte	$00 ,$0f ,$8f ,$8f ,$8f ,$8e ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$00 ,$d4
MARIOEnvelope17:
	.byte	$00 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$81 ,$00 ,$cb
MARIOEnvelope18:
	.byte	$00 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0b ,$07 ,$03 ,$00 ,$cc
MARIOEnvelope19:
	.byte	$00 ,$0f ,$8f ,$8f ,$8f ,$8f ,$8b ,$0e ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$09 ,$80 ,$08 ,$07 ,$80 ,$06 ,$00 ,$d4
MARIOSUB22:
	.byte	$3b
	.byte	$11 ,$d3 ,$fe
	.byte	$a9 ,$12
	.byte	$11 ,$e7 ,$fe
	.byte	$a9 ,$11
	.byte	$11 ,$fa ,$fe
	.byte	$a7 ,$0b
	.byte	$a7 ,$0c
	.byte	$a7 ,$0b
	.byte	$11 ,$03 ,$ff
	.byte	$a5 ,$0b
	.byte	$a7 ,$0c
	.byte	$a9 ,$0b
	.byte	$aa ,$0c
	.byte	$a9 ,$0b
	.byte	$a7 ,$0b
	.byte	$a9 ,$0c
	.byte	$aa ,$0b
	.byte	$3c
	.byte	$a0 ,$0c
	.byte	$a2 ,$0b
	.byte	$a5 ,$0b
	.byte	$a2 ,$0c
	.byte	$a0 ,$0b
	.byte	$3b
	.byte	$aa ,$0c
	.byte	$a9 ,$0b
	.byte	$a7 ,$12
	.byte	$a7 ,$10
	.byte	$a9 ,$12
	.byte	$11 ,$f4 ,$fe
	.byte	$a9 ,$10
	.byte	$11 ,$d5 ,$fe
	.byte	$a9 ,$0c
	.byte	$a5 ,$0b
	.byte	$a9 ,$0c
	.byte	$11 ,$fd ,$fe
	.byte	$a7 ,$73
	.byte	$11 ,$0e ,$ff
	.byte	$3c
	.byte	$a0 ,$12
	.byte	$a0 ,$04
	.byte	$a5 ,$18
	.byte	$a7 ,$18
	.byte	$a9 ,$18
	.byte	$aa ,$18
	.byte	$11 ,$e8 ,$fe
	.byte	$3d
	.byte	$a0 ,$18
	.byte	$a5 ,$30
	.byte	$11 ,$f6 ,$fe
	.byte	$a4 ,$13
	.byte	$11 ,$12 ,$ff
	.byte	$a2 ,$29
	.byte	$11 ,$69 ,$ff
	.byte	$a0 ,$18
	.byte	$11 ,$26 ,$ff
	.byte	$3c
	.byte	$ab ,$18
	.byte	$11 ,$e1 ,$fe
	.byte	$3d
	.byte	$a2 ,$0c
	.byte	$a0 ,$18
	.byte	$3c
	.byte	$a9 ,$30
	.byte	$3b
	.byte	$a9 ,$13
	.byte	$11 ,$f4 ,$fe
	.byte	$a9 ,$1c
	.byte	$11 ,$ce ,$fe
	.byte	$a9 ,$18
	.byte	$ab ,$18
	.byte	$3c
	.byte	$a1 ,$18
	.byte	$11 ,$1e ,$ff
	.byte	$a2 ,$48
	.byte	$11 ,$bf ,$fe
	.byte	$a4 ,$0c
	.byte	$a5 ,$0c
	.byte	$11 ,$12 ,$ff
	.byte	$a7 ,$3c
	.byte	$11 ,$f2 ,$fe
	.byte	$a2 ,$18
	.byte	$a5 ,$24
	.byte	$11 ,$ac ,$fe
	.byte	$a4 ,$18
	.byte	$a2 ,$18
	.byte	$a0 ,$18
	.byte	$11 ,$8d ,$fe
	.byte	$a9 ,$3c
	.byte	$11 ,$9e ,$fe
	.byte	$aa ,$0c
	.byte	$a9 ,$0c
	.byte	$a7 ,$0c
	.byte	$11 ,$7f ,$fe
	.byte	$a5 ,$30
	.byte	$a2 ,$18
	.byte	$a5 ,$18
	.byte	$a7 ,$3c
	.byte	$11 ,$8a ,$fe
	.byte	$a9 ,$0c
	.byte	$a7 ,$0c
	.byte	$11 ,$f3 ,$fe
	.byte	$a5 ,$3c
	.byte	$11 ,$68 ,$fe
	.byte	$a4 ,$18
	.byte	$a0 ,$18
	.byte	$3d
	.byte	$a0 ,$3c
	.byte	$11 ,$74 ,$fe
	.byte	$3c
	.byte	$a9 ,$0c
	.byte	$aa ,$0c
	.byte	$3d
	.byte	$a0 ,$0c
	.byte	$11 ,$53 ,$fe
	.byte	$a2 ,$3c
	.byte	$11 ,$64 ,$fe
	.byte	$3c
	.byte	$a2 ,$0c
	.byte	$a4 ,$0c
	.byte	$a5 ,$0c
	.byte	$11 ,$44 ,$fe
	.byte	$aa ,$30
	.byte	$a9 ,$30
	.byte	$11 ,$de ,$fe
	.byte	$a5 ,$48
	.byte	$11 ,$4e ,$fe
	.byte	$af ,$13
	.byte	$af ,$04
	.byte	$00
MARIOEnvelope20:
	.byte	$00 ,$0f ,$0e ,$80 ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$80 ,$09 ,$80 ,$08 ,$07 ,$80 ,$06 ,$80 ,$05 ,$80 ,$04 ,$03 ,$80 ,$00 ,$d7
MARIOEnvelope21:
	.byte	$00 ,$0f ,$80 ,$0e ,$80 ,$0d ,$80 ,$0f ,$80 ,$0e ,$80 ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$80 ,$09 ,$80 ,$08 ,$07 ,$00 ,$d6
MARIOEnvelope22:
	.byte	$00 ,$0f ,$80 ,$0e ,$80 ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$80 ,$09 ,$80 ,$08 ,$00 ,$cf
MARIOEnvelope23:
	.byte	$00 ,$0f ,$80 ,$0e ,$80 ,$0d ,$0c ,$80 ,$0b ,$80 ,$0a ,$80 ,$09 ,$08 ,$80 ,$07 ,$80 ,$06 ,$80 ,$05 ,$04 ,$80 ,$03 ,$80 ,$00 ,$d8
MARIOEnvelope24:
	.byte	$00 ,$0f ,$80 ,$0e ,$80 ,$0d ,$0c ,$0f ,$80 ,$0e ,$80 ,$0d ,$0c ,$80 ,$0b ,$80 ,$0a ,$80 ,$09 ,$08 ,$80 ,$00 ,$d5
MARIOEnvelope25:
	.byte	$00 ,$0f ,$8f ,$8f ,$8f ,$8f ,$8b ,$0e ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$09 ,$80 ,$08 ,$07 ,$80 ,$06 ,$00 ,$d4
MARIOEnvelope26:
	.byte	$00 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$82 ,$0b ,$82 ,$0a ,$82 ,$09 ,$82 ,$08 ,$80 ,$00 ,$d1
MARIOEnvelope27:
	.byte	$00 ,$0f ,$8d ,$0e ,$0a ,$06 ,$02 ,$00 ,$c7
MARIOEnvelope28:
	.byte	$00 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$82 ,$0b ,$82 ,$0a ,$82 ,$09 ,$82 ,$08 ,$80 ,$00 ,$d9
MARIOEnvelope29:
	.byte	$00 ,$0f ,$8f ,$8f ,$8f ,$8e ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$00 ,$d4
MARIOEnvelope30:
	.byte	$00 ,$0f ,$8f ,$8f ,$8f ,$8f ,$8d ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$00 ,$dd
MARIOEnvelope31:
	.byte	$00 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$00 ,$d9
MARIOEnvelope32:
	.byte	$00 ,$0f ,$82 ,$0e ,$82 ,$0d ,$82 ,$0c ,$81 ,$0f ,$81 ,$00 ,$cb
MARIOEnvelope33:
	.byte	$00 ,$0f ,$8f ,$8f ,$8f ,$8f ,$8b ,$0e ,$0d ,$80 ,$0c ,$0b ,$80 ,$0a ,$09 ,$80 ,$08 ,$07 ,$80 ,$06 ,$00 ,$d4
MARIOSUB23:
	.byte	$11 ,$cc ,$fe
	.byte	$a0 ,$12
	.byte	$11 ,$e0 ,$fe
	.byte	$a5 ,$11
	.byte	$11 ,$f3 ,$fe
	.byte	$a0 ,$0b
	.byte	$11 ,$ff ,$fe
	.byte	$a0 ,$0c
	.byte	$a0 ,$0b
	.byte	$3a
	.byte	$a9 ,$0b
	.byte	$3b
	.byte	$a0 ,$0c
	.byte	$a5 ,$0b
	.byte	$a7 ,$0c
	.byte	$a5 ,$0b
	.byte	$a0 ,$0b
	.byte	$a5 ,$0c
	.byte	$a7 ,$0b
	.byte	$a9 ,$0c
	.byte	$aa ,$0b
	.byte	$3c
	.byte	$a2 ,$0b
	.byte	$3b
	.byte	$aa ,$0c
	.byte	$a9 ,$0b
	.byte	$a7 ,$0c
	.byte	$a5 ,$0b
	.byte	$a0 ,$12
	.byte	$11 ,$ee ,$fe
	.byte	$a0 ,$10
	.byte	$11 ,$cf ,$fe
	.byte	$a5 ,$12
	.byte	$11 ,$e4 ,$fe
	.byte	$a5 ,$10
	.byte	$11 ,$c5 ,$fe
	.byte	$a5 ,$0c
	.byte	$3a
	.byte	$a9 ,$0b
	.byte	$3b
	.byte	$a5 ,$0c
	.byte	$11 ,$eb ,$fe
	.byte	$a0 ,$73
	.byte	$11 ,$fc ,$fe
	.byte	$aa ,$12
	.byte	$aa ,$04
	.byte	$a9 ,$18
	.byte	$3c
	.byte	$a0 ,$18
	.byte	$a5 ,$18
	.byte	$a5 ,$18
	.byte	$11 ,$d6 ,$fe
	.byte	$a5 ,$60
	.byte	$aa ,$24
	.byte	$11 ,$f8 ,$fe
	.byte	$a9 ,$18
	.byte	$11 ,$fc ,$fe
	.byte	$a8 ,$18
	.byte	$11 ,$db ,$fe
	.byte	$ab ,$0c
	.byte	$11 ,$c0 ,$fe
	.byte	$a9 ,$18
	.byte	$a5 ,$30
	.byte	$11 ,$cf ,$fe
	.byte	$3a
	.byte	$a9 ,$13
	.byte	$a9 ,$04
	.byte	$3b
	.byte	$a1 ,$18
	.byte	$a1 ,$18
	.byte	$a2 ,$18
	.byte	$a4 ,$18
	.byte	$11 ,$f5 ,$fe
	.byte	$a5 ,$48
	.byte	$11 ,$b9 ,$fe
	.byte	$a7 ,$0c
	.byte	$a9 ,$0c
	.byte	$11 ,$e9 ,$fe
	.byte	$3c
	.byte	$a2 ,$3c
	.byte	$11 ,$c8 ,$fe
	.byte	$3b
	.byte	$ab ,$18
	.byte	$3c
	.byte	$a2 ,$24
	.byte	$11 ,$a3 ,$fe
	.byte	$a0 ,$18
	.byte	$3b
	.byte	$aa ,$18
	.byte	$aa ,$18
	.byte	$11 ,$e6 ,$fe
	.byte	$3c
	.byte	$a1 ,$60
	.byte	$11 ,$7d ,$fe
	.byte	$a2 ,$30
	.byte	$3b
	.byte	$a9 ,$30
	.byte	$3c
	.byte	$a2 ,$3c
	.byte	$11 ,$f4 ,$fe
	.byte	$3b
	.byte	$ab ,$24
	.byte	$11 ,$6c ,$fe
	.byte	$aa ,$60
	.byte	$11 ,$ca ,$fe
	.byte	$3c
	.byte	$a6 ,$48
	.byte	$11 ,$77 ,$fe
	.byte	$a7 ,$0c
	.byte	$a9 ,$0c
	.byte	$11 ,$5a ,$fe
	.byte	$aa ,$3c
	.byte	$11 ,$6b ,$fe
	.byte	$3b
	.byte	$aa ,$0c
	.byte	$3c
	.byte	$a0 ,$0c
	.byte	$11 ,$e9 ,$fe
	.byte	$a2 ,$3c
	.byte	$11 ,$47 ,$fe
	.byte	$a4 ,$30
	.byte	$11 ,$ec ,$fe
	.byte	$3b
	.byte	$a9 ,$48
	.byte	$11 ,$52 ,$fe
	.byte	$af ,$13
	.byte	$af ,$04
	.byte	$00
MARIOSUB24:
	.byte	$a5 ,$0a
	.byte	$af ,$ef
	.byte	$af ,$e5
	.byte	$a5 ,$18
	.byte	$a4 ,$18
	.byte	$a3 ,$18
	.byte	$a2 ,$18
	.byte	$3a
	.byte	$a9 ,$30
	.byte	$aa ,$30
	.byte	$3b
	.byte	$a5 ,$18
	.byte	$a0 ,$18
	.byte	$3a
	.byte	$a5 ,$18
	.byte	$3b
	.byte	$a5 ,$18
	.byte	$a5 ,$18
	.byte	$3a
	.byte	$a9 ,$18
	.byte	$3b
	.byte	$a0 ,$18
	.byte	$a5 ,$18
	.byte	$3a
	.byte	$a9 ,$30
	.byte	$a9 ,$30
	.byte	$3b
	.byte	$a2 ,$18
	.byte	$3a
	.byte	$a9 ,$18
	.byte	$3b
	.byte	$a5 ,$18
	.byte	$a2 ,$18
	.byte	$3a
	.byte	$ab ,$18
	.byte	$3b
	.byte	$a2 ,$18
	.byte	$a7 ,$18
	.byte	$3a
	.byte	$a7 ,$18
	.byte	$3b
	.byte	$a0 ,$30
	.byte	$a0 ,$18
	.byte	$a4 ,$18
	.byte	$3a
	.byte	$a9 ,$18
	.byte	$3b
	.byte	$a1 ,$18
	.byte	$a4 ,$18
	.byte	$3a
	.byte	$a9 ,$18
	.byte	$3b
	.byte	$a2 ,$18
	.byte	$a4 ,$18
	.byte	$a5 ,$18
	.byte	$a2 ,$18
	.byte	$3a
	.byte	$ab ,$18
	.byte	$3b
	.byte	$a2 ,$18
	.byte	$a7 ,$18
	.byte	$3a
	.byte	$a7 ,$18
	.byte	$3b
	.byte	$a0 ,$18
	.byte	$a0 ,$18
	.byte	$a7 ,$18
	.byte	$aa ,$18
	.byte	$a9 ,$18
	.byte	$a6 ,$18
	.byte	$a2 ,$18
	.byte	$3a
	.byte	$a9 ,$18
	.byte	$a7 ,$18
	.byte	$a9 ,$18
	.byte	$aa ,$18
	.byte	$a7 ,$18
	.byte	$3b
	.byte	$a7 ,$18
	.byte	$a0 ,$18
	.byte	$aa ,$18
	.byte	$a0 ,$18
	.byte	$a5 ,$18
	.byte	$a0 ,$18
	.byte	$a5 ,$18
	.byte	$af ,$18
	.byte	$00
MARIOBGM2:
	.byte	$03, $0
	.word	$0008 ,$0018 ,$0028
	.byte	$08 ,$78
	.byte	$6c
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$16 ,$2e
	.byte	$70
	.byte	$02 ,$02 ,$fc
	.byte	$01 ,$fc ,$ff
	.byte	$08 ,$78
	.byte	$6c
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$16 ,$2e
	.byte	$70
	.byte	$02 ,$3d ,$fe
	.byte	$01 ,$fc ,$ff
	.byte	$08 ,$78
	.byte	$4b
	.byte	$58
	.byte	$70
	.byte	$02 ,$3d ,$ff
	.byte	$01 ,$fc ,$ff
MARIOSE0:
	.byte	$01, $0
	.word	$0004
	.byte	$08 ,$64
	.byte	$6c
	.byte	$1b ,$02
	.byte	$16 ,$9c
	.byte	$a9 ,$0c
	.byte	$00
MARIOEnvelope100:
	.byte	$00 ,$01 ,$0e ,$80 ,$0d ,$00 ,$c5
MARIOEnvelope101:
MARIOEnvelope102:
	.byte	$00 ,$0f ,$8a ,$0e ,$0d ,$0c ,$0b ,$0a ,$09 ,$08 ,$07 ,$06 ,$05 ,$00 ,$cd
MARIOSE1:
	.byte	$01, $0
	.word	$0004
	.byte	$08 ,$96
	.byte	$6c
	.byte	$1b ,$01
	.byte	$11 ,$e0 ,$ff
	.byte	$16 ,$af
	.byte	$a9 ,$03
	.byte	$11 ,$e0 ,$ff
	.byte	$16 ,$bc
	.byte	$a9 ,$1e
	.byte	$00
MARIOEnvelope103:
	.byte	$00 ,$08 ,$81 ,$07 ,$81 ,$06 ,$80 ,$05 ,$81 ,$04 ,$81 ,$03 ,$80 ,$02 ,$81 ,$01 ,$80 ,$d0
MARIOSE2:
	.byte	$01, $0
	.word	$0004
	.byte	$70
	.byte	$11 ,$e8 ,$ff
	.byte	$1b ,$01
	.byte	$16 ,$f6
	.byte	$a9 ,$04
	.byte	$16 ,$ac
	.byte	$a9 ,$16
	.byte	$00
MARIOSE3:
	.byte	$01, $0
	.word	$0004
	.byte	$1b ,$02
	.byte	$70
	.byte	$3d
	.byte	$a4 ,$05
	.byte	$3c
	.byte	$2d
	.byte	$a0 ,$05
	.byte	$3d
	.byte	$a4 ,$05
	.byte	$3c
	.byte	$2d
	.byte	$a0 ,$05
	.byte	$3d
	.byte	$a4 ,$05
	.byte	$3c
	.byte	$2d
	.byte	$a0 ,$14
	.byte	$00
