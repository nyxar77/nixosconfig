# NixOS configuration

My personal NixOS flake for a laptop and homelab server.

## Hosts

- `nixos`: laptop and daily workstation
- `serverless`: homelab server

## Layout

- `hosts/` contains machine-specific configuration
- `modules/` contains shared profiles, programs, and services
- `secrets/` contains secrets encrypted with SOPS
- `files/` and `assets/` contain static files used by the configuration
