.code									; ----- code -----

;*------------------------------------------------------------------------------
; Transfar obj data (8*8) to BG map buff($04XX/$05XX)
; @PARAMS		X: Block ID
; @CLOBBERS		A X Y
; @RETURNS		None (Y: 3)
;*------------------------------------------------------------------------------

.macro trfToBgMapBuf
		lda BROCK_ID_ARR+LO, x
		sta addr_tmp2+LO
		lda BROCK_ID_ARR+HI, x
		sta addr_tmp2+HI

		ldx bg_map_buff_index

		ldy #0
		lda (addr_tmp2), y
		sta bg_map_buff+0, x

		iny
		lda (addr_tmp2), y
		sta bg_map_buff+($0d*2), x

		inx

		iny
		lda (addr_tmp2), y
		sta bg_map_buff+0, x

		iny
		lda (addr_tmp2), y
		sta bg_map_buff+($0d*2), x

		inx

		stx bg_map_buff_index
.endmacro


;*------------------------------------------------------------------------------
; Increment row_counter
; @PARAMS		None
; @CLOBBERS		Y
; @RETURNS		None (Y: row_counter)
;*------------------------------------------------------------------------------

.macro incRowCounter
		.local @NO_OVF_ROW_CNT

		ldy DrawMap::row_counter
		iny
		cpy #$10
		bne @NO_OVF_ROW_CNT

		ldy #0
		inc DrawMap::map_buff_num
@NO_OVF_ROW_CNT:
		sty DrawMap::row_counter
.endmacro


;*------------------------------------------------------------------------------
; index = 0xff
; @PARAMS		None
; @CLOBBERS		Y
; @RETURNS		None (Y: 0xff)
;*------------------------------------------------------------------------------

.macro initIndex
		ldy #NEGATIVE 1
		sty DrawMap::index
.endmacro


;*------------------------------------------------------------------------------
; Fill blocks (store to bg buff)
; @PARAMS		None
; @CLOBBERS		A X Y
; @RETURNS		None (A = X)
;*------------------------------------------------------------------------------

.macro fillBlocks
		.local @LOOP

		lda addr_tmp2+LO
		and #BYT_LO
		sta addr_tmp2+LO

		ldx #0
		ldy #0
@LOOP:
		lda fill_block_arr, y
		sta (addr_tmp2, x)

		lda addr_tmp2+LO
		add #$10
		sta addr_tmp2+LO

		iny
		cpy #$d
		bne @LOOP
.endmacro


;*------------------------------------------------------------------------------
; fill ground (store to fill buff)
; @PARAMS		None
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.macro ramFillGround
		.local @FILL_SKY_LOOP1
		.local @FILL_SKY_LOOP1_END
		.local @FILL_GROUND_LOOP
		.local @FILL_GROUND_LOOP_END
		.local @FILL_SKY_LOOP2
		.local @END_FILL_GROUND

		ldy #0

		lda (DrawMap::map_addr), y
		and #BYT_LO
		sta DrawMap::fill_ground_end

		lda (DrawMap::map_addr), y
		shr #4
		sta DrawMap::fill_ground_start


		lda #0
		tax
@FILL_SKY_LOOP1:
		cpx DrawMap::fill_ground_start
		bcs @FILL_SKY_LOOP1_END
		sta fill_block_arr, x
		inx
		cpx #$d
		bcc @FILL_SKY_LOOP1
		bcs @END_FILL_GROUND
@FILL_SKY_LOOP1_END:

		lda DrawMap::fill_ground_block
@FILL_GROUND_LOOP:
		cpx DrawMap::fill_ground_end
		bcs @FILL_GROUND_LOOP_END
		sta fill_block_arr, x
		inx
		cpx #$d
		bcc @FILL_GROUND_LOOP
		bcs @END_FILL_GROUND
@FILL_GROUND_LOOP_END:

		lda #0
@FILL_SKY_LOOP2:
		sta fill_block_arr, x
		inx
		cpx #$d
		bcc @FILL_SKY_LOOP2

@END_FILL_GROUND:
.endmacro


;*------------------------------------------------------------------------------
; fill blocks (store to fill buff)
; @PARAMS		None
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.macro ramFillBlocks
		.local @FILL_BLOCK_LOOP_UPPER
		.local @NO_BLOCK1
		.local @FILL_BLOCK_LOOP_LOWER
		.local @NO_BLOCK2

		ldy #1
		lda (DrawMap::map_addr), y		; ブロック種類
		sta DrawMap::fill_block


		iny
		lda (DrawMap::map_addr), y		; 上位
		shl #3							; 上位3ビット削除

		ldx #0
@FILL_BLOCK_LOOP_UPPER:
		shl #1
		bcc @NO_BLOCK1

		pha
		lda DrawMap::fill_block
		sta fill_block_arr, x
		pla

@NO_BLOCK1:
		inx
		cpx #$5
		bcc @FILL_BLOCK_LOOP_UPPER


		iny
		lda (DrawMap::map_addr), y		; 下位
@FILL_BLOCK_LOOP_LOWER:
		shl #1
		bcc @NO_BLOCK2

		pha
		lda DrawMap::fill_block
		sta fill_block_arr, x
		pla

@NO_BLOCK2:
		inx
		cpx #$d
		bcc @FILL_BLOCK_LOOP_LOWER
.endmacro


;*------------------------------------------------------------------------------
; Load next map
; @PARAMS		None
; @CLOBBERS		Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.macro loadNextMap
		inc DrawMap::map_arr_num
		ldy DrawMap::map_arr_num		; Y = ++map_arr_num
		jsr _setMapAddr
.endmacro


;*------------------------------------------------------------------------------
; set BG addr (PPU)
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------

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