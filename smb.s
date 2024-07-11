;===============================================================
;		Music file for NES Sound Driver & Library
;			for assembly language (ca65.exe)
;===============================================================

	.export		DQBGM0


.segment	"RODATA"
DQEnvelope0:
	.byte	$00 ,$02 ,$01 ,$08 ,$81 ,$00 ,$c5
DQEnvelope1:
	.byte	$00 ,$02 ,$01 ,$08 ,$07 ,$06 ,$05 ,$80 ,$04 ,$80 ,$00 ,$ca
DQEnvelope2:
DQSUB0:
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
DQSUB1:
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
DQSUB2:
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
DQSUB3:
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$5b
	.byte	$2d
	.byte	$a0 ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$56
	.byte	$ab ,$0c
	.byte	$57
	.byte	$ab ,$08
	.byte	$53
	.byte	$ab ,$04
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$59
	.byte	$ab ,$12
	.byte	$56
	.byte	$ab ,$0c
	.byte	$55
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$ab ,$06
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$0a ,$11
	.byte	$ab ,$12
	.byte	$55
	.byte	$ab ,$06
	.byte	$56
	.byte	$ab ,$0c
	.byte	$5b
	.byte	$ab ,$0c
	.byte	$00
DQBGM0:
	.byte	$04, $0
	.word	$000a ,$001c ,$002e ,$0039
	.byte	$08 ,$64
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$16 ,$2e
	.byte	$70
	.byte	$11 ,$76 ,$f2
	.byte	$02 ,$7f ,$f2
	.byte	$01 ,$f9 ,$ff
	.byte	$08 ,$64
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$16 ,$2e
	.byte	$70
	.byte	$11 ,$64 ,$f2
	.byte	$02 ,$22 ,$f5
	.byte	$01 ,$f9 ,$ff
	.byte	$08 ,$64
	.byte	$4b
	.byte	$58
	.byte	$70
	.byte	$02 ,$d6 ,$f7
	.byte	$01 ,$fc ,$ff
	.byte	$08 ,$64
	.byte	$6c
	.byte	$3c
	.byte	$4b
	.byte	$1b ,$02
	.byte	$58
	.byte	$70
	.byte	$11 ,$40 ,$f2
	.byte	$02 ,$bd ,$fa
	.byte	$01 ,$f9 ,$ff
