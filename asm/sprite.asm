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


SPRITE_ARR:
	.addr PLAYER_MARIO
	.addr ENEMY_KURIBO				; 1
	.addr $0000
	.addr $0000
	.addr $0000
	.addr $0000
	.addr $0000
	.addr $0000
	.addr $0000
	.addr $0000


PLAYER_MARIO:
	; 定数は一旦0（何にも使っていない）
	.byte $0				; 踏めるかどうか
	.byte $0				; 死んだとき（踏まれたとき）のアニメーション(anime2)
	.byte $0, $0			; アニメーションの範囲（anime0-1）
	.addr PLAYER_ANIMATION_ARR
	.addr $ffff


PLAYER_ANIMATION_ARR:
	; standing
	.byte $03, $06, $0e, $0e
	.byte %0000_0000, %0000_0000, %0000_0000, %0100_0000
	; walk1
	.byte $01, $05, $09, $0f
	.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
	; walk2
	.byte $02, $06, $0a, $10
	.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
	; walk3, falling
	.byte $03, $06, $0b, $11
	.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
	; jumping
	.byte $01, $08, $0d, $13
	.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
	; braking
	.byte $04, $07, $0c, $12
	.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000



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
	is_spr_available:			.res 1	; スプライトが利用できるか（有効なスプライトか）の一時フラグ（spr_attr_arrのbit7）
	spr_buff_id:				.res 1	; バッファでのスプライトID


.code									; ----- code -----

;*------------------------------------------------------------------------------
; Move sprite
; @PARAMS		X: sprite id
; @CLOBBERS		A Y tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _moveSprite
	cpx #0
	beq :+
	; 敵キャラなど
	rts
	; ------------------------------
:
	; マリオの移動
	; Y方向
	lda spr_posY_tmp_arr, x
	sta spr_posY_arr, x

	; X方向
	lda spr_posX_tmp_arr, x
	cmp #$f8
	bcc :+
	; マリオが左端を超えた時
	; lda #0
	; sta spr_posX_arr, x
	rts
	; ------------------------------
:
	; 右端チェック
	ldy is_scroll_locked
	beq :++
	; スクロールロック時
	cmp #($100-PLAYER_WIDTH-PLAYER_PADDING)
	bcc :+
	; 右端を超えた時
	lda #($100-PLAYER_WIDTH-PLAYER_PADDING)
:
	sta spr_posX_arr, x
	rts
	; ------------------------------
:
	cmp #PLAYER_MAX_POSX
	bcc :+
	; マリオが右端を超えた時
	sub #PLAYER_MAX_POSX
	sta scroll_amount
	lda #PLAYER_MAX_POSX
	bne :++
:
	ldy #0
	sty scroll_amount
:
	sta spr_posX_arr, x

	rts
	; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 通常の向きでスプライトをバッファ転送する
; @PARAMS		x: sprite buff id
; @PARAMS		y: buff index（ストアし始める最初のindex）
; @PARAMS		tmp1: posY
; @PARAMS		tmp2: posX
; @CLOBBERS		A X Y tmp_rgstY tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _tfrSprToBuffNormal
		lda spr_attr_arr, x
		and #BIT7
		bne :+
		lda #$ff
		sta CHR_BUFF+$3, y
		sta CHR_BUFF+$b, y
		sta CHR_BUFF+$7, y
		sta CHR_BUFF+$f, y
		rts
		; --------------------------
:

		lda tmp1
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		add #8
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y

		lda tmp2
		sta CHR_BUFF+$3, y
		sta CHR_BUFF+$b, y
		add #8
		sta CHR_BUFF+$7, y
		sta CHR_BUFF+$f, y


		sty tmp1
		lda spr_id_arr, x			; キャラ固有のIDを取得
		ldy #4
		ldarr SPRITE_ARR
		sta addr_tmp2+LO
		iny
		ldarr SPRITE_ARR
		sta addr_tmp2+HI
		lda spr_anime_num, x
		shl #3
		tay

		ldx tmp1
		lda (addr_tmp2), y
		sta CHR_BUFF+$1, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$5, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$9, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$d, x

		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$2, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$6, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$a, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$e, x

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 左右反転してスプライトをバッファ転送する
; @PARAMS		x: sprite buff id
; @PARAMS		y: buff index（ストアし始める最初のindex）
; @PARAMS		tmp1: posY
; @PARAMS		tmp2: posX
; @CLOBBERS		A X Y addr_tmp1 tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _tfrSprToBuffFlipX
		lda spr_attr_arr, x
		and #BIT7
		bne :+
		lda #$ff
		sta CHR_BUFF+$3, y
		sta CHR_BUFF+$b, y
		sta CHR_BUFF+$7, y
		sta CHR_BUFF+$f, y
		rts
		; --------------------------
