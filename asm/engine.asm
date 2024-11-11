.scope Engine

.import MARIOSE3
.import MARIOBGM1
.import MARIOBGM2

se_pause:		.addr	MARIOSE3
bgm_death:		.addr	MARIOBGM1
bgm_dq:			.addr	MARIOBGM2

; id=0
.proc _gameEngine
	jsr Func::_waitDispStatus

		jsr _nsd_main

		; inc timer
		ldx #0
:
		inc spr_anime_timer, x
		inc spr_move_timer_arr, x
		inx
		cpx #6
		bne :-

	lda #0
	sta Player::player_hit_block_left_lo
	sta Player::player_hit_block_left_hi
	sta Player::player_hit_block_right_lo
	sta Player::player_hit_block_right_hi
	sta Player::player_hide_block_collision_flags

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

		; pass
@NO_PUSHED_BTN_B:
		; ↑ボタン
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_U
		beq @NO_PUSHED_BTN_U

; 		ldy map_num
; 		cpy #2
; 		bne :+
; 		ldy #$ff
; :
; 		iny
; 		sty map_num
; 		jsr DrawMap::_changeStage
@NO_PUSHED_BTN_U:
		; ↓ボタン
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_D
		beq @NO_PUSHED_BTN_D

		; lda bgm_dq
		; ldx bgm_dq+1
		; jsr _nsd_play_bgm
@NO_PUSHED_BTN_D:
	; STARTボタン
	lda Joypad::joy1_pushstart
	and #Joypad::BTN_T
	beq @NO_PUSHED_BTN_T

	lda #1
	sta engine
	lda	se_pause
	ldx	se_pause+1
	jsr	_nsd_play_se
@NO_PUSHED_BTN_T:

		jsr Player::_physicsX
		jsr Player::_jumpCheck
		jsr Player::_moveYProcess
		jsr Player::_checkCollision
		jsr Player::_animate

		jsr Enemy::_spawn
		jsr Enemy::_physicsXAllEnemy

		; chr move
	ldx #0
@CHR_MOVE_LOOP:
	stx Sprite::spr_buff_id
	lda spr_attr_arr, x
	and #BIT7
	sta Sprite::is_spr_available
	jsr Sprite::_moveSprite
	ldx Sprite::spr_buff_id
	beq :+
	jsr Enemy::_checkCollision
