{
  config,
  pkgs,
  inputs,
  ...
}:

{
  system.stateVersion = "25.11";
  networking.hostName = "zephyrus";

  time.timeZone = "Asia/Seoul";

  nix.settings.trusted-users = [
    "root"
    "sho"
  ];

  users.users.sho = {
    isNormalUser = true;
    description = "Sho";
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
}
