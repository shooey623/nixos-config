{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "sho";
  home.homeDirectory = "/home/sho";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.pointerCursor = {
    name = "capitaine-cursors-gruvbox";
    package = pkgs.capitaine-cursors-themed;
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
  };
  
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
  };
  
  home.packages = with pkgs; [
    wezterm
    fastfetch
    
    zed-editor
    helix
    nil
    nixfmt

    claude-code
    codex
    gemini-cli

    ticktick
    obsidian
    
    ripgrep
    fd
    eza
    bat
    btop
    unzip
    p7zip
    zoxide

    vlc
    gimp
    inkscape
    gowall
    
    vesktop
    firefox
    
    gruvbox-plus-icons
    capitaine-cursors-themed
    
    protonup-qt
    
    comma
    nvd
    nix-output-monitor
  ];

  home.file.".local/share/fonts/MonoLisa" = {
    source = ./fonts/MonoLisa;
    recursive = true;
  };
  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    settings.user.name = "shooey623";
    settings.user.email = "shooey623@gmail.com";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      rebuild = "find ~ -name '*.bak' -not -path '*/nix/*' -delete 2>/dev/null; nh os switch /etc/nixos";
      update = "nix flake update --flake /etc/nixos && nh os switch /etc/nixos";
      gc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      ls = "eza --icons";
      ll = "eza -la --icons";
      cat = "bat";
      nvidia-run = "nvidia-offload";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      palette = "gruvbox";
      palettes.gruvbox = {
        fg = "#ebdbb2";
        bg = "#282828";
        red = "#cc241d";
        green = "#98971a";
        yellow = "#d79921";
        blue = "#458588";
        purple = "#b16286";
        aqua = "#689d6a";
        orange = "d65d0e";   
      };
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$character";
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };
      directory = {
        style = "bold yellow";
        truncation_length = 3;
      };
      git_branch = {
        style = "bold aqua";
        symbol = " ";
      };
      git_status = {
        style = "bold red";
      };
      nix_shell = {
        symbol = " ";
        style = "bold blue";
        format = "via [$symbol$state]($style)";
      };
    };
  };

  programs.bat = {
    enable = true;
    config.theme = "gruvbox-dark";
  };

  programs.btop = {
    enable = true;
    settings.color_theme = "gruvbox_dark";
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      			local config = wezterm.config_builder()
      			
      			config.font = wezterm.font("MonoLisa")
      			config.font_size = 12.0
      			config.window_background_opacity = 0.9
      			config.window_close_confirmation = "NeverPrompt"
      			config.color_scheme = "GruvboxDark"

            config.use_fancy_tab_bar = false
            config.hide_tab_bar_if_only_one_tab = true

      			return config	
      		'';
  };

  home.file.".config/zed/settings.json".text = builtins.toJSON {
    theme = {
      mode = "dark";
      dark = "Gruvbox Dark";
      light = "Gruvbox Light";
    };

    buffer_font_family = "MonoLisa";
    buffer_font_size = 14;
    ui_font_family = "IBM Plex Sans";
    ui_font_size = 14;
    terminal = {
      font_family = "MonoLisa";
      font_size = 13;
    };

    format_on_save = "on";
    lsp = {
      nil = {
        initialization_options = {
          formatting.command = [ "nixfmt" ];
        };
      };
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "gruvbox";

      editor = {
        line-number = "relative";
        cursorline = true;
        scrolloff = 8;
        mouse = true;
        auto-format = true;
        auto-save = true;
        completion-trigger-len = 1;
        true-color = true;
        undercurl = true;
        color-modes = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
          ignore = true;
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
          ];
          center = [ "diagnostics" ];
          right = [
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
        };

        indent-guides = {
          render = true;
          character = "▏";
        };

        soft-wrap = {
          enable = false;
        };
      };

      keys = {
        normal = {
          space = {
            f = ":open ~/.config/helix/";
            w = ":write";
            q = ":quit";
          };

          C-h = "jump_view_left";
          C-j = "jump_view_down";
          C-k = "jump_view_up";
          C-l = "jump_view_right";
        };

        insert = {
          C-s = [
            "normal_mode"
            ":write"
          ];
        };
      };
    };

    languages = {
      language-server = {
        nil = {
          command = "nil";
          config.nil.formatting.command = [ "nixfmt" ];
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "nixfmt";
          language-servers = [ "nil" ];
        }
      ];
    };
   };

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

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    theme = spicePkgs.themes.text;
    customColorScheme = {
      text = "ebdbb2";
      subtext = "a89984";
      main = "282828";
      sidebar = "1d2021";
      player = "32302f";
      card = "3c3836";
      shadow = "1d2021";
      selected-row = "504945";
      button = "fabd2f";
      button-active = "d79921";
      button-disabled = "665c54";
      notification = "98971a";
      notification-error = "cc241d";
      misc = "689d6a";
      tab-active = "fabd2f";
      playback-bar = "fabd2f";
    };
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      shuffle
    ];
  };
}
