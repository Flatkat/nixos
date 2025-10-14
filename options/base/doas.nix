{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.doas;
in {
  options.me.doas = {
    enable = mkEnableOption "Enable doas";
  };
  config = mkIf cfg.enable {
    security.sudo.enable = false;
    security.doas.enable = true;
    security.doas.extraRules = [
      {
        users = ["flatkat"];
        keepEnv = true;
        persist = true;
      }
    ];
    environment.systemPackages = [
      pkgs.doas-sudo-shim
    ];
  };
}
