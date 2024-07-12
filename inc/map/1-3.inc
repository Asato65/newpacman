MAP_ARR_13:
	.addr MAP_13_1
	.addr MAP_13_2
	.addr MAP_13_3
	.addr MAP_13_4
	.addr $ffff


MAP_13_1:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $5), 'Q'
	.byte (GET_OBJ_POS $4, $5), 'B'
	.byte (GET_OBJ_POS $5, $5), 'Q'
	.byte (GET_OBJ_POS $6, $5), 'B'
	.byte (GET_OBJ_POS $6, $9), 'Q'
	.byte (GET_OBJ_POS $7, $5), 'Q'
	.byte (GET_OBJ_POS $8, $5), 'B'
	.byte (GET_OBJ_POS $c, $2), '`'		; 土管1
	.byte (GET_OBJ_POS $c, $3), 'a'
	.byte (GET_OBJ_POS $d, $2), 'b'
	.byte (GET_OBJ_POS $d, $3), 'c'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $6, $2), '`'		; 土管2
	.byte (GET_OBJ_POS $6, $3), '`'
	.byte (GET_OBJ_POS $6, $4), 'a'
	.byte (GET_OBJ_POS $7, $2), 'b'
	.byte (GET_OBJ_POS $7, $3), 'b'
	.byte (GET_OBJ_POS $7, $4), 'c'
	.byte (GET_OBJ_POS $e, $2), '`'		; 土管3
	.byte (GET_OBJ_POS $e, $3), '`'
	.byte (GET_OBJ_POS $e, $4), '`'
	.byte (GET_OBJ_POS $e, $5), 'a'
	.byte (GET_OBJ_POS $f, $2), 'b'
	.byte (GET_OBJ_POS $f, $3), 'b'
	.byte (GET_OBJ_POS $f, $4), 'b'
	.byte (GET_OBJ_POS $f, $5), 'c'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $9, $2), '`'		; 土管4
	.byte (GET_OBJ_POS $9, $3), '`'
	.byte (GET_OBJ_POS $9, $4), '`'
	.byte (GET_OBJ_POS $9, $5), 'a'
	.byte (GET_OBJ_POS $a, $2), 'b'		; 土管4
	.byte (GET_OBJ_POS $a, $3), 'b'
	.byte (GET_OBJ_POS $a, $4), 'b'
	.byte (GET_OBJ_POS $a, $5), 'c'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $5, $0), 0
	.byte (GET_OBJ_POS $5, $1), 0
	.byte (GET_OBJ_POS $6, $0), 0
	.byte (GET_OBJ_POS $6, $1), 0
	.byte (GET_OBJ_POS $d, $5), 'B'
	.byte (GET_OBJ_POS $e, $5), 'Q'
	.byte (GET_OBJ_POS $f, $5), 'B'
	.byte OBJMAP_END


MAP_13_2:
	.byte $bd
	.byte 'B'
	.byte %00000010, %00000000
	.byte (GET_OBJ_POS $6, $0), 0
	.byte (GET_OBJ_POS $6, $1), 0
	.byte (GET_OBJ_POS $7, $0), 0
	.byte (GET_OBJ_POS $7, $1), 0
	.byte (GET_OBJ_POS $8, $0), 0
	.byte (GET_OBJ_POS $8, $1), 0
	.byte (GET_OBJ_POS $8, $9), 0
	.byte (GET_OBJ_POS $9, $9), 0
	.byte (GET_OBJ_POS $a, $9), 0
	.byte (GET_OBJ_POS $e, $5), 'B'
	.byte (GET_OBJ_POS $e, $9), 'Q'
	.byte OBJMAP_END

