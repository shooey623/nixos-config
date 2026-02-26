{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

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

  nix.settings.substituters = [
    "https://attic.xuyh0120.win/lantian"
  ];

  nix.settings.trusted-public-keys = [
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    open = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:65:0:0";
    };
  };

  hardware.nvidia.nvidiaPersistenced = true;

  environment.variables = {
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
  '';

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };
  
  swapDevices = [
    {
      device = "/swap/swapfile";
    }
  ];

  systemd.services.nvidia-suspend.wantedBy = lib.mkForce [
    "systemd-suspend.service"
    "systemd-suspend-then-hibernate.service"
    "systemd-hybrid-sleep.service"
  ];

  systemd.services.nvidia-hibernate.wantedBy = lib.mkForce [
    "systemd-hibernate.service"
    "systemd-suspend-then-hibernate.service"
  ];

  systemd.services.nvidia-resume.wantedBy = lib.mkForce [
    "systemd-resume.service"
    "systemd-suspend-then-hibernate.service"
    "systemd-hybrid-sleep.service"
  ];

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  services.supergfxd.enable = true;
  services.power-profiles-daemon.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.pipewire.extraConfig.pipewire = {
    "99-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 256;
      };
    };
  };

  services.pulseaudio.enable = false;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.wireless.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
