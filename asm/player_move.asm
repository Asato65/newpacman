.scope Player							; スコープ名注意！

DOWN_SPEED_LIMIT = $04		; 落下の最高速度
; 加速度の増加値
VER_FORCE_DECIMAL_PART_DATA:
		.byte $20, $20, $1e, $28, $28
; 降下時の加速度
VER_FALL_FORCE_DATA:
		.byte $70, $70, $60, $90, $90
; 初速度(v0)
INITIAL_VER_SPEED_DATA:
		.byte $fc, $fc, $fc, $fb, $fb
; 初期加速度(a)
INITIAL_VER_FORCE_DATA:
		.byte $00, $00, $00, $00, $00

.ZeroPage
is_fly: 					.byte 0		; 空中にいるか
is_jumping:					.byte 0		; ジャンプ中か
posY_origin:				.byte 0		; ジャンプ開始時の位置
ver_speed:					.byte 0		; 速度
ver_force_decimal_part:		.byte 0		; 現在の加速度
ver_force_fall:				.byte 0		; 降下時の加速度
ver_speed_decimal_part:		.byte 0		; 加速度の増加値
ver_pos_decimal_part:		.byte 0		; 累積計算での補正値
ver_pos_fix_val:			.byte 0		; 補正値

.code

;*------------------------------------------------------------------------------
; player physics
; @PARAMS		None
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _physicsX
		lda #0								; 初期化
		sta spr_velocity_x_arr+$0

		lda Joypad::joy1
		and #Joypad::BTN_L
		bne @ACCELERATE_LEFT
		lda Joypad::joy1
		and #Joypad::BTN_R
		beq @DEC_ACCELERATION
		jmp @ACCELERATE_RIGHT

@DEC_ACCELERATION:						; 減速
		lda spr_float_velocity_x_arr+$0
		beq @EXIT1
		bmi @INC_SPEED

		; 右向きに進んでいるときの減速
		sub #1								; 減速
		sta spr_float_velocity_x_arr+$0
		beq @EXIT1							; 速度0なら終了

		tax
		shr #4
		sta spr_velocity_x_arr+$0

		cpx #$10
		bcs @EXIT1
		cpx #$0A
		bcc @EXIT1
		inc spr_velocity_x_arr+$0
		jmp @EXIT1	; -------------------

@INC_SPEED:
		; 左向きに進んでいるときの減速
		add #1
		sta spr_float_velocity_x_arr+$0
		beq @EXIT1

		tax
		shr #4
		ora #%11110000						; 上位4ビットを埋める（負の数にする）
		sta spr_velocity_x_arr+$0

		cpx #$f0
		bcc @EXIT2
		cpx #$fA
		bcs @EXIT2
		dec spr_velocity_x_arr+$0
@EXIT2:
		inc spr_velocity_x_arr+$0			; 負の向きは求めた速度+1（小数の速度がfbの時→速度はffではなく0になってほしい）
@EXIT1:
		rts
		; ------------------------------

@ACCELERATE_LEFT:						; 左向きに加速度を上昇させる
		ldx #0								; AMOUNT_INC_SPD_L[]のindex決定処理
		lda Joypad::joy1
		and #Joypad::BTN_B
		beq :+
		inx
:
		lda AMOUNT_INC_SPD_L, x				; 加速度を足す
		add spr_float_velocity_x_arr+$0
		cmp MAX_SPD_L, x
		bpl :+
		inx
		sec
		sbc AMOUNT_INC_SPD_L, x				; 足した加速度よりも大きな加速度で引く（加速度が負に）
:
		sta spr_float_velocity_x_arr+$0
		sta tmp1
		lda spr_decimal_part_velocity_x_arr+$0
		ora #%1111_0000
		add tmp1
		sta tmp1
		and #BYT_GET_LO
		sta spr_decimal_part_velocity_x_arr+$0
		lda tmp1
		cmp #0
		bpl :+
		shr #4								; 加速度が負のとき（左に進んでて，右に入力がある場合）
		ora #%11110000						; 上位4ビットを埋める（負の数にする）
		bne :++
