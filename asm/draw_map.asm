.include "draw_map_macro.asm"

.scope DrawMap

.ZeroPage
map_buff_num			: .byte 0		; マップの番号（0: 最初のscreen1，1: screen2, 2: 次のscreen1 → というデータ）
map_arr_addr			: .addr 0
map_addr				: .addr 0		; SMB風マップデータ（2バイトheader + 2バイトobj列）
isend_draw_stage		: .byte 0
row_counter				: .byte 0		; Every time this prg executed -> increment
index					: .byte 0		; index of map_addr
cnt_map_next			: .byte 0		; obj bit7とmap断片切替で進めたページ数
map_arr_num				: .byte 0
fill_upper				: .byte 0
fill_lower				: .byte 0
fill_ground_block		: .byte 0
fill_block				: .byte 0
fill_ground_end			: .byte 0		; 下側の地面の厚み。落とし穴で消す行数
fill_ground_start		: .byte 0		; 下側の地面が始まる行
hole_remain				: .byte 0		; y=12の落とし穴が残り何列続くか
objtype					: .byte 0
objsize					: .byte 0
bg_page					: .byte 0
bg_target_page			: .byte 0
bg_target_tile_x		: .byte 0
bg_obj_base_x			: .byte 0
bg_obj_base_y			: .byte 0
bg_obj_local_x			: .byte 0
bg_obj_tile				: .byte 0

;*------------------------------------------------------------------------------
; Update one row
; @PARAMS		None
; @CLOBBERS		A X Y tmp1 tmp2 addr_tmp1 addr_tmp2
; @RETURNS		None
/* main label
	@START:
	@GET_POS_AND_OBJ_LOOP:
	@END_OF_MAP:						-> load next map chunk
	@END_OF_STAGE:						-> goto nextlabel (@PREPARE_BG_MAP_BUF)
	@PREPARE_BG_MAP_BUF:
	@STORE_BG_MAP_BUF_LOOP:
*/
/*
	大まかな流れ:
	1. row_counterを進め，今回更新する画面内X列を決める
	2. fill_block_arrから地面や穴の基本ブロックをBGバッファへ敷く
	3. 前の列から続いている横長パーツをスロットから再開して描く
	4. SMB風の「位置($XY) + 設定(p abc defg)」で新しいパーツを読む
	5. BGバッファの1列分をPPU転送用バッファへ詰め直す
*/
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _updateOneLine
		lda #1
		sta is_updated_map

		incRowCounter

		lda DrawMap::map_buff_num
		and #BIT0
		ora #4
		sta addr_tmp2+HI

		lda DrawMap::row_counter
		sta addr_tmp2+LO				; unused

		fillBlocks
		jsr _applyActiveHole

; ------------ slot parts --------------
		ldx #$ff
@SLOT_LOOP:
		inx
		cpx #8
		beq @CHECK_IS_END_STAGE
		lda used_part_slots
		and NUM2BIT, x
		beq @SLOT_LOOP
		txa
		pha
		; load slot data
		; addr hi
		lda addr_tmp2+HI
		sta addr_tmp1+HI
		; addr lo（$043f->$0540のように，画面境界で下の行へ行かないように）
		lda part_slot_addr_arr, x
		and #%1111_0000
		sta tmp1
		lda part_slot_addr_arr, x
		add #1
		and #%0000_1111
		ora tmp1
		sta addr_tmp1+LO
		sta tmp2
		; index
		lda map_data_index_arr, x
		sta tmp1
		lda part_slot_index_arr, x
		sta tmp3
		jsr _setParts					; arg: tmp1, tmp2, addr_tmp1
		pla
		tax
		jmp @SLOT_LOOP

@CHECK_IS_END_STAGE:
		lda DrawMap::isend_draw_stage
		beq @SET_NEW_PARTS
		jmp @PREPARE_BG_MAP_BUF

;--- -------- new parts ----------------
@SET_NEW_PARTS:
		ldy DrawMap::index
@SET_NEW_PARTS_LOOP:
		; 1バイト目: xxxxyyyy
		;   上位4bit = 画面内X列，下位4bit = Y座標
		;   $fdだけはSMBと同じ終端コードとして扱う
		sty tmp4						; 位置バイトのindexを保存
		lda (DrawMap::map_addr), y
		sta tmp5						; 位置($XY)
		cmp #OBJMAP_END
		beq @END_OF_MAP

		; 2バイト目: p abc defg
		;   p=1なら，このオブジェクトが次の画面に属する
		iny
		lda (DrawMap::map_addr), y
		sta tmp6						; 設定(pabc defg)

		; まず対象画面を確認する。pは対象画面の計算だけに使い，
		; 実際にオブジェクトを消費するときまでcnt_map_nextは進めない
		and #BIT7
		beq @TARGET_CURRENT_PAGE
		lda DrawMap::cnt_map_next
		add #1
		jmp @CHECK_TARGET_PAGE
@TARGET_CURRENT_PAGE:
		lda DrawMap::cnt_map_next
@CHECK_TARGET_PAGE:
		cmp DrawMap::map_buff_num
		bne @SET_NEW_PARTS_LOOP_EXIT

		; 現在描いているX列に来たオブジェクトだけ展開する
		lda tmp5
		and #BYT_GET_HI
		shr #4
		cmp DrawMap::row_counter
		bne @SET_NEW_PARTS_LOOP_EXIT

		; p=1のオブジェクトをここで初めて消費するので，画面カウンタを進める
		lda tmp6
		and #BIT7
		beq :+
		inc DrawMap::cnt_map_next
