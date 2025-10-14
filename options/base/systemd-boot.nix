{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.systemd-boot;
in {
  options.me.systemd-boot = {
    enable = mkEnableOption "Enable systemd boot";
  };
  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.loader.efi.canTouchEfiVariables = true;
    
    boot.loader.systemd-boot.editor = false;

    environment.systemPackages = [
      pkgs.sbctl
    ];

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
