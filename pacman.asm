.setcpu "6502"
.feature c_comments						; Allow C language type comments (/* comments */)
.feature underline_in_numbers			; Allow notation %1010_0010
.feature string_escapes					; Allow \t, \n, \" and so on
.linecont +								; Allow line breaks in the middle of lines if you put a backslash at the end of the line


.segment "HEADER"
		.byte "NES", $1a
		.byte $02						; Program bank
		.byte $01						; Charactor bank
		.byte $01						; Vartical mirror
		.byte $00
		.byte $00, $00, $00, $00
		.byte $00, $00, $00, $00


.rodata									; ----- data -----

.include "./inc/const.inc"
.include "./inc/const_addr.inc"
.include "./inc/var_addr.inc"
.include "./inc/defmacro.inc"
.include "./inc/palette.inc"
.include "./inc/struct.inc"
.include "./inc/map_data.inc"

.code									; ----- code -----

.include "./asm/joypad.asm"
.include "./asm/macro.asm"
.include "./asm/subfunc.asm"
.include "./asm/nmi.asm"
.include "./asm/init.asm"
.include "./asm/draw_map.asm"
.include "main.asm"

; Use .org
.org SPR_BUFF
		.tag SPR_TBL


.code									; ----- code -----
.org $8000
.segment "STARTUP"

.proc _reset
		init

		lda #1
		sta is_processing_main

		jmp _main
		; ------------------------------
.endproc


.proc _irq
		rti
.endproc


.segment "CHARS"
		.incbin "spr_bg.chr"


.segment "VECINFO"
		.addr _nmi
		.addr _reset
		.addr _irq
