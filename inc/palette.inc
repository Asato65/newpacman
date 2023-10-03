DEFAULT_PLT:
		; BG
		.byte $36, $17, $0f
		.byte $27, $17, $0f				; 27 -> 07/17/27
		.byte $29, $1a, $0f
		.byte $30, $21, $0f
		; SPR
		.byte $16, $27, $18
		.byte $1a, $30, $27
		.byte $16, $30, $27
		.byte $0f, $36, $17


UNDER_GROUND_PLT:
		; BG
		.byte $3c, $1c, $0f
		.byte $27, $17, $1c
		.byte $29, $1a, $09
		.byte $30, $21, $1c
		; SPR
		.byte $16, $27, $18
		.byte $1c, $30, $17				; black disp: $30 -> $36
		.byte $16, $30, $27
		.byte $0c, $3c, $1c

