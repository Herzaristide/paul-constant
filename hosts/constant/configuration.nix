{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.default
    ../../modules/nixos.nix
    ../../modules/common.nix
    ../../modules/kernel.nix
    ../../modules/network.nix
    ../../modules/power.nix
    ../../modules/swap.nix
    ../../modules/security.nix
    ../../modules/audio.nix
    ../../modules/head.nix
    ../../modules/apps.nix
  ];

  networking.hostName = "constant";

  primaryUser = "constant";

  hardware.cpu.intel.updateMicrocode = true;

  # Bootloader (UEFI / systemd-boot)
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
