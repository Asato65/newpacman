.code									; ----- code -----

.macro init
		sei								; Ban IRQ
		cld								; Ban BCD
		ldx #$ff
		txs
		inx
		stx PPU_CTRL1
		stx PPU_CTRL2
		stx SOUND_DP_1					; Ban IRQ of APU DMC (bit7)

		/*
		A & $2002 -> set Z(zero flag)
		$2002 bit7(vblank) -> N(negative), bit6(sprite 0 hit) -> V(overflow)
		Reset vblank & sprite 0 hit flag
		(The state of this flag after reset is undefined.)
		*/
		bit $2002

		jsr Subfunc::_waitVblank					; 1st time

		; It takes about 30,000 cycles for the PPU to stabilize.

		lda #$20
		sta PPU_ADDR
		txa								; X = A = 0
		sta PPU_ADDR
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

		; CLEAR $2000~27ff
		ldy #8
@CLR_VRAM:
		sta PPU_DATA
		inx
		bne @CLR_VRAM
		dey
		bne @CLR_VRAM

		lda #$ff
@CLR_CHR_MEM:
		sta $0300, x
		inx
		bne @CLR_CHR_MEM

		; Store initial value
		lda #%10010000					; |NMI-ON|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCREEN$2000|
		sta ppu_ctrl1_cpy
		lda #%00011110					; |R|G|B|DISP-SPR|DISP-BG|SHOW-L8-SPR|SHOW-L8-BG|MODE=COLOR|
		sta ppu_ctrl2_cpy

		jsr Subfunc::_waitVblank		; 2nd time

		tfrPlt 0

		lda #0
		sta OAM_ADDR
		lda #$03
		sta OAM_DMA

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

		; Screen On
		jsr Subfunc::_restorePPUSet
		jsr Subfunc::_setScroll

		jsr Subfunc::_waitVblank
		jsr Subfunc::_dispStatus
.endmacro
