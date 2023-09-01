; 1-1 map1
MAP_1_1_1:
	.byte $80, 'G'
	.byte $90, 'G'
	.byte $a0, 'G'
	.byte $ff

MAP_1_1:
	.addr MAP_1_1_1

MAP_DATA:
	.addr MAP_1_1

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

