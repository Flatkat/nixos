{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.pc.appimage;
in {
  options.me.pc.appimage = {
    enable = mkEnableOption "Enable AppImage support";
  };
  config = mkIf cfg.enable {
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
  };
}

