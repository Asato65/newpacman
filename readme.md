## Rule

### Naming convention
- constant address/value: TEST_ADDR
- variable address: test_addr
- function label: _testLabel
- macro label: testLabel
- local label: @TEST_LABEL
- file scope: TestFileName

### Comment convention
#### Function
```
;*------------------------------------------------------------------------------
; Function description
; @PARAMS		posX: character position X
; @CLOBBERS		A X tmp1 (<- register, temporary memory)
; @RETURNS		None
;*------------------------------------------------------------------------------

.scope HelloWorld						; This program is located in the "hello_world.asm".

; function
.proc _someFunc
		lda INITIAL_POS_X				; constant value
		sta tmp_addr1					; variable address
		...
		code
		...

@SKIP1:									; local label
	...
	code being created
	...

	rts
	; ----------------------------------
.endproc

.endscope
```