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

		lda scroll_x
		and #BYT_GET_HI
		sta tmp1

		lda scroll_x
		add scroll_amount
		sta scroll_x
		and #BYT_GET_HI						; Not clobber carry
		sta tmp2

		bcc @SKIP_CHANGE_DISP
		lda main_disp
		eor #%0000_0001
		sta main_disp
		inc disp_cnt

		lda ppu_ctrl1_cpy
		eor #%0000_0001
		sta ppu_ctrl1_cpy

@SKIP_CHANGE_DISP:
		lda tmp1
		cmp tmp2
		beq @SKIP_UPDATE_LINE
		jsr DrawMap::_updateOneLine
@SKIP_UPDATE_LINE:

		rts
		; ------------------------------
.endproc


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
