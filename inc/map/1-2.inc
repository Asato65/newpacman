MAP_ARR_12:
	.addr MAP_12_1
	.addr $ffff


MAP_12_1:
	.byte $bd
	.byte 'B'
	.byte %00010000, %00000000
	.byte (GET_OBJ_POS $0, $b)
	.addr PARTS_BLOCK_5ROW
	.byte (GET_OBJ_POS $0, $7)
	.addr PARTS_BLOCK_5ROW
	.byte (GET_OBJ_POS $0, $2)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $1, $c)
	.addr PARTS_SKY_2ROW3COL
	.byte (GET_OBJ_POS $4, $c)
	.addr PARTS_SKY_2ROW2COL

	.byte (GET_OBJ_POS $a, $5)
	.addr PARTS_QBLOCK_FLWR_1
	.byte (GET_OBJ_POS $b, $5)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $c, $5)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $d, $5)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $e, $5)
	.addr PARTS_QBLOCK_1
	.byte OBJMAP_NEXT

	.byte (GET_OBJ_POS $1, $2)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $3, $3)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $3, $2)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $5, $4)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $5, $3)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $5, $2)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $7, $5)
	.addr PARTS_HARD_4ROW
	.byte (GET_OBJ_POS $9, $5)
	.addr PARTS_HARD_4ROW
	.byte (GET_OBJ_POS $b, $4)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $b, $3)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $b, $2)
	.addr PARTS_HARD_1

	.byte (GET_OBJ_POS $d, $6)
	.addr PARTS_BLOCK_1

	.byte (GET_OBJ_POS $f, $4)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $f, $3)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $f, $2)
	.addr PARTS_HARD_1
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $1, $3)
	.addr PARTS_HARD_1
	.byte (GET_OBJ_POS $1, $2)
	.addr PARTS_HARD_1


	.byte OBJMAP_END
