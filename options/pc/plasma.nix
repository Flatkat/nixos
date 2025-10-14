{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.pc.plasma;
in {
  options.me.pc.plasma = {
    enable = mkEnableOption "Enable plasma";
  };
  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      oxygen
    ];
    environment.systemPackages = [
      pkgs.kdotool
    ];
  };
}
