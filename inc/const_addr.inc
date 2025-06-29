ZP					= $00
; Unused $0200
bg_map_buff			= $0100				; size = $d ($10 - $3) * $4 = $40 - $c = $34
ppu_attr_buff			= $0134				; size = 8
fill_block_arr		= $013c				; size = 13 ($d)
hit_block_arr		= $0149				; size = 2(addr) + 4(data) = 6
anime_block_arr		= $014f				; size = 2(addr) + 4(data) = 6
del_coin_addr		= $0155				; size = 2*3 = 6（マリオが最大3枚のコインに同時に触れることを想定して）
bg_buff			 	= $015d
CHR_BUFF			= $0700
MAP1				= $0400
MAP2				= $0500
SPR_COIN_ANIMATION		= $07d8
SPR_BLOCK_ANIMATION	= $07e0
SPR_ITEM			= $07f0

PLT_TABLE_ADDR		= $3f00

; PPU_CTRL1			= $2000		; nes.incで定義済み
; PPU_CTRL2			= $2001
PPU_STATUS			= $2002
OAM_ADDR			= $2003
OAM_DATA			= $2004
PPU_SCROLL			= $2005
PPU_ADDR			= $2006
PPU_DATA			= $2007
OAM_DMA				= $4014


SOUND_SQ1_1			= $4000				; Duty(2)|time counter|音響変化|ボリューム(4)
SOUND_SQ1_2			= $4001				; 周波数変化|変化速度(3)|変化方向|変化範囲(3)
SOUND_SQ1_3			= $4002				; 周波数下位
SOUND_SQ1_4			= $4003				; 再生時間(5)|周波数上位(3)
SOUND_SQ2_1			= $4004
SOUND_SQ2_2			= $4005
SOUND_SQ2_3			= $4006
SOUND_SQ2_4			= $4007
SOUND_TR_1			= $4008				; 再生時間カウンタ|カウンタを使用した長さ(7)
SOUND_TR_2			= $400A				; 周波数下位
SOUND_TR_3			= $400B				; 再生時間(5)|周波数上位(3)
SOUND_NS_1			= $400C				; 未使用(2)|再生時間カウンタ|音響固定|ボリューム(3)
SOUND_NS_2			= $400E				; 乱数タイプ(高周波)|未使用(3)|サンプルレート(4)
SOUND_NS_3			= $400F				; 再生時間(5)|未使用(3)
SOUND_DP_1			= $4010
SOUND_DP_2			= $4011
SOUND_DP_3			= $4012
SOUND_DP_4			= $4013
SOUND_CHANNEL		= $4015				; 未使用(3)|DPCM|ノイズ|三角波|CH2|CH1


JOYPAD1				= $4016
JOYPAD2				= $4017
