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
		bne @DEC_ONES_PLACE
		ldx #10
		ldy timer_dec_num_arr+$1
		bne @DEC_TENS_PLACE
		ldy #10
		lda timer_dec_num_arr+$0
		sub #1
		bpl @DEC_HUNDREDS_PLACE
		lda #0
		sta engine_flag
		lda #2							; death
		sta engine
		bne @EXIT
@DEC_HUNDREDS_PLACE:
		sta timer_dec_num_arr+$0
@DEC_TENS_PLACE:
		dey
		sty timer_dec_num_arr+$1
@DEC_ONES_PLACE:
		dex
		stx timer_dec_num_arr+$2
@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; タイマーの描画を更新（バッファに転送）
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
.endproc


;*------------------------------------------------------------------------------
; タイマー系の動作（タイマーデクリメント，表示更新）を一括で行う
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