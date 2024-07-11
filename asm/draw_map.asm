.include "draw_map_macro.asm"

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
fill_ground_start		: .byte 0


;*------------------------------------------------------------------------------
; Update one row
; @PARAMS		None
; @CLOBBERS		A X Y tmp1 tmp2 addr_tmp1 addr_tmp2
; @RETURNS		None
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
		lda #1
		sta is_updated_map

		incRowCounter

		lda DrawMap::map_buff_num
		and #BIT0
		ora #4
		sta addr_tmp2+HI

		lda DrawMap::row_counter
		sta addr_tmp2+LO

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
		and #BYT_GET_LO
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
		lda DrawMap::row_counter
		sta addr_tmp1+LO				; PosY = 0

		lda DrawMap::map_buff_num
		and #BIT0
		ora #4
		sta addr_tmp1+HI

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
		pha								; push
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
		ora bg_plt_buff, y
@STORE_TO_PLT_BUFF:
		sta bg_plt_buff, y

		pla								; pull
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
; @PARAMS		Y: stage number
; @CLOBBERS		A Y
; @RETURNS		None (A = addr Hi)
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setStageAddr
		tya
		shl #1
		tay

		lda STAGE_ARR+LO, y
		sta DrawMap::map_arr_addr+LO
		lda STAGE_ARR+HI, y
		sta DrawMap::map_arr_addr+HI

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Set addr of maps
; @PARAMS		Y: map index
; @CLOBBERS		A Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setMapAddr
		tya
		shl #1
		tay
		pha								; push y

		lda (DrawMap::map_arr_addr), y
		sta DrawMap::map_addr+LO
		iny
		lda (DrawMap::map_arr_addr), y
		sta DrawMap::map_addr+HI

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
		; ------------------------------

@NO_EXIT:
		ramFillGround
		ramFillBlocks

		ldy #4								; マクロ後inyでもy = 4
		sty DrawMap::index

		pla
		tay

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Change stage
; @PARAMS		Y: Stage number
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _changeStage
		lda #0
		sta is_updated_map
		jsr Subfunc::_sleepOneFrame

		; Change bg color (black)
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		lda #$0f
		sta PPU_DATA
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		lda #$ff
		sta DrawMap::row_counter

		lda #0
		sta DrawMap::index
		sta main_disp
		sta DrawMap::cnt_map_next		; count ff
		sta DrawMap::map_buff_num
		sta DrawMap::isend_draw_stage
		sta DrawMap::map_arr_num
		sta scroll_x
		sta ppu_ctrl2_cpy
		sta PPU_CTRL2

		lda #'G'
		sta DrawMap::fill_ground_block

		tya
		pha
		lda STAGE_PALETTE_ARR, y
		tax
		lda BG_COLORS, x
		sta bg_color
		jsr Subfunc::_trfPltDataToBuff
		lda ppu_ctrl1_cpy
		and #%1111_1011					; ストア時のインクリメントを+1にする
		sta PPU_CTRL1
		tfrPlt
		jsr Subfunc::_restorePPUSet
		pla
		tay

		jsr DrawMap::_setStageAddr		; Y破壊（ステージ番号）
		ldy #0
		jsr DrawMap::_setMapAddr

		lda #$18
@DISP_LOOP:
		pha
		lda #1
		sta is_updated_map
		jsr DrawMap::_updateOneLine
		jsr Subfunc::_sleepOneFrame
		pla
		sub #1
		bne @DISP_LOOP

		; Restore bg color
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		lda bg_color
		sta PPU_DATA
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		jsr Subfunc::_setScroll

		lda #0
		sta is_updated_map
		jsr Subfunc::_sleepOneFrame

		lda #%00011110
		sta ppu_ctrl2_cpy
		jsr Subfunc::_restorePPUSet		; Display ON

		rts
		; ------------------------------

.endproc


.endscope
