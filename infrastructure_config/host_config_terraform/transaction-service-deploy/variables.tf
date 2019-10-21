variable "instance" {
    default = "t2.nano"
}

variable "aws_region" {
    default = "us-east-2"
}

variable "instance_profile_name" {
    default = "transaction-service-profile"
}

variable "public_key" {
    default = "~/.ssh/expense-tracker-id_rsa.pub"
}

variable "private_key" {
    default = "~/.ssh/expense-tracker-id_rsa"
}

variable "ansible_user" {
    default = "ubuntu"
} 