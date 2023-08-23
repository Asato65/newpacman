;*------------------------------------------------------------------------------
; PPU_BUFFを読み取り，指定アドレスに書き込んでカウンタをインクリメント
; Read PPU update data & store to PPU
; @PARAM	ADDR: Forwarding address
; @BREAK	A X
; @RETURN	None
;*------------------------------------------------------------------------------

.macro tfrDataToPPU ADDR
	lda PPU_BUFF, x
	sta ADDR
	inx
.endmacro

; memo
; ----- PPU buff data structure -----
; r: Direction
; 	Bit0 is a flag, others are 1.
; 	-> 0b1111_111[0/1]
; 	-> 0xFE（Horizontal）/0xFF（Vertical）
; a: Addr
; d: Data
; r [a a] [d d d ... d] r [a a] [d d ... d]


;*------------------------------------------------------------------------------
; NMI (Interrupt)
; @BREAK X Y (When end main process.)
; To shorten the clock, put the buffer data on the stack
; 	(Shorten clock by buff data length)
; 	pla -> 3 clc
; 	lda ZP/ABSORUTE, x -> 4 clc
;*------------------------------------------------------------------------------

.proc NMI
		; Automatically executed with NMI
		; lda >PC
		; pha
		; lda <PC
		; pha
		; php
		pha
		inc nmi_cnt
		lda is_processing_main
		beq @NMI_MAIN
		pla
		rts	; --------------------------

@NMI_MAIN:
		tsx
		add x, #4						; rgst A, P, return addr(2)
		txs

		inc frm_cnt

		tax								; A = 0
		cpx ppu_update_data_pointer		; Length of data stored in PPU_DATA
		beq @EXIT
		pla								; data[0]
		tay
@SET_MODE:
		tya
		bpl @SET_ADDR					; 0x00~0x7f => @SET_ADDR
		cmp #$fe
		bmi @SET_ADDR					; 0xfe~0xff = plus, 0x7e~0xfd => @SET_ADDR
		and #%00000001					; Get flag
		shl #2							; Move flag to Bit2
		sta tmp1						; Start using tmp1
		lda ppu_ctrl1_cpy
		and #%11111011					; Mask direction flag
		ora tmp1						; End using tmp1
		sta ppu_ctrl1_cpy
		sta PPU_CTRL1					; Not use restorePPUSet()
@SET_ADDR:
		pla
		sta PPU_ADDR
		pla
		sta PPU_ADDR
		inx
		inx
		inx
@STORE_DATA:
		pla
		tay
		and #%11111110
		cmp #%11111110
		beq @SET_MODE					; no inx
		tya
		sta PPU_DATA
		inx								; store data: +1
		cpx ppu_update_data_pointer
		bne @STORE_DATA

@EXIT:
		lda #1
		sta is_processing_main
		jsr _setScroll
		jmp MAIN
.endproc
