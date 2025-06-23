.scope Func

.ZeroPage
		plt_animation_counter:	.byte 0

.code

;*------------------------------------------------------------------------------
; スクロール
; @PARAMS		A: amount of scroll
; @CLOBBERS		A, tmp1, tmp2
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _scroll
		lda is_scroll_locked
		bne @SKIP_UPDATE_LINE

		lda scroll_x_old
		and #BYT_GET_HI
		sta tmp1

		lda scroll_x
		and #BYT_GET_HI
		cmp tmp1
		beq @SKIP_UPDATE_LINE
		jsr DrawMap::_updateOneLine
@SKIP_UPDATE_LINE:

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; ステータス領域の描画が終了するのを待機，この間にコントローラーの読み取りも
; @PARAMS		None
; @CLOBBERS		A Y
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _waitDispStatus
		; ----------- 0爆弾前 -----------
		lda ppu_ctrl1_cpy				; ステータス表示の為$2000の画面を表示
		and #%1111_1100
		sta PPU_CTRL1					; 後でrestoreできるようにRAMにはコピーを取らない -> ??? 分かったら書き換えておいて

		lda #0							; ステータス表示の為リセット
		sta PPU_SCROLL
		sta PPU_SCROLL

@WAIT_FINISH_VBLANK:
		bit PPU_STATUS
		bvs @WAIT_FINISH_VBLANK

		jsr Joypad::_getJoyData

@WAIT_ZERO_BOMB:
		bit PPU_STATUS
		bvc @WAIT_ZERO_BOMB

		ldy #20							; 10ぐらいまで乱れる，余裕もって20に
:
		dey
		bne :-

		; ----------- 0爆弾後 -----------

		jsr Subfunc::_setScroll
		rts
		; ------------------------------
.endproc


.proc _pltAnimation
		ldy plt_animation_counter
		iny
		cpy #10
		bcc @ANIME1
		cpy #20
		bcc @ANIME2
		cpy #48
		bcc @ANIME3
		ldy #0
@ANIME1:
		lda #$07
		bne @EXIT
@ANIME2:
		lda #$17
		bne @EXIT
@ANIME3:
		lda #$27
@EXIT:
		sta ppu_plt_animation_data
		sty plt_animation_counter
		rts


/*
		ldx bg_buff_pointer

		lda #PPU_VERTICAL_MODE
		sta bg_buff+$0, x
		lda #$3f
		sta bg_buff+$1, x
		lda #$05
		sta bg_buff+$2, x

		ldy plt_animation_counter
		iny
		cpy #10
		bcc @ANIME1
		cpy #20
		bcc @ANIME2
		cpy #48
		bcc @ANIME3
		ldy #0
@ANIME1:
		lda #$07
		bne @EXIT
@ANIME2:
		lda #$17
		bne @EXIT
@ANIME3:
		lda #$27

@EXIT:
		sta bg_buff+$3, x
		txa
		add #4
		sta bg_buff_pointer

		sty plt_animation_counter
		rts
*/
.endproc


.proc _dispCoin
		lda coin_counter+$1
		ora #$30
		sta ppu_coin_data+$0
		lda coin_counter+$0
		ora #$30
		sta ppu_coin_data+$1
		rts


/*
		ldx bg_buff_pointer

		lda #PPU_VERTICAL_MODE
		sta bg_buff+$0, x
		lda #$20
		sta bg_buff+$1, x
		lda #$52
		sta bg_buff+$2, x

		lda coin_counter+$1
		ora #$30
		sta bg_buff+$3, x
		lda coin_counter+$0
		ora #$30
		sta bg_buff+$4, x

		txa
		add #5
		sta bg_buff_pointer
		rts
*/
.endproc


.endscope
