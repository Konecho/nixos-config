# <home-manager switch --flake .#mei> 
# <nix run nixpkgs#nyancat> #disfetch #neofetch #hyfetch
{ pkgs, ... }:

rec {
  home = let userspkgs = import ./userspkgs.nix pkgs; in
    {
      stateVersion = "22.11";
      username = "mei";
      homeDirectory = "/home/mei";
      sessionPath = [ "$HOME/.cargo/bin" ];
      sessionVariables = { TERMINAL = "kitty"; XDG_CURRENT_DESKTOP = "Unity"; };
      packages = with pkgs; [ libappindicator-gtk3 highlight ] ++ userspkgs."mei";
    };
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    config = rec {
      bars = [ ];
      menu = "rofi -show run";
      modifier = "Mod4";
      terminal = "kitty";
      startup = [
        { command = "systemctl --user restart waybar"; always = true; }
        { command = "fcitx5 -d --replace"; always = true; }
        { command = "starship preset plain-text-symbols > ~/.config/starship.toml"; }
        # { command = "kitty"; }
      ];
      output = {
        HDMI-A-1 = {
          bg = "~/.config/background fill";
        };
      };
    };
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=Unity
    '';
  };
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    # fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
  # xdg.userDirs = {
  #   enable = true;
  #   createDirectories = true;
  # };
  programs = {
    home-manager.enable = true;
    starship = { enable = true; };
    navi.enable = true;
    bat.enable = true; # cat
    tealdeer.enable = true; # <tldr>
    zellij.enable = true; # tmux
    zoxide.enable = true; # <z> cd
    bottom.enable = true; # <btm> top
    mcfly.enable = true; # <ctrl-r>
    broot.enable = true; # <br> tree-view search
    lsd = { enable = true; enableAliases = true; }; # ls
    rofi = {
      enable = true;
      theme = "gruvbox-dark-soft";
    };
    bash = {
      enable = true;
      # profileExtra = ""; 
      historyIgnore = [ "l" "ls" "z" "cd" "exit" ];
    };
    git = {
      enable = true;
      userName = "NixOS";
      userEmail = "me@meiro.top";
    };
    kitty = {
      enable = true;
      font = {
        size = 12;
        name = "FiraCode Nerd Font";
      };
    };
    vscode = {
      enable = true;
      enableUpdateCheck = false;
      userSettings = {
        "workbench.colorTheme" = "Default Light+";
        "nix.enableLanguageServer" = true;
        "editor.fontFamily" = "'FiraCode Nerd Font'";
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
      };
    };
    lf = {
      enable = true;
      previewer = {
        keybinding = "i";
        source = pkgs.writeShellScript "pv.sh" ''
          #!/bin/sh
          case "$1" in
              *.tar*) tar tf "$1";;
              *.zip) unzip -l "$1";;
              *.rar) unrar l "$1";;
              *.7z) 7z l "$1";;
              *.pdf) pdftotext "$1" -;;
              *) highlight -O ansi "$1" || cat "$1";;
          esac
        '';
      };
    };
    waybar = {
      enable = true;
      systemd = { enable = true; target = "sway-session.target"; };
      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: Roboto, Helvetica, Arial, sans-serif;
            font-size: 13px;
            min-height: 0;
        }
        window#waybar {
            background: rgba(43, 48, 59, 0.5);
            border-bottom: 3px solid rgba(100, 114, 125, 0.5);
            color: white;
        }
        #workspaces button {
            padding: 0 5px;
            background: transparent;
            color: white;
            border-bottom: 3px solid transparent;
        }
        #workspaces button.focused {
            background: #64727D;
            border-bottom: 3px solid white;
        }
        #mode, #clock, #battery {
            padding: 0 10px;
            margin: 0 5px;
        }
        #mode {
            background: #64727D;
            border-bottom: 3px solid white;
        }
        #clock {
            background-color: #64727D;
        }
        #battery {
            background-color: #ffffff;
            color: black;
        }
        #battery.charging {
            color: white;
            background-color: #26A65B;
        }
        @keyframes blink {
            to {
                background-color: #ffffff;
                color: black;
            }
        }
      '';
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 24;
          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ ];
          modules-right = [
            "network"
            "temperature"
            "keyboard-state"
            "tray"
            "clock"
          ];
          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{name}";
          };
          "sway/mode" = {
            "format" = "<span style=\"italic\">{}</span>";
          };
          "tray" = {
            "icon-size" = 20;
            "spacing" = 10;
          };
          "clock" = {
            "tooltip-format" = "{:%Y-%m-%d | %H:%M}";
            "format-alt" = "{:%Y-%m-%d}";
          };
          "temperature" = {
            "critical-threshold" = 80;
            "format" = "{temperatureC}°C  ";
          };
          "network" = {
            # "interface" = "wlp4s0";
            "format-wifi" = "{essid} ({signalStrength}%)  ";
            "format-ethernet" = " {ifname}: {ipaddr}/{cidr}  ";
            "format-disconnected" = "Disconnected";
          };
          "keyboard-state" = {
            "numlock" = true;
            "capslock" = true;
            "format" = {
              "numlock" = "N {icon}";
              "capslock" = "C {icon}";
            };
            "format-icons" = {
              "locked" = " ";
              "unlocked" = " ";
            };
          };
        };
      };
    };
    neovim = {
      enable = true;
      coc = { enable = true; };
      vimAlias = true;
      extraConfig = ''
        syntax on
        set showmatch
        set nu
        set backspace=2
        set ruler
        set mouse=a
        set tabstop=4
        set helplang=cn
        set encoding=utf-8
      '';
      plugins = with pkgs.vimPlugins; [
        vim-nix
        rainbow
        {
          plugin = indentLine;
          config = ''
            let g:indent_guides_guide_size=1
            let g:indent_guides_start_level=2
          '';
        }
        { plugin = vim-monokai; config = "colo monokai"; }
        vim-airline-themes
        {
          plugin = vim-airline;
          config = ''
            let g:airline_theme = 'desertink'
            let g:airline#extensions#keymap#enabled = 1
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#left_alt_sep = '|'
            let g:airline#extensions#tabline#formatter = 'default'
            let g:airline#extensions#tabline#buffer_nr_show = 0
            let g:airline#extensions#tabline#buffer_idx_mode = 1
            let g:airline#extensions#tabline#buffer_idx_format = {
                \ '0': '0 ', '1': '1 ', '2': '2 ', '3': '3 ', '4': '4 ',
                \ '5': '5 ', '6': '6 ', '7': '7 ', '8': '8 ', '9': '9 '}
            if !exists('g:airline_symbols')
                let g:airline_symbols = {}
            endif
            let g:airline_symbols.linenr = 'CL'
            let g:airline_symbols.whitespace = '|'
            let g:airline_symbols.maxlinenr = 'Ml'
            let g:airline_symbols.branch = 'BR'
            let g:airline_symbols.readonly = 'RO'
            let g:airline_symbols.dirty = 'DT'
            let g:airline_symbols.crypt = 'CR' 
          '';
        }
      ];
    };
  };
}
