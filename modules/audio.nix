{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.musnix.nixosModules.musnix
  ];

  musnix = {
    enable = true;
    alsaSeq.enable = true;
    kernel.realtime = false;
    soundcardPciId = "";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."99-echo-cancel" = {
      "context.modules" = [
        {
          name = "libpipewire-module-echo-cancel";
          args = {
            "library.name" = "aec/libspa-aec-webrtc";
            "node.description" = "Echo Cancelled Source";
            "capture.props" = {
              "node.name" = "capture.echo-cancel";
              "node.passive" = true;
              "audio.channels" = 2;
              "audio.position" = [
                "FL"
                "FR"
              ];
            };
            "source.props" = {
              "node.name" = "echo-cancel-source";
              "node.description" = "Microphone (Echo Cancelled)";
              "priority.session" = 1500;
              "audio.channels" = 2;
              "audio.position" = [
                "FL"
                "FR"
              ];
            };
            "playback.props" = {
              "node.name" = "playback.echo-cancel";
              "node.passive" = true;
            };
            "sink.props" = {
              "node.name" = "echo-cancel-sink";
              "node.description" = "Speakers (Echo Cancel Loopback)";
            };
            "aec.args" = {
              "webrtc.gain_control" = true;
              "webrtc.extended_filter" = true;
              "webrtc.noise_suppression" = true;
            };
          };
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    sox
    alsa-utils
  ];
}
