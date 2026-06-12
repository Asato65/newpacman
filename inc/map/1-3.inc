MAP_ARR_13:
	.addr MAP_13_TEST
	; .addr MAP_13_1_NEW
	; .addr MAP_13_2_NEW
	; .addr MAP_13_3_NEW
	.addr $ffff

MAP_13_TEST:
	.byte (LH1 $0, $5, $0)
	.byte (LH2 $0, $0, $1)					; 床パターン1: 下2段だけ地面

	; テスト用マップ。左から右へ、同じページ内ではX昇順で並べる。
	; abc=0の単体は (S BLK_*) だけで置ける。
	.byte (XY $1, $7), (S BLK_Q)				; 単体はてな
	.byte (XY $3, $7), (S BLK_HARD)				; 単体ブロック
	.byte (XY $4, $5), (O OBJ_COIN_ROW, $f)		; 可変横列: コイン15個
	.byte (XY $4, $7), (O OBJ_BRICK_ROW, $6)	; 可変横列: レンガ6個
	.byte (XY $8, $9), (O OBJ_PIPE, PIPE_2)		; 固定パーツ: 土管
	.byte (XY $a, $c), (O SP_HOLE, $4)			; y=12: 幅4の落とし穴

	.byte (XY $0, $f), (ON SP_STAIRS, ST(4))	; 次ページ: 4段階段
	.byte (XY $4, $7), (O OBJ_HARD_COL, $4)		; 可変縦列: 硬いブロック4個
	.byte (XY $6, $f), (O SP_STAIRS_REV, STR(4))	; 逆4段階段
	.byte (XY $b, $f), (O SP_STAIRS, ST(9))		; 9列階段。高さ8で横へ伸びる
	.byte (XY $e, $7), (O OBJ_BRICK_ROW, $f)	; 可変横列: ページまたぎ15個
	.byte (XY $f, $b), (S BLK_BRICK)			; 地面の高さ以下なので無視される

	.byte OBJ_END

