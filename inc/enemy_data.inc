.include "enemy_data/1-1.inc"
.include "enemy_data/1-2.inc"
.include "enemy_data/1-3.inc"


STAGE_ENEMY_ARR:
	.addr ENEMY_ARR_11
	.addr ENEMY_ARR_12
	.addr ENEMY_ARR_13


; PLAYERは0
KURIBO_ID = $01
FLOWER_ID = $02


ENEMY_KURIBO:
	.byte $1				; 踏めるかどうか
	.byte $2				; 死んだとき（踏まれたとき）のアニメーション(anime2)
	.byte $02, $0a			; アニメーションの範囲（anime0-1(2は入らない)），アニメーション速度
	.addr KURIBO_ANIMATION_ARR
	.byte $1				; move_arrで設定している動きの数
	.addr KURIBO_MOVE_ARR
	.byte $0				; attr

ENEMY_FLOWER:
	.byte $0
	.byte $0
	.byte $02, $0a
	.addr FLOWER_ANIMATION_ARR
	.byte $3
	.addr FLOWER_MOVE_ARR
	.byte %0011_0000		; BIT5→右端超えてスポーン、BIT4→当たり判定無効

KURIBO_ANIMATION_ARR:
	; anime0, walk1
	.byte $20, $20, $21, $22		; chr
	; Attribute (VertFlip|HorizonFlip|Prio|Unused(3)|PltNum(2))
	.byte %0000_0011, %0100_0011, %0000_0011, %0000_0011		; attr
	; anime1, walk2
	.byte $20, $20, $22, $21
	.byte %0000_0011, %0100_0011, %0100_0011, %0100_0011
	; stepped on
	.byte $00, $00, $23, $23
	.byte %0000_0011, %0000_0011, %1000_0011, %1100_0011

FLOWER_ANIMATION_ARR:
	; anime0
	.byte $24, $24, $26, $26		; chr
	.byte %0010_0001, %0110_0001, %0010_0001, %0110_0001		; attr
	; anime1
	.byte $25, $25, $27, $27
	.byte %0010_0001, %0110_0001, %0010_0001, %0110_0001


KURIBO_MOVE_ARR:
	.byte $0, NEGATIVE $08, $0, $0, $70, $ff		; タイマー, X速度, Y速度（タイマーが0のとき、速度を後から更新しない）, X加速度, Y加速度、エンドコード（ff以外ならアニメーション番号を設定する）

FLOWER_MOVE_ARR:
	.byte 32, $0, NEGATIVE $08, $0, $0, $ff		; 約0.5秒上昇、アニメーション
	.byte 120, $0, 0,           $0, $0, $ff		; 2秒停止、アニメーションする
	.byte 32, $0, $08         , $0, $0, $ff		; 約0.5秒下降、アニメーション
	.byte 120, $0, 0,           $0, $0, $ff		; 2秒停止、アニメーション停止
	.byte 0										; endcode
