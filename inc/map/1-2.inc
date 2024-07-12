MAP_ARR_12:
	.addr MAP_12_1
	.addr $ffff


MAP_12_1:
	.byte $bd
	.byte 'B'
	.byte %00010000, %00000000
	.byte (GET_OBJ_POS $0, $2), 'B'
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $0, $4), 'B'
	.byte (GET_OBJ_POS $0, $5), 'B'
	.byte (GET_OBJ_POS $0, $6), 'B'
	.byte (GET_OBJ_POS $0, $7), 'B'
	.byte (GET_OBJ_POS $0, $8), 'B'
	.byte (GET_OBJ_POS $0, $9), 'B'
	.byte (GET_OBJ_POS $0, $a), 'B'
	.byte (GET_OBJ_POS $0, $b), 'B'
	.byte (GET_OBJ_POS $0, $c), 'B'
	.byte (GET_OBJ_POS $1, $c), 0
	.byte (GET_OBJ_POS $2, $c), 0
	.byte (GET_OBJ_POS $3, $c), 0
	.byte (GET_OBJ_POS $4, $c), 0
	.byte (GET_OBJ_POS $5, $c), 0
	.byte (GET_OBJ_POS $b, $4), 'Q'
	.byte (GET_OBJ_POS $c, $4), 'Q'
	.byte (GET_OBJ_POS $d, $4), 'Q'
	.byte (GET_OBJ_POS $e, $4), 'Q'
	.byte (GET_OBJ_POS $f, $4), 'Q'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $2, $2), 'B'
	.byte (GET_OBJ_POS $4, $2), 'B'
	.byte (GET_OBJ_POS $4, $3), 'B'
	.byte (GET_OBJ_POS $6, $2), 'B'
	.byte (GET_OBJ_POS $6, $3), 'B'
	.byte (GET_OBJ_POS $6, $4), 'B'
	.byte (GET_OBJ_POS $8, $2), 'B'
	.byte (GET_OBJ_POS $8, $3), 'B'
	.byte (GET_OBJ_POS $8, $4), 'B'
	.byte (GET_OBJ_POS $8, $5), 'B'
	.byte (GET_OBJ_POS $a, $5), 'B'
	.byte (GET_OBJ_POS $c, $2), 'B'
	.byte (GET_OBJ_POS $c, $3), 'B'
	.byte (GET_OBJ_POS $c, $4), 'B'
	.byte (GET_OBJ_POS $c, $5), 'B'
	.byte (GET_OBJ_POS $e, $2), 'B'
	.byte (GET_OBJ_POS $e, $3), 'B'
	.byte (GET_OBJ_POS $e, $4), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $2), 'B'
	.byte (GET_OBJ_POS $0, $3), 'B'
	.byte (GET_OBJ_POS $2, $2), 'B'
	.byte OBJMAP_END
