{pkgs, ...}: {
  users.users.baryon = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    /*
    packages = with pkgs; [
      #     tree
    ];
    */
  };
}
