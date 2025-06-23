; ------------------------------------------------------------------------------
; Load array
; A = Arr[X][Y]
; @PARAMS		ADDR: Array Address
; @PARAMS		X Y: index (Access Arr[x][y])
; @CLOBBERS		(ldarr_addr_tmp)
; ------------------------------------------------------------------------------

.code									; ----- code -----

.macro ldarr addr
		.if !(.blank(addr))
			tya
			pha
			txa
			asl								; ×2（アドレスが16bitなのでARR[x][y]のxが+1 => 読み込むアドレスは+2する必要がある
			tay								; アドレッシングに使うためYレジスタへ
			lda addr, y						; Low
			sta ldarr_addr_tmp+0
			lda addr+1, y					; High
			sta ldarr_addr_tmp+1
			pla
			tay
			lda (ldarr_addr_tmp), y
		.else
			.error "Arg addr in macro ldarr is wrong."
		.endif
.endmacro


; ------------------------------------------------------------------------------
; Calculate Negative Numbers
; ------------------------------------------------------------------------------

.code									; ----- code -----

.macro cnn
		eor #$ff
		add #$01
.endmacro


; ------------------------------------------------------------------------------
; Addition
; This Macro only supports Immediate/Zeropage/Absolute addressing.
; Other addressing modes are not optimized for speed.
; Other addressing usage: add a, {$00, x} / add a, {($00), y}
; @PARAMS		arg1: register or Address
; @PARAMS		arg2
; ------------------------------------------------------------------------------

.code									; ----- code -----

.macro add arg1, arg2
		.if (.paramcount = 1)
			; arg1: val
			; add #3 / add $80
			clc
			adc arg1
		.elseif (.paramcount = 2)
			; arg1: target
			; arg2: val
			.if (.match({arg1}, a))
				; add a, #3 / add a, $80
				clc
				adc arg2
			.elseif (.match({arg1}, x))
				; add x, ??
				.if (\
					.match(.left(1, {arg2}), #) &&\
					.right(.tcount({arg2})-1, {arg2}) <= 7\
				)
					; add x, #0~7
					.repeat (.right(.tcount({arg2})-1, {arg2}))
						inx
					.endrepeat
				.else
					pha
					txa
					clc
					adc arg2
					tax
					pla
				.endif
			.elseif (.match({arg1}, y))
				; add y, ??
				.if (\
					.match(.left(1, {arg2}), #) &&\
					.right(.tcount({arg2})-1, {arg2}) <= 7\
				)
					; add y, #0~7
					.repeat (.right(.tcount ({arg2})-1, {arg2}))
						iny
					.endrepeat
				.else
					pha
					tya
					clc
					adc arg2
					tay
					pla
				.endif
			.endif
		.else
			.error "Args in macro add are wrong."
		.endif
.endmacro


; ------------------------------------------------------------------------------
; Subtraction
; See macro add for comments
; @PARAMS		arg1: register or Address
; @PARAMS		arg2
; ------------------------------------------------------------------------------

.code									; ----- code -----

.macro sub arg1, arg2
		.if (.paramcount = 1)
			sec
			sbc arg1
		.elseif (.paramcount = 2 && .match({arg1}, a))
			sec
			sbc arg2
		.elseif (.paramcount = 2 && .match({arg1}, x))
			.if (\
				.match(.left(1, {arg2}), #) &&\
				.right(.tcount({arg2})-1, {arg2}) <= 7\
			)
				.repeat (.right(.tcount({arg2})-1, {arg2}))
					dex
				.endrepeat
			.else
				pha
				txa
				sec
				sbc arg2
				tax
				pla
			.endif
		.elseif (.paramcount = 2 && .match({arg1}, y))
			.if (\
				.match(.left(1, {arg2}), #) &&\
				.right(.tcount({arg2})-1, {arg2}) <= 7\
			)
				.repeat (.right(.tcount ({arg2})-1, {arg2}))
					dey
				.endrepeat
			.else
				pha
				tya
				sec
				sbc arg2
				tay
				pla
			.endif
		.else
			.error "Args in macro sub are wrong."
		.endif
.endmacro


;*------------------------------------------------------------------------------
; Light shift
; arg1 <<= c
; @PARAMS		c: default=#1
;*------------------------------------------------------------------------------

.code									; ----- code -----

.macro shl c
		.if (.blank(c))
			asl
		.elseif (.match(.left(1, {c}), #))
			.repeat	(.right(.tcount ({c})-1, {c}))
				asl
			.endrepeat
		.else
			.error "Arg \"c\" in macro shl is wrong."
		.endif
.endmacro


;*------------------------------------------------------------------------------
; Right shift
; arg1 >>= c
; @PARAMS		c: default=#1
;*------------------------------------------------------------------------------

.code									; ----- code -----

.macro shr c
		.if (.blank(c))
			lsr
		.elseif (.match(.left(1, {c}), #))
			.repeat	(.right(.tcount ({c})-1, {c}))
				lsr
			.endrepeat
		.else
			.error "Arg \"c\" in macro shr is wrong."
		.endif
.endmacro


;*------------------------------------------------------------------------------
; Arithmetic left shift
;! Deprecated (Not shortened)
; A >>= c
; @PARAMS		c: default=1
;*------------------------------------------------------------------------------

.code									; ----- code -----

.macro ashl c
		cmp #%1000_0000
		php								; Save carry
		.if (.blank(c))
			; ashl
			shl #2
		.elseif (.match(.left(1, {c}), #))
			; ashl #4
			shl #((.right(.tcount ({c})-1, {c})) + 1)
		.else
			.error "Arg \"c\" in macro ashl is wrong."
		.endif
		plp
		ror								; a /= 2, carry into bit7
.endmacro


;*------------------------------------------------------------------------------
; Arithmetic right shift
; A >>= c
; @PARAMS		c: default=1
;
; To ASR a memory location
; (From http://wiki.nesdev.com/w/index.php/Synthetic_instructions#Arithmetic_shift_right)
; 	lda addr		; Copy memory into A
; 	asl				; Copy sign bit of A into carry (shorter than CMP)
; 	ror addr
;*------------------------------------------------------------------------------

.code									; ----- code -----

.macro ashr c
		.if (.blank(c))
			; ashr
			cmp #%1000_0000				; Bit7 into carry
			ror							; Shift carry into Bit7
		.elseif (.match(.left(1, {c}), #))
			; ashr #4
			.repeat (.right(.tcount ({c})-1, {c}))
				cmp #%1000_0000
				ror
			.endrepeat
		.else
			.error "Arg \"c\" in macro ashr is wrong."
		.endif
.endmacro


;*------------------------------------------------------------------------------
; パレット転送
; 背景色はbg_color, パレットデータはplt_datasの中身を使用
;*------------------------------------------------------------------------------

.macro tfrPlt
		; Transfar palette
		lda #>PLT_TABLE_ADDR
		sta PPU_ADDR
		lda #<PLT_TABLE_ADDR			; Addr lo = 0
		sta PPU_ADDR
		tax								; X = 0
:
		ldy #3
		lda bg_color
		sta PPU_DATA
:
		lda plt_datas, x				; under ground -> UNDER_GROUND_PLT
		sta PPU_DATA
		inx
		dey
		bne :-
		cpx #$3*8
		bcc :--
.endmacro