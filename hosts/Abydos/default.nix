{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware.nix
  ];
  networking.hostName = "Abydos";
  RandomScanian.user.users = {
    "randomscanian" = {
      name = "randomscanian";
    };
  };
}
