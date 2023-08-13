; ZeroPage
tmp1							= $00
tmp2							= $01
tmp3							= $03
scroll_x						= $04
scroll_y						= $05
ppu_ctrl1_cpy					= $06				; |NMI-ON|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCREEN$2000|
ppu_ctrl2_cpy					= $07				; |R|G|B|DISP-SPR|DISP-BG|SHOW-L8-SPR|SHOW-L8-BG|MODE=COLOR|

joy1				= $08
joy2				= $09
joy1_prev			= $0a
joy2_prev			= $0b
joy1_pushstart		= $0c
joy2_pushstart		= $0d

ppu_update_data_pointer		= $0e

nmi_cnt				= $fd
frm_cnt				= $fe
isend_main			= $ff


; LABEL: .res Len FillVal
