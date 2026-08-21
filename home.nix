{ config, pkgs, ... }:

let
  herdr = pkgs.stdenv.mkDerivation {
    pname = "herdr";
    version = "0.8.0";
    src = pkgs.fetchurl {
      url = "https://github.com/herdrdev/herdr/releases/download/v0.8.0/herdr-linux-x86_64";
      hash = "sha256-uHLqfkD6LLF+hXrJtisb8m23tAPGIvXS8/WzX26azSg=";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];
    dontUnpack = true;
    installPhase = ''
      install -Dm755 $src $out/bin/herdr
    '';
  };

  cve-lite-cli = pkgs.buildNpmPackage rec {
    pname = "cve-lite-cli";
    version = "1.27.0";
    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/cve-lite-cli/-/cve-lite-cli-${version}.tgz";
      hash = "sha256-H/NbW4ExDpeS8QK+MTIPdsCx+IOZKZkYbGMERdlPePo=";
    };
    sourceRoot = "package";
    postPatch = ''
      cp ${./config/cve-lite-cli-lock.json} package-lock.json
    '';
    npmDepsHash = "sha256-DifGD7xDqKoQEVhqYg5BXrRDCFfccPfQFPUtZ1UvxNQ=";
    dontNpmBuild = true;
    nativeBuildInputs = [ pkgs.python3 pkgs.pkg-config pkgs.sqlite ];
  };
in

