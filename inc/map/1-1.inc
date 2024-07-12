MAP_ARR_11:
	.addr MAP_11_1
	.addr MAP_11_2
	.addr $ffff


MAP_11_1:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $5, $2), 'H'
	.byte (GET_OBJ_POS $5, $3), 'H'
	.byte (GET_OBJ_POS $8, $5), 'B'
	.byte (GET_OBJ_POS $9, $5), 'Q'
	.byte (GET_OBJ_POS $9, $8), 'B'
	.byte (GET_OBJ_POS $a, $5), 'B'
	.byte (GET_OBJ_POS $a, $8), 'Q'
	.byte (GET_OBJ_POS $a, $b), 'B'
	.byte (GET_OBJ_POS $b, $5), 'Q'
	.byte (GET_OBJ_POS $b, $8), 'B'
	.byte (GET_OBJ_POS $b, $b), 'B'
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
	.byte (GET_OBJ_POS $2, $5), 'Q'
	.byte (GET_OBJ_POS $2, $6), 'B'
	.byte (GET_OBJ_POS $2, $7), 'B'
	.byte (GET_OBJ_POS $a, $4), 'B'
	.byte (GET_OBJ_POS $a, $5), 'B'
	.byte (GET_OBJ_POS $a, $6), 'B'
	.byte (GET_OBJ_POS $a, $7), 'B'
	.byte (GET_OBJ_POS $a, $8), 'B'
	.byte (GET_OBJ_POS $f, $2), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $2), 'B'
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $1, $2), 'B'
	.byte (GET_OBJ_POS $1, $3), 'B'
	.byte (GET_OBJ_POS $1, $4), 'B'
	.byte (GET_OBJ_POS $4, $2), 'B'
	.byte (GET_OBJ_POS $4, $3), 'B'
	.byte (GET_OBJ_POS $4, $4), 'B'
	.byte (GET_OBJ_POS $5, $2), 'B'
	.byte (GET_OBJ_POS $5, $3), 'B'
	.byte (GET_OBJ_POS $6, $2), 'B'
	.byte (GET_OBJ_POS $a, $6), 'H'
	.byte (GET_OBJ_POS $b, $5), 'H'
	.byte (GET_OBJ_POS $b, $6), 'H'
	.byte (GET_OBJ_POS $c, $6), 'H'
	.byte OBJMAP_END