:
		; y=13/14は描画しないコマンド。現時点では最低限，読み飛ばして動かす
		lda tmp5
		and #BYT_GET_LO
		cmp #$0d
		beq @SKIP_COMMAND_OBJ
		cmp #$0e
		beq @SKIP_COMMAND_OBJ

		; y=12/abc=落とし穴は，床パターンの下側地面だけを列ごとに抜く
		lda tmp5
		and #BYT_GET_LO
		cmp #$0c
		bne @DRAW_NORMAL_OBJ
		lda tmp6
		and #%0111_0000
		cmp #(SMB_SUB2_HOLE * $10)
		bne @DRAW_NORMAL_OBJ
		tya								; 穴処理はtmp1を使うので、読み取り位置はスタックに退避する
		pha
		jsr _startHoleFromMapObj
		pla
		tay
		iny								; 位置+落とし穴の2バイトを消費
		jmp @SET_NEW_PARTS_LOOP

@DRAW_NORMAL_OBJ:
		lda DrawMap::map_buff_num
		; -- Set addr of bg map buff ---
		and #BIT0
		ora #4
		sta addr_tmp1+HI

		jsr _setObjAddrLoFromSmbPos
		lda addr_tmp1+LO
		sta addr_tmp1+LO
		sta tmp2						; save (to restore)

		; tmp1には2バイト目のindexを保存する。
		; スロット継続時にも，同じpabc defgを読み直してPARTS_*を復元する
		sty tmp1
		lda #0
		sta tmp3
		ldx #$ff
		jsr _setParts					; don't break tmp1
		ldy tmp1
		iny								; 位置+type/sizeの2バイトを消費
		jmp @SET_NEW_PARTS_LOOP

@SKIP_COMMAND_OBJ:
		iny								; 位置+コマンドの2バイトを消費
		jmp @SET_NEW_PARTS_LOOP

@SET_NEW_PARTS_LOOP_EXIT:
		ldy tmp4						; まだ消費していない位置バイトから再開する
		sty DrawMap::index
		jmp @PREPARE_BG_MAP_BUF
		; ------------------------------

		; End of map data (Not end of stage)
@END_OF_MAP:
		loadNextMap

		cmp #ENDCODE
		beq @END_OF_STAGE

		; MAP_ARR内の次の断片は，旧ページ送り相当として次画面から始める
		inc DrawMap::cnt_map_next

		ldy DrawMap::index
		jmp @PREPARE_BG_MAP_BUF
		; ------------------------------

@END_OF_STAGE:
		ldy #0
		sty DrawMap::index
		iny								; Y = 1
		sty DrawMap::isend_draw_stage

@PREPARE_BG_MAP_BUF:
		lda DrawMap::row_counter
		sta addr_tmp1+LO				; PosY = 0

		lda DrawMap::map_buff_num
		and #BIT0
		ora #4
		sta addr_tmp1+HI

		setPpuBgAddr

		; Store plt addr(ppu)
		lda addr_tmp1+LO				; posX
		shr #1
		add #$c0
		sta ppu_attr_addr+LO

		lda addr_tmp1+HI
		and #1
		shl #2
		add #$23
		sta ppu_attr_addr+HI

		jsr _loadBgMap1AttrForColumn

		ldy #0
		sty bg_map_buff_index

@STORE_BG_MAP_BUF_LOOP:					; for (y = 0; y < $0d; y++)
		tya
		shl #4
		tay
		lda (addr_tmp1), y

		; prepare plt data -------------
		sty tmp2						; (save counter) += $10
		ldy tmp1						; (save counter) += 1
		pha								; push
		and #BIT5|BIT4
		tax								; X: plt num(bit4-5) : tmp (Start using)
		lda DrawMap::row_counter
		and #BIT0
		sta tmp3
		tya
		and #BIT0
		shl #1
		ora tmp3
		sta tmp3

		; y /= 2 (Use @PLT0) -> MEMO: 短縮可能
		tya
		shr #1
		tay

		txa								; End using X (plt num)
		ldx tmp3
		/*
		PLT_DATA = BLOCK3|BLOCK2|BLOCK1|BLOCK0
		-------------------------------
		| BLOCK0(>>4) | BLOCK1(>>2) |
		| BLOCK2(0)   | BLOCK3(<<2) |
		-------------------------------
		*/
		beq @BLOCK0
		dex
		beq @BLOCK1
		dex
		beq @BLOCK2
		dex
		beq @BLOCK3
@BLOCK0:
		shr #4
		jmp @ADD_LEFT_BLOCK_PLT
		; ------------------------------
@BLOCK1:
		shr #2
		jmp @ADD_LEFT_BLOCK_PLT
		; ------------------------------
@BLOCK3:
		shl #2
@BLOCK2:
@ADD_LEFT_BLOCK_PLT:
		ora ppu_attr_buff, y
@STORE_TO_PLT_BUFF:
		sta ppu_attr_buff, y

		pla								; pull
		ldy tmp2

		and #BIT5|BIT4|BIT3|BIT2|BIT1|BIT0
		shl #1

		tax
		tfrToBgMapBuf

		ldy tmp1
		iny
		sty tmp1
		cpy #$0d
		bcc @STORE_BG_MAP_BUF_LOOP

		jsr _drawBgMap1ToBgMapBuff
		rts
		;-------------------------------
.endproc


;*------------------------------------------------------------------------------
; BG_MAP1_PLTから，現在の16x16列に対応する属性データをppu_attr_buffへ読む
; @PARAMS		DrawMap::map_buff_num / row_counter
; @CLOBBERS		A X Y tmp1 tmp2 tmp3
; @RETURNS		None
;
; データ内のbit7は「次画面へ進む」。地形マップと同じく，左から順に読む。
; ppu_attr_buffはここで0クリアし，背景属性を下地として入れる。
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _loadBgMap1AttrForColumn
		lda DrawMap::map_buff_num
		sta DrawMap::bg_target_page

		lda #0
		sta DrawMap::bg_page
		tax
@CLEAR_LOOP:
		sta ppu_attr_buff, x
		inx
		cpx #7
		bcc @CLEAR_LOOP

		ldy #0
@LOOP:
		lda BG_MAP1_PLT, y
		cmp #BG_SCENERY_END
		beq @EXIT
		sta tmp1						; dxxx0yyy
		iny
		lda BG_MAP1_PLT, y
		sta tmp2						; aabbccdd
		iny

		lda tmp1
		and #BIT7
		beq :+
		inc DrawMap::bg_page
