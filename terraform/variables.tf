variable "region" {
  description = "AWS region for the deployment."
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "Ubuntu-compatible AMI ID in the selected region."
  type        = string
  validation {
    condition     = can(regex("^ami-[a-z0-9]+$", var.ami))
    error_message = "ami must look like a valid AWS AMI ID."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of application instances to provision."
  type        = number
  default     = 1
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 3 && floor(var.instance_count) == var.instance_count
    error_message = "instance_count must be an integer between 1 and 3."
  }
}

variable "key_name" {
  description = "AWS EC2 key pair name."
  type        = string
  default     = "tf-ansible-deployer"
}

variable "public_key_path" {
  description = "Path to the local SSH public key used by Terraform."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Local private key path used by Ansible inventory."
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to reach SSH. Use your public /32 rather than 0.0.0.0/0."
  type        = string
  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "allowed_ssh_cidr must be a valid CIDR block."
  }
}

variable "ansible_user" {
  description = "Remote OS user used by Ansible."
  type        = string
  default     = "ubuntu"
}
