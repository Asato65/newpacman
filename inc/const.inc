PPU_VERTICAL_MODE						= %11111110
PPU_HORIZONTAL_MODE						= %11111111

ENDCODE									= $ff

OBJMAP_NEXT								= $fe
OBJMAP_END								= $ff

PPU_CTRL1_STD							= %10010000			; |NMION|PPU=MASTER|SPR8*8|BG$1000|SPR$0000|VRAM+1|SCRN$2000(2)|
PPU_CTRL2_STD							= %00011110			; |R|G|B|DISP-SPR|DISP-BG|SHOW-L8SPR|SHOW-L8BG|MODE=COLOR|


BIT0									= %00000001
BIT1									= %00000010
BIT2									= %00000100
BIT3									= %00001000
BIT4									= %00010000
BIT5									= %00100000
BIT6									= %01000000
BIT7									= %10000000

BYT_GET_HI								= %11110000
BYT_GET_LO								= %00001111

LO										= 0
HI										= 1

INIT = 0

PLAYER_SPR_ID							= $0				; スプライトID
PLAYER_CHR_BUFF_INDEX					= $0				; スプライトRAMのインデックス（0爆弾の次に配置する）
PLAYER_WIDTH							= $c
PLAYER_PADDING							= $2

PLAYER_MAX_POSX							= $70				; マリオの行ける最大X座標（スクロールロックが無いとき）


NUM2BIT:
	.byte $01, $02, $04, $08, $10, $20, $40, $80