;*------------------------------------------------------------------------------
; MAIN routine
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _main
		; --- Wait Finishing Vblank ----
		lda is_processing_main
		beq _main

		lda ppu_ctrl1_cpy
		and #%1111_1110
		sta PPU_CTRL1					; 後でrestoreできるようにRAMにはコピーを取らない

		lda #0
		sta PPU_SCROLL
		sta PPU_SCROLL

@WAIT_FINISH_VBLANK:
		bit PPU_STATUS
		bvs @WAIT_FINISH_VBLANK

		; ------ Before Zero Bomb ------

		jsr Joypad::_getJoyData

		; --------- Zero Bomb ----------

@WAIT_ZERO_BOMB:
		bit PPU_STATUS
		bvc @WAIT_ZERO_BOMB

		ldy #20							; 10ぐらいまで乱れる，余裕もって20に
:
		dey
		bne :-

		jsr Subfunc::_setScroll

		; ------ After Zero Bomb -------

	; chr move
	ldx #0								; spr id
	jsr Sprite::_moveSprite
	ldx #0								; spr id
	ldy #1
	jsr Sprite::_tfrToChrBuff

	jsr Func::_scroll

		; A
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_A
		beq @NO_PUSHED_BTN_A

		jsr DrawMap::_updateOneLine
@NO_PUSHED_BTN_A:
		; B
		lda Joypad::joy1
		and #Joypad::BTN_B
		beq @NO_PUSHED_BTN_B

		ldy #1
		jsr DrawMap::_changeStage
@NO_PUSHED_BTN_B:
		; U
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_U
		beq @NO_PUSHED_BTN_U

		inc Sprite::move_dx
@NO_PUSHED_BTN_U:
		; D
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_D
		beq @NO_PUSHED_BTN_D

		dec Sprite::move_dx
@NO_PUSHED_BTN_D:
		; L
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_L
		beq @NO_PUSHED_BTN_L

		lda is_scroll_locked
		eor #1
		sta is_scroll_locked
@NO_PUSHED_BTN_L:


		; ----- End main -----
		lda #0
		sta is_processing_main
		jmp _main
		; ------------------------------
.endproc
