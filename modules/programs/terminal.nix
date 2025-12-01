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
    bat
    htop
    # delta
    ripgrep # recursive search, run rg
    eza
    pstree
    lsof # listen open files
    brightnessctl
    # --------------------------
  ];

  environment = {
    shells = [
      pkgs.zsh
      pkgs.bash
      pkgs.fish
    ];
    variables = {
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
