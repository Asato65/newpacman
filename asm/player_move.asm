.scope Player

DOWN_SPEED_LIMIT = $04					; 落下の最高速度
VER_FORCE_DECIMAL_PART_DATA:			; 加速度の増加値
		.byte $1f, $1f, $1d, $27, $27		;
VER_FALL_FORCE_DATA:					; 降下時の加速度
		.byte $68, $68, $58, $88, $88
INITIAL_VER_SPEED_DATA:					; 初速度(v0)
		.byte $fc, $fc, $fc, $fb, $fb
INITIAL_VER_FORCE_DATA:					; 初期加速度(a)
		.byte $00, $00, $00, $00, $00

.ZeroPage
is_fly: 						.byte 0		; 空中にいるか
is_jumping:						.byte 0		; ジャンプ中か（ジャンプ後の下降中もフラグオン）
is_collision_down:				.byte 0		; collisionDownの関数を通ったか（床に触れたか）
one_block_jump:					.byte 0		; 1ブロックの隙間でのジャンプが直近で実行されたか
player_current_screen:			.byte 0		; プレイヤーのいる画面番号
player_actual_pos_left:			.byte 0		; 画面上の座標ではなく，実際の座標
player_actual_pos_right:		.byte 0
player_pos_top:					.byte 0
player_pos_bottom:				.byte 0
player_offset_flags:			.byte 0		; ずれのフラグ（bit1: X方向，bit0: Y方向）
player_collision_id_lu:			.byte 0		; Left UpperのブロックID
player_collision_id_ru:			.byte 0
player_collision_id_ld:			.byte 0
player_collision_id_rd:			.byte 0
player_block_pos_X:				.byte 0		; ブロック単位での座標
player_block_pos_Y:				.byte 0		; TODO: pos_X->pos_left, pos_Y -> pos_topに変更
player_block_pos_right:			.byte 0
player_block_pos_bottom:		.byte 0
player_hit_block_lo:			.byte 0
player_hit_block_hi:			.byte 0
player_hit_block_left_hi:		.byte 0
player_hit_block_left_lo:		.byte 0
player_hit_block_right_hi:		.byte 0
player_hit_block_right_lo:		.byte 0
player_hit_block_ppu_hi:		.byte 0
player_hit_block_ppu_lo:		.byte 0
player_collision_flags:			.byte 0			; マリオの位置（offset）に応じたフラグ
player_collision_fix_flags:			.byte 0		; 実際に衝突を修正する向きを保存するフラグ
player_hit_block_is_drawed:			.byte 0		; is_changedの方が適切かも，hit_blockが変化したら1にしてnmiで処理
player_animation_block_is_drawed:	.byte 0
func_index:						.res 4			; 4方位のブロック衝突時の処理番号

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
		lda Player::is_fly
		bne @EXIT

		lda Player::one_block_jump
		bne @SMALL_JUMP
		; 4Fの猶予がある
		lda Joypad::joy1_pushstart_btn_a
		and #%0001_1111
		beq @EXIT
		bne @PREPARE_JUMP
@SMALL_JUMP:
		lda #0
		sta Player::one_block_jump
		lda Joypad::joy1_pushstart_btn_a
		shr #1
		bcc @EXIT
@PREPARE_JUMP:
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

		; ジャンプ開始位置と，現在の位置（ジャンプの最大の高さまで来たか，頭をぶつけたときの位置）を比較
		lda spr_posY_arr+$0
		sub spr_pos_y_origin
		bpl :+
		cnn
:
		cmp #8
		bcs @SKIP2
		; 非常に小さいジャンプだったとき（ジャンプが2回以上繰り返されないようにするためのフラグ）
		lda #1
		sta one_block_jump
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
		; 初期化
		lda #0
		sta player_offset_flags
		sta is_collision_down
		sta player_collision_id_lu
		sta player_collision_id_ru
		sta player_collision_id_ld
		sta player_collision_id_rd

		lda spr_attr_arr+$0
		and #BIT2						; 左端フラグ
		beq @NO_UPDATE_POS_LEFT
		; 左端を超えている（座標の値で）ときの処理
		; player_actual_pos_leftの更新と，マリオのいる画面番号の更新を行う（敵のスポーンに使うため，このコードを追加したがstanding_dispの更新が必要か不明）
		lda spr_posX_tmp_arr+$0
		add #PLAYER_PADDING
		adc scroll_x

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
		sta player_actual_pos_left		; 敵のスポーンにも使用
		rts
		; TODO: ここでrtsということは，左端を超えているときに正しく当たり判定チェックされない？？チェックする
		; ------------------------------
