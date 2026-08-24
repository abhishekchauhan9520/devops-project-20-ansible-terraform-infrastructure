#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR"

private_key="${PRIVATE_KEY:-$HOME/.ssh/id_rsa}"
ansible_user="${ANSIBLE_USER:-ubuntu}"
output_file="$ROOT_DIR/inventory/hosts.ini"

command -v terraform >/dev/null 2>&1 || { echo "terraform is required" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "jq is required" >&2; exit 1; }

mapfile -t ips < <(terraform -chdir=terraform output -json public_ips | jq -r '.[] | select(. != null)')
[[ ${#ips[@]} -gt 0 ]] || { echo "No public IPs found. Apply Terraform first." >&2; exit 1; }

mkdir -p "$ROOT_DIR/inventory"
{
  echo "[app]"
  for ip in "${ips[@]}"; do
    printf '%s ansible_user=%s ansible_ssh_private_key_file=%s\n' "$ip" "$ansible_user" "$private_key"
  done
} > "$output_file"

echo "Generated $output_file"
