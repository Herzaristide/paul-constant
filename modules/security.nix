{ pkgs, ... }:

{
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.yama.ptrace_scope" = 1;

    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.all.log_martians" = 1;
  };

  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = false;
  };

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  security.auditd.enable = true;
  security.audit = {
    enable = false;
    rules = [
      "-w /etc/sudoers -p wa -k sudoers"
      "-w /etc/passwd -p wa -k passwd"
      "-w /etc/shadow -p wa -k shadow"
      "-w /etc/group -p wa -k group"
      "-w /etc/ssh/sshd_config -p wa -k sshd_config"
      "-w /etc/nixos -p wa -k nixos_config"
      "-a always,exit -F arch=b64 -S execve -F path=/run/wrappers/bin/sudo -k sudo_exec"
    ];
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h";
    };
  };

  boot.loader.systemd-boot.editor = false;
}
