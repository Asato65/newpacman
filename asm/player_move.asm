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
is_fly: 						.byte 0		; 空中にいるか
is_jumping:						.byte 0		; ジャンプ中か（ジャンプ後の下降中もフラグオン）
is_collision_down:				.byte 0		; collisionDownの関数を通ったか（床に触れたか）
player_current_screen:			.byte 0		; プレイヤーのいる画面番号
player_actual_pos_left:			.byte 0		; 画面上の座標ではなく，実際の座標
player_actual_pos_right:		.byte 0
player_pos_top:					.byte 0
player_pos_bottom:				.byte 0
player_offset_flags:			.byte 0		; ずれのフラグ（bit1: X方向，bit0: Y方向）
player_collision_flags:			.byte 0		; マリオ周辺のブロックフラグ（ブロックがあれば1, bit3-0は左上，右上，左下，右下の順）
player_block_pos_X:				.byte 0		; ブロック単位での座標
player_block_pos_Y:				.byte 0
player_block_pos_right:			.byte 0
player_block_pos_bottom:		.byte 0
player_hit_block_lo:			.byte 0
player_hit_block_hi:			.byte 0
player_hit_block_ppu_hi:		.byte 0
player_hit_block_ppu_lo:		.byte 0
player_hit_block_left_hi:		.byte 0
player_hit_block_left_lo:		.byte 0
player_hit_block_right_hi:		.byte 0
player_hit_block_right_lo:		.byte 0
player_hit_block_plt_lo:		.byte 0
player_hit_block_plt_hi:		.byte 0
player_hit_block_is_drawed:			.byte 0
player_hide_block_collision_flags:	.byte 0

.code

.import MARIOSE2

se_jump:		.addr	MARIOSE2

;*------------------------------------------------------------------------------
; プレイヤーX方向移動
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
; プレイヤーアニメーション
; @PARAMS		None
; @CLOBBERS		A tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _animate
		lda Player::is_jumping
		beq :+
		; ジャンプ時
		lda #4							; ジャンプ時のアニメーション番号
		sta spr_anime_num
		rts
		; ------------------------------
:
		lda Player::is_fly
		beq :+
		; 落下時
		lda #3
		sta spr_anime_num
		rts
		; ------------------------------
:
		lda spr_float_velocity_x_arr+$0
		bne :+
		lda Joypad::joy1
		and #(Joypad::BTN_L|Joypad::BTN_R)
		bne @NORMAL_MOVE				; 当たり判定で動きが封じられているとき（速度0でボタンは押されている）->歩行アニメーションへ
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
		bcs @NO_CHANGE_CHR

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
; smbdisでは6060行目のPlayerPhysicsSubで実行？
;*------------------------------------------------------------------------------
.proc _jumpCheck
		; 4Fの猶予がある
		lda Joypad::joy1_pushstart_btn_a
		and #%0000_1111
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
; smbdisでは6092行目のProcJumping()
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
		lda spr_float_velocity_x_arr+$0
		bpl :+
		cnn								; X方向のスピードの絶対値を求める
:
		cmp #$09
		bcc :+
		inx
		cmp #$10
		bcc :+
		inx
		cmp #$19
		bcc :+
		inx
		cmp #$1c
		bcc :+
		inx
:
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

		lda	se_jump
		ldx	se_jump+1
		jsr	_nsd_play_se

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Y方向の速度決定前のちょっとした動作
; Aボタンの押されている状況や速度に応じて重力を変更
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
; smbdisでは6082行目のCheckForJumping()
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
		; Aボタンが離されたタイミング or 速度が正（上向き）の時
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
; https://qiita.com/morian-bisco/items/4c659d9f940c7e3a2099に従ったプログラム
; smbdisでは7722行目のImposeGravity()で動作
;*------------------------------------------------------------------------------
.proc _physicsY
		ldx #0
		stx spr_fix_val_y+$0			; 初期化

		lda spr_pos_y_decimal_part+$0
		add spr_decimal_part_velocity_y_arr+$0
		sta spr_pos_y_decimal_part+$0
		bcc @SKIP_OVERFLOW
		; オーバーフローしてたら
		inx								; x = 1
		stx spr_fix_val_y+$0			; 補正値があったらここで修正
