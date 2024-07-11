; MAP_DATA[stage][map_num][index]

STAGE_ARR:
	.addr MAP_ARR_11
	.addr MAP_ARR_12
	.addr MAP_ARR_13

STAGE_PALETTE_ARR:
	.byte $1, $0, $0

MAP_ARR_11:
	.addr MAP_11_1
	.addr MAP_11_2
	.addr $ffff

MAP_ARR_12:
	.addr MAP_12_1
	.addr $ffff

MAP_ARR_13:
	.addr MAP_13_1
	.addr MAP_13_2
	.addr MAP_13_3
	.addr MAP_13_4
	.addr $ffff

MAP_11_1:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $5, $2), 'H'
	.byte (GET_OBJ_POS $5, $3), 'H'
	.byte (GET_OBJ_POS $8, $5), 'B'
	.byte (GET_OBJ_POS $9, $8), 'B'
	.byte (GET_OBJ_POS $9, $5), 'Q'
	.byte (GET_OBJ_POS $a, $8), 'Q'
	.byte (GET_OBJ_POS $a, $5), 'B'
	.byte (GET_OBJ_POS $b, $8), 'B'
	.byte (GET_OBJ_POS $b, $5), 'Q'
	.byte (GET_OBJ_POS $c, $5), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $0), 0
	.byte (GET_OBJ_POS $0, $1), 0
	.byte (GET_OBJ_POS $1, $0), 0
	.byte (GET_OBJ_POS $1, $1), 0
	.byte (GET_OBJ_POS $2, $5), 'B'
	.byte OBJMAP_END

MAP_11_2:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte (GET_OBJ_POS $0, $5), 'Q'
	.byte (GET_OBJ_POS $0, $6), 'Q'
	.byte (GET_OBJ_POS $0, $7), 'B'
	.byte (GET_OBJ_POS $1, $5), 'Q'
	.byte (GET_OBJ_POS $2, $5), 'Q'
	.byte (GET_OBJ_POS $2, $6), 'B'
	.byte (GET_OBJ_POS $2, $7), 'B'
	.byte (GET_OBJ_POS $a, $4), 'B'
	.byte (GET_OBJ_POS $a, $5), 'B'
	.byte (GET_OBJ_POS $a, $6), 'B'
	.byte (GET_OBJ_POS $a, $7), 'B'
	.byte (GET_OBJ_POS $a, $8), 'B'
	.byte (GET_OBJ_POS $f, $2), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $2), 'B'
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $1, $2), 'B'
	.byte (GET_OBJ_POS $1, $3), 'B'
	.byte (GET_OBJ_POS $1, $4), 'B'
	.byte (GET_OBJ_POS $4, $2), 'B'
	.byte (GET_OBJ_POS $4, $3), 'B'
	.byte (GET_OBJ_POS $4, $4), 'B'
	.byte (GET_OBJ_POS $5, $2), 'B'
	.byte (GET_OBJ_POS $5, $3), 'B'
	.byte (GET_OBJ_POS $6, $2), 'B'
	.byte (GET_OBJ_POS $a, $6), 'H'
	.byte (GET_OBJ_POS $b, $5), 'H'
	.byte (GET_OBJ_POS $b, $6), 'H'
	.byte (GET_OBJ_POS $c, $6), 'H'
	.byte OBJMAP_END

MAP_12_1:
	.byte $bd
	.byte 'B'
	.byte %00010000, %00000000
	.byte (GET_OBJ_POS $0, $2), 'B'
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $0, $4), 'B'
	.byte (GET_OBJ_POS $0, $5), 'B'
	.byte (GET_OBJ_POS $0, $6), 'B'
	.byte (GET_OBJ_POS $0, $7), 'B'
	.byte (GET_OBJ_POS $0, $8), 'B'
	.byte (GET_OBJ_POS $0, $9), 'B'
	.byte (GET_OBJ_POS $0, $a), 'B'
	.byte (GET_OBJ_POS $0, $b), 'B'
	.byte (GET_OBJ_POS $0, $c), 'B'
	.byte (GET_OBJ_POS $1, $c), 0
	.byte (GET_OBJ_POS $2, $c), 0
	.byte (GET_OBJ_POS $3, $c), 0
	.byte (GET_OBJ_POS $4, $c), 0
	.byte (GET_OBJ_POS $5, $c), 0
	.byte (GET_OBJ_POS $b, $4), 'Q'
	.byte (GET_OBJ_POS $c, $4), 'Q'
	.byte (GET_OBJ_POS $d, $4), 'Q'
	.byte (GET_OBJ_POS $e, $4), 'Q'
	.byte (GET_OBJ_POS $f, $4), 'Q'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $2, $2), 'B'
	.byte (GET_OBJ_POS $4, $2), 'B'
	.byte (GET_OBJ_POS $4, $3), 'B'
	.byte (GET_OBJ_POS $6, $2), 'B'
	.byte (GET_OBJ_POS $6, $3), 'B'
	.byte (GET_OBJ_POS $6, $4), 'B'
	.byte (GET_OBJ_POS $8, $2), 'B'
	.byte (GET_OBJ_POS $8, $3), 'B'
	.byte (GET_OBJ_POS $8, $4), 'B'
	.byte (GET_OBJ_POS $8, $5), 'B'
	.byte (GET_OBJ_POS $a, $5), 'B'
	.byte (GET_OBJ_POS $c, $2), 'B'
	.byte (GET_OBJ_POS $c, $3), 'B'
	.byte (GET_OBJ_POS $c, $4), 'B'
	.byte (GET_OBJ_POS $c, $5), 'B'
	.byte (GET_OBJ_POS $e, $2), 'B'
	.byte (GET_OBJ_POS $e, $3), 'B'
	.byte (GET_OBJ_POS $e, $4), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $2), 'B'
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $2, $2), 'B'
	.byte OBJMAP_END


