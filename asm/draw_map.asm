.scope DrawMap

.ZeroPage
map_buff_num			: .byte 0
map_arr_addr			: .addr 0
map_addr				: .addr 0
isend_draw_stage		: .byte 0
row_counter				: .byte 0
index					: .byte 0
cnt_map_next			: .byte 0
map_arr_num				: .byte 0


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
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _updateOneLine
		lda DrawMap::isend_draw_stage
		beq @START
		rts
		; ------------------------------

@START:
		; A = 0
		tax								; X = 0
		ldy DrawMap::row_counter
		iny
		cpy #$10
		bne @NO_OVF_ROW_CNT

		tay								; Y = 0
		inc DrawMap::map_buff_num
@NO_OVF_ROW_CNT:
		sty DrawMap::row_counter

		ldy DrawMap::index
@GET_POS_AND_OBJ:
		; ----------- get pos ----------
		lda (DrawMap::map_addr), y

		; Check Special Code
		cmp #DrawMap::OBJMAP_NEXT
		beq @LOAD_NEXT_MAP

		cmp #DrawMap::OBJMAP_END
		beq @END_MAP_DATA

		; Check if it can be updated
		sta tmp1						; Start using tmp1
		and #%0000_1111
		cmp DrawMap::row_counter
		bne @LOOP_EXIT

		lda DrawMap::map_buff_num
		cmp DrawMap::cnt_map_next		; Count OBJMAP_NEXT (is not reset until the stage changes)
		bne @LOOP_EXIT

		; Set addr of bg map buff
		and #%0000_0001					; A = map_buff_num
		ora #4
		sta addr_tmp1+1

		lda tmp1						; End using tmp1
		sta addr_tmp1+0

		; ----------- get chr ----------
		iny
		lda (DrawMap::map_addr), y
		ldx #0
		sta (addr_tmp1, x)

		iny
		bne @GET_POS_AND_OBJ			; Jmp
		; ------------------------------

@LOOP_EXIT:
		sty DrawMap::index
		jmp @EXIT
		; ------------------------------

@LOAD_NEXT_MAP:
		inc DrawMap::cnt_map_next
		iny
		jmp @GET_POS_AND_OBJ
		; ------------------------------

@END_MAP_DATA:
		; ------ Load the next map -----
		inc DrawMap::map_arr_num
		ldy DrawMap::map_arr_num
		jsr _setMapAddr					; Use Y as arg
		cmp #ENDCODE					; A = Addr Hi
		beq @END_STAGE_DRAW
		ldy #$ff
		sty DrawMap::index
		bne @LOAD_NEXT_MAP				; Jmp
		; ------------------------------

@END_STAGE_DRAW:
		ldy #0
		sty DrawMap::index				; X = 0
		iny
		sty DrawMap::isend_draw_stage


@EXIT:
		; X = 0
		lda addr_tmp1+0
		and #%0000_1111
		sta addr_tmp1+0					; PosY = 0

		lda addr_tmp1+1					; 4 or 5
		and #1
		shl #2							; 0 or 4
		ora #$20						; $20 or $24
		sta bg_map_addr+1

		stx tmp1						; Init, start using tmp1

		lda addr_tmp1+0
		add #$40
		shl #1
		rol tmp1
		sta bg_map_addr+0
		lda bg_map_addr+1
		ora tmp1						; End using tmp1
		sta bg_map_addr+1

		ldy #0
		sty bg_map_buff_index
		clc
@LOOP:
		lda (addr_tmp1), y
		and #%0011_1111
		shl #1

		sty tmp1						; Start using tmp1

		tax
		lda BROCK_ID_ARR+0, x
		sta addr_tmp2+0
		lda BROCK_ID_ARR+1, x
		sta addr_tmp2+1

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

		ldy tmp1						; End using tmp1

		tya
		adc #$10
		tay
		cmp #$d0
		bcc @LOOP

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
; @RETURN	None (A = addr Hi)
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setMapAddr
		tya
		shl
		tay

		lda (DrawMap::map_arr_addr), y
		sta DrawMap::map_addr

		iny
		lda (DrawMap::map_arr_addr), y
		sta DrawMap::map_addr+1

		rts
		; ------------------------------
.endproc


.endscope