:
		lda DrawMap::bg_page
		cmp DrawMap::bg_target_page
		bne @LOOP

		lda tmp1
		and #%0111_0000
		shr #4
		sta tmp3						; 属性X
		lda DrawMap::row_counter
		shr #1
		cmp tmp3
		bne @LOOP

		lda tmp1
		and #%0000_0111
		tax								; 属性Y
		cpx #7
		bcs @LOOP
		lda tmp2
		sta ppu_attr_buff, x
		jmp @LOOP
		; ------------------------------

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; BG_MAP1の背景オブジェクトを，現在の8x8タイル2列ぶんだけbg_map_buffへ重ねる
; @PARAMS		DrawMap::map_buff_num / row_counter
; @CLOBBERS		A X Y tmp1 tmp2 tmp3 tmp_rgstY addr_tmp1
; @RETURNS		None
;
; 既に地形/ブロックとして展開されたタイルがある場所には書かない。
; これにより，草の下側や山の下側は地面で自然に隠れる。
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _drawBgMap1ToBgMapBuff
		lda DrawMap::map_buff_num
		sta DrawMap::bg_target_page

		lda DrawMap::row_counter
		shl #1
		sta DrawMap::bg_target_tile_x	; 今回転送する左側8x8タイルX

		lda #0
		sta DrawMap::bg_page

		ldy #0
@LOOP:
		lda BG_MAP1, y
		cmp #BG_SCENERY_END
		beq @EXIT
		sta tmp1						; d00xxxxx
		iny
		lda BG_MAP1, y
		sta tmp2						; yyy00iii
		iny
		sty tmp_rgstY					; 配置リストの読み取り位置を退避

		lda tmp1
		and #BIT7
		beq :+
		inc DrawMap::bg_page
:
		lda DrawMap::bg_page
		cmp DrawMap::bg_target_page
		bne @NEXT_OBJ

		lda tmp1
		and #%0001_1111
		sta DrawMap::bg_obj_base_x

		lda tmp2
		shr #5
		tax
		lda BG_SCENERY_Y_TO_ROW, x
		sta DrawMap::bg_obj_base_y

		lda tmp2
		and #%0000_0111
		tax
		lda BG_OBJ_ADDR_LO, x
		sta addr_tmp1+LO
		lda BG_OBJ_ADDR_HI, x
		sta addr_tmp1+HI

		jsr _drawSceneryObjectColumns

@NEXT_OBJ:
		ldy tmp_rgstY
		jmp @LOOP
		; ------------------------------

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 1つの背景オブジェクトから，現在の8x8タイル2列に重なるタイルだけ描く
; @PARAMS		addr_tmp1: BG_OBJ*_DATA
; @CLOBBERS		A X Y tmp1 tmp2 DrawMap::bg_obj_*
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _drawSceneryObjectColumns
		lda #0
		sta DrawMap::bg_obj_local_x

		ldy #0
@LOOP:
		lda (addr_tmp1), y
		iny
		cmp #BG_SCENERY_END
		beq @EXIT
		sta DrawMap::bg_obj_tile

		and #%1110_0000
		cmp #BG_SCENERY_NEXT_X
		beq @NEXT_TILE_X

		lda DrawMap::bg_obj_base_x
		add DrawMap::bg_obj_local_x
		sta tmp1						; このタイルの画面内8x8 X

		lda tmp1
		cmp DrawMap::bg_target_tile_x
		beq @DRAW_LEFT

		lda DrawMap::bg_target_tile_x
		add #1
		cmp tmp1
		beq @DRAW_RIGHT
		jmp @LOOP
		; ------------------------------

@DRAW_LEFT:
		lda #0
		sta tmp2
		jmp @DRAW
		; ------------------------------

@DRAW_RIGHT:
		lda #$1a						; bg_map_buff後半は右側8x8列
		sta tmp2

@DRAW:
		lda DrawMap::bg_obj_tile
		and #%1110_0000
		shr #5
		add DrawMap::bg_obj_base_y
		cmp #$1a						; 26タイル行ぶんだけ転送する
		bcs @LOOP
		add tmp2
		tax

		lda bg_map_buff, x
		bne @LOOP						; 前景や地面がある場所には描かない

		lda DrawMap::bg_obj_tile
		and #%0001_1111
		add #BG_SCENERY_TILE_BASE
		sta bg_map_buff, x
		jmp @LOOP
		; ------------------------------

@NEXT_TILE_X:
		inc DrawMap::bg_obj_local_x
		jmp @LOOP
		; ------------------------------

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; SMB風座標($XY)を，このプログラムのBGバッファ列アドレス($YX)へ変換する
; @PARAMS		tmp5: 位置バイト xxxxyyyy
;				tmp6: 設定バイト pabcdefg
; @CLOBBERS		A tmp3
; @RETURNS		addr_tmp1+LO
;
; 通常オブジェクト(y=0..11)はそのまま上からの行として扱う。
; y=12/15の固定オブジェクトは，本家の意味に完全対応していないので
; 既存PARTS_*が画面外へはみ出しにくい行へ仮配置する。
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setObjAddrLoFromSmbPos
		lda tmp5
		and #BYT_GET_LO					; y
		cmp #$0c
		bne @CHECK_SUBTYPE3
		lda #$0b						; y=12: 穴など，下端付近に固定
		jmp @STORE_Y

@CHECK_SUBTYPE3:
		cmp #$0f
		bne @STORE_Y

		; y=15: typeによって仮の基準行を変える
		lda tmp6
		and #%0111_0000
		shr #4
		cmp #SMB_SUB3_CASTLE				; 城/ゴール系
		bne :+
		lda #0
		jmp @STORE_Y
:
		cmp #SMB_SUB3_STAIRS				; 階段
		beq @SET_STAIRS_Y
		cmp #SMB_SUB3_STAIRS_REV			; 逆階段
		bne @CHECK_BIG_PIPE

