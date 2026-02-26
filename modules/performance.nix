{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot.kernelParams = [
    "nowatchdog"
    "nmi_watchdog=0"
    "mitigations=off"
    "usbhid.mousepoll=1"
  ];

  boot.blacklistedKernelModules = [ "sp5100_tco" ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.compaction_proactiveness" = 0;
    "vm.page_cluster" = 0;
    "kernel.split_lock_mitigate" = 0;
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
  '';

 # services.ananicy = {
  #  enable = true;
  #  package = pkgs.ananicy-cpp;
  #  rulesProvider = pkgs.ananicy-rules-cachyos;
 # };

  environment.variables = {
    __GL_SHADER_DISK_CAHCE = "1";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire = {
      "99-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
        };
      };
    };
  };

  services.pulseaudio.enable = false;
}
