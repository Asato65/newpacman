MAIN_FILE = pacman
ASM_FILE = $(MAIN_FILE).asm
OBJ_FILE = $(MAIN_FILE).o
NES_FILE = $(MAIN_FILE).nes
DBG_FILE = $(MAIN_FILE).dbg
CFG_FILE = .vscode/memmap.cfg
ASSEMBLER = ca65.exe
LINKER = ld65.exe
EMULATOR = Mesen.exe

all : clean build play

build : $(NES_FILE) $(OBJ_FILE)

play : $(NES_FILE)
	$(EMULATOR) $(NES_FILE)

clean :
	-rm $(OBJ_FILE) $(DBG_FILE)
	-del $(OBJ_FILE) $(DBG_FILE)

$(OBJ_FILE) : $(ASM_FILE)
	$(ASSEMBLER) $(ASM_FILE) -g

$(NES_FILE) : $(OBJ_FILE)
	$(LINKER) -t nes --dbgfile $(DBG_FILE) --cfg-path $(CFG_FILE) -o $(NES_FILE) $(OBJ_FILE)
