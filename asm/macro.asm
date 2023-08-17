; ------------------------------------------------------------------------------
; Load array
; A = Arr[X][Y]
; @PARAM	ADDR: Array Address
; @PARAM	X Y: index (Access Arr[x][y])
; @BREAK	A tmp1
; ------------------------------------------------------------------------------

.macro ldarr ADDR
		sty tmp1						; save Y
		txa
		asl								; ×2（アドレスが16bitなのでARR[x][y]のxが+1 => 読み込むアドレスは+2する必要がある
		tay								; アドレッシングに使うためYレジスタへ
		lda ADDR, y						; Low
		sta <addr_tmp1
		lda ADDR+1, y					; High
		sta >addr_tmp1
		ldy tmp1						; restore Y
		lda (addr_tmp1), y
.endmacro


; ------------------------------------------------------------------------------
; Calculate Negative Numbers
; ------------------------------------------------------------------------------

.macro cnn
		eor #$ff
		add #$01
.endmacro


; ------------------------------------------------------------------------------
; Upper 4 bits -> lower bits
; ------------------------------------------------------------------------------

.macro rsft4
		lsr
		lsr
		lsr
		lsr
.endmacro


; ------------------------------------------------------------------------------
; Lower 4 bits -> upper bits
; ------------------------------------------------------------------------------

.macro lsft4
		asl
		asl
		asl
		asl
.endmacro


; ------------------------------------------------------------------------------
; Addition
; This Macro only supports Immediate/Zeropage/Absolute addressing.
; Other addressing modes are not optimized for speed.
; Other addressing usage: add a, {$00, x} / add a, {($00), y}
; @PARAM	ARG1: register or Address
; @PARAM	VAL
; ------------------------------------------------------------------------------

.macro add ARG1, VAL
		.if (.paramcount = 1)
			; add #3 / add $80
			clc
			adc ARG1
		.elseif (.paramcount = 2)
			.if (.match({ARG1}, a))
				; add a, #3 / add a, $80
				clc
				adc VAL
			.elseif (.match({ARG1}, x))
				; add x, ??
				.if (\
					.match(.left(1, {VAL}), #) &&\
					.right(.tcount({VAL})-1, {VAL}) <= 7\
				)
					; add x, #0~7
					.repeat (.right(.tcount({VAL})-1, {VAL}))
						inx
					.endrepeat
				.else
					pha
					txa
					clc
					adc VAL
					tax
					pla
				.endif
			.elseif (.match({ARG1}, y))
				; add y, ??
				.if (\
					.match(.left(1, {VAL}), #) &&\
					.right(.tcount({VAL})-1, {VAL}) <= 7\
				)
					; add y, #0~7
					.repeat (.right(.tcount ({VAL})-1, {VAL}))
						iny
					.endrepeat
				.else
					pha
					tya
					clc
					adc VAL
					tay
					pla
				.endif
			.endif
		.else
			.error "Too or few parameters for macro 'add'"
		.endif
.endmacro


; ------------------------------------------------------------------------------
; Subtraction
; @PARAM	ARG1: register or Address
; @PARAM	VAL
; ------------------------------------------------------------------------------

.macro sub ARG1, VAL
		.if (.paramcount = 1)
			sec
			sbc ARG1
		.elseif (.paramcount = 2 && .match({ARG1}, a))
			sec
			sbc VAL
		.elseif (.paramcount = 2 && .match({ARG1}, x))
			.if (\
				.match(.left(1, {VAL}), #) &&\
				.right(.tcount({VAL})-1, {VAL}) <= 7\
			)
				.repeat (.right(.tcount({VAL})-1, {VAL}))
					dex
				.endrepeat
			.else
				pha
				txa
				sec
				sbc VAL
				tax
				pla
			.endif
		.elseif (.paramcount = 2 && .match({ARG1}, y))
			.if (\
				.match(.left(1, {VAL}), #) &&\
				.right(.tcount({VAL})-1, {VAL}) <= 7\
			)
				.repeat (.right(.tcount ({VAL})-1, {VAL}))
					dey
				.endrepeat
			.else
				pha
				tya
				sec
				sbc VAL
				tay
				pla
			.endif
		.endif
.endmacro


;*------------------------------------------------------------------------------
; Arithmetic right shift
; A >>= C
; @PARAM	A
; @PARAM	C: default=1
;*------------------------------------------------------------------------------

.macro asr C
	.ifblank(C)
		; asr
		cmp #%10000000				; Bit 7 into carry
		ror							; Shift carry into bit 7
	.else
		; asr #4
		.repeat (.right(.tcount ({C})-1, {C}))
			cmp #%10000000
			ror
		.endrepeat
	.endif
.endmacro


;*------------------------------------------------------------------------------
; Light shift
; A <<= C
; @PARAM	ARG1
; @PARAM	C: default=1
;*------------------------------------------------------------------------------

.macro shl ARG1, C
	.repeat	C
		lsr	ARG1
	.endrepeat
.endmacro


;*------------------------------------------------------------------------------
; Right shift
; A >>= C
; @PARAM	ARG1
; @PARAM	C: default=1
;*------------------------------------------------------------------------------

.macro shr C
	.repeat	C
		asl	ARG1
	.endrepeat
.endmacro
