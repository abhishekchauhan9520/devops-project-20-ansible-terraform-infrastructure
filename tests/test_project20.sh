#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

assert_contains() {
  local file="$1" text="$2"
  grep -Fq -- "$text" "$file" || { echo "Missing '$text' in $file" >&2; exit 1; }
}

assert_contains "$ROOT_DIR/terraform/main.tf" 'data "aws_vpc" "default"'
assert_contains "$ROOT_DIR/terraform/main.tf" 'public_key = file(pathexpand(var.public_key_path))'
assert_contains "$ROOT_DIR/terraform/main.tf" 'http_tokens   = "required"'
assert_contains "$ROOT_DIR/terraform/variables.tf" 'allowed_ssh_cidr'
assert_contains "$ROOT_DIR/terraform/terraform.tfvars.example" 'allowed_ssh_cidr'
assert_contains "$ROOT_DIR/ansible/playbook.yml" 'roles:'
assert_contains "$ROOT_DIR/ansible/roles/app/tasks/main.yml" 'ansible.builtin.apt'
grep -Fq -- 'validate:' "$ROOT_DIR/ansible/roles/app/tasks/main.yml" || { echo 'Missing nginx validate directive' >&2; exit 1; }
assert_contains "$ROOT_DIR/ansible/roles/app/handlers/main.yml" 'state: reloaded'
assert_contains "$ROOT_DIR/scripts/terraform/generate_inventory.sh" 'terraform -chdir=terraform output -json public_ips'
assert_contains "$ROOT_DIR/.github/workflows/terraform-ansible.yml" 'terraform validate'
assert_contains "$ROOT_DIR/.github/workflows/terraform-ansible.yml" 'ansible-playbook --syntax-check playbook.yml'

bash -n "$ROOT_DIR/scripts/terraform/apply.sh"
bash -n "$ROOT_DIR/scripts/terraform/init.sh"
bash -n "$ROOT_DIR/scripts/terraform/plan.sh"
bash -n "$ROOT_DIR/scripts/terraform/destroy.sh"
bash -n "$ROOT_DIR/scripts/terraform/generate_inventory.sh"
bash -n "$ROOT_DIR/scripts/ansible/run.sh"

echo 'Project 20 structural tests passed.'
