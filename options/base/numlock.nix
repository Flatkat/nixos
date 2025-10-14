{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.numlock;
in {
  options.me.numlock = {
    enable = mkEnableOption "Enable auto numlock";
    numlockx = mkEnableOption "Enable auto numlock in xorg";
  };
  config = mkIf cfg.enable (mkMerge [
    {
      systemd.services.numLockOnTty = {
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = lib.mkForce (pkgs.writeShellScript "numLockOnTty" ''
            for tty in /dev/tty{1..6}; do
                ${pkgs.kbd}/bin/setleds -D +num < "$tty";
            done
          '');
        };
      };
    }
    (mkIf cfg.numlockx {
      systemd.user.timers."numlockx_boot" = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnStartupSec = "1us";
          AccuracySec = "1us";
          Unit = "numlockx.service";
        };
      };

      systemd.user.timers."numlockx_sleep" = {
        wantedBy = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];
        after = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];
        timerConfig = {
          AccuracySec = "1us";
          Unit = "numlockx.service";
        };
      };

      systemd.user.services."numlockx" = {
        script = ''
          ${pkgs.numlockx}/bin/numlockx on
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };

      services.xserver.displayManager.setupCommands = "${pkgs.numlockx}/bin/numlockx on";

      environment.systemPackages = [
        pkgs.numlockx
      ];
    })
  ]);
}
