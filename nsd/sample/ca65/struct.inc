
;************************************************************************
;*		�X�v���C�g						*
;************************************************************************

;�P�v�f
.Struct	SPR_ONE
	pty	.byte
	num	.byte
	att	.byte
	ptx	.byte
.Endstruct

;�S��
.Struct	SPR_TBL
	spr	.tag	SPR_ONE		64
.Endstruct
