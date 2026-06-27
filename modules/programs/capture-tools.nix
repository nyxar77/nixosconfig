{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_zen.v4l2loopback
  ];

  programs.gpu-screen-recorder.enable = true;
}
