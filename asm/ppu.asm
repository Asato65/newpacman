;*------------------------------------------------------------------------------
; Set scroll position
; Use during NMI or executing raster scroll.
; @PARAM void
; @BREAK A
; @RETURN void
;*------------------------------------------------------------------------------

_setScroll:
	lda scroll_x
	sta PPU_SCROLL
	lda scroll_y
	sta PPU_SCROLL
	rts	; ------------------------------
