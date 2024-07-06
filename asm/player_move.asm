.scope Player							; スコープ名注意！

DOWN_SPEED_LIMIT = $04					; 落下の最高速度
VER_FORCE_DECIMAL_PART_DATA:			; 加速度の増加値
		.byte $20, $20, $1e, $28, $28
VER_FALL_FORCE_DATA:					; 降下時の加速度
		.byte $70, $70, $60, $90, $90
INITIAL_VER_SPEED_DATA:					; 初速度(v0)
		.byte $fc, $fc, $fc, $fb, $fb
INITIAL_VER_FORCE_DATA:					; 初期加速度(a)
		.byte $00, $00, $00, $00, $00

.ZeroPage
is_fly: 					.byte 0		; 空中にいるか
is_jumping:					.byte 0		; ジャンプ中か（ジャンプ後の下降中もフラグオン）
is_collision_down:			.byte 0		; collisionDownの関数を通ったか（床に触れたか）
player_current_screen:		.byte 0		; プレイヤーのいる画面番号
player_actual_pos_left:		.byte 0		; 画面上の座標ではなく，実際の座標
player_actual_pos_right:	.byte 0
player_pos_top:				.byte 0
player_pos_bottom:			.byte 0
player_offset_flags:		.byte 0		; ずれのフラグ（bit1: X方向，bit0: Y方向）
player_collision_flags:		.byte 0		; マリオ周辺のブロックフラグ（ブロックがあれば1, bit3-0は左上，右上，左下，右下の順）
player_block_pos_X:			.byte 0		; ブロック単位での座標
player_block_pos_Y:			.byte 0
player_block_pos_right:		.byte 0
player_block_pos_bottom:	.byte 0

.code

;*------------------------------------------------------------------------------
; player physics
; @PARAMS		None
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _physicsX
		lda #0							; 初期化
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
		sub #1							; 減速
		sta spr_float_velocity_x_arr+$0
		beq @EXIT1						; 速度0なら終了

		tax
		shr #4
		sta spr_velocity_x_arr+$0

		cpx #$10
		bcs @EXIT1
		cpx #$0A
		bcc @EXIT1
		inc spr_velocity_x_arr+$0
		jmp @EXIT1	; ------------------

@INC_SPEED:
		; 左向きに進んでいるときの減速
		add #1
		sta spr_float_velocity_x_arr+$0
		beq @EXIT1

		tax
		shr #4
		ora #%11110000					; 上位4ビットを埋める（負の数にする）
		sta spr_velocity_x_arr+$0

		cpx #$f0
		bcc @EXIT2
		cpx #$fA
		bcs @EXIT2
		dec spr_velocity_x_arr+$0
@EXIT2:
		inc spr_velocity_x_arr+$0		; 負の向きは求めた速度+1（小数の速度がfbの時→速度はffではなく0になってほしい）
@EXIT1:
		jmp EXIT	; ------------------

@ACCELERATE_LEFT:						; 左向きに加速度を上昇させる
		ldx #0							; AMOUNT_INC_SPD_L[]のindex決定処理
		lda Joypad::joy1
		and #Joypad::BTN_B
		beq :+
		inx
:
		lda AMOUNT_INC_SPD_L, x			; 加速度を足す
		add spr_float_velocity_x_arr+$0
		cmp MAX_SPD_L, x
		bpl :+
		inx
		sec
		sbc AMOUNT_INC_SPD_L, x			; 足した加速度よりも大きな加速度で引く（加速度が負に）
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
		shr #4							; 加速度が負のとき（左に進んでて，右に入力がある場合）
		ora #%11110000					; 上位4ビットを埋める（負の数にする）
		bne :++
:
		shr #4							; 加速度が正のとき
:
		sta spr_velocity_x_arr+$0
		; 向きの更新
		beq :++							; 速度が0のとき向きフラグを更新しない（今の向きを継続利用）
		bmi :+
		lda #%0000_0001					; 速度が正のとき向きフラグを1に
		ora spr_attr_arr+$0
		sta spr_attr_arr+$0
		bne :++
:
		lda spr_attr_arr+$0				; 速度が負のとき向きフラグを0に
		and #%1111_1110
		sta spr_attr_arr+$0
:
		; 速度調整
		lda tmp1
		cpx #$f0
		bcc :+
		cpx #$fA
		bcs :+
		dec spr_velocity_x_arr+$0		; 速度が遅めのときに進んでいる方向に速度を1足す
