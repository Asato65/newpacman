.scope Enemy


.ZeroPage
counter:						.res 1	; 敵が何体スポーンしたかのカウンタ
arr_addr:						.res 2	; ステージごとの敵の配列の

enemy_current_screen:		.byte 0		; 画面番号
enemy_actual_pos_left:		.byte 0		; 画面上の座標ではなく，実際の座標
enemy_actual_pos_right:		.byte 0
enemy_pos_top:				.byte 0
enemy_pos_bottom:			.byte 0
enemy_offset_flags:			.byte 0		; ずれのフラグ（bit1: X方向，bit0: Y方向）
enemy_collision_flags:		.byte 0		; マリオ周辺のブロックフラグ（ブロックがあれば1, bit3-0は左上，右上，左下，右下の順）
enemy_block_pos_left:			.byte 0		; ブロック単位での座標
enemy_block_pos_top:			.byte 0
enemy_block_pos_right:		.byte 0
enemy_block_pos_bottom:		.byte 0

.code


;*------------------------------------------------------------------------------
; 敵のRAM領域をリセット
; @PARAMS		Y: stage number
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _reset
		tya
		pha

		shl #1
		tay
		lda STAGE_ENEMY_ARR, y
		sta Enemy::arr_addr+LO
		lda STAGE_ENEMY_ARR+1, y
		sta Enemy::arr_addr+HI
		lda #0
		sta Enemy::counter
		sta spr_anime_num+$0

		ldy #0							; マリオの領域もリセットしてしまう
:
		lda #$ff						; moveカウンターは初期値ff
		sta spr_move_counter, y
		sta spr_posY_tmp_arr, y
		sta spr_posY_arr, y

		lda #0
		sta spr_attr_arr, y
		sta spr_attr2_arr, y
		sta spr_pos_y_decimal_part, y
		sta spr_fix_val_y, y
		sta spr_force_fall_y, y
		sta spr_velocity_y_arr, y
		sta spr_float_velocity_y_arr, y
		sta spr_decimal_part_force_y, y
		sta spr_decimal_part_velocity_x_arr, y
		iny
		cpy #6
		bne :-

		; マリオ右向き，表示
		lda #BIT7|BIT0
		sta spr_attr_arr+$0
		lda #%000_010_00
		sta spr_attr2_arr+$0

		pla
		tay
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵をスポーンさせる
; @PARAMS		None
; @CLOBBERS		A X Y tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _spawn
		ldy Enemy::counter
		lda (Enemy::arr_addr), y		; ENEMY_ARR_11などの配列のデータを取ってくる（マップ番号, 上位マリオX座標，下位敵Y座標，敵ID）
		cmp #ENDCODE					; $ff
		bne :+
		rts
		; ------------------------------
:
		; マップ番号と今いるマップの比較
		cmp standing_disp
		beq :+
		rts
		; ------------------------------
:
		; 座標系取得
		iny
		lda (Enemy::arr_addr), y
		sta tmp1
		and #BYT_GET_HI					; スポーンさせるときのマリオのX座標
		cmp Player::player_actual_pos_left		; バグ含んでない？
		bcc :+
		rts
		; ------------------------------
		; 指定X座標 < プレイヤーX座標 →　マリオが敵をスポーンできる位置にいる
:
		; 敵のバッファ格納場所を決定
		ldx #1							; マリオのフラグは確認を省く
@CHECK_LOOP:
		lda spr_attr_arr, x
		bpl :+							; 上位ビットが立っていなければ次へ（検索完了）
		inx
		cpx #6							; spr_attr_arrは6要素しか入らないのでindex=6はあり得ない
		bcc @CHECK_LOOP
		iny								; スポーンさせず終了
		iny
		sty counter
		rts
		; ------------------------------
:

		; MEMO: 敵の出すX座標はマップ上（画面上ではない！）の座標でもいいかも？scroll_xを使えば実装できそう
		; MEMO: 右端を超えたフラグも用意できるかも

		cpx #0
		bne :+
		lda #0
		sta spr_buff_start_addr, x
		beq :++