@NO_UPDATE_POS_LEFT:
		lda spr_posX_tmp_arr+$0
		cmp #$f0+PLAYER_PADDING
		bcc @SKIP1						; jmp: $0e + posX < $100
		cmp #$f8
		bcc @RIGHT						; jmp: $08 + posX < $100
		; 左端衝突（$f8 <= posX < 0）
		lda #0
		sta spr_posX_tmp_arr+$0
		sta spr_float_velocity_x_arr+$0
		sta spr_velocity_x_arr+$0
		beq @SKIP1	; ------------------
@RIGHT:
		; TODO: この処理がよくわからない．調査必要
		lda #($100-PLAYER_WIDTH-PLAYER_PADDING)
		sta spr_posX_tmp_arr+$0
		lda #0
		sta spr_float_velocity_x_arr+$0
		sta spr_velocity_x_arr+$0
@SKIP1:
		lda spr_attr_arr+$0
		and #%0000_0100
		beq :+
		; 左端フラグが立っているとき
		rts
		; --------------------------
:
		; マリオのY座標を取得してブロック単位に変換
		lda spr_posY_tmp_arr+$0
		add #2							; マリオの上部分のあたり判定を緩くする（2ピクセル分下げる）
		shr #4
		sub #2							; 上2列分は使わないので、2列目を0列目としてカウントする
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


		; マリオの周辺のブロックフラグをセット

		lda #0
		sta addr_tmp1+LO
		; ----- 左上 -----
		lda player_block_pos_Y
		shl #4
		ora player_block_pos_X
		tay

		lda #4
		add player_current_screen
		sta tmp1
		sta addr_tmp1+HI
		sty tmp2						; このあとhit_block_left_loに保存する

		ldx player_block_pos_Y
		cpx #$0d
		bcc :+
		lda #0
		beq :++
:
		lda (addr_tmp1), y
:
		sta player_collision_id_lu
		lda tmp1
		sta player_hit_block_left_hi
		lda tmp2
		sta player_hit_block_left_lo


		; ----- 右上 -----
		lda #4
		add player_current_screen
		sta tmp1					; 一時的
		lda player_block_pos_X
		cmp #$0f
		bne :+
		lda player_block_pos_right
		bne :+
		lda #1
		add tmp1
		and #%0000_0101
		sta tmp1
:
		lda tmp1
		sta addr_tmp1+HI
		sta tmp3

		tya							; 座標
		and #BYT_GET_HI
		sta tmp2					; y
		iny							; x++
		tya
		and #BYT_GET_LO				; x
		ora tmp2
		sta tmp2
		sta tmp4					; 右下の処理に使用
		tay

		ldx player_block_pos_Y
		cpx #$0d
		bcc :+
		lda #0
		beq :++
:
		lda (addr_tmp1), y
:
		sta player_collision_id_ru
		lda tmp1
		sta player_hit_block_right_hi
		lda tmp2
		sta player_hit_block_right_lo

@CHK_LOWER:
		; ----- 左下 -----
		lda player_block_pos_bottom
		shl #4
		ora player_block_pos_X
		tay

		lda #4
		add player_current_screen
		sta addr_tmp1+HI

		ldx player_block_pos_bottom
		cpx #$0d
		bcc :+
		lda #0
		beq :++
:
		lda (addr_tmp1), y
:
		sta player_collision_id_ld


		; ----- 右下 -----
		lda tmp3
		sta addr_tmp1+HI

		lda tmp4
		add #$10
		tay

		ldx player_block_pos_bottom
		cpx #$0d
		bcc :+
		lda #0
		beq :++
:
		lda (addr_tmp1), y
:
		sta player_collision_id_rd


