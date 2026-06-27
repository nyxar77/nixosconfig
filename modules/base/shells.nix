{pkgs, ...}: {
  programs.zsh.enable = true;

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