:
		dex
		lda spr_attr2_arr, x
		shl #1
		and #%0011_1000
		clc
		adc spr_buff_start_addr, x

		inx
		sta spr_buff_start_addr, x
:

		; 敵の座標をストア
		lda #$ff
		sta spr_posX_tmp_arr, x				; 右端から
		sta spr_posX_arr, x

		sub spr_posX_tmp_arr+$0
		add Player::player_actual_pos_left
		lda #0
		adc standing_disp
		sta spr_standing_disp, x

		lda tmp1
		and #BYT_GET_LO
		shl #4							; ピクセル単位の座標に変換
		add #NEGATIVE $e0
		cnn
		sta spr_posY_tmp_arr, x

		; 敵IDを取得
		iny
		lda (Enemy::arr_addr), y
		sta spr_id_arr, x

		iny
		sty counter						; 各X座標（各列）で敵は一体のみの出現を想定

		; アニメーション初期化
		stx tmp1						; バッファINDEX
		lda spr_id_arr, x
		cmp #FLOWER_ID
		bne :+
		; ファイヤーフラワーの設定（ブロック間に配置する必要があるので）
		pha
		lda scroll_x
		add scroll_amount				; scroll_xは前のフレームの値のままなので、scroll_amount（更新済み）を足す
		cnn
		add #8
		add scroll_amount				; moveSprite()で引くので±0にできるように足しておく
		and #%0000_1111
		sta spr_posX_tmp_arr, x
		sta spr_posX_arr, x
		pla
:
		tax
		stx tmp2
		ldy #2
		ldarr SPRITE_ARR
		shr #4
		ldx tmp1
		sta spr_anime_num, x

		ldx tmp2
		ldy #9
		ldarr SPRITE_ARR
		ldx tmp1
		ora #BIT7
		sta spr_attr_arr, x

		ldx tmp2
		ldy #0
		ldarr SPRITE_ARR
		ldx tmp1
		sta spr_attr2_arr, x


		ldx tmp2
		ldy #$0c
		ldarr SPRITE_ARR
		ldx tmp1
		sta spr_collision_box_x1, x

		ldx tmp2
		ldy #$0d
		ldarr SPRITE_ARR
		ldx tmp1
		sta spr_collision_box_y1, x

		ldx tmp2
		ldy #$0e
		ldarr SPRITE_ARR
		ldx tmp1
		sta spr_collision_box_x2, x

		ldx tmp2
		ldy #$0f
		ldarr SPRITE_ARR
		ldx tmp1
		sta spr_collision_box_y2, x


		lda #$ff
		sta spr_move_counter, x

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵キャラの移動（すでにセットされている速度で，これ一回で全部のキャラが動く）
; @PARAMS		None
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _physicsXAllEnemy
		ldx #1
@LOOP:
		lda spr_attr_arr, x
		bpl @SKIP1
		; X軸方向の移動
		lda spr_float_velocity_x_arr, x
		tay
		bpl :+
		cnn
:
		clc
		adc spr_decimal_part_velocity_x_arr, x
		sta tmp1
		shr #4
		cpy #0
		bpl :+
		cnn
:
		sta spr_velocity_x_arr, x
		clc
		adc spr_posX_tmp_arr, x
		sta spr_posX_tmp_arr, x
		lda tmp1
		and #BYT_GET_LO
		sta spr_decimal_part_velocity_x_arr, x

		; Y軸方向の移動
		lda spr_float_velocity_y_arr, x
		tay
		bpl :+
		; 絶対値をとる
		cnn
:
		clc
		adc spr_decimal_part_velocity_y_arr, x
		sta tmp1
		shr #4
		cpy #0
		bpl :+
		; 速度が負のとき、負の値に戻す
		cnn
