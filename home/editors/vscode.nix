{
  pkgs,
  config,
  lib,
  username,
  ...
}: {
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
  # home.activation.symlinks = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   echo "-------------------------------------------------------------"
  #   echo "------------ START MANUAL IDEMPOTENT SECTION ----------------"
  #   echo "-------------------------------------------------------------"
  #   homedir=${config.home.homeDirectory}
  #   echo "****** homedir=$homedir"

  #   echo
  #   echo "------ symlinks ----"

  #   symlink() {
  #     local src="$1"
  #     local dest="$2"
  #     [[ -e "$src" ]] && {
  #         [[ -e $dest ]] && {
  #             echo "****** OK: $dest exists"
  #         } || {
  #             $DRY_RUN_CMD ln -s "$src" "$dest" || {
  #                 echo "****** ERROR: could not symlink $src to $dest"
  #             }
  #             echo "****** CHANGED: $dest updated"
  #         }
  #     } || {
  #         echo "****** ERROR: source $src does not exist"
  #     }
  #   }

  #   symlink "$homedir/.vscode/extensions" \
  #           "$homedir/.vscode-oss/extensions"
  #   # symlink "$homedir/.config/Code/User/settings.json" \
  #   #         "$homedir/.config/VSCodium/User/settings.json"

  #   echo "-------------------------------------------------------------"
  #   echo "------------ END MANUAL IDEMPOTENT SECTION ----------------"
  #   echo "-------------------------------------------------------------"
  # '';
}
