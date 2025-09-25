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


.import MARIOSE0

se_stepped_on:
		.addr	MARIOSE0


SPRITE_ARR:
		.addr PLAYER_MARIO
		.addr ENEMY_KURIBO				; 1
		.addr ENEMY_FLOWER				; 2
		.addr FIREFLOWER_ARR			; 3
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
		.addr PLAYER_MOVE_ARR


PLAYER_ANIMATION_ARR:
		; standing
		.byte $04, $05, $06, $07
		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
		; walk1
		.byte $08, $09, $0a, $0b
		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
		; walk2
		.byte $0c, $0d, $0e, $0f
		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
		; walk3, falling
		.byte $10, $11, $12, $13
		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
		; jumping
		.byte $14, $15, $16, $17
		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
		; braking
		.byte $18, $19, $1a, $1b
		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000
		; death
		.byte $1c, $1d, $1e, $1f
		.byte %0000_0000, %0000_0000, %0000_0000, %0000_0000


PLAYER_MOVE_ARR:
		.byte $0, $0, $0, $0, $0, $ff		; タイマー(0なので速度を更新しない), X速度, Y速度, X加速度, Y加速度、エンドコード


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
; スプライトの移動
; スプライトごとにループさせてこの関数を呼ぶ形式
; @PARAMS		X: スプライトID（バッファのINDEX）
; @CLOBBERS		A Y tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _moveSprite
		cpx #$ff
		beq @BLOCK_ANIMATION
		cpx #0
		bne @OTHER
		jmp @PLAYER
@BLOCK_ANIMATION:
		ldx #0
:
		lda SPR_BLOCK_ANIMATION+3, x
		sta tmp1
		sub scroll_amount
		sta SPR_BLOCK_ANIMATION+3, x
		bcs :+
		lda tmp1
		bmi :+
		lda #$ff
		sta SPR_BLOCK_ANIMATION+0, x
:
		add x, #4
		cpx #$10
		bne :--
		rts
@OTHER:
		; 敵キャラなど
		lda spr_attr_arr, x
		bmi :+
		rts
		; ------------------------------
:
		lda spr_posY_tmp_arr, x
		cmp #$f0
		bcc :+
		lda spr_posY_arr, x
		cmp #$f0
		bcs :+
		lda spr_attr_arr, x
		ora #BIT2						; Y座標の画面外フラグ
		sta spr_attr_arr, x
:
		lda spr_posY_tmp_arr, x
		sta spr_posY_arr, x

@DISP_OVER_CHK:
		lda spr_posX_tmp_arr, x
		sub scroll_amount
		sta spr_posX_tmp_arr, x

		bpl @RIGHT_OVER_CHK
; (left over | right over end) flag change
; if (newX < 0 && 0 <= oldX): left over on | right over off
; -> if (0 <= newX || oldX < 0): skip
		lda spr_posX_arr, x
		bmi @DESTROY_ENEMY_CHK
		cmp #$10
		bcs @STORE_POS_X
		lda spr_attr_arr, x
		and #BIT5
		bne @RIGHT_OVER_FLAG_OFF
		; left over on
		lda spr_attr_arr, x
		ora #BIT1
		sta spr_attr_arr, x
		bne @DESTROY_ENEMY_CHK
		; ------------------------------
@RIGHT_OVER_FLAG_OFF:
		eor spr_attr_arr, x
		sta spr_attr_arr, x
		jmp @DESTROY_ENEMY_CHK
		; ------------------------------
@RIGHT_OVER_CHK:
; (left over end | right over) flag change
; if (oldX < 0 && 0 <= newX): left over off | right over on
; -> if (0 <= oldX || newX < 0): skip
		lda spr_posX_arr, x
		bpl @DESTROY_ENEMY_CHK
		cmp #$f0
		bcc @STORE_POS_X
		lda spr_attr_arr, x
		and #BIT1
		bne @LEFT_OVER_FLAG_OFF
		; right over on
		lda spr_attr_arr, x
		ora #BIT5
		sta spr_attr_arr, x
		bne @DESTROY_ENEMY_CHK
		; ------------------------------