@END_CHECK_ALL_BLOCK:
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
		ldx #0
		stx player_collision_fix_flags
; process
/*
for (i = 0; i < 4; i++) {
	attr = BlockCollisionSetting[playerCollisionID[x]]
	if (attr.bit6 == 0 || playerCollisionID[x] == 0) continue
	res1 = x < 2 && playerCollisonID[x] == 'h'

	if (attr.bit7 == 1) {
		carry = 1
	}

	funcIndex = attr & 0b00011111 + carry

	if (attr.bit5 == 1 || res1) {
		playerCollisionFixFlags += 1 << (3 - x)
		func_index[x] = funcIndex
		; あとでplayerCollisionFlagsを適用したときに，
		; 一部のfunc_indexの要素は使用しない可能性があるので
		; スタックではなく配列に
	} else {
		blockCollisionFunc[funcIndex]()
	}

}

playerCollisionFixFlags &= playerCollisionFlags
for (x = 0; x < 4; x++) {
	if (playerCollisionFixFlags.bit[x]) {
		funcIndex = func_index[x]
		blockCollisionFunc[funcIndex]()
	}
}
switch(playerColllisionFixFlags) {
	case "0011": ...
}
*/


		; ループの最初にインデックスのインクリメントと比較を行うので，初期値はff
		ldx #$ff
		stx tmp1						; loop index
@LOOP1:
		ldx tmp1
		inx
		cpx #4
		bne :+
		jmp @EXEC_FIX
:
		stx tmp1

		lda player_collision_id_lu, x
		sta tmp4
		and #%0011_1111
		tax
		lda BLOCK_COLLISION_SETTING, x
		sta tmp2						; attr

		lda tmp2
		beq @LOOP1
		and #BIT6
		beq @LOOP1
		lda tmp4
		beq @LOOP1

		lda #0
		ldx tmp1
		cpx #2
		bcs :+
		lda #1
:
		sta tmp3						; res1
		lda tmp4
		tax
		lda #0
		cpx #'h'
		bne :+
		lda #1
:
		and tmp3
		sta tmp3

		lda tmp2
		shl #1							; set carry

		lda tmp2
		and #%0001_1111
		adc #0
		shl #1
		sta tmp4						; funcIndex

		lda tmp2
		and #BIT5
		bne @SET_FIX_FLAGS
		lda tmp3
		beq @END_SET_FIX_FLAGS
@SET_FIX_FLAGS:
		lda tmp1
		cnn
		add #3
		tax
		lda #1
@LOOP2_START:
		cpx #0
		beq @LOOP2_END
		shl #1
		dex
		jmp @LOOP2_START
@LOOP2_END:
		ora player_collision_fix_flags
		sta player_collision_fix_flags
		lda tmp4						; funcIndex
		ldx tmp1
		sta func_index, x
		jmp @LOOP1

@END_SET_FIX_FLAGS:
		; コインなど，座標修正が不要なオブジェクトの動作
		ldx tmp4
		lda BLOCK_COLLISION_FUNC, x
		sta addr_tmp1+LO
		lda BLOCK_COLLISION_FUNC+1, x
		sta addr_tmp1+HI

		lda #>@LOOP1
		pha
		lda #<@LOOP1
		sub #1
		pha

		jmp (addr_tmp1)						; TODO: player_collision_flagsを考慮しておらず，コインの取得でバグがあるかも，修正
		;* ----------------------------------


; ブロックに衝突したときの座標修正と，ブロックアニメーションを実行
@EXEC_FIX:
		lda player_collision_fix_flags
		and player_collision_flags
		sta player_collision_fix_flags

		lda player_actual_pos_left
		add #PLAYER_WIDTH/2
		shr #4
		cmp player_block_pos_X
		bne @HIT_UR
		; 左上のブロックに衝突
		; 下位がd-fのときにはブロックを叩かない
		lda player_actual_pos_left
		and #BYT_GET_LO
		tax
		lda #%0000_1000
		cpx #$0a
		bcc @STORE_ANIME_BLOCK_FLAGS
		lda #0
		beq @STORE_ANIME_BLOCK_FLAGS
		; ------------------------------