{

  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-27.3.11"
    ];
  };


  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "frbl";
  home.homeDirectory = "/home/frbl";

  # Packages to install
  home.packages = with pkgs; [
    # Languages
    # terraform
    gcc
    #ruby_3_1
    ruby
    nodejs
    elixir
    erlang
    R
    rstudio
    gnumake
    solargraph


    # File management
    thunar
    unzip

    ansible

    # Go
    go
    sqlc

    #
    android-tools
    libX11.dev

    libva

    # Signing and editing PDFs
    qpdf
    xournalpp
    pdf-sign
    signaturepdf
    masterpdfeditor4

    gettext
    #tools
    zotero
    dbeaver-bin
    remmina #remotedesktop

    # Ubuntu apparmor
    apparmor-utils
    apparmor-profiles
    apparmor-bin-utils
    #apparmor-easyprof
    #apparmor-notify

    # Keyboard tools
    kmonad
    #autokey
    espanso

    asciinema

    # Games
    gcompris
    zeroad 

    swagger-codegen

    #logseq
    picom

    texlive.combined.scheme-full
    obsidian
    trilium-desktop # Obsidian alternative

    teleport
    doctl

    sonar-scanner-cli

    # Amateur radio
    chirp
    gqrx
    sdrangel
    sdrpp
    cubicsdr
    wsjtx
    fldigi
    qsstv
    # gpredict

    # Noaa
    noaa-apt
    jack2 # Virtual audio cable
    pulseaudioFull

    # RTL-SDR drivers
    libusb1
    rtl-sdr-osmocom

    #nixFlakes

    # General
    openssl
    pandoc
    flameshot # screenshot tool
    audacity # audio tool

    # npm
    http-server
    # nodePackages.serverless
    # nodePackages.eas-cli
    #nodePackages.eas-cli
    cypress

    tree
    tree-sitter

    # Applications
    gimp
    grafana

    # Emulation
    #flatpak
    bottles

    # VPN
    tailscale
    wireguard-tools

    # Music
    spotify
    #downonspot
    spotdl
    yt-dlp #new version of youtube-dl
    musikcube

    tmuxinator

    tldr # shorter manual pages

    scrot
    imagemagick

    cloc
    ngrok

    #vagrant
    virtualbox

    xsel # copy pasting
    yarn

    libreoffice
    xarchiver

    entr

    # Fonts
    fira-code
    #nerdfonts
    nerd-fonts.droid-sans-mono

    # Antivir
    #clamav
    #clamav-daemon
    # Use the other script

    #yamlfix
    yamllint
    yq
    jq
    alacritty
    #docker
    #docker-compose

    # Usespace docker via podman
    #podman

    minikube
    k9s
    kubernetes-helm
    kubectl
    kubeseal
    kube-linter
    argocd
    trivy # Vulnerability scanner for containers

    # Cloud env
    azure-cli
    azure-functions-core-tools

    mr
    arandr
    wdisplays

    _1password-cli

    # Slack might give issues with XDG open. On the latest ubuntu I did not
    # have any issues, hence its back in the list.
    slack
    beeper
    google-chrome
    brave
    insync # Google drive
    #curl
    xautolock
    fzf
    # Process / battery info
    htop
    powertop

    geekbench
    cpupower-gui
    conky
    #(pkgs.conky.override {
      #waylandSupport = true;
    #})


    btop
    patch
    git
    rofi

    # Searching
    #silver-searcher
    ripgrep  # Also used by telescope nvim
    fd # Also used by telescope nvim

    feh
    xclip
    zathura
    ranger
    fail2ban
    tmux
    zsh
    #zsh-z 
    #zsh-autosuggestions

    ruff

    # python packages
    (python3.withPackages (p: with p; [
      regex
      pip
      pyarrow
      setuptools
      #jupyter
      pandas
      numpy
      matplotlib
    ]))


    # Editors
    vscode
    neovim
    antigravity

    libnotify

    # AI
    herdr
    cve-lite-cli
    claude-code
    gemini-cli
    ollama
    opencode
    #opendesign

    # i3
    #i3lock
    #i3
    #i3status

    # Sway
    sway
    swaybg
    swayidle
    swaylock
    waybar
    mako
    foot

    # Hacking
    nmap
    amass
    wireshark
    netdiscover
    bettercap
    ettercap
    openvas-scanner
    nikto
    nuclei

    ## Wireless Hacking
    aircrack-ng
    kismet

    ## Password & Exploitation
    john
    hashcat
    metasploit

    ## Web Vulnerabilities
    burpsuite
    sqlmap
  ];


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  # Raw configuration files
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ./config/raw/nvim;

  home.file.".tmux.conf".source = ./config/raw/tmux.conf;
  home.file.".config/nix/nix.conf".source = ./config/raw/nix.conf;
  home.file.".agignore".source = ./config/raw/agignore;
  home.file.".compton.conf".source = ./config/raw/compton.conf;
  home.file.".config/sway".source = ./config/raw/sway;
  home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./config/raw/waybar;
  home.file.".config/rofi".source = ./config/raw/rofi;
  home.file.".conkyrc".source = ./config/raw/conkyrc;
  home.file.".ctags".source = ./config/raw/ctags;
  home.file.".dmrc".source = ./config/raw/dmrc;
  home.file.".ideavimrc".source = ./config/raw/ideavimrc;
  home.file.".irbrc".source = ./config/raw/irbrc;
  home.file.".mrconfig".source = ./config/raw/mrconfig;
  home.file.".octaverc".source = ./config/raw/octaverc;
  home.file.".Xdefaults".source = ./config/raw/Xdefaults;
  home.file.".Rprofile".source = ./config/raw/Rprofile;
  home.file.".config/xfce4/terminal/terminalrc".source = ./config/raw/xfce_terminal;
  home.file.".config/zathura/zathurarc".source = ./config/raw/zathurarc;
  home.file.".config/Thunar/thunarrc".source = ./config/raw/thunarrc;
  home.file.".config/kmonad/keyboard.kbd".source = ./config/raw/kmonad;
  home.file.".config/espanso/match/base.yml".source = ./config/raw/espanso.yml;
  home.file.".claude/settings.json".source = ./config/raw/claude-settings.json;
  home.file.".config/opencode/config.json".source = ./config/raw/opencode.json;
  home.file.".snippets/vim/UltiSnips".source = ./config/UltiSnips;
  home.file.".git_template".source = ./config/raw/git_template;
  home.file.".tmuxinator".source = ./config/raw/tmuxinator;
  home.file.".bin".source = ./config/raw/bin;
  home.file."Wallpapers".source = ./config/raw/wallpapers;

  systemd.user.services.batsignal = {
    Unit = {
      Description = "Battery level notification daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.batsignal}/bin/batsignal -w 20 -c 10 -d 5 -f 99";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.clear-downloads = {
    Unit.Description = "Remove Downloads files older than 24 hours";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.findutils}/bin/find %h/Downloads -mindepth 1 -type f -mmin +1440 -delete";
    };
  };

  systemd.user.timers.clear-downloads = {
    Unit.Description = "Periodically remove Downloads files older than 24 hours";
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "1h";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  imports = [
    ./config/zsh.nix
    ./config/git.nix
    ./config/ssh.nix
    ./config/alacritty.nix
    ./config/direnv.nix
    #./config/docker-containers.nix
  ];
}
