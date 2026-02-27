{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ ./common.nix ];

  home.username = "sho";
  home.homeDirectory = "/home/sho";
  home.stateVersion = "25.11";

  home.pointerCursor = {
    name = "Capitaine Cursors (Gruvbox)";
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

  home.packages = with pkgs; [
    wezterm
    zed-editor
    nil
    nixfmt
    claude-code
    codex
    gemini-cli
    gruvbox-plus-icons
    ticktick
    obsidian
    moonlight-qt
    solaar
  ];

  home.file.".local/share/fonts/MonoLisa" = {
    source = ./fonts/MonoLisa;
    recursive = true;
  };

  programs.zsh.shellAliases = {
    nvidia-run = "nvidia-offload";
  };

  programs.git = {
    enable = true;
    settings.user.name = "shooey623";
    settings.user.email = "shooey623@gmail.com";
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
        orange = "#d65d0e";
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
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  # ── bat / btop (Gruvbox) ───────────────────────────────
  programs.bat = {
    enable = true;
    config.theme = "gruvbox-dark";
  };
  programs.btop = {
    enable = true;
    settings.color_theme = "gruvbox_dark";
  };

  # ── WezTerm (Gruvbox) ─────────────────────────────────
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

  # ── Zed (Gruvbox) ─────────────────────────────────────
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
    lsp.nil.initialization_options.formatting.command = [ "nixfmt" ];
  };

  home.file.".config/fastfetch/logo.png".source = ./assets/logo.png;

  home.file.".config/fastfetch/config.jsonc".text = builtins.toJSON {
    logo = {
      type = "kitty-direct";
      source = "~/.config/fastfetch/logo.png";
      width = 18;
      padding = {
        top = 1;
        left = 2;
        right = 2;
      };
    };
    display = {
      separator = "  ";
      color = {
        keys = "magenta";
        title = "magenta";
      };
    };
    modules = [
      {
        type = "title";
        format = "{user-name}@{host-name}";
      }
      "separator"
      {
        type = "os";
        key = "  os";
      }
      {
        type = "kernel";
        key = " 󰒋 ker";
      }
      {
        type = "uptime";
        key = " 󰅐 up";
      }
      {
        type = "packages";
        key = " 󰏖 pkgs";
      }
      {
        type = "shell";
        key = " 󰆍 sh";
      }
      {
        type = "de";
        key = " 󰧨 de";
      }
      {
        type = "terminal";
        key = " 󰞷 term";
      }
      {
        type = "cpu";
        key = " 󰍛 cpu";
      }
      {
        type = "gpu";
        key = " 󰢮 gpu";
      }
      {
        type = "memory";
        key = " 󰑭 mem";
      }
      {
        type = "disk";
        key = " 󰋊 disk";
      }
      "break"
      {
        type = "colors";
        paddingLeft = 2;
        symbol = "circle";
      }
    ];
  };

  programs.zsh.initContent = ''
    # Show fastfetch on new interactive shells (not inside editors/scripts)
    if [[ -z "$VSCODE_PID" && -z "$INSIDE_EMACS" && -z "$NVIM" && -o interactive ]]; then
      fastfetch
    fi
  '';

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
        true-color = true;
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
      language-server.nil = {
        command = "nil";
        config.nil.formatting.command = [ "nixfmt" ];
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

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      theme = spicePkgs.themes.text;
      colorScheme = "custom";
      customColorScheme = {
        accent = "d79921";
        accent-active = "fabd2f";
        accent-inactive = "282828";
        banner = "fabd2f";
        border-active = "d79921";
        border-inactive = "3c3836";
        header = "665c54";
        highlight = "504945";
        main = "282828";
        notification = "458588";
        notification-error = "cc241d";
        subtext = "a89984";
        text = "ebdbb2";
      };
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle
      ];
    };
}
