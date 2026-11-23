# Partition layout for this machine (from nixos-generate-config).
# Split from hardware-configuration.nix; regenerate there if disks change.
{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6b0d59cd-0ae1-4502-8228-18c9ff60b194";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4FDC-A326";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/5aa2fd4b-4dd2-4411-86fd-182b70e661b8"; }
    ];
}