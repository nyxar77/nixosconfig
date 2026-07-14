{pkgs, ...}: {
  # programs.thunar.enable = true;
  environment.systemPackages = with pkgs; [
    nautilus
  ];
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  services = {
    gnome.sushi.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
}