MAP_13_1:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $5), 'Q'
	.byte (GET_OBJ_POS $4, $5), 'B'
	.byte (GET_OBJ_POS $5, $5), 'Q'
	.byte (GET_OBJ_POS $6, $5), 'B'
	.byte (GET_OBJ_POS $6, $9), 'Q'
	.byte (GET_OBJ_POS $7, $5), 'Q'
	.byte (GET_OBJ_POS $8, $5), 'B'
	.byte (GET_OBJ_POS $c, $2), '`'		; 土管1
	.byte (GET_OBJ_POS $c, $3), 'a'
	.byte (GET_OBJ_POS $d, $2), 'b'
	.byte (GET_OBJ_POS $d, $3), 'c'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $6, $2), '`'		; 土管2
	.byte (GET_OBJ_POS $6, $3), '`'
	.byte (GET_OBJ_POS $6, $4), 'a'
	.byte (GET_OBJ_POS $7, $2), 'b'
	.byte (GET_OBJ_POS $7, $3), 'b'
	.byte (GET_OBJ_POS $7, $4), 'c'
	.byte (GET_OBJ_POS $e, $2), '`'		; 土管3
	.byte (GET_OBJ_POS $e, $3), '`'
	.byte (GET_OBJ_POS $e, $4), '`'
	.byte (GET_OBJ_POS $e, $5), 'a'
	.byte (GET_OBJ_POS $f, $2), 'b'
	.byte (GET_OBJ_POS $f, $3), 'b'
	.byte (GET_OBJ_POS $f, $4), 'b'
	.byte (GET_OBJ_POS $f, $5), 'c'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $9, $2), '`'		; 土管4
	.byte (GET_OBJ_POS $9, $3), '`'
	.byte (GET_OBJ_POS $9, $4), '`'
	.byte (GET_OBJ_POS $9, $5), 'a'
	.byte (GET_OBJ_POS $a, $2), 'b'		; 土管4
	.byte (GET_OBJ_POS $a, $3), 'b'
	.byte (GET_OBJ_POS $a, $4), 'b'
	.byte (GET_OBJ_POS $a, $5), 'c'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $5, $0), 0
	.byte (GET_OBJ_POS $5, $1), 0
	.byte (GET_OBJ_POS $6, $0), 0
	.byte (GET_OBJ_POS $6, $1), 0
	.byte (GET_OBJ_POS $d, $5), 'B'
	.byte (GET_OBJ_POS $e, $5), 'Q'
	.byte (GET_OBJ_POS $f, $5), 'B'
	.byte OBJMAP_END


MAP_13_2:
	.byte $bd
	.byte 'B'
	.byte %00000010, %00000000
	.byte (GET_OBJ_POS $6, $0), 0
	.byte (GET_OBJ_POS $6, $1), 0
	.byte (GET_OBJ_POS $7, $0), 0
	.byte (GET_OBJ_POS $7, $1), 0
	.byte (GET_OBJ_POS $8, $0), 0
	.byte (GET_OBJ_POS $8, $1), 0
	.byte (GET_OBJ_POS $8, $9), 0
	.byte (GET_OBJ_POS $9, $9), 0
	.byte (GET_OBJ_POS $a, $9), 0
	.byte (GET_OBJ_POS $e, $5), 'B'
	.byte (GET_OBJ_POS $e, $9), 'Q'
	.byte OBJMAP_END

