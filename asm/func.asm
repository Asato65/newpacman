.scope Func

;*------------------------------------------------------------------------------
; Scroll
; @PARAMS		A: amount of scroll
; @CLOBBERS		A, tmp1, tmp2
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _scroll
		lda scroll_x
		and #BYT_HI
		sta tmp1

		lda scroll_x
		add scroll_amount
		sta scroll_x
		and #BYT_HI						; Not clobber carry
		sta tmp2

		bcc @SKIP_CHANGE_DISP
		lda main_disp
		eor #%0000_0001
		sta main_disp

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


.endscope
