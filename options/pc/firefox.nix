{
  pkgs,
  config,
  lib,
  custom-pkgs,
  ...
}:
with lib; let
  cfg = config.me.pc.firefox;
in {
  options.me.pc.firefox = {
    enable = mkEnableOption "Enable firefox";
  };
  config = mkIf cfg.enable {
    programs.firefox.enable = true;
    programs.firefox.package = custom-pkgs.zen-browser;
    environment.systemPackages = [
      pkgs.firefox-devedition
    ];
  };
}