@SET_STAIRS_Y:
		lda tmp6
		and #%0000_1111					; defgは横幅-1
		add #1
		cmp #9
		bcc :+
		lda #8							; 高さは最大8段まで
:
		sta tmp3
		lda DrawMap::fill_ground_start	; 地面の直上に階段の底が来るように上端行を出す
		sub tmp3
		bcs :+
		lda #0							; 高すぎる場合は画面上端から描く
:
		jmp @STORE_Y

@CHECK_BIG_PIPE:
		cmp #SMB_SUB3_BIG_PIPE			; 地下出口の巨大土管
		bne :+
		lda #8
		jmp @STORE_Y
:
		lda #0

@STORE_Y:
		shl #4
		sta tmp3
		lda tmp5
		and #BYT_GET_HI					; x
		shr #4
		ora tmp3
		sta addr_tmp1+LO
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; y=12/abc=落とし穴を開始する
; @PARAMS		tmp6: 設定バイト p abc defg
; @CLOBBERS		A X tmp1 addr_tmp1
; @RETURNS		None
;
; defgは穴の幅。size=1なら1列だけ穴を開ける。
; 穴は床パターンの「下側の地面」だけを消し，天井や中段の床には触らない。
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _startHoleFromMapObj
		lda tmp6
		and #%0000_1111
		beq @EXIT						; size=0は何もしない
		sta DrawMap::hole_remain
		jsr _applyActiveHole				; 現在列にもすぐ反映する

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 継続中の落とし穴を現在のX列へ反映する
; @PARAMS		DrawMap::hole_remain
; @CLOBBERS		A X tmp1 addr_tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _applyActiveHole
		lda DrawMap::hole_remain
		beq @EXIT

		lda DrawMap::fill_ground_end		; 下側の地面の厚み
		beq @STEP_HOLE
		sta tmp1

		lda DrawMap::map_buff_num
		and #BIT0
		ora #4
		sta addr_tmp1+HI

		lda DrawMap::fill_ground_start
		shl #4
		add DrawMap::row_counter
		sta addr_tmp1+LO

		ldx #0
@CLEAR_GROUND_LOOP:
		lda #0							; 空ブロック。天井や中段の床は消さない
		sta (addr_tmp1, x)
		lda addr_tmp1+LO
		add #$10
		sta addr_tmp1+LO
		dec tmp1
		bne @CLEAR_GROUND_LOOP

@STEP_HOLE:
		dec DrawMap::hole_remain

@EXIT:
		rts
		; ------------------------------
.endproc



;*------------------------------------------------------------------------------
; パーツスロットに保存されているパーツ（描画中のパーツ）を指定して
; ブロックを保存（$04xx/$05xxへ書き込み）
; @PARAMS		x: スロットのインデックス（新規の場合ff）
;				addr_tmp1: 配置する列の一番上のアドレス
;				（$0401の列（$0401-$04e1）に書き込み，8行目が一番上→addr_tmp1=$0471）
;				tmp1: DrawMap::indexの値
;				tmp2: addr_tmp1+LOの値
;				tmp3: slot_index_arr[slot_index]の値
; @CLOBBERS		A X Y tmp3 tmp4 addr_tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setParts
		stx tmp4						; slot index
		jsr _loadMapObjMeta
		jsr _trySetCalculatedParts
		bcc :+
		rts
:
		jsr _setPartsAddrFromMapObj
@GET_OBJ_CONTENTS_LOOP:
		; ldarr_addr_tmpには，type/sizeから選ばれたPARTS_*のアドレスが入っている
		ldy tmp3
		lda (DrawMap::ldarr_addr_tmp), y
		; .byte OBJ('^', 1)などの値が取得できているはず
		cmp #PARTS_ENDCODE
		beq @END_SET_PARTS
		pha								; obj & nextline
		and #%0111_1111
		pha								; obj

		; change addr
		iny
		lda (DrawMap::ldarr_addr_tmp), y		; posY(upper 4bit)
		; ldarr DrawMap::map_addr			; posY(upper 4bit)
		add addr_tmp1+LO
		sta addr_tmp1+LO

		; store obj ('H', 'B', '^') -> $04xx, $05xx
		pla								; obj
		jsr _storeBlockIfVisible

		; restore addr
		lda tmp2
		sta addr_tmp1+LO

		; continue?
		iny
		sty tmp3
		pla
		bmi @BREAK_LOOP					; bit7: nextline flag
		bpl @GET_OBJ_CONTENTS_LOOP
		; ------------------------------
@END_SET_PARTS:
		jsr _clearCurrentPartSlot
		jmp @EXIT
		; ------------------------------

@BREAK_LOOP:
		jsr _saveCurrentPartSlot
@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; SMB風の位置/設定バイトから，実際に描くPARTS_*のアドレスを決める
; @PARAMS		tmp1: map_addr内のtype/sizeバイトのindex
; @CLOBBERS		A Y
; @RETURNS		ldarr_addr_tmp: PARTS_*のアドレス
;
; ざっくりした対応（未実装オブジェクトは今あるPARTS_*へ寄せる）:
;   y=0..11:
;     abc=0: defgを単体オブジェクトIDとして扱う
;     abc=2: レンガ横列 / abc=3: 硬いブロック横列
;     abc=4: コイン横列 / abc=5: レンガ縦列 / abc=6: 硬いブロック縦列
;     abc=7: 土管。d(入れるフラグ)は今は無視し，efgを高さとして使う
;   y=12:
;     abc=0を穴として扱う。ほかは仮対応
;   y=15:
;     abc=2をゴール/城，abc=3を階段，abc=4を巨大土管として扱う
;*------------------------------------------------------------------------------

.code									; ----- code -----

