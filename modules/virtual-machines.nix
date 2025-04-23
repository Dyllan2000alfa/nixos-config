{ pkgs, lib, config, ... }:

{
  # Allow module to be easily enabled and disabled
  options = {
    vms.enable =
      lib.mkEnableOption "enables vms";
  };

  config = lib.mkIf config.vms.enable {

    # Enable KVM virtual machines
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      mstflint
      looking-glass-client
    ];
  };
}