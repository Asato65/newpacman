.macro init
	sei									; IRQ禁止
	cld									; BCD禁止
	; NesDevではAPUのフレームIRQを無効にしているが，特定のマッパーでのみ有効
	ldx #$ff
	txs
	inx
	stx $2000							; NMI無効化
	stx $2001							; 描画停止
	stx $4010							; APU DMCのIRQ（bit7）無効化

	/*
		A & $2002の結果でZ（ゼロフラグ）設定
		$2002のbit7 -> N（ネガティブフラグ）, bit6 -> V（オーバーフロー）に入る
		$2002のbit7にはVblank，bit6は0爆弾の状態が入っている
		リセット後のこのフラグは，状態が不定なので，一回bit命令でリセットが出来るらしい
	*/
	bit $2002

	; Vblank待機1回目
@VBLANK_WAIT1:
	bit $2002
	bpl @VBLANK_WAIT1

	; PPUが安定するまで約30,000サイクルの時間がある -> この間にRAMリセット

	txa									; X = 0
@CLR_MEM:
	sta $00, x
	sta $0100, x
	sta $0200, x
	sta $0300, x
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	inx
	bne @CLR_MEM

	; Vblank待機2回目
@VBLANK_WAIT2:
	bit $2002
	bpl @VBLANK_WAIT2

.endmacro