;*------------------------------------------------------------------------------
; SMB風オブジェクトの位置/設定バイトを読み直して、共通メタ情報へ展開する
; @PARAMS		tmp1: map_addr内のtype/sizeバイトindex
; @CLOBBERS		A Y tmp5
; @RETURNS		tmp5: y, DrawMap::objtype, DrawMap::objsize
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _loadMapObjMeta
		ldy tmp1
		dey
		lda (DrawMap::map_addr), y
		and #BYT_GET_LO
		sta tmp5						; y

		ldy tmp1
		lda (DrawMap::map_addr), y
		and #%0000_1111
		sta DrawMap::objsize

		lda (DrawMap::map_addr), y
		and #%0111_0000					; bit7は次ページフラグなので除外
		shr #4
		sta DrawMap::objtype
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 計算だけで描けるオブジェクトを処理する
; @PARAMS		tmp1/tmp2/tmp3/tmp4/addr_tmp1, DrawMap::objtype/objsize, tmp5
; @RETURNS		C=1: 処理済み, C=0: 固定PARTS表へフォールバック
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _trySetCalculatedParts
		lda tmp5
		cmp #$0c
		beq @NOT_HANDLED				; 穴は専用処理で先に消している
		cmp #$0f
		beq @SUBTYPE3

		lda DrawMap::objtype
		cmp #SMB_OBJ_SINGLE
		bne :+
		jsr _drawCalcSingle
		jmp @HANDLED
:
		cmp #SMB_OBJ_BRICK_ROW
		bne :+
		lda #'B'
		sta DrawMap::fill_block
		jsr _drawCalcRow
		jmp @HANDLED
:
		cmp #SMB_OBJ_HARD_ROW
		bne :+
		lda #'H'
		sta DrawMap::fill_block
		jsr _drawCalcRow
		jmp @HANDLED
:
		cmp #SMB_OBJ_COIN_ROW
		bne :+
		lda #'^'
		sta DrawMap::fill_block
		jsr _drawCalcRow
		jmp @HANDLED
:
		cmp #SMB_OBJ_BRICK_COLUMN
		bne :+
		lda #'B'
		sta DrawMap::fill_block
		jsr _drawCalcColumn
		jmp @HANDLED
:
		cmp #SMB_OBJ_HARD_COLUMN
		bne @NOT_HANDLED
		lda #'H'
		sta DrawMap::fill_block
		jsr _drawCalcColumn
		jmp @HANDLED

@SUBTYPE3:
		lda DrawMap::objtype
		cmp #SMB_SUB3_STAIRS
		beq :+
		cmp #SMB_SUB3_STAIRS_REV
		bne @NOT_HANDLED
:
		jsr _drawCalcStairs

@HANDLED:
		sec
		rts
		; ------------------------------

@NOT_HANDLED:
		clc
		rts
		; ------------------------------
.endproc


; 単体オブジェクトID -> 実際に置くブロック文字。abc=0なのでマップ定義では S(id) だけでよい。
SINGLE_OBJ_BLOCKS:
		.byte '[', '_', 'Q', '^', 'B', 'H', 'N', 'G', '@'


;*------------------------------------------------------------------------------
; 画面外/地面内を無視して1ブロックだけ置く
; @PARAMS		A: ブロック文字, addr_tmp1: 書き込み先
; @CLOBBERS		A X
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _storeBlockIfVisible
		pha
		lda addr_tmp1+LO
		and #BYT_GET_HI
		cmp #$d0						; BGバッファは0..12行だけ使う
		bcs @DROP
		shr #4
		cmp DrawMap::fill_ground_start	; 地面の高さ以下は基本床に任せる
		bcs @DROP

		pla
		ldx #0
		sta (addr_tmp1, x)
		rts
		; ------------------------------

@DROP:
		pla
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; size=0だけ1として扱う。通常はsizeの値をそのまま幅/高さにする。
; @RETURNS		A: 1..15
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _getCalcSize
		lda DrawMap::objsize
		bne :+
		lda #1
:
		rts
		; ------------------------------
.endproc


.code									; ----- code -----

.proc _drawCalcSingle
		ldx DrawMap::objsize
		cpx #9
		bcc :+
		ldx #SMB_SINGLE_BRICK			; 未定義IDは仮にレンガへ寄せる
:
		lda SINGLE_OBJ_BLOCKS, x
		jsr _storeBlockIfVisible
		jsr _clearCurrentPartSlot
		rts
		; ------------------------------
.endproc


.code									; ----- code -----

.proc _drawCalcRow
		jsr _getCalcSize
		sta tmp6						; 横幅

		lda DrawMap::fill_block
		jsr _storeBlockIfVisible

		inc tmp3						; 次の列で描く何個目か
		lda tmp3
		cmp tmp6
		bcc @SAVE
		jsr _clearCurrentPartSlot
		rts
		; ------------------------------

@SAVE:
		jsr _saveCurrentPartSlot
		rts
		; ------------------------------
.endproc


.code									; ----- code -----

.proc _drawCalcColumn
		jsr _getCalcSize
		tay								; 縦の高さ

@LOOP:
		lda DrawMap::fill_block
		jsr _storeBlockIfVisible
		lda addr_tmp1+LO
		add #$10
		sta addr_tmp1+LO
		dey
		bne @LOOP

		lda tmp2
		sta addr_tmp1+LO
		jsr _clearCurrentPartSlot
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; y=15/abc=3,5の階段を計算描画する
; defg: 横幅-1。高さは最大8段。逆階段はabc=5で指定する
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _drawCalcStairs
		; sizeは横幅-1として扱う。高さは最大8段に丸める。
		; 9列目以降は8段の高さを維持して横へ伸ばす。
		lda DrawMap::objsize
		and #%0000_1111
		add #1
		sta tmp6						; 階段の横幅
		lda tmp6
		cmp #9
		bcc :+
		lda #8
:
		sta DrawMap::fill_block			; 階段の高さ。最大8段

		lda tmp3						; 現在の列番号
		cmp tmp6
		bcc :+
		jsr _clearCurrentPartSlot
		rts
:
		lda DrawMap::objtype
		cmp #SMB_SUB3_STAIRS_REV
		beq @REVERSE

		lda tmp3
		add #1
		cmp DrawMap::fill_block
		bcc :+
		lda DrawMap::fill_block