@HIT_UR:
		; 右上のブロックに衝突
		; 下位が1-3のときにはブロックを叩かない
		lda player_actual_pos_right
		and #BYT_GET_LO
		tax
		lda #%0000_0100
		cpx #6
		bcs @STORE_ANIME_BLOCK_FLAGS
		lda #0
@STORE_ANIME_BLOCK_FLAGS:
		and player_collision_fix_flags
		sta tmp1


		ldx #0
@LOOP2:
		stx tmp2							; loop index

		; マリオの左上のブロックの座標を(0,0)とするとき
		; (0,0): x=0: bit3
		; (1,0): x=1: bit2
		; (0,1): x=2: bit1
		; (1,1): x=3: bit0
		txa									; ここのXはブロック位置に対応したindex
		cnn
		add #3
		tax									; 取り出すBIT
		lda tmp1
		and NUM2BIT, x							; xbit以外マスク
		beq @EXIT_LOOP2

		ldx tmp2
		beq @LEFT_UPPER_ADDR_SET
		cpx #1
		bne @EXIT_LOOP2
		; right upper addr set
		lda player_hit_block_right_hi
		sta player_hit_block_hi
		lda player_hit_block_right_lo
		sta player_hit_block_lo
		jmp @EXEC_ANIME
@LEFT_UPPER_ADDR_SET:
		lda player_hit_block_left_hi
		sta player_hit_block_hi
		lda player_hit_block_left_lo
		sta player_hit_block_lo

@EXEC_ANIME:
		lda func_index, x
		tax
		lda BLOCK_COLLISION_FUNC, x
		sta addr_tmp1+LO
		lda BLOCK_COLLISION_FUNC+1, x
		sta addr_tmp1+HI

		lda #>@EXIT_LOOP2
		pha
		lda #<@EXIT_LOOP2
		sub #1
		pha

		jmp (addr_tmp1)
@EXIT_LOOP2:
		ldx tmp2
		inx
		cpx #4
		bne @LOOP2


		ldx #0
		lda player_collision_fix_flags

		cmp #%0000_1100
		beq @UPPER
		cmp #%0000_0011
		beq @LOWER
		cmp #%0000_0101					; 隠しブロックを含めると1101の可能性
		beq @RIGHT
		cmp #%0000_1010					; 隠しブロックで1110の可能性
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
		jsr _fixCollisionRight
		jsr _fixCollisionUp
		rts
@UPPER_LEFT:
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
		bcc @LOWER2
		beq @LOWER_LEFT2
		bcs @LEFT2						; 上下のずれ < 左右のずれ
@CHECK_UPPER_RIGHT:
		cmp #%0000_0100					; 右上
		bne @CHECK_UPPER_LEFT

		lda player_offset_flags
		cmp #%0000_0010					; X座標のずれの確認
		beq @RIGHT2
		lda player_actual_pos_right
		and #BYT_GET_LO
		cmp #6
		bcs :+
		ldx #1
		bne @RIGHT2
:
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
		beq :+
		rts
:
		lda player_offset_flags
		cmp #%0000_0010					; X座標のずれの確認
		beq @LEFT2
		lda player_actual_pos_left
		and #BYT_GET_LO
		cmp #$a
		bcc :+
		ldx #1							; ブロックを叩いたときの滑らかな移動
		bne @LEFT2
:
		sta tmp3
		lda player_pos_top
		and #BYT_GET_LO
		cmp tmp3
		bcc @LEFT2
		beq @UPPER_LEFT2
		bcs @UPPER2						; 上下のずれ <= 左右のずれ
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
		jsr _fixCollisionUp
		jsr _fixCollisionRight
		rts
@UPPER_LEFT2:
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
		rts
.endproc


;*------------------------------------------------------------------------------
; 下衝突修正
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionDown
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
		lda player_collision_fix_flags
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
		cpx #1
		bne :+
		lda spr_posX_tmp_arr+$0
		add #$ff
:
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
		lda player_actual_pos_left
		and #BYT_GET_HI
		add #$10
		sub player_actual_pos_left
		add spr_posX_tmp_arr+$0
		cpx #1
		bne :+
		cmp #0
		beq :+
		lda #1							; マリオのX座標が$70のとき，1pxずつずらす -> 数ピクセル一気にスクロールするのではなく，滑らかに動く
		add spr_posX_tmp_arr+$0
