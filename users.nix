{ pkgs, home-manager, ... }:

{
  # imports = [ home-manager ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" "input" "networkmanager" ];
    packages = with pkgs; [
      blender
      gimp
      godot
      inkscape
      # krita

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

      # chezmoi
      # ranger
      # ffmpeg

      ## rust-os-project
      rustup
      gcc
      python310Full
      qemu

      just # make
      fd # find
      procs # ps
      sd # sed
      du-dust # <dust> du
      ripgrep # <rg> grep
    ];
  };

  # home-manager.users.mei = 
}
