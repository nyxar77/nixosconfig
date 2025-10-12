{...}: {
  # enable firmware updates
  services.fwupd.enable = true;

  services.openssh = {
    enable = true;
    /*
    extraConfig = ''
      Host serverless
        HostName 192.168.1.51
        User baryon
        IdentityFile /home/nyxar/.ssh/serverless
    '';
    */
  };
}
