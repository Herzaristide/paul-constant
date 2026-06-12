{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./chromium.nix
  ];

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  programs.fish.enable = true;
  programs.git.enable = true;

  home.sessionVariables = {
    EDITOR = "nano";
    BROWSER = "chromium";
    TERMINAL = "gnome-terminal";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "chromium-browser.desktop";
      "x-scheme-handler/http" = "chromium-browser.desktop";
      "x-scheme-handler/https" = "chromium-browser.desktop";
      "x-scheme-handler/about" = "chromium-browser.desktop";
      "x-scheme-handler/unknown" = "chromium-browser.desktop";
    };
  };

  home.packages = with pkgs; [
    # Browsers / chat / office
    vesktop
    onlyoffice-desktopeditors
    teams-for-linux
    zoom-us

    # Gaming
    prismlauncher
    heroic

    # AI tooling — claude-code est le CLI officiel. Claude lui-même est
    # installé comme PWA via la policy Chromium dans home/chromium.nix
    # (WebAppInstallForceList sur https://claude.ai/new).
    claude-code

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
    "org/gnome/terminal/legacy/keybindings" = {
      copy = "<Primary>c";
      paste = "<Primary>v";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "chromium-browser.desktop"
        "vesktop.desktop"
        "DesktopEditors.desktop"
        "org.prismlauncher.PrismLauncher.desktop"
        "steam.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };
}
