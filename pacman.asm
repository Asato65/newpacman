.setcpu "6502"
.feature c_comments						; Allow C language type comments (/* comments */)
.feature underline_in_numbers			; Allow notation %1010_0010
.linecont +								; Allow line breaks in the middle of lines if you put a backslash at the end of the line

.rodata									; ----- data -----
.include "inc/const.inc"
.include "inc/const_addr.inc"
.include "inc/var_addr.inc"
.include "inc/palette.inc"

.include "./asm/macro.asm"
.include "main.asm"
.include "./asm/init.asm"
.include "./asm/nmi.asm"
.include "./asm/sub.asm"

.segment "HEADER"
		.byte $4e, $45, $53, $1a
		.byte $02						; program bank
		.byte $01						; charactor bank
		.byte $01						; vartical mirror
		.byte $00
		.byte $00, $00, $00, $00
		.byte $00, $00, $00, $00

.code
.segment "STARTUP"
.proc RESET
		init

		jmp MAIN
.endproc

.proc IRQ
		rti
.endproc

.segment "CHARS"
		.incbin "spr_bg.chr"

.segment "VECINFO"
		.word NMI
		.word RESET
		.word IRQ
