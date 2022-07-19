{ config, pkgs, ... }:
  let 
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
    #rust-analyzer-new = import (builtins.fetchTarball "https://github.com/OliverEvans96/nixpkgs/archive/refs/heads/bump-rust-analyzer-2022-05-02.tar.gz") {};
in {
  imports =
    [ 
      # read here about hardware conf:
      # https://raw.githubusercontent.com/NixOS/nixos-hardware/master/README.md
      <nixos-hardware/dell/xps/15-9560/intel>
      /etc/nixos/hardware-configuration.nix
      <home-manager/nixos>
    ];

  # allow apps like teams etc...
  nixpkgs.config.allowUnfree = true;

  # to mount ntfs external disk
  boot.supportedFilesystems = [ "ntfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.firewall.checkReversePath = "loose";



  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  #networking.useDHCP = false;
  #networking.interfaces.enp0s9.useDHCP = true;
  #networking.interfaces.eth0.useDHCP = true;


  # Enable the X11 windowing system.
  services.xserver.enable = true;


  services.undervolt = {
    enable = true;
    coreOffset = -150;
    gpuOffset = -100;
  };

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  i18n.defaultLocale = "en_US.UTF-8";


  services.onedrive.enable = true;
  services.dbus.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  virtualisation.docker.enable = true;
  # otherwise docker swarm init won't work
  # https://docs.docker.com/config/containers/live-restore/
  virtualisation.docker.liveRestore = false;

  # enable the tailscale daemon; this will do a variety of tasks:
  # 1. create the TUN network device
  # 2. setup some IP routes to route through the TUN
  services.tailscale = { enable = true; };


  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.flakm = {
     shell = pkgs.zsh;
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
   };


  home-manager.users.flakm = { pkgs, ... }: {
     programs.bash = {
        enable = true;
        bashrcExtra = ''
          . ~/.localrc
          . ~/.localrc_raves
        '';
        profileExtra = ''
          . ~/.localrc
          . ~/.localrc_raves
        '';
     };
     programs.git = {
       enable = true;
       userName  = "FlakM";
       userEmail = "maciej.jan.flak@gmail.com";
       signing = {
          key = "AD7821B8";
          signByDefault = true;
       };
     };

    programs.tmux = {
      enable = true;
      clock24 = true;

      extraConfig = ''
      # Start windows and pane numbering with index 1 instead of 0
      set -g base-index 1
      setw -g pane-base-index 1

      # {n}vim compability
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set -g default-terminal "screen-256color"
      set-option -g status-style bg=default
      '';
      plugins = with pkgs.tmuxPlugins; [ sensible yank];

    };


     nixpkgs.config.allowUnfree = true;

     services.gpg-agent = {     
       enable = true;
       defaultCacheTtl = 1800;
       enableSshSupport = true;
     };

     programs.zsh = {
       enable = true;
       autocd = true;
       enableAutosuggestions = true;
       enableCompletion = true;

       zplug = {
         enable = true;
         plugins = [
           { name = "agkozak/zsh-z"; } # smart CD
           { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
           { name = "unixorn/fzf-zsh-plugin"; } 
           { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
         ];
       };

       shellAliases = {
          ls = "ls --color";
          ll = "ls -l";
          update = "sudo nixos-rebuild switch";
          d = "git dotfiles";
	      vim = "nvim";
	      vi = "vi";
        };

       initExtra = ''
source ~/.p10k.zsh
source ~/.localrc
source ~/.localrc_raves

# home end
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line

# ctrl rigtArrow ctrl left arrow
bindkey  "^[[1;5C" forward-word
bindkey  "^[[1;5D" backward-word
bindkey  "^[[1;3C" forward-word
bindkey  "^[[1;eD" backward-word

# complete globs
setopt glob_complete
       '';
     };  
  };

  environment.variables.EDITOR = "${pkgs.neovim}/bin/nvim";


  hardware.video.hidpi.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     wget
     curl
     firefox
     google-chrome
     git
     unzip
     zip

     # editors & development
     jetbrains.idea-community

     dbeaver

     unstable.rustup
     unstable.rust-analyzer
     lldb #rust debugging

     # If used as nvim module the plugins are not used
     # https://nixos.wiki/wiki/Neovim
     unstable.neovim
     unstable.hugo
     xclip
     unstable.bloop
     unstable.coursier
     alacritty
     
     dotty
     sbt

     unstable.scalafmt
     unstable.scalafix
     gcc
     # tool needed for packaging binaries ie `ar`
     binutils 
     inotify-tools

     # utils
     bat
     fd
     ripgrep
     fzf
     delta
     htop
     timewarrior


     # vpn/rdp
     jq
     openconnect
     freerdp
     openvpn


     # media
     spotify
     gimp
     vlc
     signal-desktop

     # office
     thunderbird
     gpgme
     teams
     libreoffice
     keepassxc
     bitwarden
     bitwarden-cli
     unstable.dropbox-cli

     # spelling
     aspell
     aspellDicts.pl
     aspellDicts.en
     aspellDicts.en-computers

     tailscale
     element-desktop
     discord
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.udev.packages = [ pkgs.yubikey-personalization ];

# Depending on the details of your configuration, this section might be necessary or not;
# feel free to experiment
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';
  
  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # This adds JAVA_HOME to the global environment, by sourcing the jdk's
    # setup-hook on shell init. It is equivalent to starting a shell through 
    # 'nix-shell -p jdk', or roughly the following system-wide configuration:
    # 
    #   environment.variables.JAVA_HOME = ${pkgs.jdk.home}/lib/openjdk;
    #   environment.systemPackages = [ pkgs.jdk ];
    java = {
      enable = true;
      package = pkgs.jdk8;
    };
    kdeconnect.enable = true;
  };


  # Let's open the UDP port with which the network is tunneled through
  networking.firewall = {
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ 41641 ];
  };

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}



