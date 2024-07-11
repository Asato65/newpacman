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
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000		; standing
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000		; walk1
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000		; walk2
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000		; walk3, fall
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000		; jumping

CHR_ID:
		.byte $3a, $37, $4f, $4f		; standing
		.byte $32, $33, $34, $35		; walk1
		.byte $36, $37, $38, $39		; walk2
		.byte $3a, $37, $3b, $3c		; walk3, falling
		.byte $32, $41, $42, $43		; jumping


PLAYER_STANDING_ATTR:		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000
PLAYER_WALK1_ATTR:			.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
PLAYER_WALK2_ATTR:			.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
PLAYER_WALK3_FALLING_ATTR:	.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
PLAYER_JUMPING_ATTR:		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
PLAYER_BRAKING_ATTR:		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000

PLAYER_STANDING:		.byte $3a, $37, $4f, $4f
PLAYER_WALK1:			.byte $32, $33, $34, $35
PLAYER_WALK2:			.byte $36, $37, $38, $39
PLAYER_WALK3_FALLING:	.byte $3a, $37, $3b, $3c
PLAYER_JUMPING:			.byte $32, $41, $42, $43
PLAYER_BRAKING:			.byte $3d, $3e, $3f, $40


CHR_ATTR_TABLE:
		.word PLAYER_STANDING_ATTR
		.word PLAYER_WALK1_ATTR, PLAYER_WALK2_ATTR, PLAYER_WALK3_FALLING_ATTR
		.word PLAYER_JUMPING_ATTR
		.word PLAYER_BRAKING_ATTR

CHR_ID_TABLE:
		.word PLAYER_STANDING
		.word PLAYER_WALK1, PLAYER_WALK2, PLAYER_WALK3_FALLING
		.word PLAYER_JUMPING
		.word PLAYER_BRAKING


MAX_SPD_L:
		.byte $e8, $d8

MAX_SPD_R:
		.byte $18, $28

AMOUNT_INC_SPD_L:
		.byte $ff, $fe, $fd

AMOUNT_INC_SPD_R:
		.byte $01, $02, $03



.scope Sprite

.code									; ----- code -----

;*------------------------------------------------------------------------------
; Move sprite
; @PARAMS		X: sprite id
; @CLOBBERS		A Y tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _moveSprite
; 		dex									; sprid=0のときスプライトは無なので，必ず1から始まる→0から始まるように修正
; 		lda spr_velocity_x_arr, x
; 		bne :+
; 		sta scroll_amount
; :
; 		clc
; 		adc spr_posX_arr, x
; 		cmp #$f0
; 		bcc :+
; 		pha
; 		lda spr_posX_tmp_arr, x
; 		sec
; 		sbc spr_posX_arr, x
; 		tay								; move_dxを求める（移動量）
; 		pla
; 		cpy #$80
; 		bcc :+
; 		; posX < 0 && move_dx < 0
; 		lda #0
; :

; ; スクロールロック時の処理
; 		ldy is_scroll_locked
; 		bne @STORE_POSX

; 		cmp #PLAYER_MAX_POSX
; 		bcs @MOVE_SCROLL

; @STORE_POSX:
; 		cmp #($100-(PLAYER_WIDTH+PLAYER_PADDING))
; 		bcc @STOP_MOVE
; 		beq @STOP_MOVE

; 		lda #($100-(PLAYER_WIDTH+PLAYER_PADDING))
; @STOP_MOVE:
; 		sta spr_posX_arr, x
; 		jmp @MOVE_Y
; 		; ------------------------------

; @MOVE_SCROLL:
; 		sub #PLAYER_MAX_POSX
; 		sta scroll_amount

; 		lda #PLAYER_MAX_POSX
; 		sta spr_posX_arr, x

; @MOVE_Y:
; 		lda spr_posY_tmp_arr, x
; 		sta spr_posY_arr, x

; 		rts
; 		; ------------------------------

	dex									; sprid=0のときスプライトは無なので，必ず1から始まる→0から始まるように修正

	; Y方向
	lda spr_posY_tmp_arr, x
	sta spr_posY_arr, x

	; X方向
	lda spr_posX_tmp_arr, x
	cmp #$f8
	bcc :+
	; マリオが左端を超えた時
	; lda #0
	; sta spr_posX_arr, x
	rts
	; ------------------------------
:
	; 右端チェック
	ldy is_scroll_locked
	beq :++
	; スクロールロック時
	cmp #($100-PLAYER_WIDTH-PLAYER_PADDING)
	bcc :+
	; 右端を超えた時
	lda #($100-PLAYER_WIDTH-PLAYER_PADDING)
:
	sta spr_posX_arr, x
	rts
	; ------------------------------
:
	cmp #PLAYER_MAX_POSX
	bcc :+
	; マリオが右端を超えた時
	sub #PLAYER_MAX_POSX
	sta scroll_amount
	lda #PLAYER_MAX_POSX
	bne :++
:
	ldy #0
	sty scroll_amount
