{ options, config, lib, pkgs, inputs, homeStateVersion, hmModulesDir, ... }:

with lib;

let
  cfg = config.RandomScanian.user;
  conf = config.RandomScanian.user.users;

  userOpts = types.submoduleWith {
    description = "Home Manager module";
    specialArgs = {
      sysConfig = config;
    };
    modules = [
      ({ name, config, lib, options, specialArgs, ... }: {
        options = {
          name = mkOption {
            type = types.passwdEntry types.str;
            default = "passwdistest";
            apply = x: assert (builtins.stringLength x < 32 || abort "Username '${x}' is longer than 31 characters!"); x;
          };
          extraGroups = mkOption {
            type = types.listOf types.str;
            default = [ "audio" "video" "input"];
          };
          hashedPassword = mkOption {
            type = with types; nullOr (passwdEntry str);
            default = "$y$j9T$Z5j6E/oMaUot1IiwYwiZC0$xlWTzm60kf29.aAXoBp5F9NskbWujJlP/eA9BJJNvZ6";
          };
          shell = mkOption {
            type = types.nullOr (types.either types.shellPackage (types.passwdEntry types.path));
          };
        };
        config = {
          users.users.${name} = {
            isNormalUser = true;
            inherit (conf.${name}) name hashedPassword;
            home = "/home/${conf.${name}.name}";
            group = "users";
            shell = conf.${name}.shell;
            extraGroups = [ "wheel" ] ++ conf.${name}.extraGroups;
          };
        };
      })
    ];
  };
in
{
  options = {
    RandomScanian.user = {
      users = mkOption {
        default = {};
        type = with types; attrsOf userOpts;
      };
    };
  };
}
