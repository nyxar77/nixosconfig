set -euo pipefail

config=/etc/nyx-config
temporary_key=
temporary_age_key=
temporary_config=

cleanup() {
  if [[ -n "$temporary_key" ]]; then
    rm -f -- "$temporary_key"
  fi
  if [[ -n "$temporary_age_key" ]]; then
    rm -f -- "$temporary_age_key"
  fi
  if [[ "$temporary_config" == /run/nyx-config.* && -d "$temporary_config" ]]; then
    rm -rf -- "$temporary_config"
  fi
}
trap cleanup EXIT INT TERM

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

if [[ "$(id -u)" -ne 0 ]]; then
  die "run this command as root"
fi

if [[ ! -d /sys/firmware/efi ]]; then
  die "the installer was not booted in UEFI mode"
fi

if [[ ! -f "$config/flake.nix" ]]; then
  die "the embedded configuration is missing at $config"
fi

printf 'Available disks:\n\n'
lsblk -d -o NAME,SIZE,MODEL,SERIAL,TRAN,TYPE
printf '\n'

default_disk_id=
mapfile -t ata_disk_ids < <(
  for candidate in /dev/disk/by-id/ata-*; do
    [[ -e "$candidate" && "$candidate" != *-part* ]] || continue
    [[ "$(lsblk -dn -o TYPE -- "$candidate")" == disk ]] || continue
    printf '%s\n' "${candidate##*/}"
  done
)

if [[ "${#ata_disk_ids[@]}" -eq 1 ]]; then
  default_disk_id="${ata_disk_ids[0]}"
  printf 'Default target: %s\n\n' "$default_disk_id"
fi

read -r -p 'Target disk ID (press Enter for the default): ' disk_id
disk_id="${disk_id:-$default_disk_id}"
disk_id="${disk_id#/dev/disk/by-id/}"
[[ -n "$disk_id" && "$disk_id" != */* ]] || die "enter only one ID from /dev/disk/by-id"
[[ "$disk_id" != *-part* ]] || die "select the whole disk, not a partition"
target_disk="/dev/disk/by-id/$disk_id"
[[ -b "$target_disk" ]] || die "$target_disk is not a block device"

disk_type="$(lsblk -dn -o TYPE -- "$target_disk")"
[[ "$disk_type" == disk ]] || die "$target_disk is not a whole disk"

target_size="$(lsblk -bdn -o SIZE -- "$target_disk")"
minimum_size=445000000000
if (( target_size < minimum_size )); then
  die "$target_disk is too small for the configured 412 GiB LVM layout (at least 445 GB required)"
fi

boot_source="$(findmnt -n -o SOURCE /iso 2>/dev/null || true)"
if [[ -n "$boot_source" ]]; then
  boot_disk="$(lsblk -ndo PKNAME "$boot_source" 2>/dev/null || true)"
  target_name="$(lsblk -ndo NAME "$target_disk")"
  if [[ -n "$boot_disk" && "$target_name" == "$boot_disk" ]]; then
    die "refusing to erase the USB that booted this installer"
  fi
fi

temporary_key="$(mktemp /run/serverless-host-key.XXXXXX)"
chmod 600 "$temporary_key"
default_key=/mnt/usb/ssh_host_ed25519_key
read -r -p "Serverless SSH host private key path (press Enter for $default_key): " supplied_key
supplied_key="${supplied_key:-$default_key}"
[[ -f "$supplied_key" ]] || die "key file not found: $supplied_key"

if [[ "$supplied_key" == *.age ]]; then
  age --decrypt "$supplied_key" > "$temporary_key"
else
  cp -- "$supplied_key" "$temporary_key"
fi

chmod 600 "$temporary_key"
ssh-keygen -y -f "$temporary_key" >/dev/null 2>&1 || die "the supplied file is not a valid SSH private key"

expected_public_key="$config/files/serverless-host.pub"
[[ -f "$expected_public_key" ]] || die "the expected serverless public key is missing"
expected_fingerprint="$(ssh-keygen -lf "$expected_public_key" | awk '{ print $2 }')"
actual_fingerprint="$(ssh-keygen -y -f "$temporary_key" | ssh-keygen -lf - | awk '{ print $2 }')"
if [[ "$actual_fingerprint" != "$expected_fingerprint" ]]; then
  die "the supplied key does not match files/serverless-host.pub"
fi

secret_file="$config/secrets/attic.yaml"
[[ -f "$secret_file" ]] || die "the serverless SOPS file is missing: $secret_file"

temporary_age_key="$(mktemp /run/serverless-age-key.XXXXXX)"
chmod 600 "$temporary_age_key"
ssh-to-age -private-key -i "$temporary_key" > "$temporary_age_key"
export SOPS_AGE_KEY_FILE="$temporary_age_key"
printf 'Checking SOPS access to %s...\n' "${secret_file#"$config"/}"
sops --decrypt "$secret_file" >/dev/null || die "the embedded key cannot decrypt $secret_file"
unset SOPS_AGE_KEY_FILE

temporary_config="$(mktemp -d /run/nyx-config.XXXXXX)"
cp -a -- "$config"/. "$temporary_config"/
chown -R 1000:100 "$temporary_config"
chmod -R u+rwX,go+rX "$temporary_config"

printf '\nWARNING: this will erase all data on %s.\n' "$target_disk"
printf 'The serverless Disko layout will be created and NixOS will be installed.\n'
read -r -p 'Continue? [y/N] ' confirmation
[[ "$confirmation" == y || "$confirmation" == Y ]] || die "cancelled; nothing was changed"

disko-install \
  --flake "$config#serverless-bootstrap" \
  --disk main "$target_disk" \
  --extra-files "$temporary_key" /etc/ssh/ssh_host_ed25519_key \
  --extra-files "$temporary_config" /etc/nixos \
  --write-efi-boot-entries

printf '\nBootstrap installation completed. Remove the installer USB and reboot.\n'
printf 'After logging in as baryon, run:\n'
printf '  sudo passwd baryon\n'
printf '  sudo nixos-rebuild switch --flake /etc/nixos#serverless\n'
