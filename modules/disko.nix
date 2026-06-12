# Shared disko layout for paul and constant: UEFI + btrfs on /dev/nvme0n1.
# No LUKS — the whole btrfs volume sits directly on the second partition.
# Override `disko.devices.disk.main.device` in the host's configuration.nix
# if the NVMe enumerates under a different path.
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "space_cache=v2"
                    "discard=async"
                    "ssd"
                  ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "space_cache=v2"
                    "discard=async"
                    "ssd"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "space_cache=v2"
                    "discard=async"
                    "ssd"
                  ];
                };
                # Dédié au swapfile : pas de compression ni de COW (incompatibles
                # avec un fichier swap). NixOS le créera via `btrfs filesystem
                # mkswapfile`, qui applique NOCOW au fichier lui-même.
                "@swap" = {
                  mountpoint = "/swap";
                  mountOptions = [
                    "noatime"
                    "space_cache=v2"
                    "ssd"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
