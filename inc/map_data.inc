; MAP_DATA[stage][map_num][index]

STAGE_ARR:
	.addr MAP_ARR_11
	.addr MAP_ARR_12

MAP_ARR_11:
	.addr MAP_11_1
	.addr MAP_11_2
	.addr $ffff

MAP_ARR_12:
	.addr MAP_12_1
	.addr $ffff

MAP_11_1:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $5, $2), 'B'
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
	.byte (GET_OBJ_POS $1, $6), 'Q'
	.byte (GET_OBJ_POS $1, $7), 'Q'
	.byte (GET_OBJ_POS $2, $5), 'Q'
	.byte (GET_OBJ_POS $3, $5), 'Q'
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
	.addr $0000							; H
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
	.addr $0000							; `
	.addr $0000							; a
	.addr $0000							; b
	.addr $0000							; c
	.addr $0000							; d
	.addr $0000							; e
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

