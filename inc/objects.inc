; format
; start with $fe -> 1 block, no end flag
; $ff -> end flag

; -------------- 1 block ---------------

PARTS_SKY_1:			.byte (OBJ '@', 0), $0, PARTS_ENDCODE
PARTS_QBLOCK_1:			.byte (OBJ 'Q', 0), $0, PARTS_ENDCODE
PARTS_QBLOCK_FLWR_1:	.byte (OBJ '[', 0), $0, PARTS_ENDCODE


; -------------- parts -----------------

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

