;*------------------------------------------------------------------------------
; bg_buffを読み取り，指定アドレスに書き込んでカウンタをインクリメント
; Unused
; @PARAMS		ADDR: Forwarding address
; @CLOBBERS		A X
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.import _nsd_main_bgm

.macro tfrDataToPPU ADDR
		lda bg_buff, x
		sta ADDR
		inx
.endmacro

; memo
; ----- PPU buff data structure -----
; r: Direction
; 	Bit0 is a flag, others are 1.
; 	-> 0b1111_111[0/1]
; 	-> 0xFE（Horizontal）/0xFF（Vertical）
; a: Addr
; d: Data
; r [a a] [d d d ... d] r [a a] [d d ... d]


;*------------------------------------------------------------------------------
; NMI (Interrupt)
; @CLOBBERS	 X Y (When end main process.)
; To shorten the clock, put the buffer data on the stack
; 	(Shorten clock by buff data length)
; 	pla -> 3 clc
; 	lda ZP/ABSORUTE, x -> 4 clc
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _nmi
		pha
		inc nmi_cnt
		lda is_processing_main
		beq @NMI_MAIN
		pla
		jsr Subfunc::_setScroll
		; ゼロスプライトの描画
		lda #0
		sta OAM_ADDR
		lda #>CHR_BUFF
		sta OAM_DMA
		rti	; --------------------------

@NMI_MAIN:
		lda is_updated_map
		bne :+
		jmp @HORIZONTAL_MODE
:
.repeat 7, i
		lda ppu_attr_addr+1
		sta PPU_ADDR

		lda ppu_attr_addr+0
		add #((i+1)*8)
		sta PPU_ADDR

		lda ppu_attr_buff+i
		sta PPU_DATA
.endrepeat


		lda ppu_ctrl1_cpy
		ora #%0000_0100					; Vertical mode
		sta ppu_ctrl1_cpy
		sta PPU_CTRL1					; Not use restorePPUSet()

		; line 1
		lda ppu_bg_addr+HI
		sta PPU_ADDR
		lda ppu_bg_addr+LO
		sta PPU_ADDR

.repeat $1a, i
		lda bg_map_buff+i
		sta PPU_DATA
.endrepeat

		; line 2
		lda ppu_bg_addr+HI
		sta PPU_ADDR
		ldx ppu_bg_addr+LO
		inx
		stx PPU_ADDR

.repeat $1a, i
		lda bg_map_buff+$1a+i
		sta PPU_DATA
.endrepeat

@HORIZONTAL_MODE:
		lda ppu_ctrl1_cpy
		and #%11111011
		sta ppu_ctrl1_cpy
		sta PPU_CTRL1

@STORE_ANIMATION_BLOCK:
		lda Player::player_animation_block_is_drawed
		beq @STORE_HIT_BLOCK

		lda anime_block_arr+$0
		sta PPU_ADDR
		lda anime_block_arr+$1
		sta PPU_ADDR
		lda anime_block_arr+$2
		sta PPU_DATA
		lda anime_block_arr+$3
		sta PPU_DATA

		lda anime_block_arr+$0
		sta PPU_ADDR
		lda anime_block_arr+$1
		add #$20
		sta PPU_ADDR
		lda anime_block_arr+$4
		sta PPU_DATA
		lda anime_block_arr+$5
		sta PPU_DATA

		lda #0
		sta Player::player_animation_block_is_drawed

@STORE_HIT_BLOCK:
		lda Player::player_hit_block_is_drawed
		beq @DELETE_COIN

		lda ppu_ctrl1_cpy
		and #%11111011					; Mask direction flag(Horizontal(+1)/Vertical(+32))
		sta ppu_ctrl1_cpy
		sta PPU_CTRL1					; Not use restorePPUSet()

		lda hit_block_arr+$0
		sta PPU_ADDR
		lda hit_block_arr+$1
		sta PPU_ADDR
		lda hit_block_arr+$2
		sta PPU_DATA
		lda hit_block_arr+$3
		sta PPU_DATA

		lda hit_block_arr+$0
		sta PPU_ADDR
		lda hit_block_arr+$1
		add #$20
		sta PPU_ADDR
		lda hit_block_arr+$4
		sta PPU_DATA
		lda hit_block_arr+$5
		sta PPU_DATA

		lda #0
		sta Player::player_hit_block_is_drawed

