{
  pkgs,
  lib,
  ...
}:

{
  networking.networkmanager.enable = lib.mkDefault true;
  networking.networkmanager.wifi.macAddress = "stable";
  networking.networkmanager.ethernet.macAddress = "stable";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
      AllowAgentForwarding = false;
      MaxAuthTries = 3;
      LoginGraceTime = 30;
    };
  };

  # Wake-on-LAN on all wired interfaces (skips loopback/virtual/wireless and
  # NICs that don't advertise WoL support, so safe on every host).
  systemd.services.wake-on-lan = {
    description = "Enable Wake-on-LAN on all wired interfaces";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-pre.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [ pkgs.ethtool ];
    script = ''
      for sys in /sys/class/net/*; do
        name=$(basename "$sys")
        [ "$name" = "lo" ] && continue
        [ -d "$sys/wireless" ] && continue
        [ ! -e "$sys/device" ] && continue
        if ethtool "$name" 2>/dev/null | grep -q 'Supports Wake-on:.*g'; then
          ethtool -s "$name" wol g || true
        fi
      done
    '';
  };

  networking.firewall = {
    enable = lib.mkDefault true;
    allowedTCPPorts = [
      22
      80
    ];
    allowedUDPPorts = [
      51820
      51821
    ];
    trustedInterfaces = [ "lo" ];
  };
}
