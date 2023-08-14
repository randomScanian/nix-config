{inputs, outputs, config, lib, pkgs, isNvidia, allowUnfree, ...}:
with lib;
{
  #nixpkgs.config = 
  #  if ((isNvidia == true) && (allowUnfree == true)) then {
  #    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "nvidia-x11" ];
  #  }
  #  else {};
  nixpkgs.config.allowUnfree = allowUnfree;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
  ];
  hardware.nvidia.package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver = mkIf isNvidia {
    videoDrivers = if (allowUnfree == true) then [ "nvidia" ] else [ "nouveau" ];
  };
}
  
