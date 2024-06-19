;*------------------------------------------------------------------------------
; メインルーチン
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _main
		; -------- Vblank終了待ち --------
		lda is_processing_main
		beq _main

		; ----------- 0爆弾前 -----------

		lda ppu_ctrl1_cpy				; ステータス表示の為$2000の画面を表示
		and #%1111_1100
		sta PPU_CTRL1					; 後でrestoreできるようにRAMにはコピーを取らない -> ??? 分かったら書き換えておいて

		lda #0							; ステータス表示の為リセット
		sta PPU_SCROLL
		sta PPU_SCROLL

@WAIT_FINISH_VBLANK:
		bit PPU_STATUS
		bvs @WAIT_FINISH_VBLANK

		jsr Joypad::_getJoyData

@WAIT_ZERO_BOMB:
		bit PPU_STATUS
		bvc @WAIT_ZERO_BOMB

		ldy #20							; 10ぐらいまで乱れる，余裕もって20に
:
		dey
		bne :-

		jsr Subfunc::_setScroll

		; ----------- 0爆弾後 -----------

	; 前回の最終速度をコピー
	ldx #0
:
	lda spr_float_velocity_x_arr, x
	sta spr_last_float_velocity_x_arr, x
	inx
	cpx #6
	bne :-

	; chr move
	ldx #PLAYER_SPR_ID					; spr id
	jsr Sprite::_moveSprite
	ldx #PLAYER_SPR_ID					; spr id
	ldy #PLAYER_CHR_BUFF_INDEX			; buff index (0は0爆弾用のスプライト)
	jsr Sprite::_tfrToChrBuff

	jsr Func::_scroll

		; Aボタン
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_A
		beq @NO_PUSHED_BTN_A

		; jsr DrawMap::_updateOneLine
@NO_PUSHED_BTN_A:
		; Bボタン
		lda Joypad::joy1
		and #Joypad::BTN_B
		beq @NO_PUSHED_BTN_B

		; ldy #1
		; jsr DrawMap::_changeStage
@NO_PUSHED_BTN_B:
		; ↑ボタン
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_U
		beq @NO_PUSHED_BTN_U

		inc Sprite::move_dx
@NO_PUSHED_BTN_U:
		; ↓ボタン
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_D
		beq @NO_PUSHED_BTN_D

		dec Sprite::move_dx
@NO_PUSHED_BTN_D:

		jsr Sprite::_playerPhysics


		; ----- End main -----
		lda #0
		sta is_processing_main
		jmp _main
		; ------------------------------
.endproc
