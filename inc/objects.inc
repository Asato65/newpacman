; format
; start with $fe -> 1 block, no end flag
; $ff -> end flag


; PARTS_COIN_1: .byte PARTS_1_OBJ, '^'
; PARTS_BLOCK_1: .byte PARTS_1_OBJ, 'B'

PARTS_COIN_1:
	.byte OBJ('^', 0), $0
	.byte PARTS_ENDCODE

PARTS_BLOCK_1:
	.byte OBJ('B', 0), $0
	.byte PARTS_ENDCODE

PARTS_COINS_4COL:
	; y座標は上位4bitに設定
	.byte OBJ('^', 1), $0
	.byte OBJ('^', 1), $0
	.byte OBJ('^', 1), $0
	.byte OBJ('^', 0), $0
	.byte PARTS_ENDCODE


