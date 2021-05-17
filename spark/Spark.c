#include <Uefi.h>

extern EFI_SYSTEM_TABLE* gST;
extern EFI_BOOT_SERVICES* gBS;

EFI_STATUS EfiMain(EFI_HANDLE Handle, EFI_SYSTEM_TABLE* SystemTable) {
    SetImageParameters(Handle, SystemTable);
    EFI_STATUS Status = EFI_SUCCESS;
    EFI_CHECK(EnterOptimalTextMode());

Cleanup:
    return Status;
}
