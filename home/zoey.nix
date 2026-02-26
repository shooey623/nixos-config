{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ ./common.nix ];

  home.username = "zoey";
  home.homeDirectory = "/home/zoey";
  home.stateVersion = "25.11";

  gtk.enable = true;

  home.packages = with pkgs; [
    wezterm
    nil
    nixfmt
    krita
    gimp
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    })
    nerd-fonts.departure-mono
  ];

  programs.git = {
    enable = true;
    settings.user.name = "shooey623";
    settings.user.email = "shooey623@gmail.com";
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
        key = "  os";
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

  programs.zsh.initExtra = ''
    if [[ -z "$VSCODE_PID" && -z "$INSIDE_EMACS" && -z "$NVIM" && -o interactive ]]; then
      fastfetch
    fi
  '';

  programs.starship = {
    enable = true;
    settings = {
      palette = "sanrio";
      palettes.sanrio = {
        fg = "#f5e6d3";
        bg = "#1a1b2e";
        red = "#e88b9c";
        green = "#a8dbc5";
        yellow = "#f0d895";
        blue = "#a8d1e7";
        purple = "#c5a3d4";
        pink = "#f2a7c3";
        beige = "#edd9c0";
      };
      format = "$directory$git_branch$git_status$nix_shell$character";
      character = {
        success_symbol = "[❯](pink)";
        error_symbol = "[❯](red)";
      };
      directory = {
        style = "bold blue";
        truncation_length = 3;
      };
      git_branch = {
        style = "bold purple";
        symbol = " ";
      };
      git_status = {
        style = "bold red";
      };
      nix_shell = {
        symbol = " ";
        style = "bold beige";
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };
  programs.btop = {
    enable = true;
    settings.color_theme = "sanrio";
  };

  home.file.".config/btop/themes/sanrio.theme".text = ''
    theme[main_bg]="#1a1b2e"
    theme[main_fg]="#f5e6d3"
    theme[title]="#f2a7c3"
    theme[hi_fg]="#a8d1e7"
    theme[selected_bg]="#2e2f42"
    theme[selected_fg]="#f7c4d8"
    theme[inactive_fg]="#c4a6b5"
    theme[graph_text]="#edd9c0"
    theme[meter_bg]="#232437"
    theme[proc_misc]="#a8d1e7"
    theme[cpu_box]="#f2a7c3"
    theme[mem_box]="#a8d1e7"
    theme[net_box]="#c5a3d4"
    theme[proc_box]="#edd9c0"
    theme[div_line]="#2e2f42"
    theme[temp_start]="#a8dbc5"
    theme[temp_mid]="#f0d895"
    theme[temp_end]="#e88b9c"
    theme[cpu_start]="#f2a7c3"
    theme[cpu_mid]="#c5a3d4"
    theme[cpu_end]="#a8d1e7"
    theme[free_start]="#a8dbc5"
    theme[free_mid]="#a8d1e7"
    theme[free_end]="#c5a3d4"
    theme[cached_start]="#edd9c0"
    theme[cached_mid]="#f0d895"
    theme[cached_end]="#f2a7c3"
    theme[available_start]="#a8d1e7"
    theme[available_mid]="#c5a3d4"
    theme[available_end]="#f2a7c3"
    theme[used_start]="#f2a7c3"
    theme[used_mid]="#c5a3d4"
    theme[used_end]="#e88b9c"
    theme[download_start]="#a8d1e7"
    theme[download_mid]="#c5a3d4"
    theme[download_end]="#f2a7c3"
    theme[upload_start]="#a8dbc5"
    theme[upload_mid]="#edd9c0"
    theme[upload_end]="#f0d895"
    theme[process_start]="#a8d1e7"
    theme[process_mid]="#f2a7c3"
    theme[process_end]="#c5a3d4"
  '';

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = wezterm
      local config = wezterm.config_builder()

      config.font = wezterm.font("DepartureMono Nerd Font")
      config.font_size = 13.0
      config.window_background_opacity = 0.92
      config.window_close_confirmation = "NeverPrompt"
      config.use_fancy_tab_bar = false
      config.hide_tab_bar_if_only_one_tab = true

      config.color_scheme = "sanrio"
      config.color_schemes = {
        ["sanrio"] = {
          foreground = "#f5e6d3",
          background = "#1a1b2e",
          cursor_bg = "#f2a7c3",
          cursor_fg = "#1a1b2e",
          cursor_border = "#f2a7c3",
          selection_bg = "#2e2f42",
          selection_fg = "#f5e6d3",
          ansi = {
            "#232437", "#e88b9c", "#a8dbc5", "#f0d895",
            "#a8d1e7", "#c5a3d4", "#f2a7c3", "#f5e6d3",
          },
          brights = {
            "#2e2f42", "#f7c4d8", "#c4f0de", "#f5e4b3",
            "#c4e4f5", "#d4b8e0", "#f7c4d8", "#faf0e6",
          },
          tab_bar = {
            background = "#1a1b2e",
            active_tab = { bg_color = "#2e2f42", fg_color = "#f2a7c3" },
            inactive_tab = { bg_color = "#1a1b2e", fg_color = "#c4a6b5" },
          },
        },
      }

      return config
    '';
  };

  # ── Helix (Sanrio theme) ───────────────────────────────
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "sanrio";
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

  home.file.".config/helix/themes/sanrio.toml".text = ''
    "ui.background" = { bg = "#1a1b2e" }
    "ui.text" = { fg = "#f5e6d3" }
    "ui.text.focus" = { fg = "#faf0e6" }
    "ui.cursor" = { fg = "#1a1b2e", bg = "#f2a7c3" }
    "ui.cursor.primary" = { fg = "#1a1b2e", bg = "#f2a7c3" }
    "ui.cursor.match" = { fg = "#1a1b2e", bg = "#c5a3d4" }
    "ui.selection" = { bg = "#2e2f42" }
    "ui.selection.primary" = { bg = "#3a2f42" }
    "ui.cursorline.primary" = { bg = "#232437" }
    "ui.linenr" = { fg = "#4a4b5e" }
    "ui.linenr.selected" = { fg = "#f2a7c3" }
    "ui.statusline" = { fg = "#f5e6d3", bg = "#232437" }
    "ui.statusline.inactive" = { fg = "#c4a6b5", bg = "#1a1b2e" }
    "ui.statusline.normal" = { fg = "#1a1b2e", bg = "#a8d1e7" }
    "ui.statusline.insert" = { fg = "#1a1b2e", bg = "#f2a7c3" }
    "ui.statusline.select" = { fg = "#1a1b2e", bg = "#c5a3d4" }
    "ui.popup" = { fg = "#f5e6d3", bg = "#232437" }
    "ui.menu" = { fg = "#f5e6d3", bg = "#232437" }
    "ui.menu.selected" = { fg = "#faf0e6", bg = "#2e2f42" }
    "ui.menu.scroll" = { fg = "#f2a7c3", bg = "#232437" }
    "ui.window" = { fg = "#2e2f42" }
    "ui.help" = { fg = "#f5e6d3", bg = "#232437" }
    "ui.virtual.whitespace" = { fg = "#2e2f42" }
    "ui.virtual.indent-guide" = { fg = "#2e2f42" }
    "ui.bufferline" = { fg = "#c4a6b5", bg = "#1a1b2e" }
    "ui.bufferline.active" = { fg = "#f2a7c3", bg = "#232437", modifiers = ["bold"] }
    "diagnostic.error" = { underline = { color = "#e88b9c", style = "curl" } }
    "diagnostic.warning" = { underline = { color = "#f0d895", style = "curl" } }
    "diagnostic.info" = { underline = { color = "#a8d1e7", style = "curl" } }
    "diagnostic.hint" = { underline = { color = "#a8dbc5", style = "curl" } }
    "error" = { fg = "#e88b9c" }
    "warning" = { fg = "#f0d895" }
    "info" = { fg = "#a8d1e7" }
    "hint" = { fg = "#a8dbc5" }
    "comment" = { fg = "#c4a6b5", modifiers = ["italic"] }
    "constant" = { fg = "#f0d895" }
    "constant.numeric" = { fg = "#f0d895" }
    "constant.character.escape" = { fg = "#e88b9c" }
    "string" = { fg = "#a8dbc5" }
    "string.regexp" = { fg = "#e88b9c" }
    "variable" = { fg = "#f5e6d3" }
    "variable.builtin" = { fg = "#f2a7c3" }
    "variable.parameter" = { fg = "#edd9c0" }
    "variable.other.member" = { fg = "#a8d1e7" }
    "function" = { fg = "#a8d1e7" }
    "function.builtin" = { fg = "#a8d1e7", modifiers = ["bold"] }
    "function.macro" = { fg = "#c5a3d4" }
    "type" = { fg = "#f2a7c3" }
    "type.builtin" = { fg = "#f2a7c3", modifiers = ["bold"] }
    "keyword" = { fg = "#c5a3d4" }
    "keyword.operator" = { fg = "#e88b9c" }
    "keyword.function" = { fg = "#c5a3d4", modifiers = ["bold"] }
    "operator" = { fg = "#e88b9c" }
    "punctuation" = { fg = "#c4a6b5" }
    "punctuation.special" = { fg = "#f2a7c3" }
    "tag" = { fg = "#f2a7c3" }
    "tag.attribute" = { fg = "#a8d1e7" }
    "markup.heading" = { fg = "#f2a7c3", modifiers = ["bold"] }
    "markup.bold" = { modifiers = ["bold"] }
    "markup.italic" = { modifiers = ["italic"] }
    "markup.link.url" = { fg = "#a8d1e7", modifiers = ["underlined"] }
    "markup.raw" = { fg = "#edd9c0" }
    "diff.plus" = { fg = "#a8dbc5" }
    "diff.minus" = { fg = "#e88b9c" }
    "diff.delta" = { fg = "#a8d1e7" }
  '';

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    theme = spicePkgs.themes.text;
    colorScheme = "custom";
    customColorScheme = {
      accent             = "f2a7c3";
      accent-active      = "f7c4d8";
      accent-inactive    = "1a1b2e";
      banner             = "f2a7c3";
      border-active      = "f2a7c3";
      border-inactive    = "2e2f42";
      header             = "4a4b5e";
      highlight          = "3a2f42";
      main               = "1a1b2e";
      notification       = "a8dbc5";
      notification-error = "e88b9c";
      subtext            = "c4a6b5";
      text               = "f5e6d3";
    };
    enabledExtensions = with spicePkgs.extensions; [
      adblockify shuffle
    ];
  };
}
