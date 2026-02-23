{
  inputs,
  pkgs,
  ...
}: let
  rycee-addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  # home.nix
  imports = [
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  programs.zen-browser = {
    enable = true;
    suppressXdgMigrationWarning = true;
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
    # profiles.default.sine.enable = true;
    profiles.default.extensions.packages = import ./firefox-addons.nix {
      inherit rycee-addons;
      inherit (pkgs) fetchgit stdenv zip;
    };
    profiles.default.mods = [
      "642854b5-88b4-4c40-b256-e035532109df"
    ];
  };
}
