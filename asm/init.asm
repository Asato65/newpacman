.code									; ----- code -----

.macro init
		sei								; Ban IRQ
		cld								; Ban BCD
		ldx #$40
		stx JOYPAD2
		ldx #$ff
		txs
		inx								; X = 0
		stx PPU_CTRL1
		stx PPU_CTRL2
		stx SOUND_DP_1					; Ban IRQ of APU DMC (bit7)
		stx SOUND_CHANNEL

		/*
		A & $2002 -> set Z(zero flag)
		$2002 bit7(vblank) -> N(negative), bit6(sprite 0 hit) -> V(overflow)
		Reset vblank & sprite 0 hit flag
		(The state of this flag after reset is undefined.)
		*/
		bit $2002
		jsr Subfunc::_waitVblank		; 1st time

		txa								; A = 0
@CLR_MEM:
		sta $00, x
		sta $0100, x
		sta $0200, x
		sta $0400, x
		sta $0500, x
		sta $0600, x
		sta $0700, x
		inx
		bne @CLR_MEM

		lda #$ff
@CLR_CHR_MEM:
		sta $0300, x
		inx
		bne @CLR_CHR_MEM

		jsr Subfunc::_waitVblank		; 2nd time

		; ------- PPU stabilizes -------

		lda #%00010000					; SPR = $0000, BG = $1000
		sta ppu_ctrl1_cpy
		jsr Subfunc::_restorePPUSet

		; Clear VRAM
		lda #$20
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		ldy #8
		tax
@CLR_VRAM:
		sta PPU_DATA
		inx
		bne @CLR_VRAM
		dey
		bne @CLR_VRAM


		jsr Subfunc::_waitVblank


		tfrPlt

	; Change bg color (black)
	lda #$3f
	sta PPU_ADDR
	lda #$00
	sta PPU_ADDR
	lda #$0f
	sta PPU_DATA
	lda #$3f
	sta PPU_ADDR
	lda #$00
	sta PPU_ADDR

	; Map setting
	lda #$ff
	sta DrawMap::row_counter

	and #0
	sta DrawMap::index

	lda #'G'
	sta DrawMap::fill_ground_block

	; test(load map 1 of world 1-1)
	ldy #0
	jsr DrawMap::_setStageAddr
	jsr DrawMap::_setMapAddr


		jsr Subfunc::_dispStatus

		lda ppu_ctrl1_cpy
		ora #%10000000
		sta ppu_ctrl1_cpy
		jsr Subfunc::_restorePPUSet		; NMI ON

		lda #0
		sta is_processing_main


		jsr Subfunc::_sleepOneFrame		; draw disp status & DMA
		jsr Subfunc::_sleepOneFrame		; ここで1Fかせぐと画面の乱れなし


	; Restore bg color
	lda #$3f
	sta PPU_ADDR
	lda #$00
	sta PPU_ADDR
	lda #$22
	sta PPU_DATA

		jsr Subfunc::_setScroll

		lda #%00011110
		sta ppu_ctrl2_cpy
		jsr Subfunc::_restorePPUSet		; Display ON

.endmacro
