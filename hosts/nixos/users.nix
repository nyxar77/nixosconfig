{pkgs, ...}: {
  users = {
    defaultUserShell = pkgs.zsh;
    users.nyxar = {
      useDefaultShell = true;
      isNormalUser = true;
      description = "Nyxar";
      extraGroups = [
        "networkmanager"
        "wheel"
        # "docker"
        "libvirt"
        "adbusers"
        "plugdev"
      ];
    };
  };
}