:
		inc spr_velocity_x_arr+$0
		jmp EXIT	; ------------------

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
		lda spr_float_velocity_x_arr+$0
		beq :++							; 速度が0のとき向きフラグを更新しない（今の向きを継続利用）
		bmi :+
		lda spr_attr_arr				; 速度が正のとき向きフラグを1に
		ora #%0000_0001
		sta spr_attr_arr+$0
		bne :++		; ------------------
:
		lda spr_attr_arr+$0				; 速度が負のとき向きフラグを0に
		and #%1111_1110
		sta spr_attr_arr+$0
:
		; 速度調整
		lda tmp1
		cmp #$10
		bcs EXIT
		cmp #$06
		bcc EXIT
		inc spr_velocity_x_arr+$0
EXIT:
		lda spr_posX_arr+$0
		add spr_velocity_x_arr+$0
		sta spr_posX_tmp_arr+$0
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; player animate
; @PARAMS		None
; @CLOBBERS		A tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _animate
		lda Player::is_jumping
		beq :+
		lda #4							; ジャンプ時のアニメーション番号
		sta spr_anime_num
		rts
		; ------------------------------
:
	lda Player::is_fly
	beq :+
	lda #3
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
		shr #1							; 左ボタンのフラグを最下位ビットに
		sta tmp1
		lda spr_float_velocity_x_arr+$0
		asl								; 速度の最上位ビットを最下位ビットに入れる
		lda #0
		rol
		cmp tmp1
		beq @NORMAL_MOVE
		; ブレーキ時の動作
		cmp #0
		beq @RIGHT
		lda spr_attr_arr+$0				; 左ボタンが押されているとき
		ora #%0000_0001
		bne :+		; ------------------
@RIGHT:
		lda spr_attr_arr+$0
		and #%1111_1110
:
		sta spr_attr_arr+$0
		lda #5							; ブレーキ時のアニメーション番号
		sta spr_anime_num+$0
		rts
		; ------------------------------
@NORMAL_MOVE:							; 通常の進み方（ブレーキでない）をしているとき
		; MEMO: 工夫すればバイト数削れそうなプログラム
		lda spr_float_velocity_x_arr+$0
		bpl :+
		cnn								; 速度の絶対値を取る
:
		cmp #$10
		bpl :+
		; スピードが$10以下
		lda #4
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
		bpl @ANIMATE
		lda #1
@ANIMATE:								; タイマーと速度に応じた値を比較しアニメーションを進める
		cmp spr_anime_timer+$0
		bpl @NO_CHANGE_CHR

		lda #0							; アニメーション変更
		sta spr_anime_timer+$0

		inc spr_anime_num+$0
		lda spr_anime_num+$0
		cmp #4
		bcc @NO_CHANGE_CHR
		lda #1							; アニメーション番号が超えたので最初に戻す
		sta spr_anime_num+$0
@NO_CHANGE_CHR:
		lda spr_anime_num+$0
		bne @EXIT
		; 歩き始め（止まっている状態から進み出した時）
		lda #1							; 1F目から歩いているアニメーションにする
		sta spr_anime_num+$0
		lda #0							; タイマーリセット
		sta spr_anime_timer+$0
@EXIT:
		rts
		; ------------------------------

.endproc


;*------------------------------------------------------------------------------
; ジャンプするかの確認
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _jumpCheck
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_A
		beq @EXIT
		lda Player::is_fly
		bne @EXIT
		; 地面にいるときジャンプ開始準備
		jsr Player::_prepareJumping
@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; ジャンプの初期設定
; @PARAMS		None
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _prepareJumping
		ldx #1
		stx Player::is_fly				; 空中にいるかつ
		stx Player::is_jumping			; ジャンプ中

		dex
		stx spr_decimal_part_velocity_y_arr+$0	; 補正値を0に

		lda spr_posY_arr+$0				; 現在のY座標を保存
		sta spr_pos_y_origin+$0

		; X = 0
		lda spr_velocity_x_arr+$0
		bpl :+
		cnn								; X方向のスピードの絶対値を求める
:
		cmp #$1c
		bmi @SKIP1
		inx								; x = 1
@SKIP1:
		cmp #$19
		bmi @SKIP2
		inx								; x = 2
@SKIP2:
		cmp #$10
		bmi @SKIP3
		inx								; x = 3
@SKIP3:
		cmp #$09
		bmi @SKIP4
		inx								; x = 4
@SKIP4:
		; 現在の速度に応じた初期データを格納
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


