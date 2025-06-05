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
ldarr_addr_tmp			: .addr 0

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
disp_cnt				: .byte 0		; 画面が切り替わった回数
standing_disp			: .byte 0		; マリオが立っている位置の画面番号

nmi_cnt					: .byte 0
frm_cnt					: .byte 0
is_processing_main		: .byte 0

plt_addr				: .addr 0

is_updated_map			: .byte 0

is_scroll_locked		: .byte 0

is_jumping				: .byte 0

map_num					: .byte 0


.segment "USER_MEM"


spr_posX_arr						: .res 6
spr_posX_tmp_arr					: .res 6
spr_velocity_x_arr					: .res 6
spr_float_velocity_x_arr			: .res 6
spr_decimal_part_velocity_x_arr		: .res 6		; 小数部分のみ（補正値）

spr_posY_arr						: .res 6
spr_posY_tmp_arr					: .res 6
spr_velocity_y_arr					: .res 6
spr_decimal_part_velocity_y_arr		: .res 6		; 小数部分のみ（補正値）
spr_pos_y_origin					: .res 6
spr_decimal_part_force_y			: .res 6		; 現在の加速度
spr_force_fall_y					: .res 6		; 降下時の加速度
spr_pos_y_decimal_part				: .res 6
spr_fix_val_y						: .res 6		; 加速度補正値
spr_float_velocity_y_arr			: .res 6

spr_anime_timer						: .res 6
spr_anime_num						: .res 6
spr_id_arr							: .res 6		; キャラに固有のID（マリオは最初から0でセット済み）
spr_attr_arr						: .res 6		; bit7: ほかのスプライトが利用中か、bit5: 右端を超えたとき（敵のみ使用）、bit4: 当たり判定なし，bit3: 倒された，bit2: マリオ…上端を超えたとき／敵：下端を超えた時、敵…非表示、 bit1: 左端を超えたとき, bit0: 向き（1のとき右向き）
spr_move_timer_arr					: .res 6		; マリオの領域は未使用
spr_move_counter					: .res 6		; $ffで初期化する
spr_move_timer_max_arr				: .res 6
spr_move_num						: .res 6		; 移動リストのインデックス
spr_standing_disp					: .res 6

plt_datas							: .res 24
bg_color							: .res 1

timer_dec_num_arr					: .res 3

engine								: .res 1		; 0: game, 1: pause
engine_flag							: .res 1
engine_timer						: .res 2		; upper: seconds, lower: frame

item_id								: .res 1
item_timer							: .res 1
item_standing_disp					: .res 1
item_posX_arr						: .res 1
item_posY_arr						: .res 1
item_velocity_X_arr					: .res 1
item_velocity_y_arr					: .res 1


block_anime_spr_id					: .res 1
block_anime_timer					: .res 1
block_anime_tmp1					: .res 1   ; 今は叩いたあとの背景データのIDに使う
; block_anime_addr					: .res 2

.code
