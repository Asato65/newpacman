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

.include "const.inc"
.include "const_addr.inc"
.include "var_addr.inc"
.include "defmacro.inc"
.include "palette.inc"
.include "struct.inc"
.include "map_data.inc"

.code									; ----- code -----

.include "joypad.asm"
.include "macro.asm"
.include "subfunc.asm"			; インクルードが必要ないような，深い階層で使われる関数群
.include "draw_map.asm"
.include "sprite.asm"
.include "player_move.asm"
.include "nes.inc"
.include "nsd.inc"
.include "nmi.asm"
.include "init.asm"
.include "func.asm"				; いくつかのファイルのインクルードが必要な関数群
.include "main.asm"


.segment "DMA_MEM"
		.tag SPR_TBL


.code									; ----- code -----
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
