{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./programs/kvmfr
  ];

  # Allow module to be easily enabled and disabled
  options = {
    vms.enable =
      lib.mkEnableOption "enables vms";
  };

  config = lib.mkIf config.vms.enable {
    # Enable KVM virtual machines
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;

          verbatimConfig = ''
            cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm",
              "/dev/kvmfr0"
            ]
          '';
        };
      };

      kvmfr = {
        enable = true;
        shm = {
          enable = true;
          size = 128;
          user = "dyllant";
          group = "libvirtd";
          mode = "0600";
        };
      };
    };

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      mstflint
      looking-glass-client
    ];
  };
}
