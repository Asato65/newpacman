BG_COLORS:
	.byte $22, $0f

PALETTES:
	.addr GROUND_PLT
	.addr UNDER_GROUND_PLT


GROUND_PLT:
		; BG
		.byte $36, $17, $0f
		.byte $27, $17, $0f				; 27 -> 07/17/27
		.byte $29, $1a, $0f
		.byte $30, $21, $0f
		; SPR
		.byte $20, $0f, $1a
		.byte $20, $0f, $25
		.byte $16, $30, $27
		.byte $0f, $36, $17


UNDER_GROUND_PLT:
		; BG
		.byte $3c, $1c, $0f
		.byte $27, $17, $1c
		.byte $29, $1a, $09
		.byte $30, $21, $1c
		; SPR
		.byte $20, $0f, $1a
		.byte $20, $0f, $25				; black disp: $30 -> $36
		.byte $16, $30, $27
		.byte $0c, $3c, $1c

