.scope Enemy

/*
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
	lda STAGE_ENEMY_ARR, y
	sta Enemy::arr_addr+LO
	lda STAGE_ENEMY_ARR+1, y
	sta Enemy::arr_addr+HI
	lda #0
	sta Enemy::counter
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
	ldy counter
	lda (Enemy::arr_addr), y
	cmp #$ff
	bne :+
	rts
	; ------------------------------
:
	cmp disp_cnt
	beq :+
	rts
	; ------------------------------
	iny
	lda (Enemy::arr_addr), y
	sta tmp1
	and #BYT_GET_HI					; スポーンさせるときのマリオのX座標
	cmp Player::player_actual_pos_left		; バグ含んでない？
	bcc :+
	rts
	; ------------------------------
	; 指定X座標 < プレイヤーX座標
:
	; 敵のの格納場所を決定
	ldx #1							; マリオのフラグは確認を省く
@CHECK_LOOP:
	lda spr_attr_arr, x
	inx
	cpx #6							; spr_attr_arrは6要素しか入らないのでindex=6はあり得ない
	bne :+
	iny								; スポーンさせず終了
	iny
	sty counter
	rts
	; ------------------------------
:
	and #BIT7
	bne @CHECK_LOOP

	; MEMO: 敵の出すX座標はマップ上（画面上ではない！）の座標でもいいかも？scroll_xを使えば実装できそう
	; MEMO: 右端を超えたフラグも用意できるかも

	; 敵の座標をストア
	lda #$ff
	sta spr_posX_arr, x
	lda tmp1
	and #BYT_GET_LO
	adc #NEGATIVE $e
	shl #4							; ピクセル単位の座標に変換
	sta spr_posY_arr, x

	iny
	txa
	pha
	tya
	pha
	lda (Enemy::arr_addr), y		; 敵のID番号
	tax
	ldy #4							; ANIMATION_ARRのあるアドレスを読み出す
	ldarr ENEMY_ARR
	sta addr_tmp2+LO
	iny
	ldarr ENEMY_ARR
	sta addr_tmp2+HI
	ldy #0
	lda (addr_tmp2), y
	pla
	tay
	pla
	tax

	iny
	sty counter						; 各X座標（各列）で敵は一体のみの出現を想定
	rts
	; ------------------------------
.endproc
*/

.endscope
