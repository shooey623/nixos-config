{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    package = pkgs.steam.override {
      extraPkgs =
        p: with p; [
          mangohud
          gamemode
        ];
    };
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        inhibit_screensaver = 0;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsiblity";
        gpu_device = 0;
      };
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    lutris
    heroic
    winetricks
    wineWow64Packages.stable
    wineWow64Packages.staging
    vulkan-tools
    mesa-demos
    protontricks
  ];

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1";
  };
}
