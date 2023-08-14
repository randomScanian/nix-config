{ inputs, outputs, lib, config, pkgs, allowUnfree, stateVersion, userName, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };
  nixpkgs.config.allowUnfree = allowUnfree;
  nixpkgs.config.allowUnfreePredicate = (_: allowUnfree);
  home = {
    username = "${userName}";
    homeDirectory = "/home/${userName}";
    stateVersion = stateVersion;
  };
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
