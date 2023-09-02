;*------------------------------------------------------------------------------
; Update a row
; @PARAM	None
; @BREAK	A X Y tmp_rgstA
; @RETURN	None
;*------------------------------------------------------------------------------

_draw_map:
	ldy index
@LOOP1:
	; get pos
	lda (map_addr), y
	pha
	cmp #$ff
	beq @END_MAP_DATA
	and #%0000_1111
	sta posy
	pla
	shr #4
	cmp row_counter
	bne @EXIT
	sta posx

	; get chr
	iny
	lda (map_addr), y

@LOOP_EXIT:


@END_MAP_DATA:
	; 次のマップ
	ldy map_num
	iny
	jsr setMapAddr

	cmp #$ff							; A = Addr Hi
	bne @EXIT
	lda #1
	sta isend_draw_stage				; ステージのブロック
@EXIT:

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


/*
TST:
	lda #0
	sta stage
	sta map_num
	sta index

	ldy stage
	jsr setStageAddr

	ldy map_num
	lda (addr1), y
	sta addr2
	iny
	lda (addr1), y
	sta addr2+1

	ldy index

	; loop!!!
	lda (addr2), y
	sta $90
	rts	;-------------------------------


TST2:
	lda #0
	sta stage
	sta map_num
	sta index

	lda stage
	shl
	tax

	lda MAP_DATA, x
	sta addr1
	inx
	lda MAP_DATA, x
	sta addr1+1
	inx

	ldy map_num
	lda (addr1), y
	sta addr2
	iny
	lda (addr1), y
	sta addr2+1
	sty map_num

	ldy index

@LOOP:
	lda (addr2), y
	; 座標，キャラ番号取得など
	cmp #$fe
	bcc @EXIT
	iny
@EXIT:
	rts	;-------------------------------

*/

;*------------------------------------------------------------------------------
; Set addr of stage data
; @PARAM	Y: stage number
; @BREAK	A Y
; @RETURN	None
;*------------------------------------------------------------------------------

setStageAddr:
	tya
	shl
	tay
	lda MAP_DATA, y
	sta stage_addr
	lda MAP_DATA+1, y
	sta stage_addr+1
	rts	; ------------------------------

setMapAddr:
	tya
	shl
	tay
	lda (stage_addr), y
	sta map_addr
	iny
	lda (stage_addr), y
	sta map_addr+1
	rts	; ------------------------------