:
		sta spr_velocity_y_arr, x
		clc
		adc spr_posY_tmp_arr, x
		sta spr_posY_tmp_arr, x
		lda tmp1
		and #BYT_GET_LO
		sta spr_decimal_part_velocity_y_arr, x

@SKIP1:
		inx
		cpx #6
		bne @LOOP

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵キャラのオブジェクト(BG)衝突判定
; @PARAMS		X: sprite buff id
; @CLOBBERS		A Y
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _checkCollision
		lda spr_attr_arr, x
		and #BIT7
		bne :+
		rts
		; ------------------------------
:
		; 当たり判定なしならスキップ
		lda spr_attr2_arr, x
		and #BIT1
		bne :+
		rts
		; ------------------------------
:
		; 下端を超えたときスキップ（バグあり？）
		lda spr_attr_arr, x
		and #BIT2
		beq :+
		rts
		; --------------------------
:
		; マリオのY座標を取得してブロック単位に変換
		lda spr_posY_tmp_arr, x
		shr #4
		cmp #2
		bcs :+
		rts								; 上1列に敵（の頭）がいるとき
		; ------------------------------
:
		sub #2							; 上2列分は使わないので、3列目を1列目としてカウントする
		sta enemy_block_pos_top

		lda spr_posY_tmp_arr, x
		sta enemy_pos_top
		add #$10						; 敵の高さ
		sta enemy_pos_bottom			; 敵の下端+1pxの座標
		sub #1							; 敵の下端
		shr #4
		sub #2
		sta enemy_block_pos_bottom


		; スクロール量と画面を考慮してX座標を取得
		lda spr_posX_arr, x
		add scroll_x
		tay

		lda spr_posX_tmp_arr, x
		add scroll_x
		sta tmp2						; この関数の終了時，再度standing_dispを計算するのに使う
		cmp #$f0
		bcc :+
		cpy #$10
		bcs :+
		; f0 <= newpos < 0 && 0 <= pos < 10
		dec spr_standing_disp, x
:
		cmp #$10
		bcs :+
		cpy #$f0
		bcc :+
		; 0 <= newpos < 10 && f0 <= pos < 0
		inc spr_standing_disp, x
:
		sta enemy_actual_pos_left

		lda enemy_actual_pos_left
		shr #4
		sta enemy_block_pos_left
		lda enemy_actual_pos_left
		add #$10
		sta enemy_actual_pos_right		; マリオの右端+1pxの座標
		sub #1							; マリオの右端を求める
		shr #4
		sta enemy_block_pos_right

		lda spr_standing_disp, x
		and #1
		sta enemy_current_screen

		; 下方向のあたり判定
		lda enemy_block_pos_top
		cmp enemy_block_pos_bottom
		beq :+
		lda enemy_offset_flags
		ora #%0000_0001					; Y方向にずれあり
		sta enemy_offset_flags
:
		; 右方向のあたり判定
		lda enemy_block_pos_right
		cmp enemy_block_pos_left
		beq :+
		lda enemy_offset_flags
		ora #%0000_0010
		sta enemy_offset_flags
:


		; 敵の周辺のブロックフラグをセット
		; ----- 左上 -----
		lda enemy_block_pos_top
		shl #4
		ora enemy_block_pos_left
		tay
		clc								; 後で使うためにキャリークリア
		lda enemy_current_screen
		bne :+
		lda $0400, y
		bcc :++	; ----------------------
:
		lda $0500, y
:
		beq :+							; ブロック判定
		sec								; ブロックがあったときキャリーセット
:
		rol enemy_collision_flags		; キャリーを入れていく（あと三回ローテートするのでbit3に格納される）

		; ----- 右上 -----
		lda enemy_block_pos_left
		cmp #$0f
		bne @NORMAL1
		; マリオのいる位置とその右側の位置で画面が違うとき
		lda enemy_block_pos_top
		shl #4							; 下位（X座標）は0
		tay
		clc
		lda enemy_current_screen
		bne :+
		lda $0500, y					; 今いる画面とは違う方の画面を使う
		bcc @CHECK1	; ------------------
