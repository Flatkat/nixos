{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.me.base;
in {
  options.me.base = {
    enable = mkEnableOption "Enable base";
  };
  config = mkIf cfg.enable {
    users.users.flatkat = lib.mkDefault {
      isNormalUser = true;
      extraGroups = ["wheel"];
      initialPassword = "abc123.";
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.trusted-users = ["flatkat"];

    programs.nix-ld.enable = true;

    console.keyMap = "es";

    time.timeZone = lib.mkDefault "Europe/Madrid";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "es_ES.UTF-8";
      LC_IDENTIFICATION = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
      LC_MONETARY = "es_ES.UTF-8";
      LC_NAME = "es_ES.UTF-8";
      LC_NUMERIC = "es_ES.UTF-8";
      LC_PAPER = "es_ES.UTF-8";
      LC_TELEPHONE = "es_ES.UTF-8";
      LC_TIME = "es_ES.UTF-8";
    };
  };
}
