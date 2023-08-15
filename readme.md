# MY NES PROGRAM 4

## Rule

### Naming convention
- constant address/value: TEST_ADDR
- variable address: test_addr
- function/macro label: testLabel
- local label: @TEST_LABEL

### Comment convention
#### Function
```
;*------------------------------------------------------------------------------
; Function description
; @PARAM	data1
; @PARAM	None
; @BREAK	A X tmp1 (register, temporary memory)
; @RETURN	None
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