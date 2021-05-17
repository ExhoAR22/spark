default: aarch64
.PHONY: aarch64

aarch64: aarch64-spark aarch64-uefilib aarch64-esp aarch64-esp-img

include spark/Spark.mk uefi/Uefi.mk

CC = clang
LD = clang
AR = llvm-ar

UEFILIB_CFLAGS_AARCH64 := \
	-target aarch64-unknown-windows \
	$(COMMON_CFLAGS)

SPARK_CFLAGS_AARCH64 := \
	$(UEFILIB_CFLAGS_AARCH64) \
	-D_SPARK_ARCH_AARCH64 \
	-Iuefi

SPARK_LDFLAGS_AARCH64 := \
	-target aarch64-unknown-windows \
	$(COMMON_LDFLAGS)

aarch64-spark: bin/aarch64/BOOTAA64.EFI
aarch64-uefilib: bin/aarch64/uefi.lib
aarch64-esp: bin/aarch64/esp
aarch64-esp-img: bin/aarch64/esp.img

bin/aarch64/BOOTAA64.EFI: $(SPARK_OBJS) bin/aarch64/uefi.lib
	@echo LD $@
	@mkdir -p $(@D)
	@$(LD) $(SPARK_LDFLAGS_AARCH64) -o $@ $^

obj/aarch64/spark/%.c.o: spark/%.c
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(SPARK_CFLAGS_AARCH64) -c -o $@ $<

obj/aarch64/uefi/%.c.o: uefi/%.c
	@echo CC $@
	@mkdir -p $(@D)
	@$(CC) $(UEFILIB_CFLAGS_AARCH64) -c -o $@ $<

bin/aarch64/uefi.lib: $(UEFILIB_OBJS)
	@echo AR $@
	@mkdir -p $(@D)
	@$(AR) rcs $@ $^

bin/aarch64/esp: bin/aarch64/BOOTAA64.EFI
	@echo GEN $@
	@mkdir -p $@/EFI/BOOT
	@cp $< $@/EFI/BOOT/BOOTAA64.EFI

bin/aarch64/esp.img: bin/aarch64/BOOTAA64.EFI
	@echo GEN $@
	@dd if=/dev/zero of=$@ bs=1k count=1440
	@mformat -i $@ -f 1440 ::
	@mmd -i $@ ::/EFI
	@mmd -i $@ ::/EFI/BOOT
	@mcopy -i $@ $< ::/EFI/BOOT
