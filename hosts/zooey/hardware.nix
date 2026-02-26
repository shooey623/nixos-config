{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
 # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

 # nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
 # nix.settings.trusted-public-keys = [
 #   "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
 # ];

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
    powerManagement.enable = false;
    open = true;
    nvidiaPersistenced = true;
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
