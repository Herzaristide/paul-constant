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

  networking.hostName = "paul";

  primaryUser = "paul";

  hardware.cpu.amd.updateMicrocode = true;

  # Disque de données 1.8 To (HDD SATA) — btrfs zstd. `nofail` pour ne pas
  # bloquer le boot si jamais le disque est absent ou en panne.
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/5da4ab34-2631-4d64-af58-44a4fe22ba7a";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "nofail"
    ];
  };

  # Dossier Steam Library sur le disque de données. Owned par paul pour que
  # Steam puisse y écrire sans sudo. À ajouter ensuite dans l'UI Steam :
  # Paramètres → Stockage → "+ Ajouter un disque" → /mnt/data/SteamLibrary.
  systemd.tmpfiles.rules = [
    "d /mnt/data/SteamLibrary 0755 ${config.primaryUser} users -"
  ];

  # Bootloader (UEFI / systemd-boot)
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
