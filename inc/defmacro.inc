;*------------------------------------------------------------------------------
; Calcurate BG address
; @PARAM ptx: X coordinate
; @PARAM pty: Y coordinate
; @PARAM scn: Screen number
;*------------------------------------------------------------------------------

.define ADDR_BG (ptx, pty, scn)			$2000 + (ptx) + ((pty) * $20) + ((scn) * $400)
.define ADDR_BG_BE (ptx, pty, scn)		GET_BE ADDR_BG (ptx), (pty), (scn)

;*------------------------------------------------------------------------------
; Calcurate SPR address
; @PARAM spr_num: Sprite number (0~63)
; @PARAM member:
; 	pty: PosiTion Y
; 	num: Tile(8*8) number
; 	att: Attribute (VertFlip|HorizonFlip|Prio|Unused(3)|PltNum(2))
; 	ptx: PosiTion X
;*------------------------------------------------------------------------------

.define ADDR_SPR(spr_num, member)		SPR_BUFF + ((spr_num)*4) + SPR_STRUCT::member


;*------------------------------------------------------------------------------
; Get data in big endian
; dbyt = Define BYTe?
; Define word data with the hi & lo bytes swapped
; ($1234=$12,$34)
;*------------------------------------------------------------------------------

.define GET_BE(data)					.dbyt data


;*------------------------------------------------------------------------------
; Get obj position
; @PARAM	posX, posY
; @RETURN	$YX
;*------------------------------------------------------------------------------
.define GET_OBJ_POS (posX, posY)		(posY) * $10 + (posX)