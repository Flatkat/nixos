{
  pkgs,
  unstable,
  self,
  custom-pkgs,
  ...
}: {
  me = {
    base.enable = true;
    doas.enable = true;
    temp.enable = true;
    numlock = {
      enable = true;
      numlockx = true;
    };
    systemd-boot.enable = true;

    pc = {
      laptop = {
        enable = true;
        manualBt = false;
      };

      kdeconnect = {
        enable = true;
        indicator = false;
      };

      firefox.enable = true;
      aw.enable = true;
      appimage.enable = true;

      # Desktop enviroments
      plasma.enable = true;
    };
  };

  services.syncthing.enable = false;
  services.syncthing.user = "flatkat";

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    (pkgs.fishPlugins.callPackage "${self}/derivations/zoxide.nix" {})

    # Propietary Apps
    obsidian
    spotify

    # Apps
    vlc
    anki
    unstable.vesktop
    thunderbird
    gimp3
    vscode-fhs
    qbittorrent
    ungoogled-chromium
    unstable.signal-desktop
    kdePackages.filelight
    libreoffice
    zapzap
    bitwarden-desktop
    protonvpn-gui
    unstable.bottles
    godot
    custom-pkgs.vicinae
    distrobox

    #Gayms :3
    custom-pkgs.eden
    pcsx2
    dolphin-emu
    #emulationstation-de
    owmods-gui
    protonup-qt
    celeste64
    ryubing
    unstable.boilr
    protontricks
    unstable.gale
    prismlauncher
    heroic
    unstable.rpcs3
    itch
    rusty-psn-gui
    cemu

    # Retroarch
    (retroarch.withCores (cores: with cores; [
      mgba
    ]))

    # KDE Plasma
    kdePackages.krohnkite

    # CLI
    gh
    uv
    just
    atuin
    carapace
    fastfetch
    hyfetch
    spicetify-cli

    # Shell
    fish
    nushell

    # LSP
    alejandra
    nixd
    neovim

    # Basic
    bat
    fzf
    wget
    htop
    gotop
    zoxide
  ];

  programs.steam.enable = true;

  #systemd.user.services.vicinae = {
  #  Unit = {
  #    Description = "Vicinae server daemon";
  #    Documentation = [ "https://docs.vicinae.com" ];
  #    After = [ "graphical-session.target" ];
  #    PartOf = [ "graphical-session.target" ];
  #    BindsTo = [ "graphical-session.target" ];
  #  };
  #  Service = {
  #    EnvironmentFile = pkgs.writeText "vicinae-env" ''
  #      USE_LAYER_SHELL=${if cfg.useLayerShell then builtins.toString 1 else builtins.toString 0}
  #    '';
  #    Type = "simple";
  #    ExecStart = "${lib.getExe' cfg.package "vicinae"} server";
  #    Restart = "always";
  #    RestartSec = 5;
  #    KillMode = "process";
  #  };
  #  Install = lib.mkIf cfg.autoStart {
  #    WantedBy = [ "graphical-session.target" ];
  #  };
  #};
  
  # Increase RLIMIT_MEMLOCK for RPCS3, this setting is old and not needed anymore for security apparently
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = "2100000"; # Roughly 2GB in KB, RPCS3 says to do either this or unlimited, but since im a lil paranoid im not going for the latter
    }
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "2100000";
    }];

  networking.networkmanager.enable = true;

  environment.localBinInPath = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  users.users.flatkat = {
    isNormalUser = true;
    description = "Flattest of Kats";
    extraGroups = ["networkmanager"];
    shell = pkgs.fish;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.git.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";

  networking.firewall.enable = false;

  system.stateVersion = "23.11"; # No touchy
}
