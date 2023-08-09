# MY NES PROGRAM 4

## Rule

### Naming convention
- constant address: TEST_ADDR
- variable address: test_addr
- function/macro label: testLabel
- local label: @TEST_LABEL

### Comment convention
#### Function
```asm:
;*------------------------------------------------------------------------------
; Function description
; @PARAM data1
; @PARAM void
; @BREAK A, X, tmp1 (register, temporary memory)
; @RETURN void
;*------------------------------------------------------------------------------

someFunc:
		...
		code
		...

	...
	code being created
	...

	rts	; ------------------------------

```