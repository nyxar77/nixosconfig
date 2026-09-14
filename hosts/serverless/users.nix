{
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "no";
  };

  users.users.baryon = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [ ../../files/serverless.pub ];
  };
}
