; NMI処理

		registerSave

		inc nmi_cnt

		lda isend_main
		beq EXIT
		inc frm_cnt

EXIT:
		registerLoad
		rti	; --------------------------