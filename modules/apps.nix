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

  # Java 21 — requis pour Minecraft ≥ 1.20.5. Prism gère ses propres JDKs mais
  # avoir Java 21 system-wide évite des téléchargements répétés et sert aux
  # autres apps Java.
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  # OBS — `enableVirtualCamera` charge le module noyau v4l2loopback (besoin
  # system-level), d'où le module NixOS plutôt qu'un simple package home-manager.
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vkcapture
      obs-pipewire-audio-capture
      obs-vaapi
      obs-backgroundremoval
    ];
  };
}
