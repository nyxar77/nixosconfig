{
  # Reuse serverless's existing SSH host key as the SOPS identity.
  # Private user keys remain on serverless and will be encrypted in place.
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
