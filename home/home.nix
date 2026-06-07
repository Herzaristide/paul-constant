{
  pkgs,
  config,
  lib,
  ...
}:

{
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  programs.fish.enable = true;

  home.sessionVariables = {
    EDITOR = "nano";
    BROWSER = "brave";
    TERMINAL = "gnome-terminal";
  };

  home.packages = with pkgs; [
    # Browsers / chat / office
    brave
    vesktop
    onlyoffice-desktopeditors

    # Gaming
    prismlauncher

    # AI tooling — claude-code is the official CLI; claude-desktop is the
    # community-packaged desktop app (available in nixos-unstable).
    claude-code
    claude-desktop

    # Misc CLI niceties from the original config
    micro
    fastfetch
    yazi
    starship
  ];

  # GTK dark theme — GNOME color-scheme is set declaratively below via dconf.
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = config.gtk.theme;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-format = "24h";
      clock-show-seconds = true;
      clock-show-weekday = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "brave-browser.desktop"
        "vesktop.desktop"
        "DesktopEditors.desktop"
        "org.prismlauncher.PrismLauncher.desktop"
        "steam.desktop"
        "claude-desktop.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };
}
