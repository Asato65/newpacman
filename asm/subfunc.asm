.scope Subfunc

;*------------------------------------------------------------------------------
; PPU設定をリストア
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _restorePPUSet
		lda ppu_ctrl1_cpy
		sta PPU_CTRL1
		lda ppu_ctrl2_cpy
		sta PPU_CTRL2
		rts
		; ------------------------------
.endproc



;*------------------------------------------------------------------------------
; スクロール位置の変更（表示画面も変更する）
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setScroll
		; lda is_scroll_locked
		; bne @EXIT

		lda scroll_x
		sta scroll_x_old
		add scroll_amount
		sta scroll_x
		sta PPU_SCROLL
		lda #0
		sta PPU_SCROLL

		lda scroll_x_old
		bpl :+
		lda scroll_x
		bmi :+
		lda main_disp
		eor #%0000_0001
		sta main_disp
		inc disp_cnt
:

		lda ppu_ctrl1_cpy
		and #%1111_1110
		ora main_disp
		sta ppu_ctrl1_cpy
		sta PPU_CTRL1

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Vblank開始まで待つ
; @PARAMS		None
; @CLOBBERS		None
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _waitVblank
		bit $2002
		bpl _waitVblank
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; ステータステキストを表示
; @PARAMS		None
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _dispStatus
		ldx bg_buff_pointer
		ldy #(@TEXT_END - @TEXT)
@STORE_PPU_DATA_LOOP:
		lda @TEXT, x
		beq @END_STORE
		sta bg_buff, x
		inx
		dey
		bne @STORE_PPU_DATA_LOOP
@END_STORE:
		stx bg_buff_pointer
		rts
		; ------------------------------

.rodata									; ----- data -----
@TEXT:
		.byte PPU_VERTICAL_MODE
		ADDR_BG_BE 2, 2, 0
		.byte "SCORE XXXXXX  C:YY  TIME ZZZ"
@TEXT_END:

.endproc


;*------------------------------------------------------------------------------
; 1フレーム待機（画面の乱れを防いだりするのに使用しているはず）
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None (A = 1)
;*------------------------------------------------------------------------------

.proc _sleepOneFrame
		lda #0
		sta is_processing_main
:
		lda is_processing_main
		beq :-

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 基本パレットデータをRAM上のバッファに転送する
; @PARAMS		X: パレット番号
; @CLOBBERS		A Y
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _trfPltDataToBuff
	ldy #0
:
	ldarr PALETTES
	sta plt_datas, y
	iny
	cpy #$3*8
	bne :-
	rts
	; ------------------------------
.endproc


.endscope
