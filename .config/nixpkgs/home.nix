{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "flakm";
  home.homeDirectory = "/home/flakm";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  programs.git = {
    enable = true;
    userName  = "FlakM";
    userEmail = "maciej.jan.flak@gmail.com";
    signing = {
       key = "AD7821B8";
       signByDefault = true;
    };
  };

  services.gpg-agent = {     
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" "fd" "cargo" ];
      theme = "robbyrussell";
    };
  };  
}

