#sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
#sudo nix-channel --update
{ config, pkgs, ... }:

{
  imports =
    [ 
      # https://raw.githubusercontent.com/NixOS/nixos-hardware/master/README.md
      <nixos-hardware/dell/xps/15-9560/intel>
      /etc/nixos/hardware-configuration.nix
      <home-manager/nixos>
    ];

  # allow apps like teams etc...
  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp0s9.useDHCP = true;
  #networking.interfaces.eth0.useDHCP = true;


  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.spice-vdagentd.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";


  services.onedrive.enable = true;
  services.dbus.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  virtualisation.docker.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.flakm = {
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

     nixpkgs.config.allowUnfree = true;
     services.dropbox.enable = true;

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
          ll = "ls -l";
          update = "sudo nixos-rebuild switch";
        };

       initExtra = ''
         source ~/.p10k.zsh
         source ~/.localrc
         source ~/.localrc_raves
       '';
     };  
  };

  programs.neovim.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
  environment.variables.EDITOR = "nvim";

  hardware.video.hidpi.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     wget
     curl
     firefox
     git
     unzip
     zip

     # editors & development
     nodejs
     jetbrains.idea-community
     jdk8
     bloop
     dbeaver
     rustup

     # utils
     bat
     ripgrep
     fzf
     delta


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
     teams
     libreoffice
     keepassxc
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
  };

  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}