;*------------------------------------------------------------------------------
; Y方向の速度決定前のちょっとした動作（よくわかんない）
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _moveYProcess
		lda spr_velocity_y_arr+$0
		bpl @SKIP1						; 速度が正（落下中）はスキップ
		lda Joypad::joy1
		and #Joypad::BTN_A
		bne @SKIP2
		lda Joypad::joy1_prev
		and #Joypad::BTN_A
		beq @SKIP2
@SKIP1:
		; Aボタンが離されたタイミング
		lda spr_force_fall_y+$0
		sta spr_decimal_part_force_y+$0	; 初期化
@SKIP2:
		jsr Player::_physicsY
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Y方向の速度決定，仮Y座標決定
; @PARAMS		None
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _physicsY
		ldx #0
		stx spr_fix_val_y+$0			; 初期化

		lda spr_pos_y_decimal_part+$0
		add spr_decimal_part_force_y+$0
		sta spr_pos_y_decimal_part+$0
		bcc @SKIP_OVERFLOW
		; オーバーフローしてたら
		stx spr_pos_y_decimal_part+$0	; x = 0
		inx								; x = 1
		stx spr_fix_val_y+$0			; 補正値があったらここで修正
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

		ldx #DOWN_SPEED_LIMIT
		lda #0
		sta spr_decimal_part_velocity_y_arr+$0
@STORE_VER_SPEED:
		stx spr_velocity_y_arr+$0

@EXIT:
		lda spr_posY_arr+$0
		add spr_velocity_y_arr+$0
		sta spr_posY_tmp_arr+$0			; 仮Y座標
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; あたり判定
; @PARAMS		None
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _checkCollision
	lda #0
	sta player_offset_flags
	sta player_collision_flags

	; マリオのY座標を取得してブロック単位に変換
	lda spr_posY_tmp_arr+$0
	add #2
	shr #4
	cmp #2
	bcs :+
	rts									; 上1列にマリオ（の頭）がいるとき
	; ------------------------------
:
	sub #2
	sta player_block_pos_Y

	lda spr_posY_tmp_arr+$0
	add #2
	sta player_pos_top
	add #$10-2
	sta player_pos_bottom
	sub #1
	shr #4
	sub #2
	sta player_block_pos_bottom


	; スクロール量と画面を考慮してマリオのX座標を取得
	ldx #0
	stx tmp1
	lda spr_posX_tmp_arr+$0
	add #PLAYER_PADDING
	bcc :+
	inx
	stx tmp1
:
	add scroll_x
	sta player_actual_pos_left
	lda main_disp
	adc tmp1								; キャリーフラグ（tmp1もキャリーフラグ代わり）を足し算
	and #%0000_0001
	sta player_current_screen

	lda player_actual_pos_left
	shr #4
	sta player_block_pos_X
	lda player_actual_pos_left
	add #PLAYER_WIDTH
	sta player_actual_pos_right
	sub #1
	shr #4
	sta player_block_pos_right


	; 下方向のあたり判定
	lda player_block_pos_Y
	cmp player_block_pos_bottom
	beq :+
	lda player_offset_flags
	ora #%0000_0001					; Y方向にずれあり
	sta player_offset_flags
:
	; 右方向のあたり判定
	lda player_block_pos_right
	cmp player_block_pos_X
	beq :+
	lda player_offset_flags
	ora #%0000_0010
	sta player_offset_flags
:


	; マリオの周辺のブロックフラグをセット=
	; ----- 左上 -----
	lda player_block_pos_Y
	shl #4
	ora player_block_pos_X
	tax
	clc								; 後で使うためにキャリークリア
	lda player_current_screen
	bne :+
	lda $0400, x
	bcc :++	; ---------------------
:
	lda $0500, x
:
	beq :+							; ブロック判定
	sec								; ブロックがあったときキャリーセット
:
	rol player_collision_flags		; キャリーを入れていく（あと三回ローテートするのでbit3に格納される）

	; ----- 右上 -----
	lda player_block_pos_X
	cmp #$0f
	bne @NORMAL1
	lda player_block_pos_Y
	shl #4							; 下位（X座標）は0
	tax
	clc
	lda player_current_screen
	bne :+
	lda $0500, x
	bcc @CHECK1
:
	lda $0400, x
	bcc @CHECK1
@NORMAL1:
	lda player_block_pos_Y
	shl #4
	ora player_block_pos_X
	add #1
	tax
	clc
	lda player_current_screen
	bne :+
	lda $0400, x
	bcc @CHECK1
:
	lda $0500, x
@CHECK1:
	beq :+
	sec
