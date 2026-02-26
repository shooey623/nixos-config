{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs.home-manager.enable = true;

  # ── XDG user directories ──────────────────────────────
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
    templates = "${config.home.homeDirectory}/Templates";
    publicShare = "${config.home.homeDirectory}/Public";
  };

  # ── Shared packages ────────────────────────────────────
  home.packages = with pkgs; [
    fastfetch
    ripgrep
    fd
    eza
    bat
    btop
    unzip
    p7zip
    vlc
    firefox
    vesktop
    protonup-qt
    comma
    nvd
    nix-output-monitor
  ];

  fonts.fontconfig.enable = true;

  # ── Zsh (base config) ─────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = "find ~ -name '*.hm-backup' -not -path '*/nix/*' -delete 2>/dev/null; nh os switch /etc/nixos";
      update = "nix flake update --flake /etc/nixos && nh os switch /etc/nixos";
      gc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      ls = "eza --icons";
      ll = "eza -la --icons";
      cat = "bat";
    };
  };

  # ── Direnv ─────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ── MangoHud ───────────────────────────────────────────
  home.file.".config/MangoHud/MangoHud.conf".text = ''
    fps
    frametime
    gpu_stats
    gpu_temp
    gpu_power
    cpu_stats
    cpu_temp
    ram
    vram
    wine
    gamemode
    position=top-left
    font_size=20
    background_alpha=0.3
  '';
}