@SKIP_OVERFLOW:
		lda spr_posY_arr+$0
		add spr_velocity_y_arr+$0
		add spr_fix_val_y+$0
		sta spr_posY_tmp_arr+$0

		lda spr_decimal_part_velocity_y_arr+$0
		add spr_decimal_part_force_y+$0
		sta spr_decimal_part_velocity_y_arr+$0
		bcc :+
		; 直前の計算結果が255を超えたとき
		inc spr_velocity_y_arr+$0
:
		lda spr_velocity_y_arr+$0
		cmp #DOWN_SPEED_LIMIT
		bmi :+
		; 落下スピードがMAXを超えていたら
		lda #DOWN_SPEED_LIMIT
		sta spr_velocity_y_arr+$0
		lda #0
		sta spr_decimal_part_velocity_y_arr+$0
:
		lda spr_velocity_y_arr+$0
		bpl @DOWN
		; 上昇中
		lda spr_posY_tmp_arr+$0
		add #$10
		bpl @EXIT
		; 移動後のposYが負（画面下部、画面外）
		lda spr_posY_arr+$0
		add #$10
		bmi @EXIT
		; 元のposYが正（画面上部）
		lda spr_attr_arr+$0
		ora #%0000_0100
		sta spr_attr_arr+$0
		bne @EXIT
		; ------------------------------
@DOWN:
		lda spr_attr_arr+$0
		and #%0000_0100
		bne :+
		lda spr_posY_tmp_arr+$0
		cmp #$f0
		bcc :+
		; 落下死
		lda #2
		sta engine
		bne @EXIT
:
		lda engine
		cmp #2
		beq @EXIT
		lda spr_attr_arr+$0
		and #BIT2
		beq @EXIT
		lda spr_posY_tmp_arr+$0
		bmi @EXIT
		; posYが正（画面上部）に戻ってきたとき
		lda spr_attr_arr+$0
		and #%1111_1011
		sta spr_attr_arr+$0
@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; あたり判定チェック（ブロック）
; @PARAMS		None
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _checkCollision
		lda #0
		sta player_offset_flags
		sta player_collision_flags
		sta is_collision_down

		lda spr_attr_arr+$0
		and #BIT4
		beq :+
		rts
		; ------------------------------
:

		lda spr_posX_tmp_arr+$0
		cmp #$f0+PLAYER_PADDING
		bcc @SKIP1
		cmp #$f8
		bcc @RIGHT
		; 左端衝突
		lda #0
		sta spr_posX_tmp_arr+$0
		sta spr_float_velocity_x_arr+$0
		sta spr_velocity_x_arr+$0
		beq @SKIP1	; ------------------
@RIGHT:
		lda #($100-PLAYER_WIDTH-PLAYER_PADDING)
		sta spr_posX_tmp_arr+$0
		lda #0
		sta spr_float_velocity_x_arr+$0
		sta spr_velocity_x_arr+$0
@SKIP1:
		lda spr_attr_arr+$0
		and #%0000_0100
		beq :+
		rts
		; --------------------------
:
		; マリオのY座標を取得してブロック単位に変換
		lda spr_posY_tmp_arr+$0
		add #2							; マリオの上部分のあたり判定を緩くする（2ピクセル分下げる）
		shr #4
		cmp #2
		bcs :+
		rts								; 上1列にマリオ（の頭）がいるとき
		; ------------------------------
:
		sub #2							; 上2列分は使わないので、3列目を1列目としてカウントする
		sta player_block_pos_Y

		lda spr_posY_tmp_arr+$0
		add #2
		sta player_pos_top
		add #$10-2						; 当たり判定を緩くした分、マリオの高さを低くする
		sta player_pos_bottom			; マリオの下端+1pxの座標
		sub #1							; マリオの下端
		shr #4
		sub #2
		sta player_block_pos_bottom


		; スクロール量と画面を考慮してマリオのX座標を取得
		ldx #0
		stx tmp1
		lda spr_posX_tmp_arr+$0
		add #PLAYER_PADDING
		bcc :+
		; キャリーがあったらtmp1に1を代入（キャリーフラグ代わり）
		inx
		stx tmp1
