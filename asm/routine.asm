.scope Func

;*------------------------------------------------------------------------------
; Scroll
; @PARAMS		A: amount of scroll
; @CLOBBERS		A, tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _scroll
		add scroll_x
		php
		sta tmp1
		lda scroll_x
		and #BYT_HI
		sta scroll_x					; tmp
		lda tmp1
		and #BYT_HI
		cmp scroll_x
		beq :+
		inc $80
		jsr DrawMap::_updateOneLine
:
		lda tmp1
		sta scroll_x
		plp
		bcc :+
		lda main_disp
		eor #%0000_0001
		sta main_disp
:
		rts
		; ------------------------------
.endproc


.endscope