:
		shr #4								; 加速度が正のとき
:
		sta spr_velocity_x_arr+$0
		; 向きの更新
		beq :++								; 速度が0のとき向きフラグを更新しない（今の向きを継続利用）
		bmi :+
		lda #%0000_0001						; 速度が正のとき向きフラグを1に
		ora spr_attr_arr+$0
		sta spr_attr_arr+$0
		bne :++
:
		lda spr_attr_arr+$0					; 速度が負のとき向きフラグを0に
		and #%1111_1110
		sta spr_attr_arr+$0
:
		; 速度調整
		lda tmp1
		cpx #$f0
		bcc :+
		cpx #$fA
		bcs :+
		dec spr_velocity_x_arr+$0			; 速度が遅めのときに進んでいる方向に速度を1足す
:
		inc spr_velocity_x_arr+$0
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
		add spr_decimal_part_velocity_x_arr+$0
		sta tmp1
		and #BYT_GET_LO
		sta spr_decimal_part_velocity_x_arr+$0
		lda tmp1
		cmp #0
		bpl :+
		shr #4
		ora #%11110000
		bne :++
:
		shr #4
:
		sta spr_velocity_x_arr+$0
		; 向きの更新
		beq :++								; 速度が0のとき向きフラグを更新しない（今の向きを継続利用）
		bmi :+
		lda #%0000_0001						; 速度が正のとき向きフラグを1に
		ora spr_attr_arr+$0
		sta spr_attr_arr+$0
		bne :++
:
		lda spr_attr_arr+$0					; 速度が負のとき向きフラグを0に
		and #%1111_1110
		sta spr_attr_arr+$0
:
		; 速度調整
		lda tmp1
		cmp #$10
		bcs :+
		cmp #$06
		bcc :+
		inc spr_velocity_x_arr+$0
:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; player animate
; @PARAMS		None
; @CLOBBERS		A X tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _animate
	lda Player::is_jumping
	beq :+
	lda #4
	sta spr_anime_num
	rts
	; ------------------------------
:
		lda spr_float_velocity_x_arr+$0
		bne :+
		lda #0
		sta spr_anime_num+$0
		rts
		; ------------------------------
:										; 速度が0でないとき
		lda Joypad::joy1
		and #(Joypad::BTN_L|Joypad::BTN_R)
		beq @NORMAL_MOVE
		and #Joypad::BTN_L
		shr #1								; 左ボタンのフラグを最下位ビットに
		sta tmp1
		lda spr_float_velocity_x_arr+$0
		asl									; 速度の最上位ビットを最下位ビットに入れる
		lda #0
		rol
		cmp tmp1
		beq @NORMAL_MOVE
		; ブレーキ時の動作
		cmp #0
		beq @RIGHT
		lda spr_attr_arr+$0					; 左ボタンが押されているとき
		ora #%0000_0001
		bne :+
@RIGHT:
		lda spr_attr_arr+$0
		and #%1111_1110
:
		sta spr_attr_arr+$0
		lda #5
		sta spr_anime_num+$0
		rts
		; ------------------------------
@NORMAL_MOVE:							; 通常の進み方（ブレーキでない）をしているとき
		lda spr_float_velocity_x_arr+$0
		bpl :+
		cnn									; 速度の絶対値を取る
:
		cmp #$10
		bpl :+
		; スピードが$10以下
		lda #4								; タイマー5フレーム
		bne @ANIMATE
:
		cmp #$18
		bpl :+
		lda #3
		bne @ANIMATE
:
		cmp #$20
		bpl :+
		lda #2
		bne @ANIMATE
:
		cmp #$28
		bpl :+
		lda #1
@ANIMATE:								; タイマーと速度に応じた値を比較しアニメーションを進める
		cmp spr_anime_timer+$0
		bpl @NO_CHANGE_CHR

		lda #0
		sta spr_anime_timer+$0

		inc spr_anime_num+$0
		lda spr_anime_num+$0
		cmp #4
		bcc @NO_CHANGE_CHR
		lda #1								; アニメーション番号が超えたので最初に戻す
		sta spr_anime_num+$0
