{ pkgs, ... }:

{
  users.users.mei = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" "input" "networkmanager" ];
  };
}
