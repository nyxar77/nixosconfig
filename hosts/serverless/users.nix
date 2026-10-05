{
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "no";
  };

  users.users.baryon = {
    uid = 1000;
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ../../files/serverless.pub ];
  };
  nix.settings.trusted-users = [ "baryon" ];
}
