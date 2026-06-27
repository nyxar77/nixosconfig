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
        "libvirt"
        "adbusers"
        "plugdev"
      ];
    };
    # guest
    users.guest = {
      isNormalUser = true;
      description = "Guest user";
      createHome = true;
      home = "/home/guest";

      extraGroups = [
        "networkmanager"
      ];
      # Mot de passe vide.
      # Attention: pas recommandé si la machine est accessible physiquement par d'autres.
      packages = with pkgs; [
        firefox
      ];
      hashedPassword = "";
    };
  };
}