:
		add scroll_x
		sta tmp2
		lda main_disp
		adc tmp1						; キャリーが立っている／tmp1が1ならそれを足す
		and #%0000_0001
		sta player_current_screen

		lda tmp2
		ldx player_actual_pos_left
		cmp #$f0
		bcc :+
		cpx #$10
		bcs :+
		; f0 <= newpos < 0 && 0 <= pos < 10
		dec standing_disp
:
		cmp #$10
		bcs :+
		cpx #$f0
		bcc :+
		; 0 <= newpos < 10 && f0 <= pos < 0
		inc standing_disp
:
		sta player_actual_pos_left

		lda player_actual_pos_left
		shr #4
		sta player_block_pos_X
		lda player_actual_pos_left
		add #PLAYER_WIDTH
		sta player_actual_pos_right		; マリオの右端+1pxの座標
		sub #1							; マリオの右端を求める
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
		lda #4
		sta tmp1
		stx tmp2
		lda $0400, x
		bcc :++	; ----------------------
:
		lda #5
		sta tmp1
		stx tmp2
		lda $0500, x
:
		beq @ROL1					; ブロック判定
		cmp #'B'
		beq @SKIP2_1
		cmp #'Q'
		beq @SKIP2_1
		cmp #'h'
		bne :+
		lda #%0000_1000
		sta player_hide_block_collision_flags
		clc
		bcc @SKIP2_2
:
		sec								; 当たり判定があって叩いたときの動作がないブロック
		bcs @ROL1
@SKIP2_1:
		sec								; ブロックがあったときキャリーセット
@SKIP2_2:
		lda tmp1
		sta player_hit_block_left_hi
		lda tmp2
		sta player_hit_block_left_lo
@ROL1:
		rol player_collision_flags		; キャリーを入れていく（あと三回ローテートするのでbit3に格納される）

		; ----- 右上 -----
		lda player_block_pos_X
		cmp #$0f
		bne @NORMAL1
		; マリオのいる位置とその右側の位置で画面が違うとき
		lda player_block_pos_Y
		shl #4							; 下位（X座標）は0
		tax
		clc
		lda player_current_screen
		bne :+
		lda #5
		sta tmp1
		stx tmp2
		lda $0500, x					; 今いる画面とは違う方の画面を使う
		bcc @CHECK1	; ------------------
:
		lda #4
		sta tmp1
		stx tmp2
		lda $0400, x
		bcc @CHECK1	; ------------------
@NORMAL1:
		lda player_block_pos_Y
		shl #4
		ora player_block_pos_X
		add #1							; X座標を右に一つずらす
		tax
		clc
		lda player_current_screen
		bne :+
		lda #4
		sta tmp1
		stx tmp2
		lda $0400, x
		bcc @CHECK1	; ------------------
:
		lda #5
		sta tmp1
		stx tmp2
		lda $0500, x
@CHECK1:
		beq @ROL2						; ブロック判定
		cmp #$64						; ゴールポール
		beq @COLLISION_GOAL_POAL
		cmp #'B'
		beq @SKIP3_1
		cmp #'Q'
		beq @SKIP3_1
		cmp #'h'
		bne :++
		lda player_offset_flags
		and #%0000_0010
		beq :+
		lda #%0000_0100
		sta player_hide_block_collision_flags
:
		clc
		bcc @SKIP3_2
:
		sec
		bcs @ROL2
@COLLISION_GOAL_POAL:
		lda player_offset_flags
		and #%0000_0010
		beq @SKIP3_2
		lda player_actual_pos_right
		and #BYT_GET_LO
		cmp #8
		bcc @SKIP3_2
		lda #4
		sta engine
		bne @ROL2
@SKIP3_1:
		sec
@SKIP3_2:
		lda tmp1
		sta player_hit_block_right_hi
		lda tmp2
		sta player_hit_block_right_lo
@ROL2:
		rol player_collision_flags

		; ----- 左下 -----
		lda player_block_pos_bottom
		shl #4
		ora player_block_pos_X
		tax
		clc
		lda player_current_screen
		bne :+
		lda $0400, x
		bcc :++	; ---------------------
:
		lda $0500, x
:
		beq :++
		cmp #'h'
		bne :+
		clc
		bcc :++
:
		sec
