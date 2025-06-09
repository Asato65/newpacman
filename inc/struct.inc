.struct	SPR_STRUCT
		pty		.byte					; PosiTion Y
		num		.byte					; Tile(8*8) number
		att		.byte					; Attribute (VertFlip|HorizonFlip|Prio|Unused(3)|PltNum(2))
		ptx		.byte					; PosiTion X
.endstruct


.struct	SPR_TBL
		spr		.tag SPR_STRUCT 64
.endstruct
