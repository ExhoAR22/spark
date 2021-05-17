default: amd64
.PHONY: amd64

amd64: amd64-spark amd64-uefilib amd64-esp amd64-esp-img

include spark/Spark.mk uefi/Uefi.mk

CC = clang
LD = clang
AR = llvm-ar

UEFILIB_CFLAGS_AMD64 := \
	-target x86_64-unknown-windows \
	$(COMMON_CFLAGS)

SPARK_CFLAGS_AMD64 := \
	$(UEFILIB_CFLAGS_AMD64) \
	-D_SPARK_ARCH_AMD64 \
	-Iuefi

SPARK_LDFLAGS_AMD64 := \
	-target x86_64-unknown-windows \
	$(COMMON_LDFLAGS)

amd64-spark: bin/amd64/BOOTX64.EFI
amd64-uefilib: bin/amd64/uefi.lib
amd64-esp: bin/amd64/esp
amd64-esp-img: bin/amd64/esp.img

bin/amd64/BOOTX64.EFI: $(SPARK_OBJS) bin/amd64/uefi.lib
	@echo LD $@
	@mkdir -p $(@D)
	@$(LD) $(SPARK_LDFLAGS_AMD64) -o $@ $^

obj/amd64/spark/%.c.o: spark/%.c
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(SPARK_CFLAGS_AMD64) -c -o $@ $<

obj/amd64/uefi/%.c.o: uefi/%.c
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(UEFILIB_CFLAGS_AMD64) -c -o $@ $<

bin/amd64/uefi.lib: $(UEFILIB_OBJS)
	@echo AR $@
	@mkdir -p $(@D)
	@$(AR) rcs $@ $^

bin/amd64/esp: bin/amd64/BOOTX64.EFI
	@echo GEN $@
	@mkdir -p $@/EFI/BOOT
	@cp $< $@/EFI/BOOT/BOOTX64.EFI

bin/amd64/esp.img: bin/amd64/BOOTX64.EFI
	@echo GEN $@
	@dd if=/dev/zero of=$@ bs=1k count=1440
	@mformat -i $@ -f 1440 ::
	@mmd -i $@ ::/EFI
	@mmd -i $@ ::/EFI/BOOT
	@mcopy -i $@ $< ::/EFI/BOOT
