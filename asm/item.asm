.scope Item

.export _spawn
.export _moveItem

.ZeroPage
	item_velocity_x:		.byte 0
	item_velocity_y:		.byte 0
	item_counter:			.byte 0
	is_animation:			.byte 0
	item_id:				.byte 0
	item_attr:				.byte 0		; BIT7 -> 利用中, BIT1 -> 左端フラグ
	item_pos_x:				.byte 0
	item_pos_y:				.byte 0
	item_float_velocity_x:	.byte 0
	item_float_velocity_y:	.byte 0
	item_decimal_part_velocity_x:	.byte 0
	item_decimal_part_velocity_y:	.byte 0

.code

.proc _spawn
	lda tmp1
	pha
	lda tmp2
	pha
	lda tmp3
	pha
	txa
	pha

	lda is_animation
	beq :+
	jsr _endItemAnimation
:

	lda #1
	sta is_animation
	lda #BIT7
	sta item_attr

	pla
	sta item_id
	shl #1
	tax

	lda Player::player_hit_block_lo
	and #BYT_GET_HI
	add #$20
	sta item_pos_y

	lda Player::player_hit_block_lo
	shl #4
	sub scroll_x
	sta item_pos_x

	lda SPRITE_ARR+0, x
	sta addr_tmp1+LO
	lda SPRITE_ARR+1, x
	sta addr_tmp1+HI

	ldy #0
	lda (addr_tmp1), y
	sta SPR_ITEM+0*4+1
	iny
	lda (addr_tmp1), y
	sta SPR_ITEM+1*4+1
	iny
	lda (addr_tmp1), y
	sta SPR_ITEM+2*4+1
	iny
	lda (addr_tmp1), y
	sta SPR_ITEM+3*4+1

	iny
	lda (addr_tmp1), y
	sta SPR_ITEM+0*4+2
	iny
	lda (addr_tmp1), y
	sta SPR_ITEM+1*4+2
	iny
	lda (addr_tmp1), y
	sta SPR_ITEM+2*4+2
	iny
	lda (addr_tmp1), y
	sta SPR_ITEM+3*4+2

	lda #0
	sta item_float_velocity_x
	sta item_decimal_part_velocity_x
	sta item_decimal_part_velocity_y
	lda #$f8
	sta item_float_velocity_y

	pla
	sta tmp3
	pla
	sta tmp2
	pla
	sta tmp1
	rts
	; ------------------------------
.endproc


.proc _moveItem
	lda item_attr
	bmi :+								; BIT7（利用中フラグ）のチェック
	rts
:

	; X速度の設定
	lda item_float_velocity_x
	bpl :+
	cnn
:
	add item_decimal_part_velocity_x
	pha
	shr #4
	tax
	lda item_float_velocity_x
	bpl :+
	txa
	cnn
	tax
:
	stx item_velocity_x

	pla
	and #BYT_GET_LO
	sta item_decimal_part_velocity_x

	; Y速度の設定
	lda item_float_velocity_y
	bpl :+
	cnn
:
	add item_decimal_part_velocity_y
	pha
	shr #4
	tax
	lda item_float_velocity_y
	bpl :+
	txa
	cnn
	tax
:
	stx item_velocity_y

	pla
	and #BYT_GET_LO
	sta item_decimal_part_velocity_y


	; Y座標の更新
	lda item_pos_y
	add item_velocity_y
	sta item_pos_y
	sub #1
	sta SPR_ITEM+0*4+0
	sta SPR_ITEM+1*4+0
	add #8
	sta SPR_ITEM+2*4+0
	sta SPR_ITEM+3*4+0

	; X座標の更新，左端のチェック
	lda item_pos_x
	add item_velocity_x
	sub scroll_amount
	sta tmp4							; 新しいposX
	lda item_pos_x
	bmi @SKIP_SET_LEFTOVER_FLAG
	lda tmp4
	bpl @SKIP_SET_LEFTOVER_FLAG
	; 左端フラグを立てる
	lda item_attr
	ora #BIT1
	sta item_attr
@SKIP_SET_LEFTOVER_FLAG:
	lda item_attr
	and #BIT1
	beq @NOT_LEFTOVER
	; 左端フラグが立っていたらキャラの左側は必ず非表示
	lda #$ff
	sta SPR_ITEM+0*4+0
	sta SPR_ITEM+2*4+0
	; 座標に応じてキャラの右側も非表示にするか決定
	lda tmp4
	cmp #$f9
	bcs @NOT_LEFTOVER
	lda #$ff
	sta SPR_ITEM+1*4+0
	sta SPR_ITEM+3*4+0
	; キャラクタの利用中フラグもOFF
	lda #0
	sta item_attr
@NOT_LEFTOVER:
	; X座標の更新
	lda tmp4
	sta item_pos_x
	sta SPR_ITEM+0*4+3
	sta SPR_ITEM+2*4+3
	add #8
	sta SPR_ITEM+1*4+3
	sta SPR_ITEM+3*4+3

	; パレットのローテーション
	lda frm_cnt
	and #1
	sta tmp4
	; OAMデータを直接変更する
	lda SPR_ITEM+0*4+2
	add tmp4
	and #%1110_0011		; BIT4-2は未使用なのでマスク（BIT1-0の繰り上がりを消す役割も果たす）
	sta SPR_ITEM+0*4+2
	lda SPR_ITEM+1*4+2
	add tmp4
	and #%1110_0011
	sta SPR_ITEM+1*4+2

	; アイテムがブロックから出てくるアニメーションのカウンタを確認
	lda is_animation
	beq @EXIT
	ldx item_counter
	inx
	stx item_counter
	cpx #$10
	bcs :+
	; アイテムが出てくるとき，ブロックもアニメーション中
	; すると，上昇しているブロックの下側にアイテムがはみ出て見えてしまうので
	; アイテムの下側を非表示
	lda #$ff
	sta SPR_ITEM+2*4+0
	sta SPR_ITEM+3*4+0
:
	cpx #$20
	bcc @EXIT
	jsr _endItemAnimation
@EXIT:

	rts
.endproc


.proc _endItemAnimation
	lda #0
	sta is_animation
	sta item_counter

	lda item_id
	tax
	ldy #8
	ldarr SPRITE_ARR
	sta item_float_velocity_x
	iny
	ldarr SPRITE_ARR
	sta item_float_velocity_y

	rts
.endproc

.endscope