STAGE_ARR:
	.addr MAP_ARR_11

MAP_ARR_11:
	.addr MAP_11_1

MAP_11_1:
	.byte $85, 'G'
	.byte $94, 'G'
	.byte $a3, 'G'
	.byte $ff

/*
BROCK_ID:
	.addr BR_SKY
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

OBJ_QBLOCK:
OBJ_BROCK:
OBJ_COIN:
OBJ_GROUND:
	.byte $00, $00
	.byte $00, $00


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

