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
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000
		.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000

CHR_ID:
		.byte $3a, $37, $4f, $4f		; standing
		.byte $32, $33, $34, $35		; walk1
		.byte $36, $37, $38, $39		; walk2
		.byte $3a, $37, $3b, $3c		; walk3, falling
		.byte $32, $41, $42, $43		; jumping


MAX_SPD_L:
		.byte $e8, $d8

MAX_SPD_R:
		.byte $18, $28

AMOUNT_INC_SPD_L:
		.byte $ff, $fe, $fd

AMOUNT_INC_SPD_R:
		.byte $01, $02, $03



.scope Sprite

.ZeroPage

move_dx		: .byte 0
move_dy		: .byte 0


.code									; ----- code -----

;*------------------------------------------------------------------------------
; Move sprite
; @PARAMS		X: sprite id
; @CLOBBERS		A Y tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _moveSprite
	dex									; sprid=0のときスプライトは無なので，必ず1から始まる→0から始まるように修正
	lda spr_velocity_x_arr, x
	sta spr_final_velocity_x_arr, x
	bne :+
	sta scroll_amount
:
	clc
	adc spr_posX_arr, x
	cmp #$f0
	bcc :+
	ldy spr_velocity_x_arr, x
	cpy #$80
	bcc :+
	; posX < 0 && move_dx < 0
	lda #0
:

	; スクロールロック時の処理
	ldy is_scroll_locked
	bne @STORE_POSX

	cmp #PLAYER_MAX_POSX
	bcs @MOVE_SCROLL

@STORE_POSX:
	cmp #($100-(PLAYER_WIDTH+PLAYER_PADDING))
	bcc @STOP_MOVE
	beq @STOP_MOVE

	lda #($100-(PLAYER_WIDTH+PLAYER_PADDING))
@STOP_MOVE:
	sta tmp1
	lda spr_posX_arr, x
	sub tmp1
	sta spr_final_velocity_x_arr, x
	lda tmp1
	sta spr_posX_arr, x
	jmp @MOVE_Y
	; ------------------------------

@MOVE_SCROLL:
	sub #PLAYER_MAX_POSX
	sta scroll_amount

	lda #PLAYER_MAX_POSX
	sta spr_posX_arr, x

@MOVE_Y:
	lda spr_posY_arr, x
	add Sprite::move_dy
	sta spr_posY_arr, x

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
	/*
	MEMO:
	sprite
		posX, Y
		sprID
		velocity (HI: X, LO: Y)
		(player: acceleration)
	*/

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

@EXIT:
	rts
	; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; player physics
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _playerPhysics
	lda #0
	sta spr_velocity_x_arr+$0
	lda Joypad::joy1
	and #Joypad::BTN_L
	bne @ACCELERATE_LEFT
	lda Joypad::joy1
	and #Joypad::BTN_R
	beq @DEC_ACCELERATION
	jmp @ACCELERATE_RIGHT
@DEC_ACCELERATION:
	lda spr_float_velocity_x_arr+$0
	beq @EXIT1
	; 減速
	lda spr_float_velocity_x_arr+$0
	bmi @INC_SPEED
@DEC_SPEED:
	; 右向きに進んでいるときの減速
	ldx spr_float_velocity_x_arr+$0
	dex
	stx spr_float_velocity_x_arr+$0
	txa
	shr #4
	sta spr_velocity_x_arr+$0
	cpx #$10
	bpl @EXIT1
	cpx #$08
	bmi @EXIT1
	ldx spr_velocity_x_arr+$0
	beq @EXIT1
	dex
	stx spr_velocity_x_arr+$0
	jmp @EXIT1
@INC_SPEED:
	; 左向きに進んでいるときの減速
	ldx spr_float_velocity_x_arr+$0
	inx
	stx spr_float_velocity_x_arr+$0
	txa
	shr #4
	beq :+
	ora #%11110000						; 上位4ビットを埋める（負の数にする）
:
	sta spr_velocity_x_arr+$0
	cpx #$f0
	bmi @EXIT1
	cpx #$f8
	bpl @EXIT1
	ldx spr_velocity_x_arr+$0
	beq @EXIT1
	inx
	stx spr_velocity_x_arr+$0
@EXIT1:
	rts
	; ------------------------------
@ACCELERATE_LEFT:
	; 左向きに加速度を上昇させる
	ldx #0
	lda Joypad::joy1
	and #Joypad::BTN_B
	beq :+
	inx
:
	lda AMOUNT_INC_SPD_L, x
	add spr_float_velocity_x_arr+$0
	cmp MAX_SPD_L, x
	bpl :+
	inx
	sec
	sbc AMOUNT_INC_SPD_L, x
:
	sta spr_float_velocity_x_arr+$0
	pha
	cmp #0
	bpl :+
	shr #4
	ora #%11110000						; 上位4ビットを埋める（負の数にする）
	bne :++
:
	shr #4
:
	sta spr_velocity_x_arr+$0
	pla
	cmp #$f0
	bmi :+
	cmp #$f8
	bpl :+
	dec spr_velocity_x_arr+$0
:
	rts
	; ------------------------------

@ACCELERATE_RIGHT:
	ldx #0
	lda Joypad::joy1
	and #Joypad::BTN_B
	beq :+
	inx
:
	lda AMOUNT_INC_SPD_R, x
	add spr_float_velocity_x_arr+$0
	cmp MAX_SPD_R, x
	bmi :+
	inx
	sec
	sbc AMOUNT_INC_SPD_R, x
:
	sta spr_float_velocity_x_arr+$0
	pha
	cmp #0
	bpl :+
	shr #4
	ora #%11110000
	bne :++
:
	shr #4
:
	sta spr_velocity_x_arr+$0
	pla
	cmp #$10
	bpl :+
	cmp #$08
	bmi :+
	inc spr_velocity_x_arr+$0
:
	rts
	; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; sprite animate
; @PARAMS		X: sprite id
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _sprAnimate
	cpx #0
	beq :+
	rts
	; ------------------------------
:
	dex
	lda spr_velocity_x_arr, x

.endproc

.endscope