:
	rol player_collision_flags

	; ----- 左下 -----
	lda player_block_pos_bottom
	shl #4
	ora player_block_pos_X
	tax
	clc								; 後で使うためにキャリークリア
	lda player_current_screen
	bne :+
	lda $0400, x
	bcc :++	; ---------------------
:
	lda $0500, x
:
	beq :+							; ブロック判定
	sec								; ブロックがあったときキャリーセット
:
	rol player_collision_flags		; キャリーを入れていく（あと三回ローテートするのでbit3に格納される）

	; ----- 右下 -----
	lda player_block_pos_X
	cmp #$0f
	bne @NORMAL2
	lda player_block_pos_bottom
	shl #4							; 下位（X座標）は0
	tax
	clc
	lda player_current_screen
	bne :+
	lda $0500, x
	bcc @CHECK2
:
	lda $0400, x
	bcc @CHECK2
@NORMAL2:
	lda player_block_pos_bottom
	shl #4
	ora player_block_pos_X
	add #1
	tax
	clc
	lda player_current_screen
	bne :+
	lda $0400, x
	bcc @CHECK2
:
	lda $0500, x
@CHECK2:
	beq :+
	sec
:
	rol player_collision_flags


	; フラグを元にしてあたり判定・位置調整
	lda player_offset_flags
	cmp #%0000_0011
	beq @CHECK_XY
	cmp #%0000_0001
	beq @CHECK_BOTTOM
	cmp #%0000_0010
	beq @CHECK_RIGHT
	bne @EXIT
@CHECK_XY:
	lda #%0000_1111
	jmp @JMP_SUB
@CHECK_BOTTOM:
	lda #%0000_1010					; 右側は無視
	jmp @JMP_SUB
@CHECK_RIGHT:
	lda #%0000_1100					; 下側は無視
@JMP_SUB:
	and player_collision_flags
	sta player_collision_flags
	jsr _fixCollision
@EXIT:
	rts
	; ------------------------------
.endproc


.proc _fixCollision
	lda player_collision_flags
	bne :+
	rts
	; ------------------------------
:

	cmp #%0000_1100
	beq @UPPER
	cmp #%0000_0011
	beq @LOWER
	cmp #%0000_0101
	beq @RIGHT
	cmp #%0000_1010
	beq @LEFT

	cmp #%0000_0111
	beq @LOWER_RIGHT				; 右下→着地する方向に動かし，左にずらす
	cmp #%0000_1011
	beq @LOWER_LEFT
	cmp #%0000_1101
	beq @UPPER_RIGHT
	cmp #%0000_1110
	beq @UPPER_LEFT
	bne @OTHER_CHECK

@LOWER:
	jsr _fixCollisionDown
	jmp @EXIT
@UPPER:
	jsr _fixCollisionUp
	jmp @EXIT
@RIGHT:
	jsr _fixCollisionRight
	jmp @EXIT
@LEFT:
	jsr _fixCollisionLeft
	jmp @EXIT
@LOWER_RIGHT:
	jsr _fixCollisionDown
	jsr _fixCollisionRight
	jmp @EXIT
@LOWER_LEFT:
	jsr _fixCollisionDown
	jsr _fixCollisionLeft
	jmp @EXIT
@UPPER_RIGHT:
	jsr _fixCollisionUp
	jsr _fixCollisionRight
	jmp @EXIT
@UPPER_LEFT:
	jsr _fixCollisionUp
	jsr _fixCollisionLeft
@EXIT:
	lda is_collision_down
	bne :+
	lda #1
	sta is_fly
:
	rts
	; ------------------------------

@OTHER_CHECK:
	cmp #%0000_0001					; 右下→着地する方向に動かし，左にずらす
	bne :+
	lda player_offset_flags
	cmp #%0000_0001					; Y座標のずれの確認
	beq @LOWER
	lda player_actual_pos_right
	and #BYT_GET_LO
	sta tmp1
	lda player_pos_bottom
	and #BYT_GET_LO
	cmp tmp1
	bcc @LOWER						; right-bottom<0 → right<bottom（左右<上下）
	beq @LOWER_RIGHT
	bcs @RIGHT						; 上下のずれ < 左右のずれ
:
	cmp #%0000_0010					; 左下
	bne :+
	lda player_offset_flags
	cmp #%0000_0001					; Y座標のずれの確認
	beq @LOWER
	lda player_actual_pos_left
	cnn
	and #BYT_GET_LO
	sta tmp1
	lda player_pos_bottom
	and #BYT_GET_LO
	cmp tmp1
	bcc @LOWER
	beq @LOWER_LEFT
	bcs @LEFT						; 上下のずれ < 左右のずれ
