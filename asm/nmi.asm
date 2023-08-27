;*------------------------------------------------------------------------------
; BG_BUFFを読み取り，指定アドレスに書き込んでカウンタをインクリメント
; Read PPU update data & store to PPU
; @PARAM	ADDR: Forwarding address
; @BREAK	A X
; @RETURN	None
;*------------------------------------------------------------------------------

.macro tfrDataToPPU ADDR
	lda BG_BUFF, x
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
		pha								; If main processing has not finished, tmp_rgstA may be in use
		inc nmi_cnt
		lda is_processing_main
		beq @NMI_MAIN
		pla
		rti	; --------------------------

@NMI_MAIN:
		cmp bg_buff_pointer				; A = 0
		beq @STORE_CHR
		tax
@SET_MODE:
		lda BG_BUFF, x
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
		inx								; Not do inx when go to @EXIT
		lda BG_BUFF, x
		sta PPU_ADDR
		inx
		lda BG_BUFF, x
		sta PPU_ADDR
		inx
@STORE_DATA:
		lda BG_BUFF, x
		tay
		and #%11111110
		cmp #%11111110
		beq @SET_MODE					; no inx
		tya
		sta PPU_DATA
		inx
		cpx bg_buff_pointer
		bne @STORE_DATA

		; @SET_MODE + @SET_ADDR = 51 cycle
		; @STORE_DATA (return @STORE_DATA) = 24 cycle
		; @STORE_DATA (return @SET_MODE) = 13 cycle

		; str1 = "A  B"
		; 	=> 51 + space_len * 24 cycle
		; 	=> mode(1) + addr(2) + data(2 + space_len) = (5 + space_len) bytes
		; 	|  len  || 1  | 2  |  3  |  4  |
		; 	| cycle || 75 | 99 | 123 | 147 |
		;	| bytes || 6  | 7  |  8  |  9  |
		; str2 = 'A', str3 = 'B'
		; 	=> (51 + 13) * 2 = 64 * 2 = 128 cycle
		; 	=> (mode(1) + addr(2) + data(1)) * 2 = 8 bytes
		; space length:
		; 	1: 75 cycle,	6 bytes (str1)
		; 	2: 99 cycle,	7 bytes
		; 	3: 123 cycle,	8 bytes
		; 	4~: 128 cycle,	8 bytes (str2)
@STORE_CHR:
		lda #0
		sta OAM_ADDR
		lda #$03
		sta OAM_DMA

@EXIT:
		lda #1
		sta is_processing_main
		shr								; A = 0
		sta bg_buff_pointer
		inc frm_cnt
		jsr _setScroll
		pla
		rti	; --------------------------
.endproc

