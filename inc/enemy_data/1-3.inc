ENEMY_ARR_13:
	; .byte $00, $c2, KURIBO_ID			; マップ0, X=cにマリオが来たら、Y=2にクリボー
	.byte $01, $33, FLOWER_ID
	.byte $02, $12, KURIBO_ID			; マップ0, X=cにマリオが来たら、Y=2にクリボー
	.byte $02, $82, KURIBO_ID			; マップ0, X=cにマリオが来たら、Y=2にクリボー
	.byte $02, $92, KURIBO_ID			; マップ0, X=cにマリオが来たら、Y=2にクリボー
	.byte $04, $8a, KURIBO_ID
	.byte $04, $9a, KURIBO_ID
	.byte $05, $62, KURIBO_ID
	.byte $05, $72, KURIBO_ID
	.byte $06, $62, KURIBO_ID
	.byte $06, $72, KURIBO_ID
	.byte $07, $42, KURIBO_ID
	.byte $07, $52, KURIBO_ID
	.byte $07, $82, KURIBO_ID
	.byte $07, $92, KURIBO_ID
	.byte $0a, $02, KURIBO_ID
	.byte $0a, $12, KURIBO_ID
	.byte $ff							; マップff、Y=f、敵ffはありえないのでffはエンドコードに使える


