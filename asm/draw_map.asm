;*------------------------------------------------------------------------------
; Update one row
; @PARAM	None
; @BREAK	A X Y
; @RETURN	None
;*------------------------------------------------------------------------------

_drawMap:
	lda isend_draw_stage
	bne @EXIT

	tax									; X = 0
	ldy row_counter
	iny
	cpy #$10
	bne @NO_OVF_ROW_CNT

	tay									; Y = 0
	inc map_buff_num

@NO_OVF_ROW_CNT:
	sty row_counter

	ldy index
@GET_POS_AND_OBJ:
	; get pos
	lda (map_addr), y

	cmp #OBJMAP_NEXT
	beq @LOAD_NEXT_MAP

	cmp #OBJMAP_END
	beq @END_MAP_DATA

	sta addr1+0
	and #%0000_1111
	cmp row_counter
	bne @LOOP_EXIT

	lda map_buff_num
	cmp cnt_map_next					; Count OBJMAP_NEXT (is not reset until the stage changes)
	bne @LOOP_EXIT

	and #%0000_0001
	add #4
	sta addr1+1

	; get chr
	iny
	lda (map_addr), y

	sta (addr1, x)						; End using addr1
	iny
	bne @GET_POS_AND_OBJ							; Jmp

@LOOP_EXIT:
	sty index

	rts	; ------------------------------


@LOAD_NEXT_MAP:
	inc cnt_map_next
	iny
	bne @LOOP1							; Jmp


@END_MAP_DATA:
	; Load the next map
	ldy map_arr_num
	iny
	sty map_arr_num
	jsr _setMapAddr						; Use Y as arg
	cmp #$ff							; A = Addr Hi
	bne @NO_DRAW

	inx
	stx isend_draw_stage				; X = 1

@NO_DRAW:
	stx index							; X = 0

	rts	;-------------------------------


;*------------------------------------------------------------------------------
; Set addr of stages
; @PARAM	Y: stage number
; @BREAK	A Y
; @RETURN	None (A = addr Hi)
;*------------------------------------------------------------------------------

_setStageAddr:
	tya
	shl
	tay

	lda STAGE_ARR, y
	sta map_arr_addr

	lda STAGE_ARR+1, y
	sta map_arr_addr+1

	rts	; ------------------------------


;*------------------------------------------------------------------------------
; Set addr of maps
; @PARAM	Y: map index
; @BREAK	A Y
; @RETURN	None (A = addr Hi)
;*------------------------------------------------------------------------------

_setMapAddr:
	tya
	shl
	tay

	lda (map_arr_addr), y
	sta map_addr

	iny
	lda (map_arr_addr), y
	sta map_addr+1

	rts	; ------------------------------
