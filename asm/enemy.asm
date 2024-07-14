.scope Enemy


.ZeroPage
counter:						.res 1	; 敵が何体スポーンしたかのカウンタ
arr_addr:						.res 2	; ステージごとの敵の配列の

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

	ldy #0							; マリオの領域もリセットしてしまう
:
	lda #$ff						; moveカウンターは初期値ff
	sta spr_move_counter, y
	iny
	cpy #6
	bne :-

	pla
	tay
	rts
	; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵をスポーンさせる
; @PARAMS		None
; @CLOBBERS		A X Y tmp1 tmp_addr1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _spawn
	ldy counter
	lda (Enemy::arr_addr), y		; ENEMY_ARR_11などの配列のデータを取ってくる（マップ番号, 上位マリオX座標，下位敵Y座標，敵ID）
	cmp #ENDCODE					; $ff
	bne :+
	rts
	; ------------------------------
:
	; マップ番号と今いるマップの比較
	cmp disp_cnt
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

	; 敵の座標をストア
	lda #$ff
	sta spr_posX_tmp_arr, x				; 右端から
	sta spr_posX_arr, x
	lda tmp1
	and #BYT_GET_LO
	shl #4							; ピクセル単位の座標に変換
	add #NEGATIVE $e0
	cnn
	sta spr_posY_tmp_arr, x
	lda spr_attr_arr, x
	ora #BIT7
	sta spr_attr_arr, x

	; 敵IDを取得
	iny
	lda (Enemy::arr_addr), y
	sta spr_id_arr, x

	iny
	sty counter						; 各X座標（各列）で敵は一体のみの出現を想定
	rts
	; ------------------------------
.endproc


.proc _physicsXAllEnemy
	ldx #1
@LOOP:
	lda spr_attr_arr, x
	bpl @SKIP1
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
@SKIP1:
	inx
	cpx #6
	bne @LOOP
	rts
	; ------------------------------
.endproc


.endscope
