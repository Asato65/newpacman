.scope Func

;*------------------------------------------------------------------------------
; Scroll
; @PARAMS		A: amount of scroll
; @CLOBBERS		A, tmp1
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

		bcc :+
		lda main_disp
		eor #%0000_0001
		sta main_disp
:

		lda tmp1
		cmp tmp2
		beq :+
		jsr DrawMap::_updateOneLine
:

		rts
		; ------------------------------
.endproc


.endscope
