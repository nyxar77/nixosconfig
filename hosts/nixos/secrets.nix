{ ... }: {
  sops = {
    defaultSopsFile = ../../secrets/nixos.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets.syncthing-gui-password = {
      owner = "nyxar";
      group = "users";
      mode = "0400";
    };
  };
}
