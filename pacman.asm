.setcpu "6502"
.feature c_comments

.rodata									; ----- data -----
.include "inc/const.inc"
.include "inc/const_addr.inc"
.include "inc/var_addr.inc"
.include "inc/palette.inc"

.code
.include "main.asm"
.include "./asm/init.asm"
.include "./asm/ppu.asm"
.include "./asm/macro.asm"

.include "./asm/nmi.asm"
.include "./asm/sub.asm"

.segment "HEADER"
		.byte $4e, $45, $53, $1a
		.byte $02						; プログラムバンク
		.byte $01						; キャラクターバンク
		.byte $01						; 垂直ミラー
		.byte $00
		.byte $00, $00, $00, $00
		.byte $00, $00, $00, $00

.segment "STARTUP"
.proc RESET
.code									; ----- code -----
		init

		jmp MAIN
.endproc


.proc IRQ
.code									; ----- code -----
		rti
.endproc

.segment "CHARS"
		.incbin "spr_bg.chr"

.segment "VECTORS"
		.word NMI
		.word RESET
		.word IRQ