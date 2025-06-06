.scope Joypad

BTN_A									= %10000000
BTN_B									= %01000000
BTN_S									= %00100000
BTN_T									= %00010000
BTN_U									= %00001000
BTN_D									= %00000100
BTN_L									= %00000010
BTN_R									= %00000001

.ZeroPage
joy1					: .byte 0
joy2					: .byte 0
joy1_prev				: .byte 0
joy2_prev				: .byte 0
joy1_pushstart			: .byte 0
joy2_pushstart			: .byte 0
joy1_pushstart_btn_a	: .byte 0		; pushstartのaボタンの情報が入っていく（左シフトで格納されていく）


;*------------------------------------------------------------------------------
; Get Joypad data (including prev and newly pushed btn)
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _getJoyData
		; set prev
		lda Joypad::joy1
		sta Joypad::joy1_prev
		lda Joypad::joy2
		sta Joypad::joy2_prev

		jsr Joypad::_readJoy

		lda Joypad::joy1
		and #Joypad::BTN_U|Joypad::BTN_L				; Compare Up and Left...
		lsr
		and Joypad::joy1						; to Down and Right
		beq @GET_PUSHSTART_BTN
		; Use previous frame's directions
		lda Joypad::joy1
		eor Joypad::joy1_prev
		and #%11110000
		eor Joypad::joy1_prev
		sta Joypad::joy1

@GET_PUSHSTART_BTN:
		; set pushstart
		lda Joypad::joy1_prev
		eor #%11111111
		and Joypad::joy1
		sta Joypad::joy1_pushstart
		lda Joypad::joy2_prev
		eor #%11111111
		and Joypad::joy2
		sta Joypad::joy2_pushstart

		lda Joypad::joy1_pushstart
		shl #1							; bit7，Aボタンの情報をキャリーにセット
		rol Joypad::joy1_pushstart_btn_a	; 格納

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Read controller
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _readJoy
		; Init controller & Set a ring counter
		lda #1
		sta JOYPAD1
		sta Joypad::joy2						; ring counter
		lsr								; A = 0
		sta JOYPAD1

@READ_JOY_LOOP:
		lda JOYPAD1
		and #%00000011
		cmp #$01						; A - 1 = A + 0xff; if A > 0 then Carry=1
		rol Joypad::joy1						; Carry -> Bit0; Bit7 -> Carry
		lda JOYPAD2
		and #%00000011
		cmp #$01
		rol Joypad::joy2
		bcc @READ_JOY_LOOP				; CarryON -> end
		rts
		; ------------------------------
.endproc


.endscope