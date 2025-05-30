; MAP_DATA[stage][map_num][index]

.include "map/1-1.inc"
.include "map/1-2.inc"
.include "map/1-3.inc"

.include "asm/collision_func_list.asm"


STAGE_ARR:
	.addr MAP_ARR_11
	.addr MAP_ARR_12
	.addr MAP_ARR_13


STAGE_PALETTE_ARR:
	.byte $1, $0, $0



BLOCK_ID_ARR:
	; 40 = %0100
	.addr OBJ_SKY						; @ (or 0)
	.addr $0000							; A
	.addr OBJ_BLOCK						; B
	.addr $0000							; C
	.addr $0000							; D
	.addr $0000							; E
	.addr $0000							; F
	.addr OBJ_GROUND					; G
	.addr OBJ_HARD_BLOCK				; H
	.addr OBJ_INVISIBLE_BLOCK			; I
	.addr $0000							; J
	.addr $0000							; K
	.addr $0000							; L
	.addr $0000							; M
	.addr OBJ_HARD2_BLOCK				; N
	.addr $0000							; O
	; 50 = %0101
	.addr $0000							; P
	.addr OBJ_QBLOCK					; Q
	.addr $0000							; R
	.addr $0000							; S
	.addr $0000							; T
	.addr $0000							; U
	.addr $0000							; V
	.addr $0000							; W
	.addr $0000							; X
	.addr $0000							; Y
	.addr $0000							; Z
	.addr OBJ_QBLOCK					; [（フラワーが出るブロック）
	.addr $0000							; \
	.addr $0000							; ]
	.addr OBJ_COIN						; ^
	.addr $0000							; _
	; 60 = %0110
	.addr OBJ_PIPE_LEFT					; `
	.addr OBJ_PIPE_UPPER_LEFT			; a
	.addr OBJ_PIPE_RIGHT				; b
	.addr OBJ_PIPE_UPPER_RIGHT			; c
	.addr OBJ_GOAL_POAL					; d
	.addr OBJ_GOAL_BALL					; e
	.addr $0000							; f
	.addr $0000							; g
	.addr OBJ_HIDE_BLOCK				; h
	.addr $0000							; i
	.addr $0000							; j
	.addr $0000							; k
	.addr $0000							; l
	.addr $0000							; m
	.addr $0000							; n
	.addr $0000							; o
	; 70 = %0111
	.addr $0000							; p
	.addr $0000							; q
	.addr $0000							; r
	.addr $0000							; s
	.addr $0000							; t
	.addr $0000							; u
	.addr $0000							; v
	.addr $0000							; w
	.addr $0000							; x
	.addr $0000							; y
	.addr $0000							; z
	.addr $0000							; {
	.addr $0000							; |
	.addr $0000							; }
	.addr $0000							; ~


BLOCK_COLLISION_SETTING:
	; BIT7は、当たり判定を全方位同じにするかどうか（0で全方位同じ）
	; BIT6は、当たり判定を行うかどうか（0のとき当たり判定無効）
	; ほかの7ビットで、当たり判定の処理のポインターリストのインデックスを指定する
	; 40 = %0100
	.byte $00							; @
	.byte $00							; A
	.byte $C0+$00						; B
	.byte $00							; C
	.byte $00							; D
	.byte $00							; E
	.byte $00							; F
	.byte $40+$02						; G
	.byte $40+$03						; H
	.byte $C0+$04						; I
	.byte $00							; J
	.byte $00							; K
	.byte $00							; L
	.byte $00							; M
	.byte $40+$06						; N
	.byte $00							; O
	; 50 = %0101
	.byte $00							; P
	.byte $C0+$07						; Q
	.byte $00							; R
	.byte $00							; S
	.byte $00							; T
	.byte $00							; U
	.byte $00							; V
	.byte $00							; W
	.byte $00							; X
	.byte $00							; Y
	.byte $00							; Z
	.byte $C0+$09						; [
	.byte $00							; \
	.byte $00							; ]
	.byte $40+$0b						; ^
	.byte $00							; _
	; 60
	.byte $40+$0c						; `
	.byte $40+$0d						; a
	.byte $40+$0e						; b
	.byte $40+$0f						; c
	.byte $40+$10						; d
	.byte $40+$11						; e
	.byte $00							; f
	.byte $00							; g
	.byte $C0+$12						; h
	.byte $00							; i
	.byte $00							; j
	.byte $00							; k
	.byte $00							; l
	.byte $00							; m
	.byte $00							; n
	.byte $00							; o
	; 70
	.byte $00							; p
	.byte $00							; q
	.byte $00							; r
	.byte $00							; s
	.byte $00							; t
	.byte $00							; u
	.byte $00							; v
	.byte $00							; w
	.byte $00							; x
	.byte $00							; y
	.byte $00							; z
	.byte $00							; {
	.byte $00							; |
	.byte $00							; }
	.byte $00							; ~


BLOCK_COLLISION_FUNC:
	.addr _collisionHardBlock, _collisionRengaBlock
	.addr _collisionHardBlock
	.addr _collisionHardBlock
	.addr _void, _collisionCoinBlock
	.addr _collisionHardBlock
	.addr _collisionHardBlock, _collisionCoinBlock
	.addr _collisionHardBlock, _collisionFlowerBlock
	.addr _collisionCoin
	.addr _collisionHardBlock
	.addr _collisionHardBlock
	.addr _collisionHardBlock
	.addr _collisionHardBlock
	.addr _collisionGoal
	.addr _collisionGoal
	.addr _void, _collisionCoinBlock

OBJ_SKY:
	.byte $00, $00
	.byte $00, $00

OBJ_QBLOCK:
	.byte $90, $91
	.byte $92, $93

OBJ_BLOCK:
	.byte $94, $94
	.byte $95, $95

OBJ_COIN:
	.byte $84, $85
	.byte $86, $87

OBJ_GROUND:
	.byte $80, $81
	.byte $82, $83

OBJ_HARD_BLOCK:
	.byte $8c, $8d
	.byte $8e, $8f

OBJ_PIPE_UPPER_LEFT:
	.byte $98, $99
	.byte $9a, $9b

OBJ_PIPE_UPPER_RIGHT:
	.byte $9c, $9d
	.byte $9e, $9f

OBJ_PIPE_LEFT:
	.byte $a0, $a1
	.byte $a0, $a1

OBJ_PIPE_RIGHT:
	.byte $02, $a2
	.byte $02, $a2

OBJ_GOAL_POAL:
	.byte $a4, $a5
	.byte $a4, $a5

OBJ_GOAL_BALL:
	.byte $00, $00
	.byte $a6, $a7

BG_BLOCK:
	.byte $95, $95
	.byte $95, $95

BG_DOOR_LOWER:
	.byte $03, $03
	.byte $03, $03

BG_DOOR_UPPER:
	.byte $aa, $ab
	.byte $03, $03

BG_FORT_1:
	.byte $a8, $a9
	.byte $95, $95

BG_FORT_2:
	.byte $aa, $ab
	.byte $95, $95

BG_FORT_3:
	.byte $95, $03
	.byte $95, $03

OBJ_HIDE_BLOCK:
	.byte $00, $00
	.byte $00, $00

OBJ_HARD2_BLOCK:
	.byte $88, $89
	.byte $8a, $8b

OBJ_INVISIBLE_BLOCK:
	.byte $00, $00
	.byte $00, $00