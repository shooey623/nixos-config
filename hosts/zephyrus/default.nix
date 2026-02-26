{
  config,
  pkgs,
  inputs,
  ...
}:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "sho"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "25.11";
  networking.hostName = "zephyrus";
  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  users.users.sho = {
    isNormalUser = true;
    description = "Sho / Me! Aha";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    pciutils
    usbutils
    htop
    nh
  ];

  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
    ];
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  fonts = {
    packages = with pkgs; [
      ibm-plex
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif CJK KR" "Noto Serif CJK JP" "NOto Serif" ];
      sansSerif = [ "IBM Plex Sans" "Noto Sans CJK KR" "Noto Sans CJK JP" "Noto Sans" ];
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-hangul
        fcitx5-mozc
        fcitx5-gtk
        kdePackages.fcitx5-qt
      ];
      waylandFrontend = true;
    };
  };

  services.tailscale.enable = true;
}