MAP_13_1_NEW:
	.byte (SMB_LEVEL_HEADER1 $0, $5, $0)
	.byte (SMB_LEVEL_HEADER2 $0, $0, $1)

	; SMB風タイルデータ:
	;   1バイト目 xxxxyyyy = X/Y
	;   2バイト目 p abc defg = 次画面/type/size
	;   終端は $fd。次画面に進む最初のオブジェクトだけSMB_OBJ_NEXTを使う
	.byte (SMB_OBJ_POS $0, $7), (SMB_OBJ_NEXT SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)	; 最初の改ページ後，x=5のハテナ
	.byte (SMB_OBJ_POS $4, $7), (SMB_OBJ SMB_OBJ_BRICK_ROW, $4)
	.byte (SMB_OBJ_POS $5, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK_POWERUP)	; レンガ列を上書き
	.byte (SMB_OBJ_POS $6, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)
	.byte (SMB_OBJ_POS $7, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)

	.byte (SMB_OBJ_POS $c, $9), (SMB_OBJ SMB_OBJ_PIPE, SMB_PIPE_2ROW)			; 土管1
	.byte (SMB_OBJ_POS $6, $8), (SMB_OBJ_NEXT SMB_OBJ_PIPE, SMB_PIPE_3ROW)				; 土管2
	.byte (SMB_OBJ_POS $e, $7), (SMB_OBJ SMB_OBJ_PIPE, SMB_PIPE_4ROW)				; 土管3
	.byte (SMB_OBJ_POS $9, $7), (SMB_OBJ_NEXT SMB_OBJ_PIPE, SMB_PIPE_4ROW)			; 土管4

	.byte (SMB_OBJ_POS $0, $6), (SMB_OBJ_NEXT SMB_OBJ_SINGLE, SMB_SINGLE_HIDE)		; 隠し
	.byte (SMB_OBJ_POS $5, $c), (SMB_OBJ SMB_SUB2_HOLE, SMB_HOLE_2COL)				; y=12: 落とし穴

	.byte (SMB_OBJ_POS $d, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $e, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)
	.byte (SMB_OBJ_POS $f, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)

	; -------------
	; TODO: ここがおかしいので修正したい
	.byte (SMB_OBJ_POS $0, $3), (SMB_OBJ_NEXT SMB_OBJ_BRICK_ROW, $8)

	.byte (SMB_OBJ_POS $6, $c), (SMB_OBJ SMB_SUB2_HOLE, SMB_HOLE_3COL)				; y=12: 広めの穴
	.byte (SMB_OBJ_POS $8, $c), (SMB_OBJ SMB_SUB2_HOLE, SMB_HOLE_3COL)				; y=12: 広めの穴
	.byte (SMB_OBJ_POS $e, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $e, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)

	; --------------

	.byte (SMB_OBJ_POS $4, $7), (SMB_OBJ_NEXT SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $5, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)			; スターが出る場所
	.byte (SMB_OBJ_POS $a, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)
	.byte (SMB_OBJ_POS $d, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)
	.byte (SMB_OBJ_POS $d, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)			; パワーアップアイテム

	.byte (SMB_OBJ_POS $0, $7), (SMB_OBJ_NEXT SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)
	.byte (SMB_OBJ_POS $6, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $9, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $a, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $b, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)

	.byte (SMB_OBJ_POS $0, $3), (SMB_OBJ_NEXT SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $1, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)
	.byte (SMB_OBJ_POS $1, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $2, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)
	.byte (SMB_OBJ_POS $2, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)
	.byte (SMB_OBJ_POS $3, $3), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)

	.byte (SMB_OBJ_POS $6, $f), (SMB_OBJ SMB_SUB3_STAIRS, SMB_STAIRS_4)			; y=15: 階段
	.byte (SMB_OBJ_POS $c, $f), (SMB_OBJ SMB_SUB3_STAIRS_REV, SMB_STAIRS_4_REVERSE)	; y=15: 逆階段

	.byte (SMB_OBJ_POS $4, $f), (SMB_OBJ_NEXT SMB_SUB3_STAIRS, SMB_STAIRS_4)		; y=15: 階段
	.byte (SMB_OBJ_POS $8, $7), (SMB_OBJ SMB_OBJ_HARD_COLUMN, $1)
	.byte (SMB_OBJ_POS $9, $5), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_SKY)
	.byte (SMB_OBJ_POS $9, $9), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_SKY)
	.byte (SMB_OBJ_POS $b, $f), (SMB_OBJ SMB_SUB3_STAIRS_REV, SMB_STAIRS_4_REVERSE)	; y=15: 逆階段

	.byte (SMB_OBJ_POS $3, $9), (SMB_OBJ_NEXT SMB_OBJ_PIPE, SMB_PIPE_2ROW)
	.byte (SMB_OBJ_POS $8, $7), (SMB_OBJ SMB_OBJ_BRICK_ROW, $4)
	.byte (SMB_OBJ_POS $a, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_QBLOCK)
	.byte (SMB_OBJ_POS $c, $7), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_SKY)

	.byte (SMB_OBJ_POS $3, $9), (SMB_OBJ_NEXT SMB_OBJ_PIPE, SMB_PIPE_2ROW)
	.byte (SMB_OBJ_POS $5, $f), (SMB_OBJ SMB_SUB3_STAIRS, SMB_STAIRS_8)			; y=15: 8段階段
	.byte (SMB_OBJ_POS $d, $3), (SMB_OBJ SMB_OBJ_HARD_COLUMN, $1)
	.byte (SMB_OBJ_POS $d, $7), (SMB_OBJ SMB_OBJ_HARD_COLUMN, $1)

	.byte (SMB_OBJ_POS $6, $f), (SMB_OBJ_NEXT SMB_SUB3_CASTLE, SMB_CASTLE_SMALL)	; y=15: ゴール/城系
	.byte (SMB_OBJ_POS $d, $a), (SMB_OBJ SMB_OBJ_SINGLE, SMB_SINGLE_BRICK)

	.byte OBJMAP_END
