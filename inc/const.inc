; ZeroPage
tmp1		= $00
tmp2		= $01
tmp3		= $03
scroll_x	= $04
scroll_y	= $05
nmi_cnt		= $fd
frm_cnt		= $fe
isend_main	= $ff


ZP					= $00
CHR_DATA			= $0300
MAP1_DATA			= $0400
MAP2_DATA			= $0500
PPU_UPDATE_DATA		= $0600

PLT_TABLE_ADDR		= $3f00

PPU_CTRL			= $2000
PPU_MASK			= $2001
PPU_STATUS			= $2002
OAM_ADDR			= $2003
OAM_DATA			= $2004
PPU_SCROLL			= $2005
PPU_ADDR			= $2006
PPU_DATA			= $2007
OAM_DMA				= $4014
