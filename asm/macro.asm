; ------------------------------------------------------------------------------
; Load array
; A = Arr[X][Y]
; @PARAM	ADDR: Array Address
; @PARAM	X Y: index (Access Arr[x][y])
; @BREAK	A tmp1
; @RETURN	A
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
; This Macro is not support Indirect addressing.
; (Usage: add a, {$00, x})
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
				.if (
					.match(.left(1, {VAL}), #) &&
					.right(.tcount({VAL})-1, {VAL}) <= 7
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
				.if (
					.match(.left(1, {VAL}), #) &&
					.right(.tcount({VAL})-1, {VAL}) <= 7
				)
					; add y, #0~7
					.repeat (.right (.tcount ({VAL})-1, {VAL}))
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
			.else
				; add $00, ??
				.if (
					.match(.left(1, {VAL}), #) &&
					.right(.tcount({VAL})-1, {VAL}) <= 2
				)
					; add $00, #0~2
					.repeat (.right (.tcount ({VAL})-1, {VAL}))
						inc ARG1
					.endrepeat
				.else
					pha
					lda ARG1
					clc
					adc VAL
					sta ARG1
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
		sec
	.if (.blank(ARG1) || .match({ARG1}, a))
		sbc VAL
	.elseif (.match({ARG1}, x))
		pha
		txa
		sbc VAL
		tax
		pla
	.elseif (.match({ARG1}, y))
		pha
		tya
		sbc VAL
		tay
		pla
	.else
		pha
		lda ARG1
		sbc VAL
		pla
.endmacro



;*------------------------------------------------------------------------------
; arithmetic right shift
; @PARAM	ARG: register A or Address
;*------------------------------------------------------------------------------

.macro asr ARG
	.if (.blank(ARG) || .match({ARG}, a))
		cmp #%10000000					; Bit 7 into carry
		ror								; Shift carry into bit 7
	.else
		pha
		lda ARG
		cmp #%10000000
		ror ARG
		pla
	.endif
.endmacro