@LEFT_OVER_FLAG_OFF:
		eor spr_attr_arr, x
		sta spr_attr_arr, x

@DESTROY_ENEMY_CHK:
; left over -> posX < $90（<=）で消去
; right over -> $70 < posX（<=）で消去
		; chk is left over
		lda spr_attr_arr, x
		and #BIT1
		beq @CHK_IS_RIGHT_OVER
		lda spr_posX_tmp_arr, x
		cmp #$90
		bcc @DESTROY
		bcs @STORE_POS_X
		; ------------------------------
@CHK_IS_RIGHT_OVER:
		lda spr_attr_arr, x
		and #BIT5
		beq @STORE_POS_X
		lda spr_posX_tmp_arr, x
		cmp #$70
		bcc @STORE_POS_X
@DESTROY:
		lda spr_attr_arr, x
		and #%0111_1111
		sta spr_attr_arr, x
@STORE_POS_X:
		lda spr_posX_tmp_arr, x
		sta spr_posX_arr, x
		rts
		; ------------------------------
@PLAYER:
		; マリオの移動
		; Y方向
		lda spr_posY_tmp_arr, x
		cmp #$f0
		bcc :+
		lda spr_posY_arr, x
		cmp #$f0
		bcs :+
		lda spr_attr_arr, x
		ora #BIT2
		sta spr_attr_arr, x
:
		lda spr_posY_tmp_arr, x
		sta spr_posY_arr, x

		; X方向
		lda spr_posX_tmp_arr, x
		cmp #$f8
		bcc :+
		; マリオが左端を超えた時
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
		lda tmp1
		sta tmp3						; 右側8pxのY座標

		lda spr_attr_arr, x
		and #BIT1
		bne @OVER_LEFT
		lda tmp2
		cmp #$f8
		bcc @SKIP
		; 右端を超えたとき
		lda #$ff
		sta tmp3
		jmp @END
@OVER_LEFT:
		lda tmp2
		cmp #$f8
		bcc @HIDE
		lda #$ff
		sta tmp1
@SKIP:
		; hide
		lda spr_attr_arr, x
		and #BIT7
		beq @HIDE
		lda spr_attr_arr, x
		and #BIT5|BIT2
		beq @END
		lda spr_posY_tmp_arr, x
		cmp #$f8
		bcs @END
@HIDE:
		lda #$ff
		sta tmp1
		sta tmp3
@END:

		lda spr_attr2_arr, x
		shr #2
		and #%0000_0111
		bne :+
		rts
:
		sta tmp4						; size_y

		sty tmp5						; buffIndex
		stx tmp6						; sprBuffId

		lda spr_id_arr, x			; キャラ固有のIDを取得
		tax
		ldy #4						; 配列ENEMY_enemyname[4]を取得
		ldarr SPRITE_ARR
		sta addr_tmp2+LO
		iny
		ldarr SPRITE_ARR
		sta addr_tmp2+HI
		ldx tmp6
		lda tmp4
		shl #2
		sta tmp6						; クリボーなら8（chr4,attr4），フラワーは12ずつの値
		lda spr_anime_num, x
		tax
		beq @INDEX_CALC_LOOP_EXIT
		lda #0
@INDEX_CALC_LOOP:
		add tmp6
		dex
		bne @INDEX_CALC_LOOP
@INDEX_CALC_LOOP_EXIT:
		tay								; enemyname_ANIMATION_ARRのいずれかのchr配列の先頭アドレス

		ldx tmp5						; buffIndex（yレジスタに入っていた引数の値）
		lda tmp4
@COLUMN:
		pha

		; tile id
		lda (addr_tmp2), y
		sta CHR_BUFF+$1, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$5, x
		; attr
		tya

		add tmp4
		add tmp4
		sub #1
		tay
		lda (addr_tmp2), y
		sta CHR_BUFF+$2, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$6, x

		; posY
		lda tmp1
		sta CHR_BUFF+$0, x
		cmp #$ff
		beq :+
		add #8
		sta tmp1
