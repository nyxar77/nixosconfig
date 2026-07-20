# Import this module only after adding files/remotebuild.pub.
{
  users.users.remotebuild = {
    isSystemUser = true;
    group = "remotebuild";
    useDefaultShell = true;

    openssh.authorizedKeys.keyFiles = [../../files/remotebuild.pub];
  };

  users.groups.remotebuild = {};

  nix.settings.trusted-users = ["remotebuild"];
}
