.scope Time

;*------------------------------------------------------------------------------
; ゲームタイマーのデクリメント
; @PARAMS		None
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _decTimer
	lda frm_cnt
	and #%00011111
	bne @EXIT
	ldx timer_dec_num_arr+$2
	bne :++
	ldx #10
	ldy timer_dec_num_arr+$1
	bne :+
	ldy #10
	lda timer_dec_num_arr+$0
	sub #1
	sta timer_dec_num_arr+$0
:
	dey
	sty timer_dec_num_arr+$1
:
	dex
	stx timer_dec_num_arr+$2
@EXIT:
	rts
	; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; タイマーの描画を更新（バッファに転送）
; TODO: これは汎用バッファを使う必要あるのか？？できるならば修正する
; @PARAMS		None
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _dispTimer
	lda timer_dec_num_arr+$0
	ora #$30
	sta ppu_timer_data+$0
	lda timer_dec_num_arr+$1
	ora #$30
	sta ppu_timer_data+$1
	lda timer_dec_num_arr+$2
	ora #$30
	sta ppu_timer_data+$2
	rts

/*
	ldx bg_buff_pointer
	lda #PPU_VERTICAL_MODE
	sta bg_buff+$0, x
	lda @ADDR+$1
	sta bg_buff+$1, x
	lda @ADDR+$0
	sta bg_buff+$2, x
	lda timer_dec_num_arr+$0
	add #$30
	sta bg_buff+$3, x
	lda timer_dec_num_arr+$1
	add #$30
	sta bg_buff+$4, x
	lda timer_dec_num_arr+$2
	add #$30
	sta bg_buff+$5, x
	txa
	add #6
	sta bg_buff_pointer
	rts
	; ------------------------------

@ADDR:
	.addr ADDR_BG 27, 2, 0

*/

.endproc


;*------------------------------------------------------------------------------
; タイマー系の動作（タイマーデクリメント，表示更新）を一括で行う
; TODO: タイマー切れの判定を行う（decTimer()で行ってもよい）
; @PARAMS		None
; @CLOBBERS		None
; @RETURNS		None
;*------------------------------------------------------------------------------
.proc _manageTime
	jsr _decTimer
	jsr _dispTimer
	rts
	; ------------------------------
.endproc

.endscope