:
	cmp #%0000_0100
	bne :+
	lda player_offset_flags
	cmp #%0000_0010					; X座標のずれの確認
	beq @RIGHT2
	lda player_actual_pos_right
	and #BYT_GET_LO
	sta tmp1
	lda player_pos_top
	and #BYT_GET_LO
	cmp tmp1
	bcc @RIGHT2
	beq @UPPER_RIGHT2
	bcs @UPPER2						; 上下のずれ <= 左右のずれ
:
; 	bne :+
; 	ldx player_offset_flags
; 	cpx #%0000_0010
; 	beq @RIGHT
; 	bne @UPPER_RIGHT
; :
	cmp #%0000_1000
	bne :+
	lda player_offset_flags
	cmp #%0000_0010					; X座標のずれの確認
	beq @LEFT2
	lda player_actual_pos_left
	and #BYT_GET_LO
	sta tmp1
	lda player_pos_top
	and #BYT_GET_LO
	cmp tmp1
	bcc @LEFT2
	beq @UPPER_LEFT2
	bcs @UPPER2						; 上下のずれ <= 左右のずれ
:
	rts
	; ------------------------------

@LOWER2:
	jsr _fixCollisionDown
	jmp @EXIT2
@UPPER2:
	jsr _fixCollisionUp
	jmp @EXIT2
@RIGHT2:
	jsr _fixCollisionRight
	jmp @EXIT2
@LEFT2:
	jsr _fixCollisionLeft
	jmp @EXIT2
@LOWER_RIGHT2:
	jsr _fixCollisionDown
	jsr _fixCollisionRight
	jmp @EXIT2
@LOWER_LEFT2:
	jsr _fixCollisionDown
	jsr _fixCollisionLeft
	jmp @EXIT2
@UPPER_RIGHT2:
	jsr _fixCollisionUp
	jsr _fixCollisionRight
	jmp @EXIT2
@UPPER_LEFT2:
	jsr _fixCollisionUp
	jsr _fixCollisionLeft
@EXIT2:
	lda is_collision_down
	bne :+
	lda #1
	sta is_fly
:
	rts
	; ------------------------------
.endproc


.proc _fixCollisionUp
	; 上で衝突→下にずらす
	lda player_pos_top
	sub #2							; 上のパディング分
	and #BYT_GET_HI
	add #$10-2
	sta spr_posY_tmp_arr+$0

	lda #0							; 初期化
	sta spr_velocity_y_arr+$0
	sta spr_decimal_part_velocity_y_arr+$0
	lda spr_force_fall_y+$0
	sta spr_decimal_part_force_y+$0
	rts
	; ------------------------------
.endproc


.proc _fixCollisionDown
	lda player_pos_bottom
	and #BYT_GET_HI
	sub player_pos_bottom
	add spr_posY_tmp_arr+$0
	sta spr_posY_tmp_arr+$0
	ldx #0
	stx is_fly
	stx is_jumping
	inx
	stx is_collision_down
	lda spr_velocity_y_arr+$0
	bmi :+
	lda #1							; Y方向の加速度が正（下向き）の場合
	sta spr_velocity_y_arr+$0
	sta spr_decimal_part_velocity_y_arr+$0
:
	rts
	; ------------------------------
.endproc


;! -----------------------------------------------------------------------------
;! 不具合内容
;! スクロール，速度決定のプロセスに何らかのバグ
;! 上からマリオが降ってきたときには左右にずらさない
;! -----------------------------------------------------------------------------

.proc _fixCollisionRight
	; 右で衝突→左にずらす
	lda player_actual_pos_right
	and #BYT_GET_HI
	sub player_actual_pos_right
	add spr_posX_tmp_arr+$0
	sta spr_posX_tmp_arr+$0
	lda #0
	sta spr_float_velocity_x_arr+$0
	rts
	; ------------------------------
.endproc


.proc _fixCollisionLeft
	; lda player_actual_pos_left
	; and #BYT_GET_HI
	; sta spr_posX_tmp_arr+$0
	lda player_actual_pos_left
	and #BYT_GET_HI
	add #$10
	sub player_actual_pos_left
	add spr_posX_tmp_arr+$0
	sta spr_posX_tmp_arr+$0
	lda #0
	sta spr_float_velocity_x_arr+$0
	rts
	; ------------------------------
.endproc


.endscope
