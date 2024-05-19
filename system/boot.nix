{
  pkgs,
  lib,
  config,
  ...
}: {
  boot.loader = {
    grub.efiSupport = true;
    grub.device = "nodev";
    efi.canTouchEfiVariables = true;
  };

  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelPackages = let
    cjktty = pkgs.fetchFromGitHub {
      owner = "zhmars";
      repo = "cjktty-patches";
      rev = "0d0015730edd2190dee7233f87dd72c423bb75e9";
      hash = "sha256-2PifENv3HD9a1q+uPsMnFp5RHdGcV4qOyX4e5dmDHK4=";
    };
    linux_6_6_pkg = {
      fetchurl,
      buildLinux,
      ...
    } @ args:
      buildLinux (args
        // rec
        {
          version = "6.6.31";
          modDirVersion = version;

          src = fetchurl {
            url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "sha256:080wwrc231fbf43hvvygddmdxdspyw23jc5vnd6fr5ccdybgzv6n";
          };

          kernelPatches = [
            pkgs.kernelPatches.bridge_stp_helper
            pkgs.kernelPatches.request_key_helper
            {
              name = "cjktty";
              patch = "${cjktty}/v6.x/cjktty-6.6.patch";
              extraStructuredConfig = {
                FONT_CJK_16x16 = lib.kernel.yes;
                FONT_CJK_32x32 = lib.kernel.yes;
              };
            }
          ];

          extraMeta.branch = "6.6";
        }
        // (args.argsOverride or {}));
    linux_6_6 = pkgs.callPackage linux_6_6_pkg {};
  in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_6_6);
}
