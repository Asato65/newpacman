;*------------------------------------------------------------------------------
; Calcurate BG address（BE=Big Endian）
; @PARAMS	 ptx: X coordinate
; @PARAMS	 pty: Y coordinate
; @PARAMS	 scn: Screen number
;*------------------------------------------------------------------------------

.define ADDR_BG (ptx, pty, scn)			$2000 + (ptx) + ((pty) * $20) + ((scn) * $400)
.define ADDR_BG_BE (ptx, pty, scn)		GET_BE ADDR_BG (ptx), (pty), (scn)

;*------------------------------------------------------------------------------
; Calcurate SPR address
; @PARAMS	 spr_num: Sprite number (0~63)
; @PARAMS	 member:
; 	pty: PosiTion Y
; 	num: Tile(8*8) number
; 	att: Attribute (VertFlip|HorizonFlip|Prio|Unused(3)|PltNum(2))
; 	ptx: PosiTion X
;*------------------------------------------------------------------------------

.define ADDR_SPR(spr_num, member)		CHR_BUFF + ((spr_num)*4) + SPR_STRUCT::member


;*------------------------------------------------------------------------------
; Get data in big endian
; dbyt = Define BYTe?
; Define word data with the hi & lo bytes swapped
; ($1234=$12,$34)
;*------------------------------------------------------------------------------

.define GET_BE(data)					.dbyt data


;*------------------------------------------------------------------------------
; SMB風レベルヘッダーとオブジェクトデータ
;   Header1: ttsssmmm  timer/start_y/modifier
;   Header2: ffbboooo  floor/scenery/floor_pattern
;   ObjPos : xxxxyyyy  x/y
;   Obj    : ptttssss  next_page/type/size
;*------------------------------------------------------------------------------

.define SMB_LEVEL_HEADER1(timer, start_y, modifier)	((timer) * $40 + (start_y) * $08 + (modifier))
.define SMB_LEVEL_HEADER2(floor, scenery, pattern)	((floor) * $40 + (scenery) * $10 + (pattern))
.define SMB_OBJ_POS(posX, posY)						((posX) * $10 + (posY))
.define SMB_OBJ(type, size)							((type) * $10 + (size))
.define SMB_OBJ_NEXT(type, size)					(BIT7 + (type) * $10 + (size))

; 短いマップ定義用エイリアス。既存のSMB_*は互換用に残す
.define LH1(timer, start_y, modifier)				((timer) * $40 + (start_y) * $08 + (modifier))
.define LH2(floor, scenery, pattern)				((floor) * $40 + (scenery) * $10 + (pattern))
.define XY(posX, posY)								((posX) * $10 + (posY))
.define O(type, size)								((type) * $10 + (size))
.define ON(type, size)								(BIT7 + (type) * $10 + (size))
.define S(id)										(id)
.define SN(id)										(BIT7 + (id))
.define ST(width)									((width) - 1)
.define STR(width)									((width) - 1)

;*------------------------------------------------------------------------------
; Return negative number
;*------------------------------------------------------------------------------

.define NEGATIVE(val)	256 - (val)



; obj and next line
; used in objects.inc
.define OBJ(obj, nextline) nextline*$80 + obj
