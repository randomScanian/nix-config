{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.RandomScanian.security.doas;
in
{
  options.RandomScanian.security.doas = {
    enable = mkEnableOption "Whether or not to replace sudo with doas.";
  };

  config = mkIf cfg.enable {
    security.doas = {
      enable = true;
      extraRules = [{
        groups = [ "wheel" ];
        noPass = false;
        keepEnv = true;
      }];
    };
    
    environment.shellAliases = { sudo = "doas"; };
  };
}
