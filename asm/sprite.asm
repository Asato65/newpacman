.proc _moveSprite
	; ARG: A = sprite id
	shl #2
	tax
	lda SPR_BUFF, x
	add move_dy
	sta SPR_BUFF, x
	lda SPR_BUFF+3, x
	add move_dx
	sta SPR_BUFF, x
	rts
	; ------------------------------
.endproc

.proc _tfrToSprBuff
	; posy, sprid, attr, posx
	; ARG: A = sprite id
	shl #2
	tax
	lda SPR_TO_CHAR, xuu

	inx
	lda SPR_TO_CHAR, x
	inx
	lda SPR_TO_CHAR, x
	inx
	lda SPR_TO_CHAR, x
.endproc