:
		sta tmp5						; この列で積む数
		lda DrawMap::fill_block
		sub tmp5						; 上端から何行下げて描き始めるか
		jmp @DRAW

@REVERSE:
		lda tmp6
		sub tmp3
		cmp DrawMap::fill_block
		bcc :+
		lda DrawMap::fill_block
:
		sta tmp5						; この列で積む数
		lda DrawMap::fill_block
		sub tmp5						; 逆階段も最大高さからの下げ量で開始行を出す

@DRAW:
		beq @ADDR_READY
		shl #4
		add addr_tmp1+LO
		sta addr_tmp1+LO

@ADDR_READY:
		ldy tmp5
@DRAW_LOOP:
		lda #'H'
		jsr _storeBlockIfVisible
		lda addr_tmp1+LO
		add #$10
		sta addr_tmp1+LO
		dey
		bne @DRAW_LOOP

		lda tmp2
		sta addr_tmp1+LO
		inc tmp3
		lda tmp3
		cmp tmp6
		bcc @SAVE
		jsr _clearCurrentPartSlot
		rts
		; ------------------------------

@SAVE:
		jsr _saveCurrentPartSlot
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 継続描画スロットを消す/保存する
; tmp4=$ffなら新規、そうでなければ同じスロットを更新する。
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _clearCurrentPartSlot
		ldx tmp4
		cpx #$ff
		beq @EXIT
		lda NUM2BIT, x
		eor #$ff
		and used_part_slots
		sta used_part_slots

@EXIT:
		rts
		; ------------------------------
.endproc


.code									; ----- code -----

.proc _saveCurrentPartSlot
		ldx tmp4
		cpx #$ff
		bne @SAVE

		lda used_part_slots
		ldx #$ff
@FIND_FREE_SLOT:
		inx
		cpx #8
		beq @SLOT_OVERFLOW
		shr
		bcs @FIND_FREE_SLOT

@SAVE:
		lda NUM2BIT, x
		ora used_part_slots
		sta used_part_slots
		lda tmp2						; 次列ではスロット読み込み側が+1する
		sta part_slot_addr_arr, x
		lda tmp3
		sta part_slot_index_arr, x
		lda tmp1
		sta map_data_index_arr, x
		rts
		; ------------------------------

@SLOT_OVERFLOW:
		jmp @SLOT_OVERFLOW				; for debug
		; ------------------------------
.endproc


.proc _setPartsAddrFromMapObj
		jsr _loadMapObjMeta

		lda tmp5
		cmp #$0c
		bne :+
		jmp @SUBTYPE2
:
		cmp #$0f
		bne :+
		jmp @SUBTYPE3
:

@NORMAL_OBJ:
		lda DrawMap::objtype
		cmp #SMB_OBJ_PLATFORM
		bne :+
		jmp @SET_HARD_4ROW
:
		cmp #SMB_OBJ_PIPE
		bne :+
		jmp @TYPE_PIPE
:
		jmp @SET_SKY_1

@TYPE_PIPE:
		lda DrawMap::objsize
		and #%0000_0111					; d(入れるフラグ)は今は無視
		cmp #SMB_PIPE_3ROW
		bne :+
		jmp @SET_PIPE_3ROW
:
		cmp #SMB_PIPE_4ROW
		bne :+
		jmp @SET_PIPE_4ROW
:
		cmp #SMB_PIPE_5ROW
		bne :+
		jmp @SET_PIPE_5ROW
:
		jmp @SET_PIPE_2ROW

@SUBTYPE2:
		; y=12: 固定位置オブジェクト。abc=0を落とし穴として使う
		lda DrawMap::objtype
		cmp #SMB_SUB2_QBLOCK_ROW
		bne :+
		jmp @SET_QBLOCK_1
:
		cmp #SMB_SUB2_QBLOCK_POWERUP_ROW
		bne :+
		jmp @SET_QBLOCK_FLWR_1
:
		jmp @SET_SKY_1

@SUBTYPE3:
		; y=15: 城/階段/出口土管など。必要なものだけ仮実装
		lda DrawMap::objtype
		cmp #SMB_SUB3_CASTLE
		bne :+
		jmp @SET_GOAL
:
		cmp #SMB_SUB3_BIG_PIPE
		bne :+
		jmp @SET_PIPE_5ROW
:
		jmp @SET_SKY_1

@SET_SKY_1:
		lda #<PARTS_SKY_1
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_SKY_1
		jmp @STORE_HI
@SET_QBLOCK_1:
		lda #<PARTS_QBLOCK_1
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_QBLOCK_1
		jmp @STORE_HI
@SET_QBLOCK_FLWR_1:
		lda #<PARTS_QBLOCK_FLWR_1
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_QBLOCK_FLWR_1
		jmp @STORE_HI
@SET_HARD_4ROW:
		lda #<PARTS_HARD_4ROW
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_HARD_4ROW
		jmp @STORE_HI
@SET_PIPE_2ROW:
		lda #<PARTS_PIPE_2ROW
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_PIPE_2ROW
		jmp @STORE_HI
@SET_PIPE_3ROW:
		lda #<PARTS_PIPE_3ROW
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_PIPE_3ROW
		jmp @STORE_HI
@SET_PIPE_4ROW:
		lda #<PARTS_PIPE_4ROW
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_PIPE_4ROW
		jmp @STORE_HI
@SET_PIPE_5ROW:
		lda #<PARTS_PIPE_5ROW
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_PIPE_5ROW
		jmp @STORE_HI
@SET_GOAL:
		lda #<PARTS_GOAL
		sta DrawMap::ldarr_addr_tmp+LO
		lda #>PARTS_GOAL
		jmp @STORE_HI