MAP_13_3:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte (GET_OBJ_POS $4, $5), 'B'
	.byte (GET_OBJ_POS $5, $5), 'B'
	.byte (GET_OBJ_POS $a, $5), 'Q'
	.byte (GET_OBJ_POS $d, $5), 'Q'
	.byte (GET_OBJ_POS $d, $9), 'Q'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $5), 'Q'
	.byte (GET_OBJ_POS $5, $5), 'B'
	.byte (GET_OBJ_POS $8, $9), 'B'
	.byte (GET_OBJ_POS $9, $9), 'B'
	.byte (GET_OBJ_POS $a, $9), 'B'
	.byte (GET_OBJ_POS $e, $9), 'B'
	.byte (GET_OBJ_POS $f, $5), 'B'
	.byte (GET_OBJ_POS $f, $9), 'Q'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $5), 'B'
	.byte (GET_OBJ_POS $0, $9), 'Q'
	.byte (GET_OBJ_POS $1, $9), 'B'
	.byte (GET_OBJ_POS $4, $2), 'H'
	.byte (GET_OBJ_POS $5, $2), 'H'
	.byte (GET_OBJ_POS $5, $3), 'H'
	.byte (GET_OBJ_POS $6, $2), 'H'
	.byte (GET_OBJ_POS $6, $3), 'H'
	.byte (GET_OBJ_POS $6, $4), 'H'
	.byte (GET_OBJ_POS $7, $2), 'H'
	.byte (GET_OBJ_POS $7, $3), 'H'
	.byte (GET_OBJ_POS $7, $4), 'H'
	.byte (GET_OBJ_POS $7, $5), 'H'
	.byte (GET_OBJ_POS $a, $2), 'H'
	.byte (GET_OBJ_POS $a, $3), 'H'
	.byte (GET_OBJ_POS $a, $4), 'H'
	.byte (GET_OBJ_POS $a, $5), 'H'
	.byte (GET_OBJ_POS $b, $2), 'H'
	.byte (GET_OBJ_POS $b, $3), 'H'
	.byte (GET_OBJ_POS $b, $4), 'H'
	.byte (GET_OBJ_POS $c, $2), 'H'
	.byte (GET_OBJ_POS $c, $3), 'H'
	.byte (GET_OBJ_POS $d, $2), 'H'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $2, $2), 'H'
	.byte (GET_OBJ_POS $3, $2), 'H'
	.byte (GET_OBJ_POS $3, $3), 'H'
	.byte (GET_OBJ_POS $4, $2), 'H'
	.byte (GET_OBJ_POS $4, $3), 'H'
	.byte (GET_OBJ_POS $4, $4), 'H'
	.byte (GET_OBJ_POS $5, $2), 'H'
	.byte (GET_OBJ_POS $5, $3), 'H'
	.byte (GET_OBJ_POS $5, $4), 'H'
	.byte (GET_OBJ_POS $5, $5), 'H'
	.byte (GET_OBJ_POS $6, $2), 'H'
	.byte (GET_OBJ_POS $6, $3), 'H'
	.byte (GET_OBJ_POS $6, $4), 'H'
	.byte (GET_OBJ_POS $6, $5), 'H'
	.byte (GET_OBJ_POS $7, $0), 0
	.byte (GET_OBJ_POS $7, $1), 0
	.byte (GET_OBJ_POS $8, $0), 0
	.byte (GET_OBJ_POS $8, $1), 0
	.byte (GET_OBJ_POS $9, $2), 'H'
	.byte (GET_OBJ_POS $9, $3), 'H'
	.byte (GET_OBJ_POS $9, $4), 'H'
	.byte (GET_OBJ_POS $9, $5), 'H'
	.byte (GET_OBJ_POS $a, $2), 'H'
	.byte (GET_OBJ_POS $a, $3), 'H'
	.byte (GET_OBJ_POS $a, $4), 'H'
	.byte (GET_OBJ_POS $b, $2), 'H'
	.byte (GET_OBJ_POS $b, $3), 'H'
	.byte (GET_OBJ_POS $c, $2), 'H'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $1, $2), '`'		; 土管5（出口）
	.byte (GET_OBJ_POS $1, $3), 'a'
	.byte (GET_OBJ_POS $2, $2), 'b'
	.byte (GET_OBJ_POS $2, $3), 'c'
	.byte (GET_OBJ_POS $6, $5), 'B'
	.byte (GET_OBJ_POS $7, $5), 'B'
	.byte (GET_OBJ_POS $8, $5), 'Q'
	.byte (GET_OBJ_POS $9, $5), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $1, $2), '`'		; 土管6
	.byte (GET_OBJ_POS $1, $3), 'a'
	.byte (GET_OBJ_POS $2, $2), 'b'
	.byte (GET_OBJ_POS $2, $3), 'c'
	.byte (GET_OBJ_POS $3, $2), 'H'
	.byte (GET_OBJ_POS $4, $2), 'H'
	.byte (GET_OBJ_POS $4, $3), 'H'
	.byte (GET_OBJ_POS $5, $2), 'H'
	.byte (GET_OBJ_POS $5, $3), 'H'
	.byte (GET_OBJ_POS $5, $4), 'H'
	.byte (GET_OBJ_POS $6, $2), 'H'
	.byte (GET_OBJ_POS $6, $3), 'H'
	.byte (GET_OBJ_POS $6, $4), 'H'
	.byte (GET_OBJ_POS $6, $5), 'H'
	.byte (GET_OBJ_POS $7, $2), 'H'
	.byte (GET_OBJ_POS $7, $3), 'H'
	.byte (GET_OBJ_POS $7, $4), 'H'
	.byte (GET_OBJ_POS $7, $5), 'H'
	.byte (GET_OBJ_POS $7, $6), 'H'
	.byte (GET_OBJ_POS $8, $2), 'H'
	.byte (GET_OBJ_POS $8, $3), 'H'
	.byte (GET_OBJ_POS $8, $4), 'H'
	.byte (GET_OBJ_POS $8, $5), 'H'
	.byte (GET_OBJ_POS $8, $6), 'H'
	.byte (GET_OBJ_POS $8, $7), 'H'
	.byte (GET_OBJ_POS $9, $2), 'H'
	.byte (GET_OBJ_POS $9, $3), 'H'
	.byte (GET_OBJ_POS $9, $4), 'H'
	.byte (GET_OBJ_POS $9, $5), 'H'
	.byte (GET_OBJ_POS $9, $6), 'H'
	.byte (GET_OBJ_POS $9, $7), 'H'
	.byte (GET_OBJ_POS $9, $8), 'H'
	.byte (GET_OBJ_POS $a, $2), 'H'
	.byte (GET_OBJ_POS $a, $3), 'H'
	.byte (GET_OBJ_POS $a, $4), 'H'
	.byte (GET_OBJ_POS $a, $5), 'H'
	.byte (GET_OBJ_POS $a, $6), 'H'
	.byte (GET_OBJ_POS $a, $7), 'H'
	.byte (GET_OBJ_POS $a, $8), 'H'
	.byte (GET_OBJ_POS $a, $9), 'H'
	.byte (GET_OBJ_POS $b, $2), 'H'
	.byte (GET_OBJ_POS $b, $3), 'H'
	.byte (GET_OBJ_POS $b, $4), 'H'
	.byte (GET_OBJ_POS $b, $5), 'H'
	.byte (GET_OBJ_POS $b, $6), 'H'
	.byte (GET_OBJ_POS $b, $7), 'H'
	.byte (GET_OBJ_POS $b, $8), 'H'
	.byte (GET_OBJ_POS $b, $9), 'H'
	.byte OBJMAP_END

