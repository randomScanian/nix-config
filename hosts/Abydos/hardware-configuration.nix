{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      inputs.hardware.common-cpu-intel-cpu-only
      inputs.hardware.common-pc-ssd
      inputs.hardware.common-gpu-nvidia
      inputs.hardware.common-hidpi
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/3b8c38e8-34b2-48fa-9d12-4d43ac3bba78";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=var" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=tmp" ];
    };

  fileSystems."/usr" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=usr" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=persist" ];
    };

  fileSystems."/etc" =
    { device = "/dev/disk/by-uuid/90cfc083-64c6-4ce1-8bc3-4f4d1a6f11ea";
      fsType = "btrfs";
      options = [ "subvol=etc" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/ED43-037C";
      fsType = "vfat";
    };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 18); # RAM size + 2 GB
  }];
  
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
