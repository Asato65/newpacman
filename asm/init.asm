.macro init
	sei									; IRQ禁止
	cld									; BCD禁止
	; NesDevではAPUのフレームIRQを無効にしているが，特定のマッパーでのみ有効
	ldx #$ff
	txs
	inx
	stx PPU_CTRL1						; NMI無効化
	stx PPU_CTRL2						; 描画停止
	stx $4010							; APU DMCのIRQ（bit7）無効化

	/*
	A & $2002の結果でZ（ゼロフラグ）設定
	$2002のbit7 -> N（ネガティブフラグ）, bit6 -> V（オーバーフロー）に入る
	$2002のbit7にはVblank，bit6は0爆弾の状態が入っている
	リセット後のこのフラグは，状態が不定なので，一回bit命令でリセットが出来るらしい
	*/
	bit $2002

	jsr _wait_vblank					; 1st time

	; PPUが安定するまで約30,000サイクルの時間がある -> この間にRAMリセット

	txa									; X = A = 0
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

	; ここで必要なメモリの初期化
	lda #%10010000						; |NMI-ON|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCREEN$2000|
	sta ppu_ctrl1_cpy
	lda #%00011110						; |R|G|B|DISP-SPR|DISP-BG|SHOW-L8-SPR|SHOW-L8-BG|MODE=COLOR|
	sta ppu_ctrl2_cpy

	jsr _wait_vblank					; 2nd time

	; パレットテーブル転送
	lda #PLT_TABLE_ADDR				; HIGH
	sta PPU_ADDR
	lda #0				; LOW
	sta PPU_ADDR
	tax
@TFR_PAL:								; TFR = transfar
	lda DEFAULT_PLT, x
	sta PPU_DATA
	inx
	cpx #$20
	bne @TFR_PAL

	lda #0
	sta OAM_ADDR
	lda #$03
	sta OAM_DMA

	; スクリーンON
	jsr _restorePPUSet
	jsr _setScroll

	jsr _wait_vblank
	

.endmacro