:
		lda tmp3
		sta CHR_BUFF+$4, x
		cmp #$ff
		beq :+
		add #8
		sta tmp3
:

		; posX
		lda tmp2
		sta CHR_BUFF+$3, x
		add #8
		sta CHR_BUFF+$7, x

		; buff indexを増やす（4byte * 2列）
		; add x, tmp6
		lda tmp5
		add #8
		sta tmp5
		tax

		lda tmp4
		shl #1
		sub #1
		sta tmp6
		tya
		sub tmp6
		tay
		; sub y, #3  = (2 * 2 - 1)
		; sub y, #5  = (2 * 3 - 1)
		pla
		sub #1
		bne @COLUMN


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
		lda tmp1
		sta tmp3

		lda spr_attr_arr, x
		and #BIT1
		bne @OVER_LEFT
		lda tmp2
		cmp #$f8
		bcc @SKIP
		; 右端を超えたとき
		lda #$ff
		sta tmp3
		jmp @END
@OVER_LEFT:
		lda tmp2
		cmp #$f8
		bcc @HIDE
		lda #$ff
		sta tmp1
@SKIP:
		; hide
		lda spr_attr_arr, x
		and #BIT7
		beq @HIDE
		lda spr_attr_arr, x
		and #BIT5|BIT2
		beq @END
		lda spr_posY_tmp_arr, x
		cmp #$f8
		bcs @END
@HIDE:
		lda #$ff
		sta tmp1
		sta tmp3
@END:

		lda spr_attr2_arr, x
		shr #2
		and #%0000_0111
		bne :+
		rts
:
		sta tmp4						; size_y

		sty tmp5						; buffIndex
		stx tmp6						; sprBuffId

		lda spr_id_arr, x			; キャラ固有のIDを取得
		tax
		ldy #4						; 配列ENEMY_enemyname[4]を取得
		ldarr SPRITE_ARR
		sta addr_tmp2+LO
		iny
		ldarr SPRITE_ARR
		sta addr_tmp2+HI
		ldx tmp6
		lda tmp4
		shl #2
		sta tmp6						; クリボーなら8（chr4,attr4），フラワーは12ずつの値
		lda spr_anime_num, x
		tax
		beq @INDEX_CALC_LOOP_EXIT
		lda #0
@INDEX_CALC_LOOP:
		add tmp6
		dex
		bne @INDEX_CALC_LOOP
@INDEX_CALC_LOOP_EXIT:
		tay								; enemyname_ANIMATION_ARRのいずれかのchr配列の先頭アドレス

		ldx tmp5						; buffIndex（yレジスタに入っていた引数の値）
		lda tmp4
@COLUMN:
		pha

		; tile id
		lda (addr_tmp2), y
		sta CHR_BUFF+$5, x
		iny
		lda (addr_tmp2), y
		sta CHR_BUFF+$1, x
		; attr
		tya
		add tmp4
		add tmp4
		sub #1
		tay
		lda (addr_tmp2), y
		eor #%0100_0000
		sta CHR_BUFF+$6, x
		iny
		lda (addr_tmp2), y
		eor #%0100_0000
		sta CHR_BUFF+$2, x

		; posY
		lda tmp1
		sta CHR_BUFF+$0, x
		cmp #$ff
		beq :+
		add #8
		sta tmp1
:
		lda tmp3
		sta CHR_BUFF+$4, x
		cmp #$ff
		beq :+
		add #8
		sta tmp3
:

		; posX
		lda tmp2
		sta CHR_BUFF+$3, x
		add #8
		sta CHR_BUFF+$7, x

		; buff indexを増やす（4byte * 2列）
		; add x, tmp6
		lda tmp5
		add #8
		sta tmp5
		tax

		lda tmp4
		shl #1
		sub #1
		sta tmp6
		tya
		sub tmp6
		tay
		; sub y, #3  = (2 * 2 - 1)
		; sub y, #5  = (2 * 3 - 1)
		pla
		sub #1
		bne @COLUMN


		rts
		; ------------------------------



