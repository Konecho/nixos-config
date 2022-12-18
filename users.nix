{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" "input" ];
    packages = with pkgs; [
      blender
      gimp
      godot
      inkscape
      # krita

      chezmoi
      disfetch
      ranger
      ffmpeg

      firefox
      microsoft-edge
      obsidian
      libreoffice
      onlyoffice-bin
      # obs-studio
      # thunderbird

      scrcpy
      vscode
      w3m

      ## rust-os-project
      rustup
      gcc
      python310Full
      just
      qemu
      fd
    ];
  };

  home-manager.users.mei = { pkgs, ... }: {
    home = {
      stateVersion = "22.11";
      sessionPath = [ "$HOME/.cargo/bin" ];
      sessionVariables = { TERMINAL = "kitty"; };
      packages = with pkgs; [ bemenu libappindicator ];
    };
    wayland.windowManager.sway = {
      enable = true;
      systemdIntegration = true;
      config = rec {
        bars = [ ];
        menu = "bemenu-run -n";
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "kitty";
        startup = [
          # Launch Firefox on start
          # { command = "kitty"; }
        ];
      };
      extraSessionCommands = ''
        export XDG_CURRENT_DESKTOP=Unity
      '';
    };
    # services.polybar = {
    #   enable = true;
    #   config = {
    #     "bar/top" = {
    #       monitor = "\${env:MONITOR:eDP1}";
    #       width = "100%";
    #       height = "3%";
    #       radius = 0;
    #       modules-center = "date";
    #     };

    #     "module/date" = {
    #       type = "internal/date";
    #       internal = 5;
    #       date = "%d.%m.%y";
    #       time = "%H:%M";
    #       label = "%time%  %date%";
    #     };
    #   };
    # };
    # xdg.userDirs = {
    #   enable = true;
    #   createDirectories = true;
    # };
    programs = {
      home-manager.enable = true;

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
              "clock"
              "tray"
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
              # "icon-size"= 21;
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
              "format-wifi" = "{essid} ({signalStrength}%) {icon}";
              "format-ethernet" = " {ifname}: {ipaddr}/{cidr} ";
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

      bash = {
        enable = true;
        # profileExtra = ""; 
      };
      bottom.enable = true;
      lsd = { enable = true; enableAliases = true; };
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
  };
}
