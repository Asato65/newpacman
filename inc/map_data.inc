STAGE_ARR:
	.addr MAP_ARR_11

MAP_ARR_11:
	.addr MAP_11_1

MAP_11_1:
	.byte $85, 'G'
	.byte $94, 'G'
	.byte $a3, 'G'
	.byte $ff


/*
MAP_DATA[stage][map_num][index]

setAddr ----
lda stage
shl
tax

lda MAP_DATA, x
sta <addr1
inx
lda MAP_DATA, x
sta >addr1
inx

ldy map_num
lda (addr1), y
sta <addr2
lda (addr1), y
sta >addr2

ldy index
lda (addr2), y
sta <addr3
lda (addr2), y
sta >addr3

*/

