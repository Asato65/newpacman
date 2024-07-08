MAIN_FILE = mario
ASM_FILE = $(MAIN_FILE).asm
OBJ_FILE = $(MAIN_FILE).o
NES_FILE = $(MAIN_FILE).nes
DBG_FILE = $(MAIN_FILE).dbg
LST_FILE = $(MAIN_FILE).lst
MAP_FILE = $(MAIN_FILE).map

MUSIC_FILE = smb
MUSIC_MML_FILE = $(MUSIC_FILE).mml
MUSIC_ASM_FILE = $(MUSIC_FILE).s
MUSIC_OBJ_FILE = $(MUSIC_FILE).o

CFG_FILE = .vscode/memmap.cfg
ASSEMBLER = ca65.exe
LINKER = ld65.exe
EMULATOR = Mesen.exe
MUSIC_COMPILER = nsd/bin/nsc.exe

all : clean build play

clean :
	-rm $(OBJ_FILE)
	-del $(OBJ_FILE)

build : $(NES_FILE) $(OBJ_FILE) $(MUSIC_OBJ_FILE) $(MUSIC_ASM_FILE)

play : $(NES_FILE)
	$(EMULATOR) $(NES_FILE)

$(MUSIC_ASM_FILE) : $(MUSIC_MML_FILE)
	$(MUSIC_COMPILER) -a $(MUSIC_MML_FILE)

$(MUSIC_OBJ_FILE) : $(MUSIC_ASM_FILE)
	$(ASSEMBLER) $(MUSIC_ASM_FILE) -t none -I ./asm -I ./inc -I ./nsd/include --debug --debug-info --listing $(LST_FILE)

$(OBJ_FILE) : $(ASM_FILE)
	$(ASSEMBLER) $(ASM_FILE) -t none -I ./asm -I ./inc -I ./nsd/include --debug --debug-info

$(NES_FILE) : $(OBJ_FILE) $(MUSIC_OBJ_FILE)
	$(LINKER) -vm --mapfile $(MAP_FILE) --dbgfile $(DBG_FILE) -L nsd/lib -C $(CFG_FILE) -o $(NES_FILE) $(OBJ_FILE) $(MUSIC_OBJ_FILE) nsd/lib/nsd.lib
