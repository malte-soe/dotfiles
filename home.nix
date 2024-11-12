{ config, pkgs, ... }:

let
    username = import ./username.nix;
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.stateVersion = "24.05";

  home.packages = [
    pkgs.devenv
    pkgs.uv
    pkgs.nixd
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
  programs.starship.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.btop.enable = true;
  programs.neovim.enable = true;
  programs.tmux.enable = true;
  programs.lazygit.enable = true;
  programs.git.enable = true;
}
