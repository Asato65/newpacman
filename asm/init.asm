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

		; Zero sprite
		lda #$10-2-1
		sta CHR_BUFF+0
		lda #$ff
		sta CHR_BUFF+1
		lda #%0000_0010
		sta CHR_BUFF+2
		lda #$0f
		sta CHR_BUFF+3

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
		; 画面OFF中は最後に指定したアドレスの色が背景になる（指定なし→3f01の色が使用される）
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

	lda #'G'
	sta DrawMap::fill_ground_block

	lda #0
	sta is_scroll_locked

		jsr Subfunc::_dispStatus

	; sprite
	lda #$20
	sta spr_posX_arr+0
	lda #$c0
	sta spr_posY_arr+0
	ldx #PLAYER_SPR_ID					; spr id
	ldy #PLAYER_CHR_BUFF_INDEX			; buff index (0は0爆弾用のスプライト)
	jsr Sprite::_tfrToChrBuff

		lda #0
		sta is_updated_map

		lda ppu_ctrl1_cpy				; NMI ON
		ora #%10000000
		sta ppu_ctrl1_cpy
		jsr Subfunc::_restorePPUSet

		jsr Subfunc::_sleepOneFrame		; draw disp status

		ldy #0
		jsr DrawMap::_changeStage

.endmacro
