MAP_ARR_13:
	.addr MAP_13_1_NEW
	.addr MAP_13_2_NEW
	.addr MAP_13_3_NEW
	.addr $ffff

MAP_13_1_NEW:
	.byte $bd
	.byte 'B', %00000000, %00000000

	; .addr (PART x, y, type, size, flag(pipe exit, a))
	; .addr (CTR id) -> BG, floor...

	.byte (GET_OBJ_POS $0, $5)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $4, $5)
	.addr PARTS_BLOCK_5COL
	.byte (GET_OBJ_POS $5, $5)			; レンガ*5を上書き
	.addr PARTS_QBLOCK_FLWR_1
	.byte (GET_OBJ_POS $6, $9)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $7, $5)			; 上書き
	.addr PARTS_QBLOCK_1

	.byte (GET_OBJ_POS $c, $3)			; 土管1
	.addr PARTS_PIPE_2ROW
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $6, $4)			; 土管2
	.addr PARTS_PIPE_3ROW
	.byte (GET_OBJ_POS $e, $5)			; 土管3
	.addr PARTS_PIPE_4ROW
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $9, $5)			; 土管4
	.addr PARTS_PIPE_4ROW
	.byte OBJMAP_NEXT

	.byte (GET_OBJ_POS $0, $6)			; 隠し
	.addr PARTS_HIDE_1
	.byte (GET_OBJ_POS $5, $1)			; 落とし穴
	.addr PARTS_SKY_2ROW2COL

	.byte (GET_OBJ_POS $d, $5)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $e, $5)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $f, $5)
	.addr PARTS_BLOCK_1
	.byte OBJMAP_END

MAP_13_2_NEW:
	.byte $bd
	.byte 'B', %00000010, %00000000

	.byte (GET_OBJ_POS $6, $1)
	.addr PARTS_SKY_2ROW3COL
	.byte (GET_OBJ_POS $8, $9)
	.addr PARTS_SKY_2ROW3COL			; 少し無駄に書き換えるがマップサイズは小さくなる
	.byte (GET_OBJ_POS $e, $5)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $e, $9)
	.addr PARTS_QBLOCK_1
	.byte OBJMAP_END

MAP_13_3_NEW:
	.byte $bd
	.byte 'B', %00000000, %00000000

	.byte (GET_OBJ_POS $4, $5)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $5, $5)			; スターが出る場所
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $a, $5)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $d, $5)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $d, $9)			; パワーアップアイテム
	.addr PARTS_QBLOCK_1
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $5)
	.addr PARTS_QBLOCK_1

	.byte (GET_OBJ_POS $6, $5)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $9, $9)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $a, $9)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $b, $9)
	.addr PARTS_BLOCK_1
	.byte OBJMAP_NEXT

	.byte (GET_OBJ_POS $0, $9)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $1, $9)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $1, $5)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $2, $9)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $2, $5)
	.addr PARTS_BLOCK_1
	.byte (GET_OBJ_POS $3, $9)
	.addr PARTS_BLOCK_1

	.byte (GET_OBJ_POS $6, $5)
	.addr PARTS_4STAIRS
	.byte (GET_OBJ_POS $c, $5)
	.addr PARTS_4STAIRS_REV
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $4, $5)
	.addr PARTS_4STAIRS
	.byte (GET_OBJ_POS $8, $5)
	.addr PARTS_HARD_4ROW
	.byte (GET_OBJ_POS $9, $7)
	.addr PARTS_SKY_4ROW2COL
	.byte (GET_OBJ_POS $9, $3)
	.addr PARTS_SKY_4ROW2COL
	.byte (GET_OBJ_POS $b, $5)
	.addr PARTS_4STAIRS_REV
	.byte OBJMAP_NEXT

	.byte (GET_OBJ_POS $3, $3)
	.addr PARTS_PIPE_2ROW
	.byte (GET_OBJ_POS $8, $5)
	.addr PARTS_BLOCK_5COL
	.byte (GET_OBJ_POS $a, $5)
	.addr PARTS_QBLOCK_1
	.byte (GET_OBJ_POS $c, $5)
	.addr PARTS_SKY_1
	.byte OBJMAP_NEXT

	.byte (GET_OBJ_POS $3, $3)
	.addr PARTS_PIPE_2ROW
	.byte (GET_OBJ_POS $5, $9)
	.addr PARTS_8STAIRS
	.byte (GET_OBJ_POS $d, $9)
	.addr PARTS_HARD_4ROW
	.byte (GET_OBJ_POS $d, $5)
	.addr PARTS_HARD_4ROW
	.byte OBJMAP_NEXT

	.byte (GET_OBJ_POS $6, $c)
	.addr PARTS_GOAL
	.byte (GET_OBJ_POS $d, $2)
	.addr PARTS_BLOCK_1

	.byte OBJMAP_END

