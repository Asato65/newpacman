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

		jsr _wait_vblank				; 1st time

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

		; ここで必要なメモリの初期化
		lda #%10010000					; |NMI-ON|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCREEN$2000|
		sta ppu_ctrl1_cpy
		lda #%00011110					; |R|G|B|DISP-SPR|DISP-BG|SHOW-L8-SPR|SHOW-L8-BG|MODE=COLOR|
		sta ppu_ctrl2_cpy

		jsr _wait_vblank				; 2nd time

		; Transfar pallete
		lda #>PLT_TABLE_ADDR
		sta PPU_ADDR
		lda #<PLT_TABLE_ADDR			; Addr lo = 00
		sta PPU_ADDR
		tax
@TFR_PAL:
		lda DEFAULT_PLT, x
		sta PPU_DATA
		inx
		cpx #$20
		bne @TFR_PAL

		lda #0
		sta OAM_ADDR
		lda #$03
		sta OAM_DMA

		lda #$ff
		sta row_counter
		ldy #0
		jsr _setStageAddr
		ldy #0
		jsr _setMapAddr

		; スクリーンON
		jsr _restorePPUSet
		jsr _setScroll

		jsr _wait_vblank
		jsr _disp_status
.endmacro