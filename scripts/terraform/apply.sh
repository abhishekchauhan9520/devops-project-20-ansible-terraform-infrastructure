#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../../terraform"
: "${AMI:?Set AMI=<ami-id> before running}"
: "${SSH_CIDR:?Set SSH_CIDR=<your-public-cidr> before running}"
terraform apply -auto-approve \
  -var "ami=${AMI}" \
  -var "allowed_ssh_cidr=${SSH_CIDR}"
