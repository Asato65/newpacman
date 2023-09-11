; ZeroPage
.segment "ZEROPAGE"
tmp1					: .byte 0		; 00
tmp2					: .byte 0		; 01
tmp3					: .byte 0		; 02

joy1					: .byte 0		; 03
joy2					: .byte 0		; 04
joy1_prev				: .byte 0		; 05
joy2_prev				: .byte 0		; 06
joy1_pushstart			: .byte 0		; 07
joy2_pushstart			: .byte 0		; 08

bg_buff_pointer			: .byte 0		; 09
addr_tmp1				: .addr 0		; 0A, 0B

tmp_rgstA				: .byte 0		; 0C
tmp_rgstX				: .byte 0		; 0D
tmp_rgstY				: .byte 0		; 0E

; These are not used often, but are used in NMI
ppu_ctrl1_cpy			: .byte 0		; 0F |NMI-ON|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCREEN$2000(2)|
ppu_ctrl2_cpy			: .byte 0		; 10 |R|G|B|DISP-SPR|DISP-BG|SHOW-L8-SPR|SHOW-L8-BG|MODE=COLOR|

scroll_x				: .byte 0		; 11
scroll_y				: .byte 0		; 12

nmi_cnt					: .byte 0		; 13
frm_cnt					: .byte 0		; 14
is_processing_main		: .byte 0		; 15

addr1					: .addr 0		; 16, 17
addr2					: .addr 0		; 18, 19
addr3					: .addr 0		; 1a, 1b
stage					: .byte 0		; 1c
map_num					: .byte 0		; 1d
index_tmp				: .byte 0		; 1e

map_arr_addr			: .addr 0		; 1f, 20
map_addr				: .addr 0		; 21, 22

obj_posx				: .byte 0		; 23
obj_posy				: .byte 0		; 24
obj_id					: .byte 0		; 25
isend_draw_stage		: .byte 0		; 26
row_counter				: .byte 0		; 27
index					: .byte 0		; 28

ppu_addr				: .addr 0		; 29, 2a
cnt_map_next			: .byte 0		; 2b

.segment "USER_MEM"


.code
