.include "enemy_data/1-1.inc"
.include "enemy_data/1-2.inc"
.include "enemy_data/1-3.inc"


STAGE_ENEMY_ARR:
	.addr ENEMY_ARR_11
	.addr ENEMY_ARR_12
	.addr ENEMY_ARR_13


; PLAYERは0
KURIBO_ID = $01


ENEMY_KURIBO:
	.byte $1				; 踏めるかどうか
	.byte $2				; 死んだとき（踏まれたとき）のアニメーション(anime2)
	.byte $02, $0a			; アニメーションの範囲（anime0-1(2は入らない)），アニメーション速度
	.addr KURIBO_ANIMATION_ARR
	.byte $1				; move_arrで設定している動きの数
	.addr KURIBO_MOVE_ARR


KURIBO_ANIMATION_ARR:
	; anime0, walk1
	.byte $20, $20, $21, $22		; chr
	.byte %0000_0011, %0100_0011, %0000_0011, %0000_0011		; attr
	; anime1, walk2
	.byte $20, $20, $22, $21
	.byte %0000_0011, %0100_0011, %0100_0011, %0100_0011
	; stepped on
	.byte $00, $00, $23, $23
	.byte %0000_0011, %0000_0011, %1000_0011, %1100_0011


KURIBO_MOVE_ARR:
	.byte $0, NEGATIVE $08, $0, $0, $70, $ff		; タイマー, X速度, Y速度（タイマーが0のとき、速度を後から更新しない）, X加速度, Y加速度、エンドコード（ff以外ならアニメーション番号を設定する）
	/* パックンフラワーなら:
	.byte 32, $0, NEGATIVE $08, $0, $0, $0		; 約0.5秒上昇、アニメーションは0番目で固定
	.byte 120, $0, 0,           $0, $0, $ff		; 2秒停止、アニメーションする
	.byte 32, $0, $08         , $0, $0, $0		; 約0.5秒下降、アニメーションは0番目で固定
	.byte 120, $0, 0,           $0, $0, 0		; 2秒停止、アニメーション停止
	これを繰り返すようになる
	*/


