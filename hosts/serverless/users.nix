{...}: {
  users.users.baryon = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = ["wheel"];
  };
}
