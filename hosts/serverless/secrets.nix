{ config, ... }:
{
  # Reuse serverless's existing SSH host key as the SOPS identity.
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets.ssh-code-forges = {
      sopsFile = ../../secrets/serverless-code-forges;
      format = "binary";
      owner = "baryon";
      group = "users";
      mode = "0600";
    };
  };

  programs.ssh.extraConfig = ''
    Host github.com gitlab.com
      User git
      IdentityFile ${config.sops.secrets.ssh-code-forges.path}
      IdentitiesOnly yes
  '';
}
