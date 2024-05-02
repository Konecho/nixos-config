{
  pkgs,
  inputs,
  ...
}: {
  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        show_banner: false,
      }
    '';
    loginFile.text = ''
      def greet [] {
        catimg-pokemon -f ${inputs.pokesprite}
      }
      greet
    '';
  };
}
