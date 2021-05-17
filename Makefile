default: all
.PHONY: all clean

ARCH ?= amd64

COMMON_CFLAGS := \
	-ffreestanding \
    -fshort-wchar \
    -nostdinc \
    -nostdlib \
    -std=c11 \
    -static \
    -Wall \
    -Werror \
    -O1 \
    -flto

COMMON_LDFLAGS := \
	-nostdlib \
	-Wl,-entry:EfiMain \
	-Wl,-subsystem:efi_application \
	-Wl,-debug \
	-fuse-ld=lld-link \
	-Lbin/$(ARCH) \
	-static -luefi

include $(ARCH).mk

all: $(ARCH)

clean:
	mkdir -p bin obj
	rm -r bin obj
