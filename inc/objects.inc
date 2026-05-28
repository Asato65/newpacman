; format
; start with $fe -> 1 block, no end flag
; $ff -> end flag


; PARTS_COIN_1: .byte PARTS_1_OBJ, '^'
; PARTS_BLOCK_1: .byte PARTS_1_OBJ, 'B'


; -------------- 1 block ---------------

PARTS_SKY_1:			.byte (OBJ '@', 0), $0, PARTS_ENDCODE
PARTS_BLOCK_1:			.byte (OBJ 'B', 0), $0, PARTS_ENDCODE
PARTS_GROUND_1:			.byte (OBJ 'G', 0), $0, PARTS_ENDCODE
PARTS_HARD_1:			.byte (OBJ 'H', 0), $0, PARTS_ENDCODE
PARTS_HARD2_1:			.byte (OBJ 'N', 0), $0, PARTS_ENDCODE
PARTS_QBLOCK_1:			.byte (OBJ 'Q', 0), $0, PARTS_ENDCODE
PARTS_QBLOCK_FLWR_1:	.byte (OBJ '[', 0), $0, PARTS_ENDCODE
PARTS_COIN_1:			.byte (OBJ '^', 0), $0, PARTS_ENDCODE
PARTS_HIDE_1:			.byte (OBJ '_', 0), $0, PARTS_ENDCODE


; -------------- parts -----------------

PARTS_BLOCK_5COL:
	.byte (OBJ 'B', 1), $0
	.byte (OBJ 'B', 1), $0
	.byte (OBJ 'B', 1), $0
	.byte (OBJ 'B', 1), $0
	.byte (OBJ 'B', 0), $0
	.byte PARTS_ENDCODE

PARTS_BLOCK_5ROW:
	.byte (OBJ 'B', 0), $40
	.byte (OBJ 'B', 0), $30
	.byte (OBJ 'B', 0), $20
	.byte (OBJ 'B', 0), $10
	.byte (OBJ 'B', 0), $00
	.byte PARTS_ENDCODE

PARTS_COINS_4COL:
	; y座標は上位4bitに設定
	.byte (OBJ '^', 1), $0
	.byte (OBJ '^', 1), $0
	.byte (OBJ '^', 1), $0
	.byte (OBJ '^', 0), $0
	.byte PARTS_ENDCODE

PARTS_SKY_2COL:
	.byte (OBJ '@', 0), $10
	.byte (OBJ '@', 0), $00
	.byte PARTS_ENDCODE

PARTS_SKY_2ROW2COL:
	.byte (OBJ '@', 0), $10
	.byte (OBJ '@', 1), $00
	.byte (OBJ '@', 0), $10
	.byte (OBJ '@', 0), $00
	.byte PARTS_ENDCODE

PARTS_SKY_2ROW3COL:
	.byte (OBJ '@', 0), $10
	.byte (OBJ '@', 1), $00
	.byte (OBJ '@', 0), $10
	.byte (OBJ '@', 1), $00
	.byte (OBJ '@', 0), $10
	.byte (OBJ '@', 0), $00
	.byte PARTS_ENDCODE

PARTS_SKY_4ROW2COL:
	.byte (OBJ '@', 0), $30
	.byte (OBJ '@', 0), $20
	.byte (OBJ '@', 0), $10
	.byte (OBJ '@', 1), $00
	.byte (OBJ '@', 0), $30
	.byte (OBJ '@', 0), $20
	.byte (OBJ '@', 0), $10
	.byte (OBJ '@', 0), $00
	.byte PARTS_ENDCODE

PARTS_HARD_4ROW:
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 0), $20
	.byte (OBJ 'H', 0), $10
	.byte (OBJ 'H', 0), $00
	.byte PARTS_ENDCODE

PARTS_PIPE_2ROW:
	.byte (OBJ '`', 0), $10
	.byte (OBJ 'a', 1), $00
	.byte (OBJ 'b', 0), $10
	.byte (OBJ 'c', 0), $00
	.byte PARTS_ENDCODE

PARTS_PIPE_3ROW:
	.byte (OBJ '`', 0), $20
	.byte (OBJ '`', 0), $10
	.byte (OBJ 'a', 1), $00
	.byte (OBJ 'b', 0), $20
	.byte (OBJ 'b', 0), $10
	.byte (OBJ 'c', 0), $00
	.byte PARTS_ENDCODE

PARTS_PIPE_4ROW:
	.byte (OBJ '`', 0), $30
	.byte (OBJ '`', 0), $20
	.byte (OBJ '`', 0), $10
	.byte (OBJ 'a', 1), $00
	.byte (OBJ 'b', 0), $30
	.byte (OBJ 'b', 0), $20
	.byte (OBJ 'b', 0), $10
	.byte (OBJ 'c', 0), $00
	.byte PARTS_ENDCODE

PARTS_PIPE_5ROW:
	.byte (OBJ '`', 0), $40
	.byte (OBJ '`', 0), $30
	.byte (OBJ '`', 0), $20
	.byte (OBJ '`', 0), $10
	.byte (OBJ 'a', 1), $00
	.byte (OBJ 'b', 0), $40
	.byte (OBJ 'b', 0), $30
	.byte (OBJ 'b', 0), $20
	.byte (OBJ 'b', 0), $10
	.byte (OBJ 'c', 0), $00
	.byte PARTS_ENDCODE

PARTS_GOAL:
	.byte (OBJ 'H', 0), $a0
	.byte (OBJ 'd', 0), $90
	.byte (OBJ 'd', 0), $80
	.byte (OBJ 'd', 0), $70
	.byte (OBJ 'd', 0), $60
	.byte (OBJ 'd', 0), $50
	.byte (OBJ 'd', 0), $40
	.byte (OBJ 'd', 0), $30
	.byte (OBJ 'd', 0), $20
	.byte (OBJ 'd', 0), $10
	.byte (OBJ 'e', 0), $00
	.byte PARTS_ENDCODE

PARTS_4STAIRS:
	.byte (OBJ 'H', 1), $30
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 1), $20
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 0), $20
	.byte (OBJ 'H', 1), $10
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 0), $20
	.byte (OBJ 'H', 0), $10
	.byte (OBJ 'H', 0), $00
	.byte PARTS_ENDCODE

PARTS_4STAIRS_REV:
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 0), $20
	.byte (OBJ 'H', 0), $10
	.byte (OBJ 'H', 1), $00
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 0), $20
	.byte (OBJ 'H', 1), $10
	.byte (OBJ 'H', 0), $30
	.byte (OBJ 'H', 1), $20
	.byte (OBJ 'H', 0), $30
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
	.byte (OBJ 'H', 0), $00
	.byte PARTS_ENDCODE
