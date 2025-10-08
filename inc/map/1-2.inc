MAP_ARR_12:
	.addr MAP_12_1
	.addr $ffff


MAP_12_1:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $8, $2), 'B'
	.byte (GET_OBJ_POS $9, $3), 'B'
	.byte (GET_OBJ_POS $a, $4), 'B'
	.byte (GET_OBJ_POS $b, $5), 'B'
	.byte (GET_OBJ_POS $c, $6), 'B'
	.byte (GET_OBJ_POS $d, $7), 'B'
	.byte (GET_OBJ_POS $e, $b), 'B'
	.byte (GET_OBJ_POS $e, $c), 'B'
	.byte (GET_OBJ_POS $f, $b), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $b), 'B'
	.byte (GET_OBJ_POS $1, $b), 'B'
	.byte (GET_OBJ_POS $2, $a), 'B'
	.byte (GET_OBJ_POS $3, $9), 'B'
	.byte (GET_OBJ_POS $4, $8), 'B'
	.byte (GET_OBJ_POS $5, $7), 'B'
	.byte (GET_OBJ_POS $6, $6), 'B'
	.byte (GET_OBJ_POS $7, $5), 'B'
	.byte (GET_OBJ_POS $8, $4), 'B'
	.byte (GET_OBJ_POS $8, $3), 'B'
	.byte (GET_OBJ_POS $9, $3), 'B'
	.byte (GET_OBJ_POS $a, $4), 'B'
	.byte (GET_OBJ_POS $a, $3), 'B'
	.byte (GET_OBJ_POS $f, $2), 'd'
	.byte (GET_OBJ_POS $f, $3), 'd'
	.byte (GET_OBJ_POS $f, $4), 'd'
	.byte (GET_OBJ_POS $f, $5), 'd'
	.byte (GET_OBJ_POS $f, $6), 'd'
	.byte (GET_OBJ_POS $f, $7), 'd'
	.byte (GET_OBJ_POS $f, $8), 'd'
	.byte (GET_OBJ_POS $f, $9), 'd'
	.byte (GET_OBJ_POS $f, $a), 'd'
	.byte (GET_OBJ_POS $f, $b), 'd'
	.byte (GET_OBJ_POS $f, $c), 'e'
	.byte (GET_OBJ_POS $f, $2), 'H'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $f, $0), 'G'
	.byte OBJMAP_END
