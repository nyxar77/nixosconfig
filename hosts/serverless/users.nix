{pkgs, ...}: {
  users.users.baryon = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      bat
      btop
      curl
      dig
      duf
      dust
      eza
      fastfetch
      git
      micro
      ncdu
      neovim
      ripgrep
      rsync
      tealdeer
      tldr
      tmux
      tree
      zellij
      autojump
    ];
  };
}