@STORE_HI:
		sta DrawMap::ldarr_addr_tmp+HI
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Set addr of stages
; @PARAMS		Y: stage number
; @CLOBBERS		A Y
; @RETURNS		None (A = addr Hi)
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setStageAddr
		tya
		shl #1
		tay

		lda STAGE_ARR+LO, y
		sta DrawMap::map_arr_addr+LO
		lda STAGE_ARR+HI, y
		sta DrawMap::map_arr_addr+HI

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; SMB風2バイトヘッダーを，現エンジン用の床バッファへ反映する
; @PARAMS		DrawMap::map_addr -> レベルデータ先頭
; @CLOBBERS		A X Y tmp1
; @RETURNS		None
;
; Header1(ttsssmmm)は，今はコメント上の互換だけで未使用。
; Header2(ffbboooo)は，ffで床ブロックの見た目，ooooで床パターンを決める。
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _applyLevelHeader
		ldy #1
		lda (DrawMap::map_addr), y
		pha

		and #%1100_0000
		cmp #%0100_0000
		bne :+
		lda #'H'
		jmp @STORE_FLOOR_BLOCK
:
		cmp #%1000_0000
		bne :+
		lda #'N'
		jmp @STORE_FLOOR_BLOCK
:
		lda #'G'

@STORE_FLOOR_BLOCK:
		sta DrawMap::fill_ground_block

		; いったん全行を空にする。穴の継続もマップ断片ごとにリセットする
		lda #0
		sta DrawMap::hole_remain
		sta DrawMap::fill_ground_end
		lda #$0d
		sta DrawMap::fill_ground_start
		lda #0
		ldx #0
@CLEAR_LOOP:
		sta fill_block_arr, x
		inx
		cpx #$0d
		bcc @CLEAR_LOOP

		; Header2下位4bit = 本家風の床パターン番号
		pla
		and #%0000_1111
		sta tmp6
		tax

		lda FLOOR_PATTERN_GROUND_HEIGHT, x
		jsr _fillGroundRows

		ldx tmp6
		lda FLOOR_PATTERN_CEILING_HEIGHT, x
		jsr _fillCeilingRows

		ldx tmp6
		lda FLOOR_PATTERN_MIDDLE_HEIGHT, x
		beq @EXIT
		sta tmp1
		lda FLOOR_PATTERN_MIDDLE_START, x
		tax
		jsr _fillRowsFromX

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 下側の地面を塗る。ここで覚えた厚みを，落とし穴処理が使う
; @PARAMS		A: 下側の地面の厚み
; @CLOBBERS		A X tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _fillGroundRows
		sta DrawMap::fill_ground_end
		sta tmp1
		lda #$0d
		sta DrawMap::fill_ground_start

		lda tmp1
		beq @EXIT
		lda #$0d
		sub tmp1
		sta DrawMap::fill_ground_start
		tax
		jsr _fillRowsFromX

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 天井を塗る。落とし穴では消さない
; @PARAMS		A: 天井の厚み
; @CLOBBERS		A X tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _fillCeilingRows
		sta tmp1
		lda tmp1
		beq @EXIT
		ldx #0
		jsr _fillRowsFromX

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; fill_block_arrの指定行からtmp1行分を床ブロックで塗る
; @PARAMS		X: 開始行, tmp1: 行数
; @CLOBBERS		A X tmp1
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _fillRowsFromX
		lda tmp1
		beq @EXIT
		lda DrawMap::fill_ground_block
@LOOP:
		sta fill_block_arr, x
		inx
		dec tmp1
		bne @LOOP

@EXIT:
		rts
		; ------------------------------
.endproc


; 下側地面の厚み。0,1,2,...,f の順
FLOOR_PATTERN_GROUND_HEIGHT:
		.byte 0, 2, 2, 2, 2, 2, 5, 5, 5, 6, 0, 6, 9, 2, 2, 13

; 天井の厚み。落とし穴では消さない
FLOOR_PATTERN_CEILING_HEIGHT:
		.byte 0, 0, 1, 3, 4, 8, 1, 3, 4, 1, 1, 4, 1, 1, 1, 0

; パターンd/eだけ，下側地面から3マス空けて中段床を置く
FLOOR_PATTERN_MIDDLE_START:
		.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 0

FLOOR_PATTERN_MIDDLE_HEIGHT:
		.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 4, 0


;*------------------------------------------------------------------------------
; Set addr of maps
; @PARAMS		Y: map index
; @CLOBBERS		A Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setMapAddr
		tya
		shl #1
		tay
		pha								; push y

		; ffコードをこの関数の返値にして，この関数の外でマップ終了を判定しているが
		; その前に@NO_EXIT以下の処理を行ってしまい，バグるため，ここで抜ける
		; 直接@END_OF_STAGEにジャンプしてもOKなはずだが（マップ終了判定でジャンプするラベル）
		; procを使っているため今は無理
		iny
		lda (DrawMap::map_arr_addr), y
		cmp #ENDCODE
		bne @NO_EXIT
		pla
		tay
		lda #ENDCODE					; マップ終了時にはmapaddrを書き換えない
		rts
		; ------------------------------

@NO_EXIT:
		lda (DrawMap::map_arr_addr), y
		sta DrawMap::map_addr+HI
		dey
		lda (DrawMap::map_arr_addr), y
		sta DrawMap::map_addr+LO

		jsr _applyLevelHeader

		ldy #2								; SMB風ヘッダー2バイトの直後から読む
		sty DrawMap::index

		pla
		tay

		lda #0							; return value != ENDCODE

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Change stage
; @PARAMS		Y: Stage number
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.proc _changeStage
		tya
		pha

		lda #0
		sta is_updated_map
		sta engine_flag

		jsr _nsd_pause_bgm

		lda #0
		sta PPU_SCROLL
		sta PPU_SCROLL
		sta ppu_ctrl2_cpy
		sta PPU_CTRL2

		jsr _nsd_stop_se
		jsr _nsd_stop_bgm

		pla
		tay

		lda STAGE_PALETTE_ARR, y
		tax
		lda BG_COLORS, x
		sta bg_color

		jsr Subfunc::_waitVblankUsingNmi				; Vblankの開始を待つ

		; Change bg color (black)
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		lda bg_color
		sta PPU_DATA
		; 画面OFF中は最後に指定したアドレスの色が背景になる（指定なし→3f01の色が使用される）
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		lda #$ff
		sta DrawMap::row_counter
		sta coin_animation_counter

		lda #0
		sta DrawMap::index
		sta main_disp
		sta disp_cnt
		sta DrawMap::cnt_map_next		; count ff
		sta DrawMap::map_buff_num
		sta DrawMap::isend_draw_stage
		sta DrawMap::map_arr_num
		sta scroll_x
		sta Player::is_fly
		sta Player::is_jumping
		sta scroll_amount
		sta is_updated_map
		sta standing_disp

		lda #'G'
		sta DrawMap::fill_ground_block

		tya
		pha
		lda STAGE_PALETTE_ARR, y
		tax							; _tfrPltDataToBuffで転送するパレット番号に使う

		jsr Enemy::_reset

		lda #1
		sta is_processing_main
		; NMIが終了するのを待つが，NMI処理はスキップしたいのでこのような構成に
		lda nmi_cnt
