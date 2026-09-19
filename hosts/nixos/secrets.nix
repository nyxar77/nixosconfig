{
  sops = {
    defaultSopsFile = ../../secrets/nixos.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets.ssh-github = {
      path = "/home/nyxar/.ssh/github";
      owner = "nyxar";
      group = "users";
      mode = "0600";
    };

    secrets.ssh-gitlab = {
      path = "/home/nyxar/.ssh/gitlab";
      owner = "nyxar";
      group = "users";
      mode = "0600";
    };

    secrets.ssh-serverless = {
      path = "/home/nyxar/.ssh/serverless";
      owner = "nyxar";
      group = "users";
      mode = "0600";
    };

    secrets.syncthing-gui-password = {
      owner = "nyxar";
      group = "users";
      mode = "0400";
    };
  };
}
