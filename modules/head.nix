{ pkgs, ... }:

{
  # dconf — required for GTK/GNOME settings persistence
  programs.dconf.enable = true;

  # GNOME Keyring (Secret Service) — unlocked by PAM at login
  services.gnome.gnome-keyring.enable = true;

  # Backends de stockage pour Nautilus : disques externes, partitions, réseau
  # (SMB/SFTP/etc.), corbeille. Sans ça, "Other Locations" reste vide et les
  # USB ne se montent pas auto.
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # XDG Portal for file pickers, screen sharing, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  # X server + GDM + GNOME
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # GNOME applications shipped alongside the desktop
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    dconf-editor

    # Core GNOME apps
    gnome-calculator
    gnome-calendar
    gnome-clocks
    gnome-weather
    gnome-maps
    gnome-music
    gnome-photos
    gnome-screenshot
    gnome-system-monitor
    gnome-disk-utility
    gnome-characters
    gnome-font-viewer
    gnome-logs
    gnome-text-editor
    gnome-connections
    gnome-contacts
    gnome-boxes

    nautilus
    file-roller
    evince
    eog
    loupe
    totem
    snapshot
    seahorse
    baobab
    simple-scan
    cheese
  ];

  # Printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  environment.variables.FC_FONTATIONS = "0";
}