MAP_13_4:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte (GET_OBJ_POS $4, $2), 'H'
	.byte (GET_OBJ_POS $4, $3), 'd'
	.byte (GET_OBJ_POS $4, $4), 'd'
	.byte (GET_OBJ_POS $4, $5), 'd'
	.byte (GET_OBJ_POS $4, $6), 'd'
	.byte (GET_OBJ_POS $4, $7), 'd'
	.byte (GET_OBJ_POS $4, $8), 'd'
	.byte (GET_OBJ_POS $4, $9), 'd'
	.byte (GET_OBJ_POS $4, $a), 'd'
	.byte (GET_OBJ_POS $4, $b), 'd'
	.byte (GET_OBJ_POS $4, $c), 'e'
	.byte (GET_OBJ_POS $b, $2), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $f, $0), 'G'
	.byte OBJMAP_END




BROCK_ID_ARR:
	; 40 = %0100
	.addr OBJ_SKY						; @ (or 0)
	.addr $0000							; A
	.addr OBJ_BROCK						; B
	.addr $0000							; C
	.addr $0000							; D
	.addr $0000							; E
	.addr $0000							; F
	.addr OBJ_GROUND					; G
	.addr OBJ_HARD_BROCK				; H
	.addr $0000							; I
	.addr $0000							; J
	.addr $0000							; K
	.addr $0000							; L
	.addr $0000							; M
	.addr $0000							; N
	.addr $0000							; O
	; 50 = %0101
	.addr $0000							; P
	.addr OBJ_QBROCK					; Q
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
	.addr $0000							; h
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

OBJ_QBROCK:
	.byte $90, $91
	.byte $92, $93

OBJ_BROCK:
	.byte $94, $94
	.byte $95, $95

OBJ_COIN:
	.byte $84, $85
	.byte $86, $87

OBJ_GROUND:
	.byte $80, $81
	.byte $82, $83

OBJ_HARD_BROCK:
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

BG_BROCK:
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