:
		rol player_collision_flags

		; ----- 右下 -----
		lda player_block_pos_X
		cmp #$0f
		bne @NORMAL2
		lda player_block_pos_bottom
		shl #4
		tax
		clc
		lda player_current_screen
		bne :+
		lda $0500, x
		bcc @CHECK2	; ------------------
:
		lda $0400, x
		bcc @CHECK2	; ------------------
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
		bcc @CHECK2	; ------------------
:
		lda $0500, x
@CHECK2:
		beq :++							; ブロック判定
		cmp #$64
		bne @SKIP3
		lda player_offset_flags
		and #%0000_0010
		beq @SKIP4_2
		lda player_actual_pos_right
		and #BYT_GET_LO
		cmp #8
		bcc @SKIP4_2
		lda #4
		sta engine
		clc
		bcc :++
@SKIP3:
		cmp #'h'
		bne :+
		clc
		bcc :++
:
		sec
:
		rol player_collision_flags
@SKIP4_2:

		; フラグを元にしてあたり判定・位置調整
		lda player_offset_flags
		cmp #%0000_0011
		beq @CHECK_XY
		cmp #%0000_0001
		beq @CHECK_Y
		cmp #%0000_0010
		beq @CHECK_X
		bne @EXIT
@CHECK_XY:
		lda #%0000_1111
		bne @JMP_SUB	; --------------
@CHECK_Y:
		lda #%0000_1010					; 右側は無視
		bne @JMP_SUB	; --------------
@CHECK_X:
		lda #%0000_1100					; 下側は無視
@JMP_SUB:
		and player_collision_flags
		sta player_collision_flags
		jsr _fixCollision
@EXIT:
		lda is_collision_down
		eor #%0000_0001
		sta is_fly
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 衝突修正
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollision
		lda player_collision_flags
		bne :+
		lda player_hide_block_collision_flags
		sta player_collision_flags
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
		bne @OTHER_CHECK				; マリオ周辺のブロックが一つだけのとき

@LOWER:
		jsr _fixCollisionDown
		rts
@UPPER:
		jsr _fixCollisionUp
		rts
@RIGHT:
		jsr _fixCollisionRight
		rts
@LEFT:
		jsr _fixCollisionLeft
		rts
@LOWER_RIGHT:
		jsr _fixCollisionRight
		jsr _fixCollisionDown
		rts
@LOWER_LEFT:
		jsr _fixCollisionLeft
		jsr _fixCollisionDown
		rts
@UPPER_RIGHT:
		lda #0
		sta player_hide_block_collision_flags
		jsr _fixCollisionRight
		jsr _fixCollisionUp
		rts
@UPPER_LEFT:
		lda #0
		sta player_hide_block_collision_flags
		jsr _fixCollisionLeft
		jsr _fixCollisionUp
		rts
		; ------------------------------

@OTHER_CHECK:
		cmp #%0000_0001					; 右下→着地する方向に動かし，左にずらす
		bne @CHECK_LOWER_LEFT
		lda player_offset_flags
		cmp #%0000_0001					; Y座標のずれの確認
		beq @LOWER
		lda player_actual_pos_right
		and #BYT_GET_LO
		sta tmp3
		lda player_pos_bottom
		and #BYT_GET_LO
		cmp tmp3
		bcc @LOWER						; right-bottom<0 → right<bottom（左右<上下）
		beq @LOWER_RIGHT
		bcs @RIGHT						; 上下のずれ < 左右のずれ
@CHECK_LOWER_LEFT:
		cmp #%0000_0010					; 左下
		bne @CHECK_UPPER_RIGHT
		lda player_offset_flags
		cmp #%0000_0001					; Y座標のずれの確認
		beq @LOWER
		lda player_actual_pos_left
		cnn
		and #BYT_GET_LO
		sta tmp3
		lda player_pos_bottom
		and #BYT_GET_LO
		cmp tmp3
		bcc @LOWER
		beq @LOWER_LEFT
		bcs @LEFT						; 上下のずれ < 左右のずれ
@CHECK_UPPER_RIGHT:
		cmp #%0000_0100					; 右上
		bne @CHECK_UPPER_LEFT
		lda player_offset_flags
		cmp #%0000_0010					; X座標のずれの確認
		beq @RIGHT2
		lda player_actual_pos_right
		and #BYT_GET_LO
		sta tmp3
		lda player_pos_top
		cnn
		and #BYT_GET_LO
		cmp tmp3
		bcc @UPPER2						; 上下のずれ <= 左右のずれ
		beq @UPPER_RIGHT2
		bcs @RIGHT2
