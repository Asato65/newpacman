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
is_jumping:					.byte 0		; ジャンプ中か
posY_origin:				.byte 0		; ジャンプ開始時の位置
ver_speed:					.byte 0		; 速度
ver_force_decimal_part:		.byte 0		; 現在の加速度
ver_force_fall:				.byte 0		; 降下時の加速度
ver_speed_decimal_part:		.byte 0		; 加速度の増加値
ver_pos_decimal_part:		.byte 0		; 累積計算での補正値
ver_pos_fix_val:			.byte 0		; 補正値
mario_block_x:				.byte 0
mario_block_y:				.byte 0
tmp_x:						.byte 0
tmp_y:						.byte 0

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
		sta Player::posY_origin

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
		bne @SKIP2						; Aボタンが押されているとき
		lda Joypad::joy1_prev
		and #Joypad::BTN_A
		beq @SKIP2						; 今も1F前もAボタンが押されていないとき
@SKIP1:
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
	; スクロール量と画面を考慮してマリオのX座標を取得
	lda spr_posX_tmp_arr+$0
	add scroll_x
	lda main_disp
	add #0
	and #%0000_0001
	sta tmp2

	lda spr_posX_tmp_arr+$0
	add scroll_x
	shr #4
	sta mario_block_x

	; マリオのY座標を取得してブロック単位に変換
	lda spr_posY_tmp_arr+$0
	clc
	adc #8 ; 中心点に変換
	shr #4
	cmp #2
	bcs :+
	rts									; 上二列にマリオがいるとき
	; ------------------------------
:
	sub #2
	sta mario_block_y

	; 各方向の衝突判定
	; 上方向
	lda mario_block_y
	sub #1
	sta tmp_y
	lda mario_block_x
	sta tmp_x
	lda #1
	sta tmp1
	jsr _checkBlock

	; 下方向
	lda mario_block_y
	add #1
	sta tmp_y
	lda mario_block_x
	sta tmp_x
	lda #2
	sta tmp1
	jsr _checkBlock

	; 左方向
	lda mario_block_y
	sta tmp_y
	lda mario_block_x
	sub #1
	sta tmp_x
	lda #3
	sta tmp1
	jsr _checkBlock

	; 右方向
	lda mario_block_y
	sta tmp_y
	lda mario_block_x
	add #1
	sta tmp_x
	lda #4
	sta tmp1
	jsr _checkBlock

	rts
	; ------------------------------
.endproc


.proc _checkBlock
	; ブロックの位置を取得
	lda tmp_y
	shl #4
	clc
	adc tmp_x
	tax

	; 画面が$2000番台か$2400番台かを確認
	lda tmp2
	beq @LOAD_MAP_0400

	; $0500番台のブロックデータを確認
@LOAD_MAP_0500:
	lda $0500, x
	jmp @CHECK_COLLISION

	; $0400番台のブロックデータを確認
@LOAD_MAP_0400:
	lda $0400, x

@CHECK_COLLISION:
	; ブロックが存在するか確認
	cmp #$00
	beq @EXIT

	; 衝突がある場合の処理
	lda tmp1
	cmp #1
	beq @COLLISION_UP
	cmp #2
	beq @COLLISION_DOWN
	cmp #3
	beq @COLLISION_LEFT
	cmp #4
	beq @COLLISION_RIGHT
	bne @EXIT

@COLLISION_UP:
	; 上方向の衝突判定
	lda spr_posY_tmp_arr+$0
	and #BYT_GET_HI
	add #$10
	sta spr_posY_tmp_arr+$0
	jmp @EXIT

@COLLISION_DOWN:
	; 下方向の衝突判定
	lda spr_posY_tmp_arr+$0
	and #BYT_GET_HI
	sta spr_posY_tmp_arr+$0
	lda #0
	sta Player::is_fly
	sta Player::is_jumping
	jmp @EXIT

@COLLISION_LEFT:
	; 左方向の衝突判定
	lda spr_posX_tmp_arr+$0
	and #BYT_GET_HI
	add #$10
	sta spr_posX_tmp_arr+$0
	jmp @EXIT

@COLLISION_RIGHT:
	; 右方向の衝突判定
	lda spr_posX_tmp_arr+$0
	and #BYT_GET_HI
	sta spr_posX_tmp_arr+$0
	jmp @EXIT

@EXIT:
	rts
.endproc

.endscope
