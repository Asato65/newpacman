; ------------------------------------------------------------------------------
; Addition without Carry
; @PARAM	VAL(Arg): Number to add
; @BREAK	A
; @RETURN	A: Added number
; ------------------------------------------------------------------------------

.macro add VAL
		clc
		adc VAL
.endmacro


; ------------------------------------------------------------------------------
; Subtraction without Carry
; @PARAM	VAL(Arg): Number to subtract
; @BREAK	A
; @RETURN	A: Subtracted number
; ------------------------------------------------------------------------------

.macro sub VAL
		sec
		sbc VAL
.endmacro


; ------------------------------------------------------------------------------
; Load array
; A = Arr[X][Y]
; @PARAM	ADDR(Arg): Array Address
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



; TODO: add/sub with X, Y register
; 足し引きする数によって分岐（+1 -> inx, +10 -> txa, add）