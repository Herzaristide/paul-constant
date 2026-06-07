{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Periodic automatic rebuild — pulls the flake at /etc/nixos, updates the
  # nixpkgs input and switches to the new generation. Runs once a day with a
  # randomized delay to spread load if multiple hosts share a clock source.
  # Reboot is left manual (no allowReboot) so kernel/initrd updates land on the
  # next intentional reboot.
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos#${config.networking.hostName}";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L"
    ];
    dates = "04:30";
    randomizedDelaySec = "45min";
    persistent = true;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    max-jobs = 2;
    cores = 6;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  system.stateVersion = "25.11";
}
