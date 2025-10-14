{
  pkgs,
  lib,
  unstable,
  self,
  ...
}: {
  me = {
    base.enable = true;
    grub.enable = true;
    doas.enable = true;
    temp.enable = true;
    numlock = {
      enable = true;
      numlockx = true;
    };

    pc = {
      laptop = {
        enable = true;
        manualBt = false;
        slimbook = true;
      };

      kdeconnect = {
        enable = true;
        indicator = false;
      };

      xkb = {
        enable = true;
        replace = false;
      };

      vscode.enable = false;
      firefox.enable = true;
      aw.enable = true;

      # Desktop enviroments
      xfce.enable = false;
      plasma.enable = true;
      niri.enable = false;
      # cosmic.enable = false;
    };
  };

  services.syncthing.enable = true;
  services.syncthing.user = "flatkat";

  programs.fish.enable = true;

  boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.binfmt.registrations."aarch64-linux" = {
    #   preserveArgvZero = true;
    #   matchCredentials = true;
    fixBinary = true;
  };

  environment.systemPackages = with pkgs; [
    (pkgs.fishPlugins.callPackage "${self}/derivations/zoxide.nix" {})

    # Propietary Apps
    obsidian

    # Apps
    vlc
    anki
    remmina
    vesktop
    xarchiver
    pavucontrol
    # input-leap
    thunderbird
    unstable.dbeaver-bin
    telegram-desktop
    gimp3
    koreader
    qbittorrent
    unstable.signal-desktop
    unstable.beeper
    unstable.jami

    # CLI
    carapace
    gh
    act
    deno
    zola
    just
    atuin
    xdotool
    alejandra
    xorg.xmodmap
    ffmpeg_6-full

    # Shell
    fish
    nushell

    # LSP
    nixd
    neovim

    # Basic
    bat
    fzf
    wget
    htop
    gotop
    zoxide

    # Unstable
    vscode-fhs
    peazip
  ];

  programs.bash.interactiveShellInit = lib.mkBefore ''
    eval "$(${pkgs.zoxide}/bin/zoxide init bash)"
  '';

  networking.networkmanager.enable = true;

  environment.localBinInPath = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  users.users.flatkat = {
    isNormalUser = true;
    description = "PWall";
    extraGroups = ["networkmanager"];
    shell = pkgs.fish;
  };

  programs.ssh.startAgent = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  programs.bash.blesh.enable = true;
  programs.git.enable = true;
  virtualisation.docker.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";

  networking.firewall.enable = false;

  system.stateVersion = "23.11"; # No touchy
}
