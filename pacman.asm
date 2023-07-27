.setcpu "6502"
.feature c_comments

.include "inc/const.inc"
.include "inc/palette.inc"


.include "asm/ppu.asm"
.include "asm/macro.asm"
.include "asm/init.asm"

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
		init

		.include "main.asm"
.endproc

.proc NMI
		.include "asm/nmi.asm"
.endproc

.proc IRQ
		rti
.endproc

.segment "CHARS"
		.incbin "spr_bg.chr"

.segment "VECTORS"
		.word NMI
		.word RESET
		.word IRQ