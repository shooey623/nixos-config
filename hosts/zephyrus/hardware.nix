{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
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
    nvidiaPersistenced = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:65:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  
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
  };
  services.supergfxd.enable = true;
  services.power-profiles-daemon.enable = true;

  swapDevices = [ { device = "/swap/swapfile"; } ];
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.wifi.backend = "iwd";
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