@CHECK_UPPER_LEFT:
		cmp #%0000_1000					; 左上
		bne :+
		lda player_offset_flags
		cmp #%0000_0010					; X座標のずれの確認
		beq @LEFT2
		lda player_actual_pos_left
		and #BYT_GET_LO
		sta tmp3
		lda player_pos_top
		and #BYT_GET_LO
		cmp tmp3
		bcc @LEFT2
		beq @UPPER_LEFT2
		bcs @UPPER2						; 上下のずれ <= 左右のずれ
:
		rts
		; ------------------------------

@LOWER2:
		jsr _fixCollisionDown
		rts
@UPPER2:
		jsr _fixCollisionUp
		rts
@RIGHT2:
		jsr _fixCollisionRight
		rts
@LEFT2:
		jsr _fixCollisionLeft
		rts
@LOWER_RIGHT2:
		jsr _fixCollisionDown
		jsr _fixCollisionRight
		rts
@LOWER_LEFT2:
		jsr _fixCollisionDown
		jsr _fixCollisionLeft
		rts
@UPPER_RIGHT2:
		lda #0
		sta player_hide_block_collision_flags
		jsr _fixCollisionUp
		jsr _fixCollisionRight
		rts
@UPPER_LEFT2:
		lda #0
		sta player_hide_block_collision_flags
		jsr _fixCollisionUp
		jsr _fixCollisionLeft
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 上衝突修正
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionUp
		lda spr_velocity_y_arr+$0
		bmi :+
		rts
:
		lda player_hide_block_collision_flags
		bne :+
		; 上で衝突→下にずらす
		lda player_pos_top
		sub #2							; 上のパディング分
		and #BYT_GET_HI
		add #$10-2
		sta spr_posY_tmp_arr+$0

		lda #1							; 初期化
		sta spr_velocity_y_arr+$0
		sta spr_decimal_part_velocity_y_arr+$0
		lda spr_force_fall_y+$0
		sta spr_decimal_part_force_y+$0
:

		; 衝突したブロックの変更ルーチン（レンガブロック等）
		lda #0
		sta tmp1						; bit1: 左上のブロックが存在するか, bit0: 右上のブロックが存在するか
		lda player_hit_block_left_hi
		beq :+
		lda #%0000_0010
		ora tmp1
		sta tmp1
:
		lda player_hit_block_right_hi
		beq :+
		lda #%0000_0001
		ora tmp1
		sta tmp1
:
		lda player_offset_flags
		and #%0000_0010
		bne :+							; X方向のずれがあるときスキップ（左上と右上両方使う）
		lda tmp1						; X方向のずれがないとき
		and #%0000_0010					; 右上のブロックはマスク
		sta tmp1
:
		lda tmp1
		bne :+
		rts
		; ------------------------------
:
		cmp #%0000_0011
		bne :+
		lda player_actual_pos_left
		add #PLAYER_WIDTH/2
		shr #4
		cmp player_block_pos_X
		beq @HIT_UPPER_LEFT
		bne @HIT_UPPER_RIGHT
		; ------------------------------
:
		cmp #%0000_0010
		bne @HIT_UPPER_RIGHT
@HIT_UPPER_LEFT:
		lda player_hit_block_left_hi
		sta player_hit_block_hi
		lda player_hit_block_left_lo
		sta player_hit_block_lo
		jmp :+
@HIT_UPPER_RIGHT:
		lda player_hit_block_right_hi
		sta player_hit_block_hi
		lda player_hit_block_right_lo
		sta player_hit_block_lo
:
		ldy #0
		; $2000 + (ptx) + ((pty) * $20) + ((scn) * $400)
		lda player_hit_block_hi
		and #%0000_0001
		shl #2
		ora #$20
		sta player_hit_block_ppu_hi
		add #3
		sta player_hit_block_plt_hi

		lda player_hit_block_lo
		shl
		and #%0001_1111
		sta tmp1						; posX
		lda player_hit_block_lo
		add #$20
		shr #4
		shl
		sta tmp2
		sta tmp3						; posY
		ldx #$20-1