/*
		lda spr_attr_arr, x
		and #BIT7
		beq @HIDE
		lda spr_attr_arr, x
		and #BIT5|BIT2
		beq :+
		lda spr_posY_tmp_arr, x
		cmp #$f8
		bcs :+
@HIDE:
		; 非表示
		lda #$ff
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y
		rts
		; --------------------------
:

		lda spr_attr_arr, x
		and #BIT1					; 左端を超えたか
		bne @OVER_LEFT
		lda tmp2
		cmp #$f8
		bcc :+
		; 右端を超えたとき
		lda #$ff
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$8, y
		lda tmp1
		sta CHR_BUFF+$4, y
		add #8
		sta CHR_BUFF+$c, y
		jmp @STORE_POS_Y
:
		lda tmp1
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		add #8
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y
		jmp @STORE_POS_Y
@OVER_LEFT:
		lda tmp2
		cmp #$f8
		bcc :+
		lda #$ff
		sta CHR_BUFF+$4, y
		sta CHR_BUFF+$c, y
		lda tmp1
		sta CHR_BUFF+$0, y
		add #8
		sta CHR_BUFF+$8, y
		jmp @STORE_POS_Y
:
		lda #$ff
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y

@STORE_POS_Y:
		lda tmp2
		sta CHR_BUFF+$7, y
		sta CHR_BUFF+$f, y
		add #8
		sta CHR_BUFF+$3, y
		sta CHR_BUFF+$b, y

		sty tmp1
		stx tmp2
		lda spr_id_arr, x			; キャラ固有のIDを取得
		tax
		ldy #4
		ldarr SPRITE_ARR
		sta addr_tmp2+LO
		iny
		ldarr SPRITE_ARR
		sta addr_tmp2+HI
		ldx tmp2
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

*/
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

.proc _tfrSprToBuffFlipY
		lda spr_attr_arr, x
		and #BIT7
		bne :+
		; 非表示
		lda #$ff
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y
		rts
		; --------------------------
:

		lda spr_attr_arr, x
		and #BIT1					; 左端を超えたか
		bne @OVER_LEFT
		lda tmp2
		cmp #$f8
		bcc :+
		; 右端を超えたとき
		lda #$ff
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$8, y
		lda tmp1
		sta CHR_BUFF+$c, y
		add #8
		sta CHR_BUFF+$4, y
		jmp @STORE_POS_X
:
		lda tmp1
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y
		add #8
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		jmp @STORE_POS_X
@OVER_LEFT:
		lda tmp2
		cmp #$f8
		bcc :+
		lda #$ff
		sta CHR_BUFF+$4, y
		sta CHR_BUFF+$c, y
		lda tmp1
		sta CHR_BUFF+$8, y
		add #8
		sta CHR_BUFF+$0, y
		jmp @STORE_POS_X
:
		lda #$ff
		sta CHR_BUFF+$0, y
		sta CHR_BUFF+$4, y
		sta CHR_BUFF+$8, y
		sta CHR_BUFF+$c, y

@STORE_POS_X:
		lda tmp2
		sta CHR_BUFF+$3, y
		sta CHR_BUFF+$7, y
		add #8
		sta CHR_BUFF+$b, y
		sta CHR_BUFF+$f, y

		sty tmp1
		stx tmp2
		lda spr_id_arr, x			; キャラ固有のIDを取得
		tax
		ldy #4
		ldarr SPRITE_ARR
		sta addr_tmp2+LO
		iny
		ldarr SPRITE_ARR
		sta addr_tmp2+HI
		ldx tmp2
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
		eor #%1000_0000					; 左右反転
		sta CHR_BUFF+$2, x
		iny
		lda (addr_tmp2), y
		eor #%1000_0000
		sta CHR_BUFF+$6, x
		iny
		lda (addr_tmp2), y
		eor #%1000_0000
		sta CHR_BUFF+$a, x
		iny
		lda (addr_tmp2), y
		eor #%1000_0000
		sta CHR_BUFF+$e, x

		rts
		; ------------------------------
