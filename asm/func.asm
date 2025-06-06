.scope Func

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


.endscope
