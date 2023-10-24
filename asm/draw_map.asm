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
; @PARAM	X: Block ID
; @BREAK	A X Y
; @RETURN	None
;*------------------------------------------------------------------------------

.macro trfToBgMapBuf
		lda BROCK_ID_ARR+LO, x
		sta addr_tmp2+LO
		lda BROCK_ID_ARR+HI, x
		sta addr_tmp2+HI

		ldx bg_map_buff_index

		ldy #0
		lda (addr_tmp2), y
		sta BG_MAP_BUFF+0, x

		iny
		lda (addr_tmp2), y
		sta BG_MAP_BUFF+($0d*2), x

		inx

		iny
		lda (addr_tmp2), y
		sta BG_MAP_BUFF+0, x

		iny
		lda (addr_tmp2), y
		sta BG_MAP_BUFF+($0d*2), x

		inx

		stx bg_map_buff_index
.endmacro


.macro incRowCounter
		ldy DrawMap::row_counter
		iny
		cpy #$10
		bne @NO_OVF_ROW_CNT
		ldy #0
		inc DrawMap::map_buff_num
@NO_OVF_ROW_CNT:
		sty DrawMap::row_counter
.endmacro


.macro initIndex
		ldy #NEGATIVE 1
		sty DrawMap::index
.endmacro


.macro fillBlocks
	lda addr_tmp2+LO
	and #BYT_LO
	sta addr_tmp2+LO
	txa
	pha
	tya
	pha
	ldx #0
	ldy #0
@LOOP:
	lda FILL_BLOCKS, y
	sta (addr_tmp2, x)
	lda addr_tmp2+LO
	add #$10
	sta addr_tmp2+LO
	iny
	cpy #$d
	bne @LOOP

	pla
	tay
	pla
	tax
.endmacro


.macro loadNextMap
		inc DrawMap::map_arr_num
		ldy DrawMap::map_arr_num		; Y = ++map_arr_num
		jsr _setMapAddr
.endmacro


.macro setPpuBgAddr
		lda #0
		sta tmp1						; Start using tmp1

		lda addr_tmp1+LO
		add #$40
		shl #1
		rol tmp1
		sta ppu_bg_addr+LO

		lda addr_tmp1+HI				; 4 or 5
		and #BIT0
		shl #2							; 0 or 4
		ora #$20						; $20 or $24
		ora tmp1						; End using tmp1
		sta ppu_bg_addr+HI
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
		incRowCounter

		lda DrawMap::map_buff_num
		and #BIT0
		ora #4
		sta addr_tmp2+HI

		lda DrawMap::row_counter
		sta addr_tmp2

		fillBlocks

		ldy DrawMap::index
@GET_POS_AND_OBJ_LOOP:
		; ----------- get pos ----------
		lda (DrawMap::map_addr), y
		sta tmp1

		; Check Special Code
		cmp #OBJMAP_NEXT
		beq @LOAD_NEXT_MAP

		cmp #OBJMAP_END
		beq @END_OF_MAP

		; Check if it can be updated
		and #BYT_LO
		cmp DrawMap::row_counter
		bne @GET_POS_AND_OBJ_LOOP_EXIT

		lda DrawMap::map_buff_num
		cmp DrawMap::cnt_map_next		; Count OBJMAP_NEXT (is not reset until the stage changes)
		bne @GET_POS_AND_OBJ_LOOP_EXIT

		; -- Set addr of bg map buff ---
		and #BIT0
		ora #4
		sta addr_tmp1+HI


		lda tmp1						; End using tmp1
		sta addr_tmp1+LO

		; ----------- get chr ----------
		iny
		ldx #0
		lda (DrawMap::map_addr), y
		sta (addr_tmp1, x)

		iny
		bne @GET_POS_AND_OBJ_LOOP		; Jmp
		; ------------------------------

@GET_POS_AND_OBJ_LOOP_EXIT:
		sty DrawMap::index
		jmp @PREPARE_BG_MAP_BUF
		; ------------------------------


		; End of map data (Not end of stage)
@END_OF_MAP:
		loadNextMap

		lda DrawMap::map_addr+HI
		cmp #ENDCODE					; A = Addr Hi
		beq @END_OF_STAGE

		ldy #3							; この後inyされてy(index) = 4に

@LOAD_NEXT_MAP:
		inc DrawMap::cnt_map_next
		iny
		jmp @GET_POS_AND_OBJ_LOOP
		; ------------------------------

@END_OF_STAGE:
		ldy #0
		sty DrawMap::index
		iny								; Y = 1
		sty DrawMap::isend_draw_stage

@PREPARE_BG_MAP_BUF:
		lda row_counter
		sta addr_tmp1+LO				; PosY = 0

		setPpuBgAddr

		; Store plt addr(ppu)
		lda addr_tmp1+LO				; posX
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

		; prepare plt data -------------
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
		PLT_DATA = BLOCK3|BLOCK2|BLOCK1|BLOCK0
		-------------------------------
		| BLOCK0(>>4) | BLOCK1(>>2) |
		| BLOCK2(0)   | BLOCK3(<<2) |
		-------------------------------
		*/
		beq @BLOCK0
		dex
		beq @BLOCK1
		dex
		beq @BLOCK2
		dex
		beq @BLOCK3
@BLOCK0:
		shr #4
		jmp @STORE_TO_PLT_BUFF
		; ------------------------------
@BLOCK1:
		shr #2
		jmp @ADD_LEFT_BLOCK_PLT
		; ------------------------------
@BLOCK3:
		shl #2
@BLOCK2:
@ADD_LEFT_BLOCK_PLT:
		ora BG_PLT_BUFF, y
@STORE_TO_PLT_BUFF:
		sta BG_PLT_BUFF, y

		pla
		ldy tmp2

		and #BIT5|BIT4|BIT3|BIT2|BIT1|BIT0
		shl #1

		tax
		trfToBgMapBuf

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


	; ----------- fill ground ----------
	ldy #0

	lda (DrawMap::map_addr), y
	and #%0000_1111
	sta DrawMap::fill_ground_end

	lda (DrawMap::map_addr), y
	shr #4
	tax
	cpx DrawMap::fill_ground_end
	beq @FILL_GROUND_LOOP_END

	lda DrawMap::fill_ground_block

@FILL_GROUND_LOOP:
	sta FILL_BLOCKS, x
	inx
	cpx DrawMap::fill_ground_end
	bne @FILL_GROUND_LOOP
@FILL_GROUND_LOOP_END:

	; ------------ fill block ----------
	iny									; y = 1
	lda (DrawMap::map_addr), y
	sta DrawMap::fill_block

	iny									; y = 2
	lda (DrawMap::map_addr), y
	shl #3
	ldx #0
@FILL_BLOCK_LOOP_UPPER:
	shl #1
	bcc @NO_BLOCK1
	pha
	lda DrawMap::fill_block
	sta FILL_BLOCKS, x
	pla
@NO_BLOCK1:
	inx
	cpx #$5
	bcc @FILL_BLOCK_LOOP_UPPER

	iny									; y = 3
	lda (DrawMap::map_addr), y
@FILL_BLOCK_LOOP_LOWER:
	shl #1
	bcc @NO_BLOCK2
	pha
	lda DrawMap::fill_block
	sta FILL_BLOCKS, x
	pla
@NO_BLOCK2:
	inx
	cpx #$d
	bcc @FILL_BLOCK_LOOP_LOWER

	iny									; y = 4
	sty DrawMap::index
	; ----------------------------------

		pla
		tay

		rts
		; ------------------------------
.endproc


.endscope
