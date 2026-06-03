{
  pkgs,
  config,
  lib,
  unstable,
  ...
}:
with lib; let
  cfg = config.me.pc.niri;
in {
  options.me.pc.niri = {
    enable = mkEnableOption "Enable niri";
  };
  config = mkIf cfg.enable {
    programs.niri.enable = true;

    services.gnome.gcr-ssh-agent.enable = mkDefault false;
    /*
    services.greetd.enable = true;
    services.greetd.settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --user-menu --remember --asterisks --time";
      user = "greeter";
    };
    */
    environment.systemPackages = [
      unstable.onagre
      pkgs.xwayland-satellite
      pkgs.alacritty
      pkgs.wlr-randr
      pkgs.fuzzel
    ];

    systemd.user.services.mako = with pkgs; {
      enable = true;
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      description = "Lightweight Wayland notification daemon";
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecCondition = ''/bin/sh -C '[ -n "$WAYLAND_DISPLAY"]' '';
        ExecStart = "${mako}/bin/mako";
        ExecReload = "${mako}/bin/mako reload";
        Restart = "always";
      };
    };

    programs.waybar.enable = true;
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      nerd-fonts.symbols-only
      roboto-mono
      font-awesome
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # "Disable" XWayland for Electron
    environment.sessionVariables.GTK_THEME = "Adwaita:dark"; # Dark theme for GTK4
  };
}