@DELETE_COIN:
		lda Player::collision_coin_counter
		beq @DISP_TIMER

		ldx #0
:

		lda del_coin_addr+$0, x
		sta PPU_ADDR
		lda del_coin_addr+$1, x
		sta PPU_ADDR

		lda #0
		sta PPU_DATA
		sta PPU_DATA

		lda del_coin_addr+$0, x
		sta PPU_ADDR
		lda del_coin_addr+$1, x
		add #$20
		sta PPU_ADDR

		lda #0
		sta PPU_DATA
		sta PPU_DATA

		inx
		inx
		cpx Player::collision_coin_counter
		bcc :-

		lda #0
		sta Player::collision_coin_counter

@DISP_TIMER:
		lda #$20
		sta PPU_ADDR
		lda #$5B
		sta PPU_ADDR
		lda ppu_timer_data+$0
		sta PPU_DATA
		lda ppu_timer_data+$1
		sta PPU_DATA
		lda ppu_timer_data+$2
		sta PPU_DATA

@DISP_AMOUNT_COIN:
		lda #$20
		sta PPU_ADDR
		lda #$52
		sta PPU_ADDR
		lda ppu_coin_data+$0
		sta PPU_DATA
		lda ppu_coin_data+$1
		sta PPU_DATA

@PLT_ANIMATION:
		lda #$3f
		sta PPU_ADDR
		lda #$05
		sta PPU_ADDR
		lda ppu_plt_animation_data
		sta PPU_DATA

@PRINT:
		lda #0
		cmp bg_buff_pointer
		beq @STORE_CHR
		tax
		lda bg_buff, x
@SET_MODE:
		and #%00000001					; Get flag
		shl #2							; Move flag to Bit2
		sta tmp1						; Start using tmp1
		lda ppu_ctrl1_cpy
		and #%11111011					; Mask direction flag(Horizontal(+1)/Vertical(+32))
		ora tmp1						; End using tmp1
		sta ppu_ctrl1_cpy
		sta PPU_CTRL1					; Not use restorePPUSet()
@SET_ADDR:
		inx								; Not do inx when go to @EXIT
		lda bg_buff, x
		sta PPU_ADDR
		inx
		lda bg_buff, x
		sta PPU_ADDR
		inx
@STORE_DATA:
		lda bg_buff, x
		tay
		cmp #$fe
		bcs @SET_MODE					; no inx
		tya
		sta PPU_DATA
		inx
		cpx bg_buff_pointer
		bne @STORE_DATA

		; @SET_MODE + @SET_ADDR = 51 cycle
		; @STORE_DATA (return @STORE_DATA) = 24 cycle
		; @STORE_DATA (return @SET_MODE) = 13 cycle

		; str1 = "A  B"
		; 	=> 51 + space_len * 24 cycle
		; 	=> mode(1) + addr(2) + data(2 + space_len) = (5 + space_len) bytes
		; 	|  len  || 1  | 2  |  3  |  4  |
		; 	| cycle || 75 | 99 | 123 | 147 |
		;	| bytes || 6  | 7  |  8  |  9  |
		; str2 = 'A', str3 = 'B'
		; 	=> (51 + 13) * 2 = 64 * 2 = 128 cycle
		; 	=> (mode(1) + addr(2) + data(1)) * 2 = 8 bytes
		; space length:
		; 	1: 75 cycle,	6 bytes (str1)
		; 	2: 99 cycle,	7 bytes
		; 	3: 123 cycle,	8 bytes
		; 	4~: 128 cycle,	8 bytes (str2)

@STORE_CHR:
		lda #0
		sta OAM_ADDR
		lda #>CHR_BUFF
		sta OAM_DMA

@EXIT:
		lda #1
		sta is_processing_main
		shr #1							; A = 0
		sta bg_buff_pointer
		sta is_updated_map
		inc frm_cnt
		pla
		rti	; --------------------------
.endproc
