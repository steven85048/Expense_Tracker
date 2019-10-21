variable "instance" {
    default = "t2.nano"
}

variable "aws_region" {
    default = "us-east-2"
}

# These instance profiles are defined in expense_tracker/infrastructure_config/aws/hostroles
variable "instance_profile_name" {
    default = "cd-push-host-profile"
}

# Terraform pathing gets wonky when running on windows, so this is a stopgap solution for windows
variable "public_key" {
    #default = "~/.ssh/expense-tracker-id_rsa.pub"
    default = "ansible-push-host-id_rsa.pub"
}

variable "private_key" {
    #default = "~/.ssh/expense-tracker-id_rsa"
    default = "ansible-push-host-id_rsa"
}

variable "ansible_user" {
    default = "ubuntu"
} 