.endproc



;*------------------------------------------------------------------------------
; スプライトのキャラクタデータをバッファに積む
; バッファidから転送先のアドレスを計算し，向きに応じて適切な順番でバッファに積む
; @PARAMS		X: sprite buff id
; @PARAMS		Y: BUFF index
; @CLOBBERS		A X Y tmp1 tmp2
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _tfrToChrBuff
		lda spr_buff_start_addr, x
		add #4
		tay
		; tya
		; shl #4
		; tay
		; add y, #4									; 0スプライトの分空けるため(buff indexを0に設定しても0スプライトを上書きしない)

		lda spr_posY_arr, x
		sta tmp1							; posY
		; 死亡時（落下死・敵に接触した後のアニメーションで画面下に落ちたとき）に実行
		cmp #$f0
		bcc :+
		lda spr_attr_arr, x
		and #%0111_1111
		sta spr_attr_arr, x
:
		lda spr_posX_arr, x
		sta tmp2							; posX

		lda spr_attr_arr, x
		and #BIT0						; 向きフラグ
		beq :+
		jsr _tfrSprToBuffNormal
		jmp @EXIT
:
		jsr _tfrSprToBuffFlipX

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵の動きデータを読み込んで速度等を変更する
; クリボーのような敵ではなく，ハンマーブロスなど特定の動きを再現するための機能
; SPRITE_ARR > [キャラ名前] > [キャラ名前]_ANIMATION_ARRの中にアニメーション（ネーミングが良くなかったかも，動きデータのこと）がある
; 現在は動きが一定（クリボー）しか対応していない
; この関数を使えば，パックンフラワー，ハンマーブロス，下から上がってくる炎，などが作れる）
; @PARAMS		x: sprite buff id
; @CLOBBERS		A Y tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _loadMoveArr
		lda spr_attr_arr, x
		and #BIT7
		bne :+
		rts
		; ------------------------------
:
		; スプライトが利用可能なとき（まだ何のキャラクタもこの領域を使用しておらず，新規にキャラクタを出せる状態）
		lda spr_move_counter, x
		cmp #$ff
		beq @INIT
		jmp @SKIP1

@INIT:
		; 初期化
		txa
		pha
		lda #0
		sta spr_move_counter, x
		lda spr_id_arr, x				; キャラ固有のIDを取得
		tax
		ldy #2
		ldarr SPRITE_ARR
		shr #4
		sta spr_anime_num, x			; アニメーション開始番号
		; [enemyname]_MOVE_ARRを読みこむ
		ldy #7
		ldarr SPRITE_ARR
		sta addr_tmp1+LO
		iny
		ldarr SPRITE_ARR
		sta addr_tmp1+HI
		pla
		tax

		lda #0
		sta spr_anime_timer, x			; 初期化
		ldy #0
		lda (addr_tmp1), y
		sta spr_move_timer_max_arr, x
		iny
		lda (addr_tmp1), y				; X速度
		sta spr_float_velocity_x_arr, x
		iny
		lda (addr_tmp1), y
		sta spr_float_velocity_y_arr, x
		iny								; 加速度は一旦実装を飛ばす
		iny
		iny
		lda (addr_tmp1), y
		cmp #$ff
		beq :+							; エンドコードが来たら処理は終了
		; エンドコードがセットされていなかったとき
		sta spr_anime_num, x			; アニメーションを上書き
:
		iny
		tya
		sta spr_move_num, x
		rts
		; ------------------------------
@SKIP1:
		; すでにセット済みのとき
		sta tmp1							; どこに使用？
		lda spr_move_timer_max_arr, x		; XXX_MOVE_ARRのタイマーの値
		bne @COMPLEX_MOVE					; move_num_maxではなく、timer_max==0かで判定している（どっちでもいいはず）
		; 動きが一定（クリボーなど）はアニメーションだけする
		cpx #0
		beq :+
		jsr _animate
