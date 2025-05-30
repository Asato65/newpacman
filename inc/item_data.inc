FIREFLOWER_ID = $03

FIREFLOWER_ARR:
	; chr
	.byte $20, $20, $21, $22
	; Attribute (VertFlip|HorizonFlip|Prio|Unused(3)|PltNum(2))
	.byte %0010_0010, %0110_0010, %0010_0010, %0110_0010		; attr
	.byte $0, $0			; x速度、y速度
