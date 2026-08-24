#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR"
[[ -f inventory/hosts.ini ]] || { echo "inventory/hosts.ini not found; run scripts/terraform/generate_inventory.sh first" >&2; exit 1; }
command -v ansible-playbook >/dev/null 2>&1 || { echo "ansible-playbook is required" >&2; exit 1; }
ANSIBLE_CONFIG="$ROOT_DIR/ansible/ansible.cfg" ansible-playbook -i inventory/hosts.ini ansible/playbook.yml
