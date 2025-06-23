;*------------------------------------------------------------------------------
; メインルーチン
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _main
		; -------- Vblank終了待ち --------
		lda is_processing_main
		beq _main

		; TODO: エンジンのルーチンのアドレスを配列に入れておき，ジャンプするようにすると速そう

		lda engine
		bne :+
		jmp Engine::_gameEngine
:
		cmp #1
		bne :+
		jmp Engine::_pauseEngine
:
		cmp #2
		bne :+
		jmp Engine::_deathEngine
:
		cmp #3
		bne :+
		jmp Engine::_titleEngine
:
		cmp #4
		bne :++

		ldy map_num
		cpy #2
		bne :+
		ldy #$ff
:
		iny
		sty map_num
		jsr DrawMap::_changeStage
		lda #0
		sta engine
		sta is_processing_main
		jmp _main
:
		jmp Engine::_gameEngine

.endproc
