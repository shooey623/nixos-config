{
  config,
  pkgs,
  inputs,
  ...
}:

{
  system.stateVersion = "25.11";
  networking.hostName = "zooey";

  time.timeZone = "Asia/Singapore";

  nix.settings.trusted-users = [
    "root"
    "zoey"
  ];

  users.users.zoey = {
    isNormalUser = true;
    description = "Zoey";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };

  services.tailscale.enable = true;

  # ── Sunshine (Moonlight streaming host) ────────────────
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    };
  };
}
