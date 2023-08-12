;*------------------------------------------------------------------------------
; Restore PPU setting
; @PARAM void
; @BREAK A
; @RETURN void
;*------------------------------------------------------------------------------

restorePPUSet:
		lda ppu_ctrl1_cpy
		sta PPU_CTRL1
		lda ppu_ctrl2_cpy
		sta PPU_CTRL2
		rts	; --------------------------


;*------------------------------------------------------------------------------
; Get Joypad data (including prev and newly pushed btn)
; @PARAM void
; @BREAK A
; @RETURN void
;*------------------------------------------------------------------------------

getJoyData:
		lda joy1
		sta joy1_prev
		lda joy2
		sta joy2_prev

		jsr readJoy

		lda joy1
		and #BTN_U|BTN_L				; Compare Up and Left...
		lsr
		and joy1						; to Down and Right
		beq @GET_PUSHSTART_BTN
		; Use previous frame's directions
		lda joy1
		eor joy1_prev
		and #%11110000
		eor joy1_prev
		sta joy1

@GET_PUSHSTART_BTN:
		lda joy1_prev
		eor #%11111111
		and joy1
		sta joy1_pushstart
		lda joy2_prev
		eor #%11111111
		and joy2
		sta joy2_pushstart


;*------------------------------------------------------------------------------
; Read controller
; @PARAM void
; @BREAK A
; @RETURN void
;*------------------------------------------------------------------------------

readJoy:
		; Init controller & Set a ring counter
		lda #1
		sta JOYPAD1
		sta joy2						; ring counter
		lsr								; A = 0
		sta JOYPAD2

@READ_JOY_LOOP:
		lda JOYPAD1
		and #%00000011
		cmp #$01						; A - 1 = A + 0xff; if A > 0 then Carry=1
		rol joy1						; Carry -> bit 0; bit 7 -> Carry
		lda JOYPAD2
		and #%00000011
		cmp #$01
		rol joy2
		bcc @READ_JOY_LOOP				; CarryON -> end
		rts	; --------------------------
