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
    ../../modules/security.nix
    ../../modules/audio.nix
    ../../modules/head.nix
    ../../modules/apps.nix
  ];

  networking.hostName = "paul";

  head = true;
  primaryUser = "paul";

  # Mot de passe par défaut pour les tests en VM — à ne pas utiliser en prod.
  users.users."paul" = {
    hashedPasswordFile = lib.mkForce null;
    password = "changeme";
  };

  # Bootloader (UEFI / systemd-boot)
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