MAP_13_3:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte (GET_OBJ_POS $4, $5), 'B'
	.byte (GET_OBJ_POS $5, $5), 'B'
	.byte (GET_OBJ_POS $a, $5), 'Q'
	.byte (GET_OBJ_POS $d, $5), 'Q'
	.byte (GET_OBJ_POS $d, $9), 'Q'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $5), 'Q'
	.byte (GET_OBJ_POS $5, $5), 'B'
	.byte (GET_OBJ_POS $8, $9), 'B'
	.byte (GET_OBJ_POS $9, $9), 'B'
	.byte (GET_OBJ_POS $a, $9), 'B'
	.byte (GET_OBJ_POS $e, $9), 'B'
	.byte (GET_OBJ_POS $f, $5), 'B'
	.byte (GET_OBJ_POS $f, $9), 'Q'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $0, $5), 'B'
	.byte (GET_OBJ_POS $0, $9), 'Q'
	.byte (GET_OBJ_POS $1, $9), 'B'
	.byte (GET_OBJ_POS $4, $2), 'H'
	.byte (GET_OBJ_POS $5, $2), 'H'
	.byte (GET_OBJ_POS $5, $3), 'H'
	.byte (GET_OBJ_POS $6, $2), 'H'
	.byte (GET_OBJ_POS $6, $3), 'H'
	.byte (GET_OBJ_POS $6, $4), 'H'
	.byte (GET_OBJ_POS $7, $2), 'H'
	.byte (GET_OBJ_POS $7, $3), 'H'
	.byte (GET_OBJ_POS $7, $4), 'H'
	.byte (GET_OBJ_POS $7, $5), 'H'
	.byte (GET_OBJ_POS $a, $2), 'H'
	.byte (GET_OBJ_POS $a, $3), 'H'
	.byte (GET_OBJ_POS $a, $4), 'H'
	.byte (GET_OBJ_POS $a, $5), 'H'
	.byte (GET_OBJ_POS $b, $2), 'H'
	.byte (GET_OBJ_POS $b, $3), 'H'
	.byte (GET_OBJ_POS $b, $4), 'H'
	.byte (GET_OBJ_POS $c, $2), 'H'
	.byte (GET_OBJ_POS $c, $3), 'H'
	.byte (GET_OBJ_POS $d, $2), 'H'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $2, $2), 'H'
	.byte (GET_OBJ_POS $3, $2), 'H'
	.byte (GET_OBJ_POS $3, $3), 'H'
	.byte (GET_OBJ_POS $4, $2), 'H'
	.byte (GET_OBJ_POS $4, $3), 'H'
	.byte (GET_OBJ_POS $4, $4), 'H'
	.byte (GET_OBJ_POS $5, $2), 'H'
	.byte (GET_OBJ_POS $5, $3), 'H'
	.byte (GET_OBJ_POS $5, $4), 'H'
	.byte (GET_OBJ_POS $5, $5), 'H'
	.byte (GET_OBJ_POS $6, $2), 'H'
	.byte (GET_OBJ_POS $6, $3), 'H'
	.byte (GET_OBJ_POS $6, $4), 'H'
	.byte (GET_OBJ_POS $6, $5), 'H'
	.byte (GET_OBJ_POS $7, $0), 0
	.byte (GET_OBJ_POS $7, $1), 0
	.byte (GET_OBJ_POS $8, $0), 0
	.byte (GET_OBJ_POS $8, $1), 0
	.byte (GET_OBJ_POS $9, $2), 'H'
	.byte (GET_OBJ_POS $9, $3), 'H'
	.byte (GET_OBJ_POS $9, $4), 'H'
	.byte (GET_OBJ_POS $9, $5), 'H'
	.byte (GET_OBJ_POS $a, $2), 'H'
	.byte (GET_OBJ_POS $a, $3), 'H'
	.byte (GET_OBJ_POS $a, $4), 'H'
	.byte (GET_OBJ_POS $b, $2), 'H'
	.byte (GET_OBJ_POS $b, $3), 'H'
	.byte (GET_OBJ_POS $c, $2), 'H'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $1, $2), '`'		; 土管5（出口）
	.byte (GET_OBJ_POS $1, $3), 'a'
	.byte (GET_OBJ_POS $2, $2), 'b'
	.byte (GET_OBJ_POS $2, $3), 'c'
	.byte (GET_OBJ_POS $6, $5), 'B'
	.byte (GET_OBJ_POS $7, $5), 'B'
	.byte (GET_OBJ_POS $8, $5), 'Q'
	.byte (GET_OBJ_POS $9, $5), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $1, $2), '`'		; 土管6
	.byte (GET_OBJ_POS $1, $3), 'a'
	.byte (GET_OBJ_POS $2, $2), 'b'
	.byte (GET_OBJ_POS $2, $3), 'c'
	.byte (GET_OBJ_POS $3, $2), 'H'
	.byte (GET_OBJ_POS $4, $2), 'H'
	.byte (GET_OBJ_POS $4, $3), 'H'
	.byte (GET_OBJ_POS $5, $2), 'H'
	.byte (GET_OBJ_POS $5, $3), 'H'
	.byte (GET_OBJ_POS $5, $4), 'H'
	.byte (GET_OBJ_POS $6, $2), 'H'
	.byte (GET_OBJ_POS $6, $3), 'H'
	.byte (GET_OBJ_POS $6, $4), 'H'
	.byte (GET_OBJ_POS $6, $5), 'H'
	.byte (GET_OBJ_POS $7, $2), 'H'
	.byte (GET_OBJ_POS $7, $3), 'H'
	.byte (GET_OBJ_POS $7, $4), 'H'
	.byte (GET_OBJ_POS $7, $5), 'H'
	.byte (GET_OBJ_POS $7, $6), 'H'
	.byte (GET_OBJ_POS $8, $2), 'H'
	.byte (GET_OBJ_POS $8, $3), 'H'
	.byte (GET_OBJ_POS $8, $4), 'H'
	.byte (GET_OBJ_POS $8, $5), 'H'
	.byte (GET_OBJ_POS $8, $6), 'H'
	.byte (GET_OBJ_POS $8, $7), 'H'
	.byte (GET_OBJ_POS $9, $2), 'H'
	.byte (GET_OBJ_POS $9, $3), 'H'
	.byte (GET_OBJ_POS $9, $4), 'H'
	.byte (GET_OBJ_POS $9, $5), 'H'
	.byte (GET_OBJ_POS $9, $6), 'H'
	.byte (GET_OBJ_POS $9, $7), 'H'
	.byte (GET_OBJ_POS $9, $8), 'H'
	.byte (GET_OBJ_POS $a, $2), 'H'
	.byte (GET_OBJ_POS $a, $3), 'H'
	.byte (GET_OBJ_POS $a, $4), 'H'
	.byte (GET_OBJ_POS $a, $5), 'H'
	.byte (GET_OBJ_POS $a, $6), 'H'
	.byte (GET_OBJ_POS $a, $7), 'H'
	.byte (GET_OBJ_POS $a, $8), 'H'
	.byte (GET_OBJ_POS $a, $9), 'H'
	.byte (GET_OBJ_POS $b, $2), 'H'
	.byte (GET_OBJ_POS $b, $3), 'H'
	.byte (GET_OBJ_POS $b, $4), 'H'
	.byte (GET_OBJ_POS $b, $5), 'H'
	.byte (GET_OBJ_POS $b, $6), 'H'
	.byte (GET_OBJ_POS $b, $7), 'H'
	.byte (GET_OBJ_POS $b, $8), 'H'
	.byte (GET_OBJ_POS $b, $9), 'H'
	.byte OBJMAP_END

MAP_13_4:
	.byte $bd
	.byte 'B'
	.byte %00000000, %00000000
	.byte (GET_OBJ_POS $4, $2), 'H'
	.byte (GET_OBJ_POS $4, $3), 'd'
	.byte (GET_OBJ_POS $4, $4), 'd'
	.byte (GET_OBJ_POS $4, $5), 'd'
	.byte (GET_OBJ_POS $4, $6), 'd'
	.byte (GET_OBJ_POS $4, $7), 'd'
	.byte (GET_OBJ_POS $4, $8), 'd'
	.byte (GET_OBJ_POS $4, $9), 'd'
	.byte (GET_OBJ_POS $4, $a), 'd'
	.byte (GET_OBJ_POS $4, $b), 'd'
	.byte (GET_OBJ_POS $4, $c), 'e'
	.byte (GET_OBJ_POS $b, $2), 'B'
	.byte OBJMAP_NEXT
	.byte (GET_OBJ_POS $f, $0), 'G'
	.byte OBJMAP_END
