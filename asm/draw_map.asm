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
; Update one row
; @PARAM	None
; @BREAK	A X Y
; @RETURN	None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _updateOneLine
		lda DrawMap::isend_draw_stage
		bne @NO_DRAW

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
		; get pos
		lda (DrawMap::map_addr), y

		cmp #DrawMap::OBJMAP_NEXT
		beq @LOAD_NEXT_MAP

		cmp #DrawMap::OBJMAP_END
		beq @END_MAP_DATA

		tax								; Start using x (tmp)
		and #%0000_1111
		cmp DrawMap::row_counter
		bne @LOOP_EXIT

		lda DrawMap::map_buff_num
		cmp DrawMap::cnt_map_next		; Count OBJMAP_NEXT (is not reset until the stage changes)
		bne @LOOP_EXIT

		stx addr_tmp1+0					; End using x
		ldx #0							; init

		and #%0000_0001					; A = map_buff_num
		ora #4
		sta addr_tmp1+1

		; get chr
		iny
		lda (DrawMap::map_addr), y
		sta (addr_tmp1, x)				; End using addr_tmp1

		iny
		bne @GET_POS_AND_OBJ			; Jmp

@LOOP_EXIT:
		sty DrawMap::index
		jmp @EXIT


@LOAD_NEXT_MAP:
		inc DrawMap::cnt_map_next
		iny
		jmp @GET_POS_AND_OBJ


@END_MAP_DATA:
		; Load the next map
		inc DrawMap::map_arr_num
		ldy DrawMap::map_arr_num
		jsr _setMapAddr					; Use Y as arg
		cmp #ENDCODE					; A = Addr Hi
		beq @NO_DRAW
		ldy #$ff
		sty DrawMap::index
		bne @LOAD_NEXT_MAP				; jmp

@NO_DRAW:
		ldy #0
		sty DrawMap::index				; X = 0
		iny
		sty DrawMap::isend_draw_stage


@EXIT:
		; X = 0
		; prepare data
		lda addr_tmp1+0
		and #%0000_1111
		sta addr_tmp1+0

		lda addr_tmp1+1					; 4 or 5
		and #1
		shl #2							; 0 or 4
		ora #$20						; $20 or $24
		sta bg_map_addr+1

		stx tmp1						; Init, start using tmp1

		lda addr_tmp1+0
		shl #1
		rol tmp1
		shl #1
		rol tmp1

		sta bg_map_addr+0
		ora bg_map_addr+1
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
		lda BROCK_ID+0, x
		sta addr_tmp2+0
		lda BROCK_ID+1, x
		sta addr_tmp2+1

		ldx bg_map_buff_index

		ldy #0
		lda (addr_tmp2), y
		sta BG_MAP_BUFF+0, x

		iny
		lda (addr_tmp2), y
		sta BG_MAP_BUFF+$1c, x

		inx
		iny
		lda (addr_tmp2), y
		sta BG_MAP_BUFF+0, x

		iny
		lda (addr_tmp2), y
		sta BG_MAP_BUFF+$1c, x

		inx
		stx bg_map_buff_index

		ldy tmp1						; End using tmp1

		tya
		adc #$10
		tay
		cmp #$e0
		bcc @LOOP

		rts	;---------------------------
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

		rts	; --------------------------
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

		rts	; --------------------------
.endproc


.endscope
