ENEMY_ARR_13:
	.byte $00, $82, KURIBO_ID					; マップ0, X=8にマリオが来たら、Y=2にクリボー
	.byte $00, $92, KURIBO_ID
	.byte $00, $a2, KURIBO_ID
	; .byte $00, $b2, KURIBO_ID
	; .byte $00, $c2, KURIBO_ID
	.byte $ff							; マップff、Y=f、敵ffはありえないのでffはエンドコードに使える


