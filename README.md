# Spark
UEFI-based bootloader

### Requirements
* Clang (a recent enough version)
* LLD
* mtools (for making an ESP image)
* QEMU with OVMF (for testing)

### Building
```shell
# For AMD64
make

# For Aarch64
make ARCH=aarch64
```

### Supported architectures
| Architecture | Status                 |
| ------------ | ---------------------- |
| amd64        | In progress (priority) |
| aarch64      | In progress            |
