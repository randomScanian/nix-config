{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6a23b945-3b63-419f-91d9-31c33a4421bb";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B24B-52D5";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/42a29f61-0b1a-4a19-ab9c-3449ad926c61"; }
    ];
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
