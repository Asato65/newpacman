; ZeroPage
.segment "ZEROPAGE"
tmp1						: .byte 0	; $00
tmp2						: .byte 0	; $01
tmp3						: .byte 0	; $02
scroll_x					: .byte 0	; $03
scroll_y					: .byte 0	; $04
ppu_ctrl1_cpy				: .byte 0	; $05 |NMI-ON|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCREEN$2000(2)|
ppu_ctrl2_cpy				: .byte 0	; $06 |R|G|B|DISP-SPR|DISP-BG|SHOW-L8-SPR|SHOW-L8-BG|MODE=COLOR|

joy1						: .byte 0	; $07
joy2						: .byte 0	; $08
joy1_prev					: .byte 0	; $09
joy2_prev					: .byte 0	; $0A
joy1_pushstart				: .byte 0	; $0B
joy2_pushstart				: .byte 0	; $0C

ppu_update_data_pointer		: .byte 0	; $0D
addr_tmp1					: .addr 0	; $0E, $0F

tmp_rgstA					: .byte 0	; $10
tmp_rgstX					: .byte 0	; $11
tmp_rgstY					: .byte 0	; $12

nmi_cnt						= $fd
frm_cnt						= $fe
isend_main					= $ff

.code

; LABEL: .res Len FillVal
