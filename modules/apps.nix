{ pkgs, ... }:

{
  # Steam — needs system-level integration (32-bit graphics, udev rules, firewall)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # 32-bit graphics needed by Steam/Prism Launcher (Minecraft mods, Wine)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Java — Prism Launcher fetches its own JDKs, but having one system-wide is
  # convenient for fallback launches and other Java apps.
  programs.java.enable = true;
}
