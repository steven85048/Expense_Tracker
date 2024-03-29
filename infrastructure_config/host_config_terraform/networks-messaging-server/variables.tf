variable "instance" {
  default = "t2.nano"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "host_name" {
  default = "networks-messaging-server"
}

variable "instance_profile_name" {
  default = "networks-messaging-server-profile"
}

variable "public_key" {
  default = "~/.ssh/expense-tracker-id_rsa.pub"
}

variable "private_key" {
  default = "~/.ssh/expense-tracker-id_rsa"
}

variable "ssh_port" {
  default = 22
}

variable "messaging_udp_port" {
  default = 5006
}

variable "postgresql_port" {
  default = "5432"
}

variable "ansible_user" {
  default = "ubuntu"
}