:
		cmp nmi_cnt
		beq :-

		jsr Subfunc::_tfrPltDataToBuff	; Yレジスタ破壊
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		lda ppu_ctrl1_cpy
		and #%1111_1011					; ストア時のインクリメントを+1にする
		sta PPU_CTRL1
		tfrPlt
		jsr Subfunc::_restorePPUSet
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		pla
		tay

		jsr DrawMap::_setStageAddr		; Y破壊（ステージ番号）
		ldy #0
		jsr DrawMap::_setMapAddr

		jsr Subfunc::_dispStatus
		jsr Subfunc::_sleepOneFrame
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		lda #0
		sta spr_anime_num+$0
		sta spr_anime_timer+$0
		sta spr_attr_arr+$0
		sta spr_attr_arr+$1
		sta spr_attr_arr+$2
		sta spr_attr_arr+$3
		sta spr_attr_arr+$4
		sta spr_attr_arr+$5
		sta spr_decimal_part_force_y+$0
		sta spr_decimal_part_velocity_x_arr+$0
		sta spr_decimal_part_velocity_y_arr+$0
		sta spr_fix_val_y+$0
		sta spr_float_velocity_x_arr+$0
		sta spr_float_velocity_y_arr+$0
		sta spr_force_fall_y+$0
		sta spr_move_counter+$0
		sta spr_move_num+$0
		sta spr_pos_y_decimal_part+$0
		sta spr_pos_y_origin+$0
		sta spr_standing_disp+$0
		sta spr_velocity_x_arr+$0
		sta spr_velocity_y_arr+$0
		sta Item::item_attr

		lda #$ff
		sta coin_animation_counter
		sta block_anime_timer

		lda #$28
		sta spr_posX_arr+$0
		sta spr_posX_tmp_arr+$0
		lda #$c0
		sta spr_posY_arr+$0
		sta spr_posY_tmp_arr+$0
		sta spr_pos_y_origin+$0

		lda PLAYER_COLLISION_BOX+$0
		sta spr_collision_box_x1+$0
		lda PLAYER_COLLISION_BOX+$1
		sta spr_collision_box_y1+$0
		lda PLAYER_COLLISION_BOX+$2
		sta spr_collision_box_x2+$0
		lda PLAYER_COLLISION_BOX+$3
		sta spr_collision_box_y2+$0

		lda #1
		sta spr_velocity_y_arr+$0
		sta spr_float_velocity_y_arr+$0

		lda #BIT7|BIT0
		sta spr_attr_arr+$0

		lda #$ff
		ldx #$04*5					; 0スプライトとマリオの領域を除外
@VRAM_INIT:
		sta $0700, x
		inx
		bne @VRAM_INIT

		ldx #0
@LOOP:
		stx Sprite::spr_buff_id
		ldx Sprite::spr_buff_id						; spr id
		ldy Sprite::spr_buff_id						; buff index (0は0爆弾用のスプライト）→_tfrToChrBuff側を変えて引数一つにまとめてもよい
		jsr Sprite::_tfrToChrBuff
		ldx Sprite::spr_buff_id
		inx
		cpx #6
		bne @LOOP


		jsr Subfunc::_sleepOneFrame
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		lda #$8*3-2-1
		sta CHR_BUFF+0
		lda #$ff
		sta CHR_BUFF+1
		lda #%0000_0010
		sta CHR_BUFF+2
		lda #$0f
		sta CHR_BUFF+3

		lda #4
		sta timer_dec_num_arr+$0
		lda #0
		sta timer_dec_num_arr+$1
		sta timer_dec_num_arr+$2

		lda #$18
@DISP_LOOP:
		pha
		lda #1
		sta is_updated_map
		jsr DrawMap::_updateOneLine
		jsr Subfunc::_sleepOneFrame
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		pla
		sub #1
		bne @DISP_LOOP

		jsr Subfunc::_waitVblankUsingNmi

		; Restore bg color
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		lda bg_color
		sta PPU_DATA
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR


		jsr Subfunc::_waitVblankUsingNmi
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		lda	bgm0
		ldx	bgm0+1
		jsr	_nsd_play_bgm

		jsr Subfunc::_waitVblankUsingNmi
		; ヘッドアップディスプレイの属性テーブルを変更
		lda #$23
		sta PPU_ADDR
		lda #$c0
		sta PPU_ADDR
		lda #$ff
		sta PPU_DATA
		sta PPU_DATA
		sta PPU_DATA
		sta PPU_DATA
		sta PPU_DATA
		sta PPU_DATA
		sta PPU_DATA
		sta PPU_DATA
		lda #$3f
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR

		jsr Subfunc::_sleepOneFrame

		lda #%00010100
		sta ppu_ctrl2_cpy
		jsr Subfunc::_restorePPUSet		; SPRITE ON

		jsr Subfunc::_sleepOneFrame
		jsr Subfunc::_setScroll

		lda #%00011110
		sta ppu_ctrl2_cpy
		jsr Subfunc::_restorePPUSet		; BG ON

		rts
		; ------------------------------

.endproc


.endscope
