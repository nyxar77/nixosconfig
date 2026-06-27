{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nh
    nurl
    wget
    mosh
    lazygit
    jq
    fzf
    fd
    htop
    # delta
    pstree
    lsof # listen open files
  ];
}
