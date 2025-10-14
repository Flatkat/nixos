{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.pc.aw;
in {
  options.me.pc.aw = {
    enable = mkEnableOption "Enable activitywatch";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.activitywatch
    ];

    systemd.user.services.aw = {
      enable = true;
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      description = "Open-source time tracker";
      serviceConfig = {
        Environment = "PATH=${pkgs.activitywatch}/bin/";
        Type = "simple";
        ExecStart = "${pkgs.activitywatch}/bin/aw-qt";
        Restart = "always";
      };
    };
  };
}
