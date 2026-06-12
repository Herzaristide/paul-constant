{ ... }:

{
  # zram : swap compressé en RAM, priorité haute par défaut.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Swapfile sur le subvolume @swap (voir modules/disko.nix). NixOS le crée
  # au boot avec `btrfs filesystem mkswapfile`, qui pose NOCOW correctement.
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8 * 1024; # 8 GiB, exprimé en MiB
    }
  ];
}
