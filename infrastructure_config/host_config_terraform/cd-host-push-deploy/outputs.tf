output "bastion_public_ip" {
  value = aws_instance.cd-host-push.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.cd-host-push.private_ip
}

output "bastion_user" {
  value = var.ansible_user
}

output "ssh_port" {
  value = var.ssh_port
}

output "bastion_private_key" {
  value = var.private_key
}

