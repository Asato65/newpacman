FIREFLOWER_ID = $03

FIREFLOWER_ARR:
	; chr
	.byte $f8, $f8, $f9, $f9
	; Attribute (VertFlip|HorizonFlip|Prio|Unused(3)|PltNum(2))
	.byte %0010_0000, %0110_0000, %0010_0000, %0110_0000		; attr
	.byte $0, $0			; x速度、y速度