:
		rts
		; ------------------------------
@COMPLEX_MOVE:
		cmp spr_move_counter, x
		beq :+
		inc spr_move_counter, x
		jmp @NO_UPDATE_MOVE
:
		; x = sprite buff id
		stx tmp1
		; init
		lda #0
		sta spr_move_counter, x

		lda spr_id_arr, x				; キャラ固有のIDを取得
		tax
		ldy #2
		ldarr SPRITE_ARR
		shr #4
		ldx tmp1
		sta spr_anime_num, x			; アニメーション開始番号
		; [enemyname]_MOVE_ARRを読みこむ
		lda spr_id_arr, x
		tax
		ldy #7
		ldarr SPRITE_ARR
		sta addr_tmp1+LO
		iny
		ldarr SPRITE_ARR
		sta addr_tmp1+HI
		; end using tmp1

		ldx tmp1
		lda spr_move_num, x
		tay
		lda (addr_tmp1), y
		sta spr_move_timer_max_arr, x
		iny
		lda (addr_tmp1), y				; X速度
		sta spr_float_velocity_x_arr, x
		iny
		lda (addr_tmp1), y
		sta spr_float_velocity_y_arr, x
		iny								; 加速度は一旦実装を飛ばす
		iny
		iny
		lda (addr_tmp1), y
		cmp #$ff
		beq :+							; エンドコードが来たら処理は終了
		; エンドコードがセットされていなかったとき
		sta spr_anime_num, x			; アニメーションを上書き
:
		; move_numのリセット処理
		iny
		lda (addr_tmp1), y
		bne @NO_MOVE_NUM_RESET
		ldy #0							; MOVE_ARRのENDCODEを読み取ったら
@NO_MOVE_NUM_RESET:
		tya
		sta spr_move_num, x
		lda #0
		sta spr_move_timer_arr, x
		sta spr_decimal_part_velocity_y_arr, x

@NO_UPDATE_MOVE:
		lda spr_attr_arr, x
		and #BIT3						; 倒されたフラグ
		beq :+
		lda spr_move_timer_arr, x
		cmp spr_move_timer_max_arr, x
		bne :+
		lda spr_attr_arr, x
		and #%0111_1111					; スプライト存在フラグ
		sta spr_attr_arr, x
:
		jsr _animate
		rts
.endproc


;*------------------------------------------------------------------------------
; スプライトのアニメーション
; アニメーションカウンターをインクリメント，一定期間ごとにアニメーション変更
; スプライトのバッファidをループで回して，引数にしてこの関数を呼ぶこと
; @PARAMS		x: spr buff index
; @CLOBBERS		A X Y tmp1 tmp2
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _animate
		lda spr_attr_arr, x
		and #%0000_1000
		beq :+
		rts
		; ------------------------------
:
		stx tmp1
		lda spr_id_arr, x				; キャラ固有のIDを取得
		tax
		stx tmp2
		ldy #3
		ldarr SPRITE_ARR
		ldx tmp1
		cmp spr_anime_timer, x
		bcc @next_anime
		rts
		; ------------------------------
@next_anime:
		ldx tmp2
		ldy #2
		ldarr SPRITE_ARR				; animation_maxを求める
		and #BYT_GET_LO
		sub #1
		ldx tmp1
		cmp spr_anime_num, x
		beq :+
		; anime_max != anime_num
		inc spr_anime_num, x
		jmp @EXIT
:
		; アニメーション番号を最初のアニメーションに設定
		ldx tmp2
		ldy #2
		ldarr SPRITE_ARR
		shr #4
		ldx tmp1
		sta spr_anime_num, x
@EXIT:
		lda #0
		sta spr_anime_timer, x

		rts
.endproc


;*------------------------------------------------------------------------------
; 敵キャラとの衝突を検出
; これは関数内でスプライトのバッファidをループするので引数は不要
; @PARAMS		None
; @CLOBBERS		A tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _checkEnemyCollision
		ldx #1
