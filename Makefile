NASM = nasm
NASM_FLAGS = -f elf32
QEMU = qemu-system-x86_64
BIOS_FILE = fwp-bios.bin
FIRMWARE_DIR = firmware

LD = i386-elf-ld
LD_FLAGS = -T firmware.ld

ASM_FILES = $(wildcard $(FIRMWARE_DIR)/*.asm)
OBJ_FILES = $(patsubst $(FIRMWARE_DIR)/%.asm, $(FIRMWARE_DIR)/%.o, $(ASM_FILES))

all: $(BIOS_FILE)

$(FIRMWARE_DIR)/%.o: $(FIRMWARE_DIR)/%.asm
	$(NASM) $(NASM_FLAGS) -o $@ $<

$(BIOS_FILE): $(OBJ_FILES)
	$(LD) $(LD_FLAGS) $(OBJ_FILES)
	dd if=/dev/zero bs=1 count=$$(echo 65536 - $$(stat -f%z $(BIOS_FILE)) | bc) >> $(BIOS_FILE)

clean:
	rm -f $(FIRMWARE_DIR)/*.o $(BIOS_FILE)

test: $(BIOS_FILE)
	$(QEMU) -machine pc -bios $(BIOS_FILE)
