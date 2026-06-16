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


;*------------------------------------------------------------------------------
; 背景オブジェクトデータ
;
; BG_MAP1:
;   1byte目 %d00xxxxx
;     d=1なら背景データ内の画面番号を1つ進める。xxxxxは8x8タイル単位のX。
;   2byte目 %yyy00iii
;     yyyはBG_SCENERY_Y_TO_ROWのindex。iiiはBG_OBJ*_DATAのindex。
;
; BG_OBJ*_DATA:
;   通常byte %hhhiiiii
;     hhhはオブジェクト内Y。iiiii + $af が実際の8x8タイル番号。
;   $e0: 8x8タイルXを+1して続行
;   $ff: オブジェクト終端
;*------------------------------------------------------------------------------

BG_SCENERY_TILE_BASE = $af
BG_SCENERY_NEXT_X = $e0
BG_SCENERY_END = $ff

.define BG_TILE(yy, tt) (((yy) * $20) + ((tt) - BG_SCENERY_TILE_BASE))

BG_SCENERY_Y_TO_ROW:
	.byte $00, $02, $08, $0c, $10, $12	; PPU y=$04,$06,$0c,$10,$14,$16 をBG転送バッファ内Yへ変換

BG_MAP1:
	.byte %00000000, %10100101			; x=00, 大きい山
	.byte %00010001, %00100000			; x=11, 雲1, y1
	.byte %00010111, %10100010			; x=17, 草3

	.byte %10000000, %10100110			; 次画面 x=00, 小さい山
	.byte %00000111, %00000000			; x=07, 雲1, y0
	.byte %00001111, %10100000			; x=0f, 草1
	.byte %00010111, %00100001			; x=17, 雲2, y1

	.byte %10001001, %00000001			; 次画面 x=09, 雲2, y0
	.byte %00010011, %10100001			; x=13, 草2
	.byte BG_SCENERY_END

BG_MAP1_PLT:
	.byte %00000101, %10000000
	.byte %00000110, %00001010
	.byte %00010101, %10100010
	.byte %00010110, %00001010
	.byte %00100101, %00100000

	.byte %01000001, %11110000
	.byte %01000010, %00001111
	.byte %01010001, %00110000
	.byte %01010010, %00000011

	.byte %01010110, %00001000
	.byte %01100110, %00001010
	.byte %01110110, %00001010
	.byte %10000110, %00001010
	.byte %00010110, %00000010

	.byte %00010001, %11001100
	.byte %00100001, %11111111

	.byte %00110110, %00001000
	.byte %01000110, %00000010

	.byte %01010001, %11000000
	.byte %01010010, %00001100
	.byte %01100001, %11110000
	.byte %01100010, %00001111
	.byte %01110001, %11110000
	.byte %01110010, %00001111

	.byte %10100001, %11111111
	.byte %00110001, %11111111

	.byte %01000110, %00001000
	.byte %01010110, %00001010
	.byte %01100110, %00000010
	.byte BG_SCENERY_END

BG_OBJ_ADDR_LO:
	.byte <BG_OBJ0_DATA, <BG_OBJ1_DATA, <BG_OBJ2_DATA, <BG_OBJ3_DATA
	.byte <BG_OBJ4_DATA, <BG_OBJ5_DATA, <BG_OBJ6_DATA, <BG_OBJ7_DATA

BG_OBJ_ADDR_HI:
	.byte >BG_OBJ0_DATA, >BG_OBJ1_DATA, >BG_OBJ2_DATA, >BG_OBJ3_DATA
	.byte >BG_OBJ4_DATA, >BG_OBJ5_DATA, >BG_OBJ6_DATA, >BG_OBJ7_DATA

BG_OBJ0_DATA:
	.byte BG_TILE(1, $b4)
	.byte BG_TILE(2, $b8), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b5)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $b9), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b6)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $ba), BG_SCENERY_NEXT_X
	.byte BG_TILE(1, $b7)
	.byte BG_TILE(2, $bb)
	.byte BG_SCENERY_END

BG_OBJ1_DATA:
	.byte BG_TILE(1, $b4)
	.byte BG_TILE(2, $b8), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b5)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $b9), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b6)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $ba), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b5)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $b9), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b6)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $ba), BG_SCENERY_NEXT_X
	.byte BG_TILE(1, $b7)
	.byte BG_TILE(2, $bb)
	.byte BG_SCENERY_END

BG_OBJ2_DATA:
	.byte BG_TILE(1, $b4)
	.byte BG_TILE(2, $b8), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b5)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $b9), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b6)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $ba), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b5)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $b9), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b6)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $ba), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b5)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $b9), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b6)
	.byte BG_TILE(1, $c9)
	.byte BG_TILE(2, $ba), BG_SCENERY_NEXT_X
	.byte BG_TILE(1, $b7)
	.byte BG_TILE(2, $bb)
	.byte BG_SCENERY_END

BG_OBJ3_DATA:
	.byte BG_TILE(0, $c0)
	.byte BG_TILE(1, $c4)
	.byte BG_TILE(2, $c6)
	.byte BG_TILE(3, $c6)
	.byte BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $c1)
	.byte BG_TILE(1, $c5)
	.byte BG_TILE(2, $c7)
	.byte BG_TILE(3, $c7)
	.byte BG_SCENERY_END