:

		lda tmp1
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		add #8
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y

		lda tmp2
		sta CHR_BUFF+$7, y
		sta CHR_BUFF+$f, y
		add #8
		sta CHR_BUFF+$3, y
		sta CHR_BUFF+$b, y

		sty tmp1
		lda spr_id_arr, x			; キャラ固有のIDを取得
		ldy #4
		ldarr SPRITE_ARR
		sta addr_tmp2+LO
		iny
		ldarr SPRITE_ARR
		sta addr_tmp2+HI
		lda spr_anime_num, x
		shl #3
		tay

		ldx tmp1
		lda (addr_tmp2), y
		sta CHR_BUFF+$1, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$5, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$9, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$d, x

		iny
		lda (addr_tmp2), y
		eor #%0100_0000					; 左右反転
		sta CHR_BUFF+$2, x
		iny
		lda (addr_tmp2), y
		eor #%0100_0000
		sta CHR_BUFF+$6, x
		iny
		lda (addr_tmp2), y
		eor #%0100_0000
		sta CHR_BUFF+$a, x
		iny
		lda (addr_tmp2), y
		eor #%0100_0000
		sta CHR_BUFF+$e, x

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 上下反転してスプライトをバッファ転送する
; @PARAMS		x: sprite buff id
; @PARAMS		y: buff index（ストアし始める最初のindex）
; @PARAMS		tmp1: posY
; @PARAMS		tmp2: posX
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------
/*
.proc _tfrSprToBuffFlipY
	; Lower left
	lda tmp1
	add #8
	sta CHR_BUFF+$0, y
	lda PLAYER_CHR_ID, x
	sta CHR_BUFF+$1, y
	lda PLAYER_CHR_ATTR, x
	sta CHR_BUFF+$2, y
	lda tmp2
	sta CHR_BUFF+$3, y
	; Lower right
	inx
	lda tmp1
	add #8
	sta CHR_BUFF+$4, y
	lda PLAYER_CHR_ID, x
	sta CHR_BUFF+$5, y
	lda PLAYER_CHR_ATTR, x
	sta CHR_BUFF+$6, y
	lda tmp2
	add #8
	sta CHR_BUFF+$7, y
	; Upper left
	inx
	lda tmp1
	sta CHR_BUFF+$8, y
	lda PLAYER_CHR_ID, x
	sta CHR_BUFF+$9, y
	lda PLAYER_CHR_ATTR, x
	sta CHR_BUFF+$a, y
	lda tmp2
	sta CHR_BUFF+$b, y
	; Upper right
	inx
	lda tmp1
	sta CHR_BUFF+$c, y
	lda PLAYER_CHR_ID, x
	sta CHR_BUFF+$d, y
	lda PLAYER_CHR_ATTR, x
	sta CHR_BUFF+$e, y
	lda tmp2
	add #8
	sta CHR_BUFF+$f, y
	rts
	; ------------------------------
.endproc
*/


;*------------------------------------------------------------------------------
; transfar to chr buff
; @PARAMS		X: sprite buff id
; @PARAMS		Y: BUFF index
; @CLOBBERS		A X Y tmp1 tmp2
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _tfrToChrBuff
		tya
		shl #4
		tay
		iny									; 0スプライトの分空けるため(buff indexを0に設定しても0スプライトを上書きしない)
		iny
		iny
		iny

		lda spr_posY_arr, x
		sta tmp1							; posY
		lda spr_posX_arr, x
		sta tmp2							; posX

		lda spr_attr_arr+$0
		and #%0000_0100
		beq :+
		lda #$f0						; 画面外にいったとき
		sta tmp1
:
		lda spr_attr_arr, x
		and #BIT0
		beq :+
		jsr _tfrSprToBuffNormal
		jmp @EXIT
:
		jsr _tfrSprToBuffFlipX

@EXIT:
		rts
		; ------------------------------
.endproc


.endscope