{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.pc.kdeconnect;
in {
  options.me.pc.kdeconnect = {
    enable = mkEnableOption "Enable kdeConnect";
    indicator = mkEnableOption "Add kdeConnect indicator SysD unit";
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.kdeconnect.enable = true;
    }
    (mkIf cfg.indicator {
      systemd.user.services.kdeconnect-indicator = with pkgs; {
        wantedBy = ["graphical-session.target"];
        enable = true;
        description = "Show the indicator for KDE Connect";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${kdePackages.kdeconnect-kde}/bin/kdeconnect-indicator";
          Restart = "always";
        };
      };
    })
  ]);
}
