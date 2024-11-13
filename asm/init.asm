.code									; ----- code -----

.import MARIOBGM0

bgm0:
		.addr	MARIOBGM0

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
		sta $0300, x
		sta $0400, x
		sta $0500, x
		sta $0600, x
		inx
		bne @CLR_MEM

		sta is_scroll_locked
		sta is_updated_map
		lda #3
		sta engine

		lda #$ff
@CLR_CHR_MEM:
		sta $0700, x
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

		ldx #1							; このあと背景色を変えるので今は背景色のセットはしない
		jsr Subfunc::_trfPltDataToBuff

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

		lda APU_CHANCTRL
		ora #%00000001
		sta APU_CHANCTRL
		lda #%10011111
		sta APU_PULSE1CTRL						; Duty50%(2)、ループ無し、音響固定、ボリューム最大(4)
		lda #%00000000
		sta APU_PULSE1RAMP						; 周波数変化なし（bit7）、他は設定せず

		jsr _nsd_init


.endmacro
