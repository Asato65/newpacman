;*------------------------------------------------------------------------------
; PPU設定をリストアする
; @PARAM void
; @BREAK A
; @RETURN void
;*------------------------------------------------------------------------------

restorePPUSet:
		lda ppu_ctrl_cpy
		sta PPU_CTRL
		lda ppu_mask_cpy
		sta PPU_MASK
		rts	; --------------------------


;*------------------------------------------------------------------------------
; Read controller
; @PARAM void
; @BREAK A, X
; @RETURN void
;*------------------------------------------------------------------------------

readController:
		lda con1
		sta con1_prev
		lda con2
		sta con2_prev

		jsr readJoy

		lda con1
		and #BTN_U|BTN_L					; Compare Up and Left...
		lsr
		and con1						; to Down and Right
		beq @GET_PUSHSTART_BTN
		; Use previous frame's directions
		lda con1
		eor con1_prev
		and #%11110000
		eor con1_prev
		sta con1

@GET_PUSHSTART_BTN:
		lda con1_prev
		eor #%11111111
		and con1
		sta con1_pushstart
		lda con2_prev
		eor #%11111111
		and con2
		sta con2_pushstart


readJoy:
		; Init controller & Set a ring counter
		lda #1
		sta JOYPAD1
		sta con_p2						; ring counter
		lsr								; A = 0
		sta JOYPAD2

@READ_JOY_LOOP:
		lda JOYPAD1
		and #%00000011
		cmp #$01						; A - 1 = A + 0xff; if A > 0 then Carry=1
		rol con1						; Carry -> bit 0; bit 7 -> Carry
		lda JOYPAD2
		and #%00000011
		cmp #$01
		rol con2
		bcc @READ_JOY_LOOP				; CarryON -> end
		rts	; --------------------------