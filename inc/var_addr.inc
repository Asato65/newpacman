; ZeroPage
.segment "ZEROPAGE"
tmp1						: .byte 1
tmp2						: .byte 1
tmp3						: .byte 1
scroll_x					: .byte 1
scroll_y					: .byte 1
ppu_ctrl1_cpy				: .byte 1	; |NMI-ON|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCREEN$2000(2)|
ppu_ctrl2_cpy				: .byte 1	; |R|G|B|DISP-SPR|DISP-BG|SHOW-L8-SPR|SHOW-L8-BG|MODE=COLOR|

joy1						: .byte 1
joy2						: .byte 1
joy1_prev					: .byte 1
joy2_prev					: .byte 1
joy1_pushstart				: .byte 1
joy2_pushstart				: .byte 1

ppu_update_data_pointer		: .byte 1

nmi_cnt				= $fd
frm_cnt				= $fe
isend_main			= $ff

.code


; LABEL: .res Len FillVal