@CHECK_LOOP:
		lda spr_attr_arr, x
		bpl @JMP_NEXT_ENEMY				; 敵がアクティブでない場合はスキップ
		and #BIT6|BIT5				; 当たり判定無効フラグ，右端を超えたフラグが立っているか
		beq :+
@JMP_NEXT_ENEMY:
		jmp @NEXT_ENEMY
:


		; 左端フラグが立っていて，かつ完全に画面外にいるか判定
		lda spr_attr_arr, x
		and #BIT1
		beq :+
		stx tmp1
		lda spr_id_arr, x
		tax
		ldy #$0a
		ldarr SPRITE_ARR
		sta tmp2						; width
		ldx tmp1						; restore
		lda spr_posX_tmp_arr, x
		add tmp2
		sub #8							; 敵のX座標が8未満→描画されなくなるので，存在しない判定にする
		cmp #$20
		bcs @NEXT_ENEMY					; 敵の右端が0x20～0xffなら画面外と判断する
:

		; 水平方向の衝突を確認
		lda spr_posX_arr, x
		sec
		sbc spr_posX_arr+$0
		bpl :+
		cnn
:
		cmp #PLAYER_WIDTH
		bcs @NEXT_ENEMY						; 水平方向の衝突がない場合はスキップ

		; 上の左端／右端フラグの処理だけでは，［マリオが左端，敵が右端を超えたとき］踏みつけられてしまう
		lda spr_posX_arr, x
		bpl :+
		lda spr_posX_arr+$0
		bmi :+
		; 敵が右端にまたがる ＆ マリオが左端 || 敵が左端にまたがる & マリオが左端
		lda spr_attr_arr, x
		and #BIT1
		beq @NEXT_ENEMY					; 敵が左端のときには，当たり判定チェックを通常通り行うが，敵が右端のときは当たり判定スキップ
:

		; プレイヤーが敵の上にいて、かつ下降中かを確認
		lda spr_posY_arr, x
		sec
		sbc spr_posY_arr+$0
		beq @COLLISION
		cmp #$f1
		bcs @COLLISION
		cmp #$10
		bcs @NEXT_ENEMY						; プレイヤーが敵の上にいない場合はスキップ

		lda spr_velocity_y_arr+$0
		bmi @NEXT_ENEMY						; プレイヤーが下降中でない場合はスキップ
		beq @NEXT_ENEMY

@STOMP:			; 未使用のラベル
		lda spr_attr2_arr, x			; bit0: 踏めるかどうか
		and #BIT0
		beq @COLLISION
		; プレイヤーが下降中に敵と衝突している && 踏める敵である
		jsr _handleEnemyStomp
		jmp @NEXT_ENEMY

@COLLISION:
		lda #0
		sta engine_flag
		lda #2
		sta engine
		bne @EXIT

@NEXT_ENEMY:
		inx
		cpx #6
		beq @EXIT
		jmp @CHECK_LOOP

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵がプレイヤーに踏まれたときの処理
; @PARAMS		X: spr buff id
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _handleEnemyStomp
		stx tmp_rgstX
		; 敵のキャラクタ番号を変更して踏まれたことを示す
		lda spr_id_arr, x
		tax
		ldy #1
		ldarr SPRITE_ARR				; TODO: これは[name]_ANIMATION_ARRの情報から取ってくるようにする（この定数はクリボー専用）
		ldx tmp_rgstX
		sta spr_anime_num, x

		; 敵の当たり判定無効(BG, SPR)フラグ，倒されたフラグを立てる
		lda spr_attr_arr, x
		ora #%0101_1000
		sta spr_attr_arr, x

		lda #0
		sta spr_move_timer_arr, x
		lda #30
		sta spr_move_timer_max_arr, x

		lda #0
		sta spr_float_velocity_x_arr, x

		; プレイヤーをバウンドさせる
		ldx #$fd
		lda Joypad::joy1
		and #Joypad::BTN_A
		beq :+
		lda #$30
		sta spr_decimal_part_force_y+$0
		lda Player::VER_FALL_FORCE_DATA+$0
		sta spr_force_fall_y+$0
		lda Player::INITIAL_VER_FORCE_DATA+$0
		sta spr_decimal_part_velocity_y_arr+$0
		ldx #$fb
