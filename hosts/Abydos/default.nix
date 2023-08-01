{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];
  RandomScanian = {
    system = {
      grub = true;
      isGui = true;
    };
    hardware = {
    };
    users = [
      {
        name = "randomscanian";
        fullName = "Elias W. Ferm";
        email = "randomscanian@protonmail.com";
      }
    ];
  };
}