:
		lda $0400, y
		bcc @CHECK1	; ------------------
@NORMAL1:
		lda enemy_block_pos_top
		shl #4
		ora enemy_block_pos_left
		add #1							; X座標を右に一つずらす
		tay
		clc
		lda enemy_current_screen
		bne :+
		lda $0400, y
		bcc @CHECK1	; ------------------
:
		lda $0500, y
@CHECK1:
		beq :+
		sec
:
		rol enemy_collision_flags

		; ----- 左下 -----
		lda enemy_block_pos_bottom
		shl #4
		ora enemy_block_pos_left
		tay
		clc
		lda enemy_current_screen
		bne :+
		lda $0400, y
		bcc :++	; ---------------------
:
		lda $0500, y
:
		beq :+
		sec
:
		rol enemy_collision_flags

		; ----- 右下 -----
		lda enemy_block_pos_left
		cmp #$0f
		bne @NORMAL2
		lda enemy_block_pos_bottom
		shl #4
		tay
		clc
		lda enemy_current_screen
		bne :+
		lda $0500, y
		bcc @CHECK2	; ------------------
:
		lda $0400, y
		bcc @CHECK2	; ------------------
@NORMAL2:
		lda enemy_block_pos_bottom
		shl #4
		ora enemy_block_pos_left
		add #1
		tay
		clc
		lda enemy_current_screen
		bne :+
		lda $0400, y
		bcc @CHECK2	; ------------------
:
		lda $0500, y
@CHECK2:
		beq :+
		sec
:
		rol enemy_collision_flags


		; フラグを元にしてあたり判定・位置調整
		lda enemy_offset_flags
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
		and enemy_collision_flags
		sta enemy_collision_flags
		jsr _fixCollision
@EXIT:
		; 座標を修正したあと，画面番号が変化している可能性があるので，再度計算
		; 左に移動中，画面1, x=feで，blockX=fにオブジェクト
		; 衝突したので画面2，x=0に移動
		ldy tmp2

		lda spr_posX_tmp_arr, x
		add scroll_x
		cmp #$f0
		bcc :+
		cpy #$10
		bcs :+
		; f0 <= newpos < 0 && 0 <= pos < 10
		dec spr_standing_disp, x
:
		cpy #$f0
		bcc :+
		cmp #$10
		bcs :+
		; f0 <= pos < 0 && 0 <= newpos < 10
		inc spr_standing_disp, x
:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵キャラのオブジェクト衝突後，位置を修正
; @PARAMS		X: sprite buff id
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollision
		lda enemy_collision_flags
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
		lda enemy_offset_flags
		cmp #%0000_0001					; Y座標のずれの確認
		beq @LOWER
		lda enemy_actual_pos_right
		and #BYT_GET_LO
		sta tmp1
		lda enemy_pos_bottom
		and #BYT_GET_LO
		cmp tmp1
		bcc @LOWER						; right-bottom<0 → right<bottom（左右<上下）
		beq @LOWER_RIGHT
		bcs @RIGHT						; 上下のずれ < 左右のずれ
@CHECK_LOWER_LEFT:
		cmp #%0000_0010					; 左下
		bne @CHECK_UPPER_RIGHT
		lda enemy_offset_flags
		cmp #%0000_0001					; Y座標のずれの確認
		beq @LOWER
		lda enemy_actual_pos_left
		cnn
		and #BYT_GET_LO
		sta tmp1
		lda enemy_pos_bottom
		and #BYT_GET_LO
		cmp tmp1
		bcc @LOWER
		beq @LOWER_LEFT
		bcs @LEFT						; 上下のずれ < 左右のずれ
