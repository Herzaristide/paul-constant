{ ... }:

{
  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [
    "nvme"
    "ahci"
    "sd_mod"
    "sr_mod"
    "xhci_pci"
    "xhci_pci_renesas"
    "ehci_pci"
    "ehci_hcd"
    "ohci_pci"
    "ohci_hcd"
    "uhci_hcd"
    "usb_storage"
    "usbhid"
  ];
}