BG_OBJ4_DATA:
	.byte BG_TILE(0, $c0)
	.byte BG_TILE(1, $c2)
	.byte BG_TILE(2, $c2)
	.byte BG_TILE(3, $c4)
	.byte BG_TILE(4, $c6)
	.byte BG_TILE(5, $c6)
	.byte BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $c1)
	.byte BG_TILE(1, $c3)
	.byte BG_TILE(2, $c3)
	.byte BG_TILE(3, $c5)
	.byte BG_TILE(4, $c7)
	.byte BG_TILE(5, $c7)
	.byte BG_SCENERY_END

BG_OBJ5_DATA:
	.byte BG_TILE(4, $b0), BG_SCENERY_NEXT_X
	.byte BG_TILE(3, $b0)
	.byte BG_TILE(4, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(2, $b0)
	.byte BG_TILE(3, $c8)
	.byte BG_TILE(4, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(1, $b0)
	.byte BG_TILE(2, $c8)
	.byte BG_TILE(3, $af)
	.byte BG_TILE(4, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b1)
	.byte BG_TILE(1, $c8)
	.byte BG_TILE(2, $c8)
	.byte BG_TILE(3, $c8)
	.byte BG_TILE(4, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b2)
	.byte BG_TILE(1, $af)
	.byte BG_TILE(2, $c8)
	.byte BG_TILE(3, $c8)
	.byte BG_TILE(4, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(1, $b3)
	.byte BG_TILE(2, $c8)
	.byte BG_TILE(3, $af)
	.byte BG_TILE(4, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(2, $b3)
	.byte BG_TILE(3, $c8)
	.byte BG_TILE(4, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(3, $b3)
	.byte BG_TILE(4, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(4, $b3)
	.byte BG_SCENERY_END

BG_OBJ6_DATA:
	.byte BG_TILE(2, $b0), BG_SCENERY_NEXT_X
	.byte BG_TILE(1, $b0)
	.byte BG_TILE(2, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(1, $b1)
	.byte BG_TILE(2, $c8)
	.byte BG_TILE(3, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $b2)
	.byte BG_TILE(1, $af)
	.byte BG_TILE(2, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(1, $b3)
	.byte BG_TILE(2, $c8), BG_SCENERY_NEXT_X
	.byte BG_TILE(2, $b3)
	.byte BG_SCENERY_END

BG_OBJ7_DATA:
	.byte BG_TILE(0, $bc)
	.byte BG_TILE(1, $be), BG_SCENERY_NEXT_X
	.byte BG_TILE(0, $bd)
	.byte BG_TILE(1, $bf)
	.byte BG_SCENERY_END



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
	.addr $0000							; I
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
	.addr OBJ_QBLOCK					; [（フラワーが出るブロック）
	.addr $0000							; \
	.addr $0000							; ]
	.addr OBJ_COIN						; ^
	.addr OBJ_HIDE_BLOCK				; _
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


BLOCK_COLLISION_SETTING:
	; BIT7：当たり判定を下から叩いたとき変更するか（0で全方位同じ）
	; BIT6：当たり判定を行うかどうか（0のとき当たり判定無効）
	; BIT5：プレイヤーの座標の修正が必要なブロックか（コインなどなら0，レンガは1）
	; ほかの7ビットで、当たり判定の処理のポインターリストのインデックスを指定する
	; 40 = %0100
	.byte $00							; @
	.byte $00							; A
	.byte %11100000+$00						; B
	.byte $00							; C
	.byte $00							; D
	.byte $00							; E
	.byte $00							; F
	.byte %01100000+$02						; G
	.byte %01100000+$03						; H
	.byte $00							; I
	.byte $00							; J
	.byte $00							; K
	.byte $00							; L
	.byte $00							; M
	.byte %01100000+$04						; N
	.byte $00							; O
	; 50 = %0101
	.byte $00							; P
	.byte %11100000+$05						; Q
	.byte $00							; R
	.byte $00							; S
	.byte $00							; T
	.byte $00							; U
	.byte $00							; V
	.byte $00							; W
	.byte $00							; X
	.byte $00							; Y
	.byte $00							; Z
	.byte %11100000+$07						; [
	.byte $00							; \
	.byte $00							; ]
	.byte %01000000+$09						; ^
	.byte %11100000+$10					; _
	; 60
	.byte %01100000+$0a						; `
	.byte %01100000+$0b						; a
	.byte %01100000+$0c						; b
	.byte %01100000+$0d						; c
	.byte %01000000+$0e						; d
	.byte %01000000+$0f						; e
	.byte $00							; f
	.byte $00							; g
	.byte $00							; h
	.byte $00							; i
	.byte $00							; j
	.byte $00							; k
	.byte $00							; l
	.byte $00							; m
	.byte $00							; n
	.byte $00							; o
	; 70
	.byte $00							; p
	.byte $00							; q
	.byte $00							; r
	.byte $00							; s
	.byte $00							; t
	.byte $00							; u
	.byte $00							; v
	.byte $00							; w
	.byte $00							; x
	.byte $00							; y
	.byte $00							; z
	.byte $00							; {
	.byte $00							; |
	.byte $00							; }
	.byte $00							; ~


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
