JUMP_CHECK:
	lda Joypad::joy1
	and #Joypad::BTN_A
	bne @SKIP1
	; 初めてジャンプボタンが押されてないとき終了
	rts  ; -------------------------
@SKIP1:
		lda mario_isfly
		bne @SKIP2
		; 地面にいるときジャンプ開始準備
		jsr PREPARING_JUMP
@SKIP2:
		rts  ; -------------------------