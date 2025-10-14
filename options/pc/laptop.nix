{
  pkgs,
  config,
  lib,
  self,
  ...
}:
with lib; let
  cfg = config.me.pc.laptop;
in {
  options.me.pc.laptop = {
    enable = mkEnableOption "Is the machine a laptop";
    manualBt = mkEnableOption "Enable manual bluetooth managment (blueman, mpris)";
  };
  config = mkIf cfg.enable (mkMerge [
    {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
    }
    (mkIf cfg.manualBt {
      services.blueman.enable = true;
      systemd.user.services.mpris-proxy = {
        wantedBy = ["default.target"];
        enable = true;
        description = "Forward bluetooth media controls to MPRIS";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        };
      };
    })
  ]);
}
