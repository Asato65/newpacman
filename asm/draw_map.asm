;*------------------------------------------------------------------------------
; Update a row
; @PARAM	None
; @BREAK	A X Y tmp_rgstA
; @RETURN	None
;*------------------------------------------------------------------------------

_draw_map:
/*
map_num
row_counter
index
*/

	ldx map_data_index
@INDEX_LOOP:
	lda MAP_DATA, x
	cmp #MAP_DATA_END_CODE
	bne @NO_END
	rts	; ------------------------------
	sta tmp_rgstA
	and #%1111_0000
	shr #4
	cmp row_counter
	sta pos_x
	lda tmp_rgstA						; end using
	and #%0000_1111
	sta pos_y


	; END...
	stx map_data_index

	; inc counter
	ldx row_counter
	inx
	cpx #$20
	bne @NO_INC_MAP_COUNTER
	ldx #0
	stx row_counter
	inc map_num

