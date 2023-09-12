;*------------------------------------------------------------------------------
; Update one row
; @PARAM	None
; @BREAK	A X Y tmp1 tmp2
; @RETURN	None
;*------------------------------------------------------------------------------

_drawMap:
	ldy row_counter
	iny
	cpy #$10
	bne @SKIP
	ldy #0
	inc map_num
@SKIP:
	sty row_counter

	ldy index

@LOOP1:
	; get pos
	lda (map_addr), y
	cmp #OBJMAP_END
	beq @END_MAP_DATA

	cmp #OBJMAP_NEXT
	beq @MAP_INC

	sta addr1+0
	and #%0000_1111
	cmp row_counter
	bne @LOOP_EXIT

	lda map_num
	cmp cnt_map_next					; #OBJMAP_NEXTの回数（ステージが変わるまで連番）
	bne @LOOP_EXIT

	and #%0000_0001
	add #4
	sta addr1+1

	; get chr
	iny
	lda (map_addr), y

	ldx #0
	sta (addr1, x)						; end using addr1
	iny
	bne @LOOP1							; jmp

@LOOP_EXIT:
	sty index

	rts	; ------------------------------

@MAP_INC:
	; lda #0
	; sta row_counter
	; inc map_num
	inc cnt_map_next
	iny
	bne @LOOP1							; jmp

@END_MAP_DATA:
	; 次のマップ読み込み
	ldy map_num
	iny
	sty map_num
	jsr _setMapAddr						; Use registerY as arg
	cmp #$ff							; A = Addr Hi
	bne @EXIT							; マップのアドレスだけ読みこんで終了

	lda #1
	sta isend_draw_stage				; ステージの描画全部終わったか

@EXIT:
	lda #0
	sta index

	rts	;-------------------------------


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
