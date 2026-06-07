{
  config,
  pkgs,
  inputs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  options.head = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable head (GUI) configuration";
  };

  options.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "Login name of the primary normal user on this host.";
  };

  options.darkMode = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Use dark color scheme (false = light mode).";
  };

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    # Inject community packages that aren't (yet) in nixpkgs so the rest of the
    # tree can refer to them as `pkgs.claude-desktop` etc.
    nixpkgs.overlays = [
      (final: prev: {
        claude-desktop = inputs.claude-desktop.packages.${prev.stdenv.hostPlatform.system}.claude-desktop;
      })
    ];

    console = {
      enable = lib.mkDefault true;
      earlySetup = true;
      font = "ter-v32n";
      packages = [ pkgs.terminus_font ];
      keyMap = "fr";
    };

    time.timeZone = "Europe/Paris";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      btop
      iotop
      sysstat
      lsof
      strace
      smartmontools

      pciutils
      usbutils
      lm_sensors
      dmidecode

      curl
      dig
      nmap
      tcpdump
      iproute2
      iperf3
      ethtool
      wakeonlan

      parted
      gptfdisk
      tree
      fd
      ripgrep
      file
      unzip
      p7zip
      gzip

      tmux
      jq
      yq-go
      openssl
      envsubst

      glances
    ];

    users.mutableUsers = false;
    users.users.root.hashedPassword = "!";

    users.users.${config.primaryUser} = {
      isNormalUser = true;
      description = config.primaryUser;
      shell = pkgs.fish;
      hashedPasswordFile = "/etc/passwd-${config.primaryUser}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "video"
        "render"
        "audio"
        "storage"
        "gamemode"
      ];
    };

    security.sudo.extraRules = [
      {
        users = [ config.primaryUser ];
        commands = [
          {
            command = "${pkgs.smartmontools}/bin/smartctl";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.dmidecode}/bin/dmidecode";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    virtualisation.docker.enable = true;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs;
        head = config.head;
        darkMode = config.darkMode;
      };
      users.${config.primaryUser} = import ../home/home.nix;
    };
  };
}
