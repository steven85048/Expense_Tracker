variable "instance" {
    default = "t2.nano"
}

variable "region" {
    default = "us-east-2"
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