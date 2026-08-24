# Project 20 — Automate Infrastructure Provisioning with Terraform + Ansible

A controlled two-stage workflow: **Terraform provisions AWS EC2 infrastructure; Ansible configures the resulting hosts**.

## Architecture

```text
Terraform
   |
   +--> Default VPC + subnet discovery
   +--> EC2 instances
   +--> Restricted SSH security group
   +--> Public HTTP
   |
   v
terraform output public_ips
   |
   v
inventory/hosts.ini (generated, not committed)
   |
   v
Ansible
   +--> install nginx
   +--> deploy site
   +--> validate nginx config
   +--> enable/start nginx
```

## Repository layout

- `terraform/` — infrastructure definition
- `ansible/` — host configuration
- `scripts/terraform/` — lifecycle and inventory helpers
- `scripts/ansible/` — configuration runner
- `.github/workflows/terraform-ansible.yml` — validation only by default
- `tests/` — offline structure and shell validation

## Prerequisites

Terraform, AWS credentials, an EC2-compatible SSH key pair, Ansible, `jq`, and an Ubuntu-compatible AMI in the selected AWS region.

The review/CI workflow **does not create AWS resources**.

## Safe setup

1. Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars`.
2. Set `ami`, `region`, and your public SSH CIDR.
3. Ensure the AMI matches the `ansible_user` value (Ubuntu defaults to `ubuntu`).
4. Run `bash scripts/terraform/init.sh`.
5. Run `AMI=ami-... SSH_CIDR=x.x.x.x/32 bash scripts/terraform/plan.sh`.
6. Apply only after reviewing the plan.
7. Generate inventory with `bash scripts/terraform/generate_inventory.sh`.
8. Run Ansible with `bash scripts/ansible/run.sh`.
9. Destroy when finished with `bash scripts/terraform/destroy.sh`.

## Security notes

SSH is intentionally restricted to `allowed_ssh_cidr`; do not use `0.0.0.0/0`.
The root volume is encrypted and IMDSv2 is required.
Private keys and generated inventory are ignored by Git.

The Terraform layer is deliberately separated from the Ansible layer. Terraform does not use a provisioner to configure the application; it only provisions infrastructure, and Ansible performs configuration after the inventory is generated.

## Validation

The GitHub Actions workflow runs Terraform formatting/validation, YAML validation, and Ansible syntax checks. It does not apply infrastructure automatically.
