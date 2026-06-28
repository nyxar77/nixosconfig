{...}: {
  environment.etc."xdg/tealdeer/config.toml".text = ''
    [display]
    compact = false
    use_pager = true

    [updates]
    auto_update = true
  '';
}