:
		stx spr_velocity_y_arr+$0
		lda #0
		sta spr_decimal_part_velocity_y_arr+$0

		lda	se_stepped_on
		ldx	se_stepped_on+1
		jsr	_nsd_play_se

		ldx tmp_rgstX
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 敵が非表示にならないようにするためのシャッフル関数
; （マリオ&敵合わせて5体以上出ると4体目以降のキャラクタが消えるので高速で表示するキャラクタを切り替えて5体以上表示）
; ここではスプライトのバッファデータにある表示／非表示フラグを切り替えることで実現
; @PARAMS		None
; @CLOBBERS		A tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _shuffle
		; Y座標のカウントプログラム
		ldx #0
		; tmp1-4 y座標
		stx tmp1
		stx tmp2
		stx tmp3
		stx tmp4
		; tmp5,6 カウンタ（tmp5の上位4bitがtmp1のy座標が何回出現したかのカウンタ）
		stx tmp5
		stx tmp6
@LOOP:
		lda spr_attr_arr, x
		and #BIT7
		beq @CONTINUE

		lda spr_posY_arr, x
		sub #1								; c0とbfを同じ高さとみなすようにしたいため-1する
		shr #4

		ldy tmp1
		bne :+
		; tmp1 == 0ならまだY座標がストアされていない，未使用の領域だと判定
		sta tmp1							; ゼロフラグ更新しない
		bne @CONTINUE						; -> 確実にジャンプ
:
		cmp tmp1
		bne :+
		lda tmp5
		add #$10							; 上位4bitのカウンタを+1
		sta tmp5
		bne @CONTINUE						; カウンタが6を超えることがない（0x70以下である）から，確実にジャンプする

:
		ldy tmp2
		bne :+
		sta tmp2
		bne @CONTINUE
:
		cmp tmp2
		bne :+
		inc tmp5
		bne @CONTINUE

:
		ldy tmp3
		bne :+
		sta tmp3
		bne @CONTINUE
:
		cmp tmp3
		bne :+
		lda tmp6
		add #$10
		sta tmp6
		bne @CONTINUE

:
		ldy tmp4
		bne :+
		sta tmp4
		bne @CONTINUE
:
		cmp tmp4
		bne @CONTINUE
		inc tmp6
		bne @CONTINUE

@CONTINUE:
		inx
		cpx #6
		bne @LOOP

		; 以下，シャッフルのプログラム
		ldy #0								; Y座標
		lda tmp5
		cmp #$50							; 5体
		bcc :+
		; 5体以上並んでいるところのy座標を取得
		ldy tmp1
:
		and #BYT_GET_LO
		cmp #5
		bcc :+
		ldy tmp2
:
		lda tmp6
		cmp #$50
		bcc :+
		ldy tmp3
:
		and #BYT_GET_LO
		cmp #5
		bcc :+
		ldy tmp4
:

		sty tmp1							; カウンタはもう不要なのでシャッフル対象のY座標で上書き
		lda frm_cnt
		and #%0000_0011
		add #1
		sta tmp2
		add #1
		sta tmp3

		ldx #1
@LOOP2:
		lda spr_posY_arr, x
		sub #1
		shr #4
		cmp tmp1
		bne @DISP
		cpx tmp2
		beq @HIDE
		cpx tmp3
		bne @DISP
@HIDE:
		lda spr_attr_arr, x
		ora #BIT2
		sta spr_attr_arr, x
		bne @LOOP2_END
@DISP:
		lda spr_attr_arr, x
		and #%1111_1011
		sta spr_attr_arr, x
@LOOP2_END:
		inx
		cpx #6
		bne @LOOP2

		rts
		; ------------------------------

.endproc


.endscope