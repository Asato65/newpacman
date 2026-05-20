; format
; start with $fe -> 1 block, no end flag
; $ff -> end flag


; PARTS_COIN_1: .byte PARTS_1_OBJ, '^'
; PARTS_BLOCK_1: .byte PARTS_1_OBJ, 'B'

PARTS_COIN_1:
	.byte (OBJ '^', 0), $0
	.byte PARTS_ENDCODE

PARTS_BLOCK_1:
	.byte (OBJ 'B', 0), $0
	.byte PARTS_ENDCODE

PARTS_COINS_4COL:
	; y座標は上位4bitに設定
	.byte (OBJ '^', 1), $0
	.byte (OBJ '^', 1), $0
	.byte (OBJ '^', 1), $0
	.byte (OBJ '^', 0), $0
	.byte PARTS_ENDCODE

PARTS_8STAIRS:
	.byte (OBJ 'H', 1), $70
	.byte (OBJ 'H', 0), $70
	.byte (OBJ 'H', 1), $60
	.byte (OBJ 'H', 0), $70
	.byte (OBJ 'H', 0), $60
	.byte (OBJ 'H', 1), $50
	.byte (OBJ 'H', 0), $70
	.byte (OBJ 'H', 0), $60
	.byte (OBJ 'H', 0), $50
	.byte (OBJ 'H', 1), $40
	.byte (OBJ 'H', 0), $70
	.byte (OBJ 'H', 0), $60
	.byte (OBJ 'H', 0), $50
	.byte (OBJ 'H', 0), $40
	.byte (OBJ 'H', 1), $30
	.byte (OBJ 'H', 0), $70
	.byte (OBJ 'H', 0), $60
	.byte (OBJ 'H', 0), $50
	.byte (OBJ 'H', 0), $40
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 1), $20
	.byte (OBJ 'H', 0), $70
	.byte (OBJ 'H', 0), $60
	.byte (OBJ 'H', 0), $50
	.byte (OBJ 'H', 0), $40
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 0), $20
	.byte (OBJ 'H', 1), $10
	.byte (OBJ 'H', 0), $70
	.byte (OBJ 'H', 0), $60
	.byte (OBJ 'H', 0), $50
	.byte (OBJ 'H', 0), $40
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 0), $20
	.byte (OBJ 'H', 0), $10
	.byte (OBJ 'H', 1), $00
	.byte (OBJ 'H', 0), $70
	.byte (OBJ 'H', 0), $60
	.byte (OBJ 'H', 0), $50
	.byte (OBJ 'H', 0), $40
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 0), $20
	.byte (OBJ 'H', 0), $10
	.byte (OBJ 'H', 1), $00
	.byte PARTS_ENDCODE

PARTS_SKY_1:
	.byte (OBJ 0, 0), $0
	.byte PARTS_ENDCODE

