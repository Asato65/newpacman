

STAGE_ARR:
	.addr MAP_ARR_11

MAP_ARR_11:
	.addr MAP_11_1
	.addr MAP_11_2
	.addr $ffff

MAP_11_1:
	.byte (GET_OBJ_POS $0, $0), 'G'
	.byte (GET_OBJ_POS $1, $1), 'G'
	.byte (GET_OBJ_POS $2, $2), 'G'
	.byte (GET_OBJ_POS $3, $3), 'G'
	.byte (GET_OBJ_POS $4, $4), 'G'
	.byte (GET_OBJ_POS $5, $5), 'G'
	.byte (GET_OBJ_POS $6, $6), 'G'
	.byte (GET_OBJ_POS $7, $7), 'G'
	.byte (GET_OBJ_POS $8, $8), 'G'
	.byte (GET_OBJ_POS $9, $9), 'G'
	.byte (GET_OBJ_POS $a, $a), 'G'
	.byte (GET_OBJ_POS $b, $b), 'G'
	.byte (GET_OBJ_POS $c, $c), 'G'
	.byte (GET_OBJ_POS $d, $d), 'G'
	.byte (GET_OBJ_POS $e, $c), 'G'
	.byte (GET_OBJ_POS $f, $b), 'G'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $0), 'B'
	.byte (GET_OBJ_POS $1, $1), 'B'
	.byte (GET_OBJ_POS $2, $2), 'B'
	.byte (GET_OBJ_POS $3, $3), 'B'
	.byte (GET_OBJ_POS $4, $4), 'B'
	.byte (GET_OBJ_POS $5, $5), 'B'
	.byte (GET_OBJ_POS $6, $6), 'B'
	.byte (GET_OBJ_POS $7, $7), 'B'
	.byte (GET_OBJ_POS $8, $8), 'B'
	.byte (GET_OBJ_POS $9, $9), 'B'
	.byte (GET_OBJ_POS $a, $a), 'B'
	.byte (GET_OBJ_POS $b, $b), 'B'
	.byte (GET_OBJ_POS $c, $c), 'B'
	.byte (GET_OBJ_POS $d, $d), 'B'
	.byte (GET_OBJ_POS $e, $c), 'B'
	.byte (GET_OBJ_POS $f, $b), 'B'
	.byte OBJMAP_NEXT
	.byte OBJMAP_END

MAP_11_2:
	.byte (GET_OBJ_POS $0, $0), '?'
	.byte (GET_OBJ_POS $1, $1), '?'
	.byte (GET_OBJ_POS $2, $2), '?'
	.byte (GET_OBJ_POS $3, $3), '?'
	.byte (GET_OBJ_POS $4, $4), '?'
	.byte (GET_OBJ_POS $5, $5), '?'
	.byte (GET_OBJ_POS $6, $6), '?'
	.byte (GET_OBJ_POS $7, $7), '?'
	.byte (GET_OBJ_POS $8, $8), '?'
	.byte (GET_OBJ_POS $9, $9), '?'
	.byte (GET_OBJ_POS $a, $a), '?'
	.byte (GET_OBJ_POS $b, $b), '?'
	.byte (GET_OBJ_POS $c, $c), '?'
	.byte (GET_OBJ_POS $d, $d), '?'
	.byte (GET_OBJ_POS $e, $c), '?'
	.byte (GET_OBJ_POS $f, $b), '?'
	.byte OBJMAP_NEXT
	.byte OBJMAP_END


BROCK_ID:
	.addr OBJ_SKY
	; 30
	.addr $0000							; 0
	.addr $0000							; 1
	.addr $0000							; 2
	.addr $0000							; 3
	.addr $0000							; 4
	.addr $0000							; 5
	.addr $0000							; 6
	.addr $0000							; 7
	.addr $0000							; 8
	.addr $0000							; 9
	.addr $0000							; :
	.addr $0000							; ;
	.addr $0000							; <
	.addr $0000							; =
	.addr $0000							; >
	.addr OBJ_QBLOCK					; ?
	; 40
	.addr $0000							; @
	.addr $0000							; A
	.addr OBJ_BROCK						; B
	.addr OBJ_COIN						; C
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
	; 50
	.addr $0000							; P
	.addr $0000							; Q
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
	.addr $0000							; ^
	.addr $0000							; _
	; 60
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


OBJ_SKY:
	.byte $00, $00
	.byte $00, $00

OBJ_QBLOCK:
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


/*
MAP_DATA[stage][map_num][index]

setAddr ----
lda stage
shl
tax

lda MAP_DATA, x
sta <addr1
inx
lda MAP_DATA, x
sta >addr1
inx

ldy map_num
lda (addr1), y
sta <addr2
lda (addr1), y
sta >addr2

ldy index
lda (addr2), y
sta <addr3
lda (addr2), y
sta >addr3

*/

