{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cjktty = pkgs.fetchFromGitHub {
    owner = "zhmars";
    repo = "cjktty-patches";
    rev = "0d0015730edd2190dee7233f87dd72c423bb75e9";
    hash = "sha256-2PifENv3HD9a1q+uPsMnFp5RHdGcV4qOyX4e5dmDHK4=";
  };
  version = "6.6.44";
  versionX = lib.versions.major version;
  versionX_X = lib.versions.majorMinor version;
  # TODO lock dependency version
  linuxPackage = {
    fetchurl,
    buildLinux,
    ...
  } @ args:
    buildLinux (
      args
      // rec {
        inherit version;
        modDirVersion = version;

        src = fetchurl {
          url = "mirror://kernel/linux/kernel/v${versionX}.x/linux-${version}.tar.xz";
          sha256 = "sha256-kyGClpNJFWNv5roI4SWUhCTMJw/YlIUCwKuRCHqfzNg=";
        };

        kernelPatches = [
          pkgs.kernelPatches.bridge_stp_helper
          pkgs.kernelPatches.request_key_helper
          {
            name = "cjktty";
            patch = "${cjktty}/v${versionX}.x/cjktty-${versionX_X}.patch";
            extraStructuredConfig = {
              FONT_CJK_16x16 = lib.kernel.yes;
              FONT_CJK_32x32 = lib.kernel.yes;
            };
          }
        ];

        extraMeta.branch = versionX_X;
      }
      // (args.argsOverride or {})
    );
  linux = pkgs.callPackage linuxPackage {};

  customKernel = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux);
in {
  # boot.loader.grub = {
  #   efiSupport = true;
  #   device = "nodev";
  #   # configurationLimit = 8;
  # };
  imports = [
    inputs.minegrub-theme.nixosModules.default
  ];
  # boot.loader.systemd-boot = {
  #   enable = true;
  #   configurationLimit = 16;
  # };
  boot.loader.grub = {
    configurationLimit = 30;
    efiSupport = true;
    #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
    useOSProber = true;
    device = "nodev";
    minegrub-theme = {
      enable = true;
      splash = "100% Flakes!";
      background = "background_options/1.8  - [Classic Minecraft].png";
      boot-options-count = 4;
    };
    # ...
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  # boot.kernelPackages = customKernel;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
