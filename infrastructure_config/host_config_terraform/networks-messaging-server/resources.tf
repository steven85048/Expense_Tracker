resource "aws_key_pair" "host_key" {
  key_name   = "${var.host_name}-ssh-key"
  public_key = file(var.public_key)
}

# Maybe pack and load an AMI with base configurations later instead of running the base-configurations
# with local-exec
data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "terraform_remote_state" "bastion_host" {
  backend = "s3"
  config = {
    encrypt = true
    bucket  = "expense-tracker-terraform"
    key     = "cd-host-push-deploy/terraform.tfstate"
    region  = "us-east-2"
  }
}

resource "aws_security_group" "networks-messaging-server-sg" {
  name = var.host_name

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.ssh_port
    to_port   = var.ssh_port
    protocol  = "tcp"

    # We only allow SSH connection from the bastion host (cd-host-push)
    cidr_blocks = ["${data.terraform_remote_state.bastion_host.outputs.bastion_private_ip}/32"]
  }
}

resource "aws_instance" "networks-messaging-server" {
  ami                    = data.aws_ami.latest-ubuntu.id
  instance_type          = var.instance
  key_name               = aws_key_pair.host_key.key_name
  iam_instance_profile   = var.instance_profile_name
  vpc_security_group_ids = [aws_security_group.networks-messaging-server-sg.id]

  tags = {
    Name = var.host_name
  }
}

resource "null_resource" "networks-messaging-server-provisioner" {
  triggers = {
    private_ip = aws_instance.networks-messaging-server.private_ip
  }

  connection {
    type        = "ssh"
    private_key = file(var.private_key)
    user        = var.ansible_user
    port        = var.ssh_port
    host        = aws_instance.networks-messaging-server.private_ip
    agent       = false

    bastion_host        = data.terraform_remote_state.bastion_host.outputs.bastion_public_ip
    bastion_user        = "ubuntu"
    bastion_port        = data.terraform_remote_state.bastion_host.outputs.ssh_port
    bastion_private_key = file("~/.ssh/cd-host-push-id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install software-properties-common",
      "apt-get update",
      "sudo apt install python -y",
    ]
  }

  provisioner "local-exec" {
    command = <<EOT
            sleep 3;
            cd ../../host_config_ansible
            touch inventory/${var.host_name}-hosts
            echo "[main]\n${aws_instance.networks-messaging-server.private_ip}" > inventory/${var.host_name}-hosts
            # ansible-playbook -u ${var.ansible_user} -i inventory/${var.host_name}-hosts networks-messaging-server.yml
        
EOT

  }
}

