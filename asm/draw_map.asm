;*------------------------------------------------------------------------------
; Update a row
; @PARAM	None
; @BREAK	A X Y tmp_rgstA
; @RETURN	None
;*------------------------------------------------------------------------------

_drawMap:
	ldy index
@LOOP1:
	; get pos
	lda (map_addr), y
	cmp #OBJMAP_END
	beq @END_MAP_DATA
	cmp #OBJMAP_NEXT
	beq @MAP_INC
	sta tmp_rgstA
	shr #4
	cmp row_counter
	bne @LOOP_EXIT
	sta obj_posx

	lda tmp_rgstA
	and #%0000_1111
	sta obj_posy

	; get chr
	iny
	lda (map_addr), y
	sta obj_id

@LOOP_EXIT:
	sty index
	rts	; ------------------------------

@MAP_INC:
	lda #0
	sta row_counter
	inc map_num
	iny
	jmp @LOOP1

@END_MAP_DATA:
	; 次のマップ読み込み
	ldy map_num
	iny
	jsr _setMapAddr
	cmp #$ff							; A = Addr Hi
	bne @EXIT							; マップのアドレスだけ読みこんで終了

	lda #1
	sta isend_draw_stage				; ステージの描画全部終わったか

@EXIT:
	lda #0
	sta index

	rts	;-------------------------------



/*
map_num
row_counter
index
x = index_tmp
*/

/*
	ldx map_data_index
@INDEX_LOOP:
	; map_dataを配列に
	lda MAP_DATA, x
	cmp #MAP_DATA_END_CODE
	beq @EXIT
	sta tmp_rgstA
	and #%0000_1111
	sta chr_pos_y
	lda tmp_rgstA						; end using
	shr #4
	cmp row_counter
	beq @EXIT
	sta chr_pos_x

	inx
	lda MAP_DATA, x

@EXIT:
	rts	; ------------------------------


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

rts
*/


;*------------------------------------------------------------------------------
; Set addr of stage data
; @PARAM	Y: stage number
; @BREAK	A Y
; @RETURN	None
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