:
		sta spr_posX_tmp_arr+$0
		lda spr_velocity_x_arr+$0
		bpl :+
		lda #0
		sta spr_float_velocity_x_arr+$0
:
		rts
		; ------------------------------
.endproc



BLOCK_COLLISION_FUNC:
	.addr _void, _collisionRengaBlock
	.addr _void
	.addr _void
	.addr _void
	.addr _void, _collisionCoinBlock
	.addr _void, _collisionFlowerBlock
	.addr _collisionCoin
	.addr _void
	.addr _void
	.addr _void
	.addr _void
	.addr _collisionGoal
	.addr _collisionGoal
	.addr _void, _collisionCoinBlock


BLOCK_ANIMATION_TILESET:
	.byte $f1, $f1, $f2, $f2
	.byte $f0, $f0, $f0, $f0
	.byte $f0, $f0, $f0, $f0

BLOCK_ANIMATION_TILE_ATTRSET:
	.byte $03, $03, $03, $03
	.byte %00000011, %01000011, %10000011, %11000011
	.byte %00000011, %01000011, %10000011, %11000011


.proc _void
	rts
.endproc


; ブロックが叩かれたときのアニメーションを実行する
.proc _startBlockAnimation
		lda tmp1
		pha
		lda tmp2
		pha
		lda tmp3
		pha
		txa						; 処理を分岐するためのID
		pha

		lda block_anime_timer
		cmp #$ff					; ffが初期値となっている
		beq :+
		jsr _endAnimeBlock			; ffでない＝アニメーション中ならそれを中断
:
		lda #0
		sta block_anime_timer
		sta block_anime_tmp1		; これが0ならばレンガのスプライトが描画される

		; 以下スプライトRAMの操作
		; y座標
		; $04cbの場合lo = cb
		lda player_hit_block_lo
		and #BYT_GET_HI				; $c0
		add #$20
		sta SPR_BLOCK_ANIMATION+0*4+0
		sta SPR_BLOCK_ANIMATION+1*4+0
		add #8
		sta SPR_BLOCK_ANIMATION+2*4+0
		sta SPR_BLOCK_ANIMATION+3*4+0

		; x座標
		lda player_hit_block_lo
		shl #4						; $b0
		sub scroll_x
		sta SPR_BLOCK_ANIMATION+0*4+3
		sta SPR_BLOCK_ANIMATION+2*4+3
		add #8
		sta SPR_BLOCK_ANIMATION+1*4+3
		sta SPR_BLOCK_ANIMATION+3*4+3

		pla							; 分岐のID
		shl #2
		tax
		beq :+						; レンガブロックのみスキップ
		ldy #0
		lda #'N'
		sta (player_hit_block_lo), y
		iny
		sty block_anime_tmp1
:
		lda BLOCK_ANIMATION_TILESET+0, x
		sta SPR_BLOCK_ANIMATION+0*4+1
		lda BLOCK_ANIMATION_TILESET+1, x
		sta SPR_BLOCK_ANIMATION+1*4+1
		lda BLOCK_ANIMATION_TILESET+2, x
		sta SPR_BLOCK_ANIMATION+2*4+1
		lda BLOCK_ANIMATION_TILESET+3, x
		sta SPR_BLOCK_ANIMATION+3*4+1

		lda BLOCK_ANIMATION_TILE_ATTRSET+0, x
		sta SPR_BLOCK_ANIMATION+0*4+2
		lda BLOCK_ANIMATION_TILE_ATTRSET+1, x
		sta SPR_BLOCK_ANIMATION+1*4+2
		lda BLOCK_ANIMATION_TILE_ATTRSET+2, x
		sta SPR_BLOCK_ANIMATION+2*4+2
		lda BLOCK_ANIMATION_TILE_ATTRSET+3, x
		sta SPR_BLOCK_ANIMATION+3*4+2

		; BGのアドレス取得，BG操作
		ldy #0
		; $2000 + (ptx) + ((pty) * $20) + ((scn) * $400)
		lda player_hit_block_hi
		and #%0000_0001
		shl #2
		ora #$20
		sta player_hit_block_ppu_hi		; $20 or $24

		lda player_hit_block_lo			; $cb = %11001011なら
		shl #1
		and #%0001_1111					; %00010110
		sta tmp1						; posX
		lda player_hit_block_lo
		add #$20						; $eb（Y座標が実際の高さになる）
		shr #4							; $0e
		shl								; %00011100（shr #3だと%00011110になる）
		sta tmp2
		sta tmp3						; posY

		; ppuのアドレス上位の計算（インクリメント）
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
		sta player_hit_block_ppu_lo		; X + Y

		lda player_hit_block_ppu_hi
		adc #0
		sta player_hit_block_ppu_hi		; インクリメント

		lda player_hit_block_ppu_hi
		sta hit_block_arr+$0
		lda player_hit_block_ppu_lo
		sta hit_block_arr+$1
		lda #0
		sta hit_block_arr+$2
		sta hit_block_arr+$3
		sta hit_block_arr+$4
		sta hit_block_arr+$5

		lda #1
		sta player_hit_block_is_drawed
