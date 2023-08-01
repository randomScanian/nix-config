{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.username = "randomscanian";
  home.homeDirectory = "/home/randomscanian";
  home.stateVersion = "23.05";
}