@NO_CHANGE_CHR:
		lda spr_anime_num+$0
		bne @EXIT
		; 歩き始め（止まっている状態から進み出した時）
		lda #1								; 1F目から歩いているアニメーションにする
		sta spr_anime_num+$0
		lda #0								; タイマーリセット
		sta spr_anime_timer+$0
@EXIT:
	rts
	; ------------------------------

.endproc


.proc _jumpCheck
	lda Joypad::joy1
	and #Joypad::BTN_A
	bne @SKIP1
	; 初めてAボタンが押されてないとき終了
	rts
	; ------------------------------
@SKIP1:
	lda Player::is_fly
	bne @SKIP2
	; 地面にいるときジャンプ開始準備
	jsr Player::_prepareJumping
@SKIP2:
	rts
	; ------------------------------
.endproc


.proc _prepareJumping
	ldx #1
	stx Player::is_fly
	stx Player::is_jumping
	dex
	stx spr_decimal_part_velocity_y_arr+$0
	lda spr_posY_arr+$0
	sta Player::posY_origin

	; Xレジスタ = 0
	lda spr_velocity_x_arr+$0
	bpl :+
	cnn									; X方向のスピードの絶対値を求める
:
	cmp #$1c
	bmi @SKIP1
	inx
@SKIP1:
	cmp #$19
	bmi @SKIP2
	inx
@SKIP2:
	cmp #$10
	bmi @SKIP3
	inx
@SKIP3:
	cmp #$09
	bmi @SKIP4
	inx
@SKIP4:

	lda VER_FORCE_DECIMAL_PART_DATA, x
	sta spr_decimal_part_force_y+$0
	lda VER_FALL_FORCE_DATA, x
	sta spr_force_fall_y+$0
	lda INITIAL_VER_FORCE_DATA, x
	sta spr_decimal_part_velocity_y_arr+$0
	lda INITIAL_VER_SPEED_DATA, x
	sta spr_velocity_y_arr+$0

	rts
	; ------------------------------
.endproc

.proc _moveProcess
	lda spr_velocity_y_arr+$0
	bpl @SKIP1
	lda Joypad::joy1
	and #Joypad::BTN_A
	bne @SKIP2
	lda Joypad::joy1_prev
	and #Joypad::BTN_A
	beq @SKIP2
@SKIP1:
	lda spr_force_fall_y+$0
	sta spr_decimal_part_force_y+$0
@SKIP2:
	jsr Player::_physicsY
	rts
	; ------------------------------
.endproc


.proc _physicsY
	ldx #0
	stx spr_fix_val_y+$0
	lda spr_pos_y_decimal_part+$0
	add spr_decimal_part_force_y+$0
	sta spr_pos_y_decimal_part+$0
	bcc @SKIP_OVERFLOW
	; オーバーフローしてたら
	stx spr_pos_y_decimal_part+$0
	inx
	stx spr_fix_val_y+$0				; 補正値があったらここで修正
@SKIP_OVERFLOW:
	lda spr_decimal_part_velocity_y_arr+$0
	add spr_decimal_part_force_y+$0
	sta spr_decimal_part_velocity_y_arr+$0
	bcc @EXIT
	lda #0
	sta spr_decimal_part_velocity_y_arr+$0

	ldx spr_velocity_y_arr+$0
	inx
	cpx #DOWN_SPEED_LIMIT
	bmi @STORE_VER_SPEED
	;lda ver_speed_decimal_part
	;bpl @STORE_VER_SPEED
	ldx #DOWN_SPEED_LIMIT
	lda #0
	sta spr_decimal_part_velocity_y_arr+$0
@STORE_VER_SPEED:
	stx spr_velocity_y_arr+$0

@EXIT:
	rts
	; ------------------------------
.endproc

.endscope