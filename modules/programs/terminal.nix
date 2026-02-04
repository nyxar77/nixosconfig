{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # ----awesome CLI tools----
    pavucontrol
    nh
    nurl
    wget
    mosh
    wl-clipboard
    linux-firmware
    linux-wifi-hotspot
    lazygit
    jq
    fzf
    fd
    htop
    # delta
    pstree
    lsof # listen open files
    brightnessctl
  ];

  environment = {
    shells = [
      pkgs.zsh
      pkgs.bash
    ];
    variables = {
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
