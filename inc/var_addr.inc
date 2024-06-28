; ZeroPage
.segment "ZEROPAGE"
tmp1					: .byte 0
tmp2					: .byte 0
tmp3					: .byte 0
tmp4					: .byte 0
tmp5					: .byte 0
tmp6					: .byte 0

bg_buff_pointer			: .byte 0
addr_tmp1				: .addr 0
addr_tmp2				: .addr 0

bg_map_buff_index		: .byte 0		; BG（マップ）専用バッファ

ppu_bg_addr				: .addr 0

tmp_rgstA				: .byte 0
tmp_rgstX				: .byte 0
tmp_rgstY				: .byte 0

; These are not used often, but are used in NMI
ppu_ctrl1_cpy			: .byte 0		; |NMI-ON|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCREEN$2000(2)|
ppu_ctrl2_cpy			: .byte 0		; |R|G|B|DISP-SPR|DISP-BG|SHOW-L8-SPR|SHOW-L8-BG|MODE=COLOR|

scroll_x				: .byte 0
scroll_amount			: .byte 0

main_disp				: .byte 0

nmi_cnt					: .byte 0
frm_cnt					: .byte 0
is_processing_main		: .byte 0

plt_addr				: .addr 0

is_updated_map			: .byte 0

is_scroll_locked		: .byte 0

is_jumping				: .byte 0


.segment "BUFF_MEM"


spr_posX_arr						: .res 6
spr_velocity_x_arr					: .res 6
spr_float_velocity_x_arr			: .res 6
spr_decimal_part_velocity_x_arr		: .res 6		; 小数部分のみ（補正値）

spr_posY_arr						: .res 6
spr_velocity_y_arr					: .res 6
spr_decimal_part_velocity_y_arr		: .res 6		; 小数部分のみ（補正値）
spr_pos_y_origin					: .res 6
spr_decimal_part_force_y			: .res 6		; 現在の加速度
spr_force_fall_y					: .res 6		; 降下時の加速度
spr_pos_y_decimal_part				: .res 6
spr_fix_val_y						: .res 6		; 加速度補正値

spr_anime_timer						: .res 6
spr_anime_num						: .res 6
spr_id_arr							: .res 6		; id = 0: no spr
spr_attr_arr						: .res 6		; bit0: 向き（1のとき右向き）


.code