@EXIT:
		pla
		sta tmp3
		pla
		sta tmp2
		pla
		sta tmp1

		rts
.endproc



; 以下はそれぞれブロックにぶつかったときのカスタム処理
.proc _collisionRengaBlock
		ldx #0							; 処理を分けるためのID（レンガブロックのスプライトが使用される）
		jsr _startBlockAnimation
		rts
.endproc


.proc _collisionCoinBlock
		ldx #1
		jsr _startBlockAnimation
		rts
.endproc


.proc _collisionCoin
		rts
.endproc


.proc _collisionFlowerBlock
		ldx #2							; 現在はCoinBlockとIDを分けているが，一緒でもいい
		; もしIDを分けるなら，_startBlockAnimation()内でフラワーを出すアニメーションも開始させる必要がある
		jsr _startBlockAnimation
		rts
.endproc



.proc _collisionGoal
		lda #4
		sta engine
		rts
.endproc


; ブロックを叩いたときY座標の変化量（1fで1byteずつ）
ANIME_Y_LIST:
	.byte $fe, $fe, $fe, $ff, $ff
	.byte $00
	.byte $01, $01, $02, $02, $02
	.byte $f0


; ブロックを叩いたときのアニメーション（Y座標の変更）を実行する
; 毎フレーム実行される
.proc _animeBlock
	ldx block_anime_timer
	cpx #$ff
	beq @EXIT
	lda ANIME_Y_LIST, x
	inx
	cmp #$f0
	bne :+
	jsr _endAnimeBlock
	rts
:
	sta tmp1
	stx block_anime_timer
	ldx #0
:
	lda SPR_BLOCK_ANIMATION, x
	add tmp1
	sta SPR_BLOCK_ANIMATION, x

	add x, #4

	cpx #$10
	bne :-

@EXIT:
	rts

.endproc



; ブロックのアニメーションを終了させるときの処理
; タイマーが切れる or 新たにアニメーションが開始されたときに実行
.proc _endAnimeBlock
		lda hit_block_arr+$0			; ppu addr hi
		sta anime_block_arr+$0
		lda hit_block_arr+$1			; ppu addr lo
		sta anime_block_arr+$1

		lda block_anime_tmp1
		beq :+

		; 叩けないブロック
		lda #$88
		sta anime_block_arr+$2
		lda #$89
		sta anime_block_arr+$3
		lda #$8a
		sta anime_block_arr+$4
		lda #$8b
		sta anime_block_arr+$5
		bne :++

:
		; レンガブロック
		lda #$94
		sta anime_block_arr+$2
		sta anime_block_arr+$3
		lda #$95
		sta anime_block_arr+$4
		sta anime_block_arr+$5
:

		lda #1
		sta player_animation_block_is_drawed

		lda #$ff
		sta SPR_BLOCK_ANIMATION+0
		sta SPR_BLOCK_ANIMATION+4
		sta SPR_BLOCK_ANIMATION+8
		sta SPR_BLOCK_ANIMATION+$c
		sta block_anime_timer

		rts

.endproc

.endscope
