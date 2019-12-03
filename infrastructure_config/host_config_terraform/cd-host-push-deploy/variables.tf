variable "instance" {
    default = "t2.micro"
}

variable "aws_region" {
    default = "us-east-2"
}

variable "host_name" {
    default = "cd-host-push"
}

# These instance profiles are defined in expense_tracker/infrastructure_config/aws/hostroles
variable "instance_profile_name" {
    default = "cd-push-host-profile"
}

variable "public_key" {
    default = "~/.ssh/cd-host-push-id_rsa.pub"
}

variable "private_key" {
    default = "~/.ssh/cd-host-push-id_rsa"
}

variable "ssh_port" {
    default     = 22
}

variable "ansible_user" {
    default = "ubuntu"
} 