:
		lda tmp2
		add tmp3
		sta tmp2
		lda player_hit_block_ppu_hi
		adc #0
		sta player_hit_block_ppu_hi
		dex
		bne :-

		lda tmp2
		add tmp1
		sta player_hit_block_ppu_lo
		lda player_hit_block_ppu_hi
		adc #0
		sta player_hit_block_ppu_hi

		; plt
		lda tmp1
		shr #2
		and #%0000_1111
		sta tmp2
		lda tmp3
		shl
		and #%1111_1000
		ora tmp2
		add #$c0
		sta player_hit_block_plt_lo

		lda #%0000_0011
		sta tmp2
		lda tmp1
		and #%0000_0010
		beq :+
		lda tmp2
		shl #2
		sta tmp2
:
		lda tmp3
		shr
		and #%0000_0001
		beq :+
		lda tmp2
		shl #4
		sta tmp2
:
		lda tmp2
		eor #%11111111
		sta tmp2						; plt data

		lda player_hit_block_ppu_hi
		sta hit_block_arr+$0
		lda player_hit_block_ppu_lo
		sta hit_block_arr+$1
		lda #$88
		sta hit_block_arr+$2
		lda #$89
		sta hit_block_arr+$3
		lda #$8a
		sta hit_block_arr+$4
		lda #$8b
		sta hit_block_arr+$5
		lda player_hit_block_plt_hi
		sta hit_block_arr+$6
		lda player_hit_block_plt_lo
		sta hit_block_arr+$7
		lda tmp2
		sta hit_block_arr+$8

		lda #1
		sta player_hit_block_is_drawed

		ldy #0
		lda #'N'
		sta (player_hit_block_lo), y
@EXIT:
		rts
	; ------------------------------

.endproc


;*------------------------------------------------------------------------------
; 下衝突修正
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionDown
		lda player_hide_block_collision_flags
		bne :+
		lda player_pos_bottom
		and #BYT_GET_HI
		sub player_pos_bottom
		add spr_posY_tmp_arr+$0
		sta spr_posY_tmp_arr+$0
		lda #1
		sta is_collision_down
		lda spr_velocity_y_arr+$0
		bmi :+
		lda #0
		sta is_jumping
		lda #1							; Y方向の加速度が正（下向き）の場合
		sta spr_velocity_y_arr+$0
		sta spr_decimal_part_velocity_y_arr+$0
:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 右衝突修正
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionRight
		lda player_hide_block_collision_flags
		bne :+
		; 右で衝突→左にずらす
		lda player_actual_pos_right
		and #BYT_GET_HI
		sub player_actual_pos_right
		add spr_posX_tmp_arr+$0
		sta tmp4
		lda spr_posX_tmp_arr+$0
		bmi @CHANGE_VELOCITY
		; 元のX座標が正で
		lda tmp4
		bpl @CHANGE_VELOCITY
		; 変更後のX座標が負のとき->左端を超えたとき
		lda #0
		sta tmp4
		lda player_collision_flags
		and #%0000_0101					; 右側のブロック情報だけ取り出す
		cmp #%0000_0100
		beq @COLLISION_UPPER_RIGHT
		; 右下、もしくは右側全部にブロックがあるとき->上昇
		lda #0
		sta spr_velocity_y_arr+$0
		jsr _fixCollisionDown
		jmp @CHANGE_VELOCITY
@COLLISION_UPPER_RIGHT:
		; 右上にブロックがあるとき->下降
		jsr _fixCollisionUp
@CHANGE_VELOCITY:
		lda tmp4
		sta spr_posX_tmp_arr+$0
		lda spr_velocity_x_arr+$0
		bmi :+
		lda #0
		sta spr_float_velocity_x_arr+$0
:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 左衝突修正
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionLeft
		lda player_hide_block_collision_flags
		bne :+
		lda player_actual_pos_left
		and #BYT_GET_HI
		add #$10
		sub player_actual_pos_left
		add spr_posX_tmp_arr+$0
		sta spr_posX_tmp_arr+$0
		lda spr_velocity_x_arr+$0
		bpl :+
		lda #0
		sta spr_float_velocity_x_arr+$0
:
		rts
		; ------------------------------
.endproc


.endscope
