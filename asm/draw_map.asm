.scope DrawMap

.ZeroPage
map_buff_num			: .byte 0
map_arr_addr			: .addr 0
map_addr				: .addr 0		; Map obj/position data (-> data addr: ROM)
isend_draw_stage		: .byte 0
row_counter				: .byte 0		; Every time this prg executed -> increment
index					: .byte 0		; index of map_addr
cnt_map_next			: .byte 0		; data (read from map_addr) = SP code(go next map) -> increment this counter
map_arr_num				: .byte 0
fill_upper				: .byte 0
fill_lower				: .byte 0
fill_ground_block		: .byte 0
fill_block				: .byte 0
fill_ground_end			: .byte 0


;*------------------------------------------------------------------------------
; Transfar obj data (8*8) to BG map buff($04XX/$05XX)
; @PARAM	mode(char): 'L' or 'R'
; @RETURN	None
; if mode == 'L': $2000, $2002, $2016, $240a...
; elif mode == 'R': $2001, $2003, $2017, $240b...
;*------------------------------------------------------------------------------

.macro trfToBgMapBuf mode
		lda (addr_tmp2), y
		.if mode = 'L'
			sta BG_MAP_BUFF+0, x
		.else
			sta BG_MAP_BUFF+($0d*2), x
		.endif
.endmacro


;*------------------------------------------------------------------------------
; Update one row
; @PARAM	None
; @BREAK	A X Y tmp1 addr_tmp1 addr_tmp2
; @RETURN	None
/* main label
	@START:
	@GET_POS_AND_OBJ_LOOP:
	@END_OF_MAP:						-> goto nextlabel (@LOAD_NEXT_MAP)
	@LOAD_NEXT_MAP:						-> goto @GET_POS_AND_OBJ_LOOP
	@END_OF_STAGE:						-> goto nextlabel (@PREPARE_BG_MAP_BUF)
	@PREPARE_BG_MAP_BUF:
	@STORE_BG_MAP_BUF_LOOP:
*/
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _updateOneLine
		lda DrawMap::isend_draw_stage
		beq @START
		rts
		; ------------------------------

@START:
	ldx #0
		ldy DrawMap::row_counter
		iny
		cpy #$10
		bne @NO_OVF_ROW_CNT
	ldy #0
		inc DrawMap::map_buff_num
@NO_OVF_ROW_CNT:
		sty DrawMap::row_counter


		ldy DrawMap::index
@GET_POS_AND_OBJ_LOOP:
		; ----------- get pos ----------
/*
	lda DrawMap::map_buff_num
	and #BIT0
	ora #4
	sta addr_tmp2+1
	lda (DrawMap::map_addr), y
	sta tmp1						; Start using tmp1 (jmp other label -> it can be break)

	and #BIT_LO
	sta addr_tmp2+0
	txa
	pha
	tya
	pha
	ldx #0
	ldy #0
@LOOP:
	lda FILL_BLOCKS, y
	sta (addr_tmp2, x)
	lda addr_tmp2+0
	add #$10
	sta addr_tmp2+0
	iny
	cpy #$d
	bne @LOOP

	pla
	tay
	pla
	tax
*/
		lda (DrawMap::map_addr), y

		; Check Special Code
		cmp #OBJMAP_NEXT
		beq @LOAD_NEXT_MAP

		cmp #OBJMAP_END
		beq @END_OF_MAP

		; Check if it can be updated
		sta tmp1						; Start using tmp1
		and #BYT_LO
		cmp DrawMap::row_counter
		bne @GET_POS_AND_OBJ_LOOP_EXIT

		lda DrawMap::map_buff_num
		cmp DrawMap::cnt_map_next		; Count OBJMAP_NEXT (is not reset until the stage changes)
		bne @GET_POS_AND_OBJ_LOOP_EXIT

		; Set addr of bg map buff
		and #%0000_0001					; A = map_buff_num
		ora #4
		sta addr_tmp1+HI

		lda tmp1						; End using tmp1
		sta addr_tmp1+LO
		pha

	and #%0000_1111
	sta addr_tmp1+0
	txa
	pha
	tya
	pha
	ldx #0
	ldy #0
@LOOP:
	lda FILL_BLOCKS, y
	sta (addr_tmp1, x)
	lda addr_tmp1+LO
	add #$10
	sta addr_tmp1+LO
	iny
	cpy #$d
	bne @LOOP

	pla
	tay
	pla
	tax

	pla
	sta addr_tmp1+LO

		; ----------- get chr ----------
		iny
		lda (DrawMap::map_addr), y
		ldx #0
		sta (addr_tmp1, x)

		iny
		bne @GET_POS_AND_OBJ_LOOP			; Jmp
		; ------------------------------

@GET_POS_AND_OBJ_LOOP_EXIT:
		sty DrawMap::index
		jmp @PREPARE_BG_MAP_BUF
		; ------------------------------


		; End of map data (Not end of stage)
@END_OF_MAP:
		inc DrawMap::map_arr_num
		ldy DrawMap::map_arr_num
		jsr _setMapAddr
		lda DrawMap::map_addr+HI
		cmp #ENDCODE					; A = Addr Hi
		beq @END_OF_STAGE
		ldy #(0-1)
		sty DrawMap::index

@LOAD_NEXT_MAP:
		inc DrawMap::cnt_map_next
		iny
		jmp @GET_POS_AND_OBJ_LOOP
		; ------------------------------

