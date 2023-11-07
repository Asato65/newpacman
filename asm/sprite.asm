/***************** メモ *****************

キャラクター情報を，キャラクターごとにまとめる

例：）クリボー
アニメーションの数：２
タイルインデックス
タイル属性
初期速度
スプライト：
	アニメーション
	ジャンプ（空中）
	やられた時
	→ ファイヤー，スターでやられた時には
	やられた時のスプライト＋向きを反転



今後：
あたり判定大きさ
速度変化（ハンマーブロスなどのアニメーション）: この時地形判定不要？
踏めるか，ファイヤー耐性は？



***************************************/



CHR_ATTR:
		.byte %0000_0000
		.byte %0000_0000
		.byte %0000_0000
		.byte %0100_0000

CHR_ID:
		.byte $3a, $37, $4f, $4f



.scope Sprite

.ZeroPage

move_dx		: .byte 0
move_dy		: .byte 0


.code									; ----- code -----

.proc _moveSprite
	; ARG: A = sprite id
	shl #1
	tax

	lda spr_posX_arr, x
	add move_dx
	sta spr_posX_arr, x

	lda spr_posY_arr, x
	add move_dy
	sta spr_posY_arr, x

	rts
	; ------------------------------
.endproc


.proc _tfrToChrBuff
	; posy, sprid, attr, posx
	; ARG: X = sprite id (MAX 11)
	; ARG: Y = BUFF index
	/*
	MEMO:
	sprite
		posX, Y
		sprID
		velocity (HI: X, LO: Y)
		(player: acceleration)
	*/

	tya
	shl #2
	tay

	lda spr_posY_arr, x
	sta tmp1							; posY
	lda spr_posX_arr, x
	sta tmp2							; posX

	; Upper left
	lda tmp1
	sta CHR_BUFF+$0, y

	lda CHR_ID, x
	sta CHR_BUFF+$1, y

	lda CHR_ATTR, x
	sta CHR_BUFF+$2, y

	lda tmp2
	sta CHR_BUFF+$3, y

	; Upper right
	inx
	lda tmp1
	sta CHR_BUFF+$4, y

	lda CHR_ID, x
	sta CHR_BUFF+$5, y

	lda CHR_ATTR, x
	sta CHR_BUFF+$6, y

	lda tmp2
	add #8
	sta CHR_BUFF+$7, y

	; Lower left
	inx
	lda tmp1
	add #8
	sta CHR_BUFF+$8, y

	lda CHR_ID, x
	sta CHR_BUFF+$9, y

	lda CHR_ATTR, x
	sta CHR_BUFF+$a, y

	lda tmp2
	sta CHR_BUFF+$b, y


	; Lower right
	inx
	lda tmp1
	add #8
	sta CHR_BUFF+$c, y

	lda CHR_ID, x
	sta CHR_BUFF+$d, y

	lda CHR_ATTR, x
	sta CHR_BUFF+$e, y

	lda tmp2
	add #8
	sta CHR_BUFF+$f, y

	rts
	; ------------------------------
.endproc

.endscope