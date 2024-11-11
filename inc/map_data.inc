; MAP_DATA[stage][map_num][index]

.include "map/1-1.inc"
.include "map/1-2.inc"
.include "map/1-3.inc"


STAGE_ARR:
	.addr MAP_ARR_11
	.addr MAP_ARR_12
	.addr MAP_ARR_13


STAGE_PALETTE_ARR:
	.byte $1, $0, $0



BLOCK_ID_ARR:
	; 40 = %0100
	.addr OBJ_SKY						; @ (or 0)
	.addr $0000							; A
	.addr OBJ_BLOCK						; B
	.addr $0000							; C
	.addr $0000							; D
	.addr $0000							; E
	.addr $0000							; F
	.addr OBJ_GROUND					; G
	.addr OBJ_HARD_BLOCK				; H
	.addr OBJ_INVISIBLE_BLOCK			; I
	.addr $0000							; J
	.addr $0000							; K
	.addr $0000							; L
	.addr $0000							; M
	.addr OBJ_HARD2_BLOCK				; N
	.addr $0000							; O
	; 50 = %0101
	.addr $0000							; P
	.addr OBJ_QBLOCK					; Q
	.addr $0000							; R
	.addr $0000							; S
	.addr $0000							; T
	.addr $0000							; U
	.addr $0000							; V
	.addr $0000							; W
	.addr $0000							; X
	.addr $0000							; Y
	.addr $0000							; Z
	.addr $0000							; [
	.addr $0000							; \
	.addr $0000							; ]
	.addr OBJ_COIN						; ^
	.addr $0000							; _
	; 60 = %0110
	.addr OBJ_PIPE_LEFT					; `
	.addr OBJ_PIPE_UPPER_LEFT			; a
	.addr OBJ_PIPE_RIGHT				; b
	.addr OBJ_PIPE_UPPER_RIGHT			; c
	.addr OBJ_GOAL_POAL					; d
	.addr OBJ_GOAL_BALL					; e
	.addr $0000							; f
	.addr $0000							; g
	.addr OBJ_HIDE_BLOCK				; h
	.addr $0000							; i
	.addr $0000							; j
	.addr $0000							; k
	.addr $0000							; l
	.addr $0000							; m
	.addr $0000							; n
	.addr $0000							; o
	; 70 = %0111
	.addr $0000							; p
	.addr $0000							; q
	.addr $0000							; r
	.addr $0000							; s
	.addr $0000							; t
	.addr $0000							; u
	.addr $0000							; v
	.addr $0000							; w
	.addr $0000							; x
	.addr $0000							; y
	.addr $0000							; z
	.addr $0000							; {
	.addr $0000							; |
	.addr $0000							; }
	.addr $0000							; ~


OBJ_SKY:
	.byte $00, $00
	.byte $00, $00

OBJ_QBLOCK:
	.byte $90, $91
	.byte $92, $93

OBJ_BLOCK:
	.byte $94, $94
	.byte $95, $95

OBJ_COIN:
	.byte $84, $85
	.byte $86, $87

OBJ_GROUND:
	.byte $80, $81
	.byte $82, $83

OBJ_HARD_BLOCK:
	.byte $8c, $8d
	.byte $8e, $8f

OBJ_PIPE_UPPER_LEFT:
	.byte $98, $99
	.byte $9a, $9b

OBJ_PIPE_UPPER_RIGHT:
	.byte $9c, $9d
	.byte $9e, $9f

OBJ_PIPE_LEFT:
	.byte $a0, $a1
	.byte $a0, $a1

OBJ_PIPE_RIGHT:
	.byte $02, $a2
	.byte $02, $a2

OBJ_GOAL_POAL:
	.byte $a4, $a5
	.byte $a4, $a5

OBJ_GOAL_BALL:
	.byte $00, $00
	.byte $a6, $a7

BG_BLOCK:
	.byte $95, $95
	.byte $95, $95

BG_DOOR_LOWER:
	.byte $03, $03
	.byte $03, $03

BG_DOOR_UPPER:
	.byte $aa, $ab
	.byte $03, $03

BG_FORT_1:
	.byte $a8, $a9
	.byte $95, $95

BG_FORT_2:
	.byte $aa, $ab
	.byte $95, $95

BG_FORT_3:
	.byte $95, $03
	.byte $95, $03

OBJ_HIDE_BLOCK:
	.byte $00, $00
	.byte $00, $00

OBJ_HARD2_BLOCK:
	.byte $88, $89
	.byte $8a, $8b

OBJ_INVISIBLE_BLOCK:
	.byte $00, $00
	.byte $00, $00