@CHECK_UPPER_RIGHT:
		cmp #%0000_0100					; 右上
		bne @CHECK_UPPER_LEFT
		lda enemy_offset_flags
		cmp #%0000_0010					; X座標のずれの確認
		beq @RIGHT2
		lda enemy_actual_pos_right
		and #BYT_GET_LO
		sta tmp1
		lda enemy_pos_top
		and #BYT_GET_LO
		cmp tmp1
		bcc @UPPER2
		beq @UPPER_RIGHT2
		bcs @RIGHT2						; 上下のずれ <= 左右のずれ
@CHECK_UPPER_LEFT:
		cmp #%0000_1000					; 左上
		bne :+
		lda enemy_offset_flags
		cmp #%0000_0010					; X座標のずれの確認
		beq @LEFT2
		lda enemy_actual_pos_left
		and #BYT_GET_LO
		sta tmp1
		lda enemy_pos_top
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
; 敵キャラが上で衝突したのを修正
; @PARAMS		X: sprite buff id
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionUp
		lda spr_velocity_y_arr, x
		bmi :+
		rts
:
		; 上で衝突→下にずらす
		lda enemy_pos_top
		sub #2							; 上のパディング分
		and #BYT_GET_HI
		add #$10-2
		sta spr_posY_tmp_arr, x

		lda #1							; 初期化
		sta spr_velocity_y_arr, x
		sta spr_decimal_part_velocity_y_arr, x
		lda spr_force_fall_y, x
		sta spr_decimal_part_force_y, x
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵キャラが地面に衝突したのを修正
; @PARAMS		X: sprite buff id
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionDown
		lda enemy_pos_bottom
		and #BYT_GET_HI
		sub enemy_pos_bottom
		clc
		adc spr_posY_tmp_arr, x
		sta spr_posY_tmp_arr, x
		; lda #1
		; sta is_collision_down
		lda spr_velocity_y_arr, x
		bmi :+
		; ldx #0
		; stx is_fly
		; stx is_jumping
		lda #1							; Y方向の加速度が正（下向き）の場合
		sta spr_velocity_y_arr, x
		sta spr_decimal_part_velocity_y_arr, x
:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵キャラが右側のオブジェクトに衝突したのを修正
; @PARAMS		X: sprite buff id
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionRight
		; 右で衝突→左にずらす
		lda enemy_actual_pos_right
		and #BYT_GET_HI
		sub enemy_actual_pos_right
		clc
		adc spr_posX_tmp_arr, x
		sub #1
		sta tmp1
		lda spr_posX_tmp_arr, x
		bmi @CHANGE_VELOCITY
		; 元のX座標が正で
		lda tmp1
		bpl @CHANGE_VELOCITY
		; 変更後のX座標が負のとき->左端を超えたとき
		lda #0
		sta tmp1
		lda enemy_collision_flags
		and #%0000_0101					; 右側のブロック情報だけ取り出す
		cmp #%0000_0100
		beq @COLLISION_UPPER_RIGHT
		; 右下、もしくは右側全部にブロックがあるとき->上昇
		lda #0
		sta spr_velocity_y_arr, x
		jsr _fixCollisionDown
		jmp @CHANGE_VELOCITY
@COLLISION_UPPER_RIGHT:
		; 右上にブロックがあるとき->下降
		jsr _fixCollisionUp
@CHANGE_VELOCITY:
		lda tmp1
		sta spr_posX_tmp_arr, x

		lda spr_float_velocity_x_arr, x
		cnn
		sta spr_float_velocity_x_arr, x

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵キャラが左側のオブジェクトに衝突したのを修正
; @PARAMS		X: sprite buff id
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _fixCollisionLeft
		lda enemy_actual_pos_left
		and #BYT_GET_HI
		add #$10
		sub enemy_actual_pos_left
		clc
		adc spr_posX_tmp_arr, x
		sta spr_posX_tmp_arr, x

		lda spr_float_velocity_x_arr, x
		cnn
		sta spr_float_velocity_x_arr, x

		rts
		; ------------------------------
.endproc


.endscope