:
	ldx Sprite::spr_buff_id						; spr id
	ldy Sprite::spr_buff_id						; buff index (0は0爆弾用のスプライト）→_tfrToChrBuff側を変えて引数一つにまとめてもよい
	jsr Sprite::_tfrToChrBuff
	ldx Sprite::spr_buff_id
	jsr Sprite::_loadMoveArr
	ldx Sprite::spr_buff_id
	inx
	cpx #6
	bne @CHR_MOVE_LOOP

	jsr Sprite::_checkEnemyCollision
	jsr Sprite::_shuffle

	jsr Time::_manageTime

		; ----- End main -----
		lda #0
		sta is_processing_main
		jmp _main
		; ------------------------------
.endproc

; id=1
.proc _pauseEngine
		jsr Func::_waitDispStatus

	lda engine_flag
	bne :+
	lda #1
	sta engine_flag
	jsr _nsd_pause_bgm
:

	jsr _nsd_main_se

		; STARTボタン
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_T
		beq @NO_PUSHED_BTN_T

		lda #0
		sta engine
		sta engine_flag
		lda	se_pause
		ldx	se_pause+1
		jsr	_nsd_play_se
		jsr _nsd_resume_bgm
@NO_PUSHED_BTN_T:

		lda #0
		sta is_processing_main
		jmp _main
.endproc

; id=2
.proc _deathEngine
	jsr Func::_waitDispStatus

	lda engine_flag
	bne :+
	lda #1
	sta engine_flag
	; 3.5s
	lda #3
	sta engine_timer+$0
	lda #30
	sta engine_timer+$1
	; 当たり判定無効
	lda spr_attr_arr+$0
	ora #BIT4
	sta spr_attr_arr+$0
	; ジャンプ
	lda #$30
	sta spr_decimal_part_force_y+$0
	lda Player::VER_FALL_FORCE_DATA+$0
	sta spr_force_fall_y+$0
	lda Player::INITIAL_VER_FORCE_DATA+$0
	sta spr_decimal_part_velocity_y_arr+$0
	lda #$fb
	sta spr_velocity_y_arr+$0
	; 見た目
	lda #6
	sta spr_anime_num+$0
	; 音再生
	lda bgm_death
	ldx bgm_death+1
	jsr _nsd_play_bgm
	jsr _nsd_stop_se
:


	lda engine_timer+$0
	cmp #3
	; 1s後
	bcs :+
	jsr Player::_physicsY
	; jsr Player::_animate
:
	ldx #0
	jsr Sprite::_moveSprite
	ldx #0						; spr id
	ldy #0						; buff index (0は0爆弾用のスプライト）→_tfrToChrBuff側を変えて引数一つにまとめてもよい
	jsr Sprite::_tfrToChrBuff
	jsr _nsd_main_bgm
	; タイマーデクリメント
	ldx engine_timer+$1
	bne :++
	ldy engine_timer+$0
	bne :+
	; 終了処理
	lda #0
	sta engine
	sta engine_flag
	ldy map_num
	jsr DrawMap::_changeStage
:
	dey
	sty engine_timer+$0
	ldx #60
:
	dex
	stx engine_timer+$1

	lda #0
	sta is_processing_main
	jmp _main
.endproc


TITLE_DATA1:
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $b4, $b5, $00
	.byte $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $04, $05, $06, $07, $60, $61, $62, $63, $64, $65, $66, $67
	.byte $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $08, $09, $0a, $0b, $68, $69, $6a, $6b, $6c, $6d, $6e, $00
	.byte $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $0c, $0d, $0e, $0f, $70, $71, $72, $73, $74, $75, $76, $00
	.byte $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $fa, $fb, $fc, $10, $11, $12, $13, $77, $78, $79, $7a, $7b, $7c, $7d, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $b0, $b1, $00, $00, $00, $00, $00, $00, $b2, $b3, $00, $00

TITLE_DATA2:
	.byte $40, "2024 ASATO", $3c, "REIN", $3c, "NENE"

TITLE_DATA3:
	.byte "PUSH START BUTTON"

.proc _titleEngine
	lda engine_flag
	beq :+
	jmp @SKIP1
	; init
	; jsr Subfunc::_sleepOneFrame
:
		; Change bg color (black)
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		lda #$0f
		sta PPU_DATA

	lda #$3f
	sta PPU_ADDR
	lda #$01
	sta PPU_ADDR
	lda #$20
	sta PPU_DATA
	lda #$3f
	sta PPU_ADDR
	lda #$05
	sta PPU_ADDR
	lda #$27
	sta PPU_DATA
	lda #$16
	sta PPU_DATA
	lda #$17
	sta PPU_DATA

	lda #$23
	sta PPU_ADDR
	lda #$c0
	sta PPU_ADDR
	lda #%01010101
	ldy #$20
:
	sta PPU_DATA
	dey
	bne :-

	lda #6
	sta tmp3
	ldx #0
	lda #$20
	sta tmp1
	lda #$84
	sta tmp2
@LOOP1:
	lda tmp2
	add #$20
	sta tmp2
	lda tmp1
	adc #0
	sta tmp1
	lda tmp1
	sta PPU_ADDR
	lda tmp2
	sta PPU_ADDR
	ldy #$19
@LOOP2:
	lda TITLE_DATA1, x
	sta PPU_DATA
	inx
	dey
	bne @LOOP2
	dec tmp3
	bne @LOOP1

	ldy #0
	lda #$23
	sta PPU_ADDR
	lda #$26
	sta PPU_ADDR
:
	lda TITLE_DATA2, y
	sta PPU_DATA
	iny
	cpy #21
	bne :-

	ldy #0
	lda #$22
	sta PPU_ADDR
	lda #$c8
	sta PPU_ADDR
:
	lda TITLE_DATA3, y
	sta PPU_DATA
	iny
	cpy #17
	bne :-


	; Restore bg color
	lda #$3f
	sta PPU_ADDR
	lda #$00
	sta PPU_ADDR
	lda #$22
	sta PPU_DATA

	lda ppu_ctrl1_cpy				; NMI ON
	ora #%10000000
	sta ppu_ctrl1_cpy
	jsr Subfunc::_restorePPUSet

	jsr Subfunc::_setScroll

	jsr Subfunc::_sleepOneFrame

	lda #1
	sta engine_flag

	lda bgm_dq
	ldx bgm_dq+1
	jsr _nsd_play_bgm

	lda #%00011110
	sta ppu_ctrl2_cpy
	jsr Subfunc::_restorePPUSet		; Display ON
@SKIP1:

	jsr _nsd_main_bgm
	jsr Joypad::_getJoyData
	lda Joypad::joy1_pushstart
	and #Joypad::BTN_T
	bne :+
	jmp @EXIT
:

	lda #0
	sta PPU_CTRL1
	sta PPU_CTRL2

	; Clear VRAM
	lda #$20
	sta PPU_ADDR
	lda #$00
	sta PPU_ADDR

	ldy #8
	ldx #0
@CLR_VRAM:
	sta PPU_DATA
	inx
	bne @CLR_VRAM
	dey
	bne @CLR_VRAM

	; Change bg color (black)
	lda #$3f
	sta PPU_ADDR
	lda #$00
	sta PPU_ADDR
	lda #$0f
	sta PPU_DATA
	lda #$3f
	sta PPU_ADDR
	lda #$00
	sta PPU_ADDR

	; Zero sprite
	lda #$8*3-2-1
	sta CHR_BUFF+0
	lda #$ff
	sta CHR_BUFF+1
	lda #%0000_0010
	sta CHR_BUFF+2
	lda #$0f
	sta CHR_BUFF+3

	lda #'G'
	sta DrawMap::fill_ground_block

		jsr Subfunc::_dispStatus

	; sprite
	lda #$20
	sta spr_posX_arr+0
	sta spr_posX_tmp_arr+0
	lda #$c0
	sta spr_posY_tmp_arr+0

	lda #1
	sta spr_velocity_y_arr+$0
	sta spr_decimal_part_velocity_y_arr+$0

	lda	bgm0
		ldx	bgm0+1
		jsr	_nsd_play_bgm

		lda spr_attr_arr+$0
		ora #BIT7
		sta spr_attr_arr+$0

		lda ppu_ctrl1_cpy				; NMI ON
		ora #%10000000
		sta ppu_ctrl1_cpy
		jsr Subfunc::_restorePPUSet

		jsr Subfunc::_sleepOneFrame		; draw disp status

		ldy #2
		sty map_num
		jsr DrawMap::_changeStage

	lda #0
	sta engine
	sta engine_flag

@EXIT:
	lda #0
	sta is_processing_main
	jmp _main
.endproc

.endscope