@END_OF_STAGE:
		ldy #0
		sty DrawMap::index				; X = 0
		iny
		sty DrawMap::isend_draw_stage

@PREPARE_BG_MAP_BUF:
		/*
		ここのaddr_tmp1が変更されないせいで
		bg_map_addrのloが変更されず
		床の描画もされない？
		*/
		; X = 0
		lda addr_tmp1+LO
		and #BIT_LO
		sta addr_tmp1+LO					; PosY = 0

		lda addr_tmp1+HI					; 4 or 5
		and #BIT0
		shl #2							; 0 or 4
		ora #$20						; $20 or $24
		sta bg_map_addr+HI

		stx tmp1						; Init and start using tmp1 (-> Can break X)

		lda addr_tmp1+LO
		add #$40
		shl #1
		rol tmp1
		sta bg_map_addr+LO
		lda bg_map_addr+HI
		ora tmp1						; End using tmp1
		sta bg_map_addr+HI

		; Store plt addr(ppu)
		lda addr_tmp1+LO					; posX
		shr #1
		add #$c0
		sta plt_addr+LO
		lda addr_tmp1+HI
		and #1
		shl #2
		add #$23
		sta plt_addr+HI

		ldy #0
		sty bg_map_buff_index


@STORE_BG_MAP_BUF_LOOP:					; for (y = 0; y < $0d; y++)
		tya
		shl #4
		tay
		lda (addr_tmp1), y

		; prepare plt data -----------------
		sty tmp2						; (save counter) += $10
		ldy tmp1						; (save counter) += 1
		pha
		and #BIT5|BIT4
		tax								; X: plt num(bit4-5) : tmp (Start using)
		lda DrawMap::row_counter
		and #BIT0
		sta tmp3
		tya
		and #BIT0
		shl #1
		ora tmp3
		sta tmp3

		; y /= 2 (Use @PLT0) -> MEMO: 短縮可能
		tya
		shr #1
		tay

		txa								; End using X (plt num)
		ldx tmp3
		/*
			PLT_DATA = BROCK3|BROCK2|BROCK1|BROCK0
			-------------------------------
			| BROCK0(>>4) | BROCK1(>>2) |
			| BROCK2(0)   | BROCK3(<<2) |
			-------------------------------
		*/
		beq @BROCK0
		dex
		beq @BROCK1
		dex
		beq @BROCK2
		dex
		beq @BROCK3
@BROCK0:
		shr #4
		jmp @STORE_TO_PLT_BUFF
		; ------------------------------
@BROCK1:
		shr #2
		jmp @ADD_LEFT_BROCK_PLT
		; ------------------------------
@BROCK3:
		shl #2
@BROCK2:
@ADD_LEFT_BROCK_PLT:
		ora BG_PLT_BUFF, y
@STORE_TO_PLT_BUFF:
		sta BG_PLT_BUFF, y

		pla
		ldy tmp2

		and #BIT5|BIT4|BIT_LO
		shl #1

		tax
		lda BROCK_ID_ARR+LO, x
		sta addr_tmp2+LO
		lda BROCK_ID_ARR+HI, x
		sta addr_tmp2+HI

		ldx bg_map_buff_index

		ldy #0
		trfToBgMapBuf 'L'
		iny
		trfToBgMapBuf 'R'

		inx
		iny
		trfToBgMapBuf 'L'
		iny
		trfToBgMapBuf 'R'

		inx
		stx bg_map_buff_index

		ldy tmp1
		iny
		sty tmp1
		cpy #$0d
		bcc @STORE_BG_MAP_BUF_LOOP

		rts
		;-------------------------------
.endproc

;*------------------------------------------------------------------------------
; Set addr of stages
; @PARAM	Y: stage number
; @BREAK	A Y
; @RETURN	None (A = addr Hi)
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setStageAddr
		tya
		shl
		tay

		lda STAGE_ARR, y
		sta DrawMap::map_arr_addr

		lda STAGE_ARR+1, y
		sta DrawMap::map_arr_addr+1

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Set addr of maps
; @PARAM	Y: map index
; @BREAK	A Y
; @RETURN	None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setMapAddr
		tya
		shl
		tay
		pha								; push y

		lda (DrawMap::map_arr_addr), y
		sta DrawMap::map_addr

		iny
		lda (DrawMap::map_arr_addr), y
		sta DrawMap::map_addr+1

	; ffコードをこの関数の返値にして，この関数の外でマップ終了を判定しているが
	; その前に@NO_EXIT以下の処理を行ってしまい，バグるため，ここで抜ける
	; 直接@END_OF_STAGEにジャンプしてもOKなはずだが（マップ終了判定でジャンプするラベル）
	; procを使っているため今は無理
	cmp #ENDCODE
	bne @NO_EXIT
	pla
	tay
	lda #ENDCODE
	rts
@NO_EXIT:

	; ------------------------------

	ldy #0

	lda (DrawMap::map_addr), y
	and #%0000_1111
	sta DrawMap::fill_ground_end

	lda (DrawMap::map_addr), y
	shr #4
	tay
	cpy DrawMap::fill_ground_end
	beq @NOLOOP

	lda DrawMap::fill_ground_block

@LOOP:
	sta FILL_BLOCKS, y
	iny
	cpy DrawMap::fill_ground_end
	bne @LOOP
@NOLOOP:

	ldy #4
	sty DrawMap::index
	; ----------------------------------

		pla
		tay

		rts
		; ------------------------------
.endproc


.endscope