:
	sta spr_posX_arr, x

	rts
	; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 通常の向きでスプライトをバッファ転送する
; @PARAMS		x: sprite id（-1された状態)
; @PARAMS		y: buff index（ストアし始める最初のindex）
; @PARAMS		tmp1: posY
; @PARAMS		tmp2: posX
; @CLOBBERS		A X Y tmp_rgstY
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _tfrSprToBuffNormal
		; Upper left
		lda tmp1
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		add #8
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y

		lda tmp2
		sta CHR_BUFF+$3, y
		sta CHR_BUFF+$b, y
		add #8
		sta CHR_BUFF+$7, y
		sta CHR_BUFF+$f, y


		sty tmp_rgstY
		lda spr_anime_num, x
		tax

		ldy #0
		ldarr CHR_ATTR_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$2, y
		ldy #1
		ldarr CHR_ATTR_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$6, y
		ldy #2
		ldarr CHR_ATTR_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$a, y
		ldy #3
		ldarr CHR_ATTR_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$e, y

		ldy #0
		ldarr CHR_ID_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$1, y
		ldy #1
		ldarr CHR_ID_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$5, y
		ldy #2
		ldarr CHR_ID_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$9, y
		ldy #3
		ldarr CHR_ID_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$d, y

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 左右反転してスプライトをバッファ転送する
; @PARAMS		x: sprite id（-1された状態)
; @PARAMS		y: buff index（ストアし始める最初のindex）
; @PARAMS		tmp1: posY
; @PARAMS		tmp2: posX
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _tfrSprToBuffFlipX
		lda tmp1
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		add #8
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y

		lda tmp2
		sta CHR_BUFF+$7, y
		sta CHR_BUFF+$f, y
		add #8
		sta CHR_BUFF+$3, y
		sta CHR_BUFF+$b, y

		sty tmp_rgstY
		lda spr_anime_num, x
		tax

		ldy #0
		ldarr CHR_ATTR_TABLE
		eor #%0100_0000						; 左右反転
		ldy tmp_rgstY
		sta CHR_BUFF+$2, y
		ldy #1
		ldarr CHR_ATTR_TABLE
		eor #%0100_0000
		ldy tmp_rgstY
		sta CHR_BUFF+$6, y
		ldy #2
		ldarr CHR_ATTR_TABLE
		eor #%0100_0000
		ldy tmp_rgstY
		sta CHR_BUFF+$a, y
		ldy #3
		ldarr CHR_ATTR_TABLE
		eor #%0100_0000
		ldy tmp_rgstY
		sta CHR_BUFF+$e, y

		ldy #0
		ldarr CHR_ID_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$1, y
		ldy #1
		ldarr CHR_ID_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$5, y
		ldy #2
		ldarr CHR_ID_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$9, y
		ldy #3
		ldarr CHR_ID_TABLE
		ldy tmp_rgstY
		sta CHR_BUFF+$d, y

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 上下反転してスプライトをバッファ転送する
; @PARAMS		x: sprite id（-1された状態)
; @PARAMS		y: buff index（ストアし始める最初のindex）
; @PARAMS		tmp1: posY
; @PARAMS		tmp2: posX
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _tfrSprToBuffFlipY
	; Lower left
	lda tmp1
	add #8
	sta CHR_BUFF+$0, y
	lda CHR_ID, x
	sta CHR_BUFF+$1, y
	lda CHR_ATTR, x
	sta CHR_BUFF+$2, y
	lda tmp2
	sta CHR_BUFF+$3, y
	; Lower right
	inx
	lda tmp1
	add #8
	sta CHR_BUFF+$4, y
	lda CHR_ID, x
	sta CHR_BUFF+$5, y
	lda CHR_ATTR, x
	sta CHR_BUFF+$6, y
	lda tmp2
	add #8
	sta CHR_BUFF+$7, y
	; Upper left
	inx
	lda tmp1
	sta CHR_BUFF+$8, y
	lda CHR_ID, x
	sta CHR_BUFF+$9, y
	lda CHR_ATTR, x
	sta CHR_BUFF+$a, y
	lda tmp2
	sta CHR_BUFF+$b, y
	; Upper right
	inx
	lda tmp1
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


;*------------------------------------------------------------------------------
; transfar to chr buff
; @PARAMS		X: sprite id, Y = BUFF index
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _tfrToChrBuff
		cpx #0								; sprid=0 -> スプライトなし
		beq @EXIT
		dex									; spridを0～に変更

		iny									; 0スプライトの分空けるため(buff indexを0に設定しても0スプライトを上書きしない)
		tya
		shl #2
		tay

		lda spr_posY_arr, x
		sta tmp1							; posY
		lda spr_posX_arr, x
		sta tmp2							; posX

		lda spr_attr_arr, x
		and #BIT0
		beq :+
		jsr _tfrSprToBuffNormal
		jmp @EXIT
:
		jsr _tfrSprToBuffFlipX

@EXIT:
		rts
		; ------------------------------
.endproc


.endscope