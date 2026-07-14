{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
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
    dig
  ];
}
