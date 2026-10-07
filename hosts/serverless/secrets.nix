{ config, ... }:
{
  # Reuse serverless's existing SSH host key as the SOPS identity.
  sops = {
    defaultSopsFile = ../../secrets/serverless.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets.ssh-github = {
      path = "/home/baryon/.ssh/github";
      owner = "baryon";
      group = "users";
      mode = "0600";
    };

    secrets.ssh-gitlab = {
      path = "/home/baryon/.ssh/gitlab";
      owner = "baryon";
      group = "users";
      mode = "0600";
    };
  };

  programs.ssh.extraConfig = ''
    Host github.com
      User git
      IdentityFile ${config.sops.secrets.ssh-github.path}
      IdentitiesOnly yes

    Host gitlab.com
      User git
      IdentityFile ${config.sops.secrets.ssh-gitlab.path}
      IdentitiesOnly yes
  '';
}
