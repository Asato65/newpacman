.setcpu "6502"
.feature c_comments

.include "macro.asm"
.include "const.inc"

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

.endproc

.proc MAINLOOP
		; jsr MAIN
		jmp MAINLOOP
.endproc


.proc NMI
		rti
.endproc


.proc IRQ
		rti
.endproc


.segment "CHARS"
		.incbin "bg-spr.chr"

.segment "VECTORS"
		.word NMI
		.word RESET
		.word IRQ