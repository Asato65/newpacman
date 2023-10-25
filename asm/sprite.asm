.proc _moveSprite
	; ARG: A = sprite id
	shl #1
	tax

	lda spr_buff, x
	add move_dx
	sta spr_buff, x

	lda spr_buff+1, x
	add move_dy
	sta spr_buff+1, x

	rts
	; ------------------------------
.endproc


.proc _tfrToChrBuff
	; posy,
	sprid, attr, posx
	; ARG: A = sprite id
	; ARG: Y = BUFF index
	shl #1
	tax

	lda spr_buff, x						; pos X
	sta tmp1
	lda spr_buff+1, x					; pos Y
	sta tmp2


	tya
	shl #2
	tay
	lda tmp2
	sta CHR_BUFF, y

	iny
	lda CHR_ID, x
	sta CHR_BUFF, y

	iny
	lda CHR_ATTR, X
	sta CHR_BUFF, y

	iny
	lda tmp1
	sta CHR_BUFF

	inx

	iny
	lda tmp2
	sta CHR_BUFF, y

	iny
	lda CHR_ID, x
	sta CHR_BUFF, y

	iny
	lda CHR_ATTR, X
	sta CHR_BUFF, y

	iny
	lda tmp1
	add #8
	sta CHR_BUFF

	inx

	iny
	lda tmp2
	add #8
	sta CHR_BUFF, y

	iny
	lda CHR_ID, x
	sta CHR_BUFF, y

	iny
	lda CHR_ATTR, X
	sta CHR_BUFF, y

	iny
	lda tmp1
	sta CHR_BUFF

	inx

	iny
	lda tmp2
	add #8
	sta CHR_BUFF, y

	iny
	lda CHR_ID, x
	sta CHR_BUFF, y

	iny
	lda CHR_ATTR, X
	sta CHR_BUFF, y

	iny
	lda tmp1
	add #8
	sta CHR_BUFF


	/*
	txa
	shl #1
	tax

	lda CHR_ATTR, x

	lda SPR_ID, x
	sta CHR_BUFF, y
	lda SPR_ATTR, x

	inx
	lda SPR_ID, x
	add y, #4
	sta CHR_BUFF, y

	inx
	lda SPR_ID, x
	add y, #4
	sta CHR_BUFF, y

	inx
	lda SPR_ID, x
	add y, #4
	sta CHR_BUFF, y
	*/

	rts
	; ------------------------------
.endproc