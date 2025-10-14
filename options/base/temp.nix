{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.temp;
in {
  options.me.temp = {
    enable = mkEnableOption "Enable clearing temp";
  };
  config = mkIf cfg.enable {
    systemd.services.clear-temp = {
      script = ''
        shopt -s dotglob
        ${pkgs.coreutils}/bin/rm -rf $HOME/Downloads/Temp/*
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "flatkat";
      };
    };

    systemd.timers.clear-temp = {
      wantedBy = ["timers.target"];
      timerConfig = {
        Persistent = true;
        OnCalendar = "weekly";
        Unit = "clear-temp.service";
      };
    };
  };
}
