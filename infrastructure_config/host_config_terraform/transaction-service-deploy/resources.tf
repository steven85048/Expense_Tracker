resource "aws_key_pair" "host_key" {
    key_name = "transaction-service-ssh-key"
    public_key = "${file(var.public_key)}"
}

# Maybe pack and load an AMI with base configurations later instead of running the base-configurations
# with local-exec
data "aws_ami" "latest-ubuntu" {
    most_recent = true
    owners = ["099720109477"]

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
        bucket = "expense-tracker-terraform"
        key = "cd-host-push-deploy/terraform.tfstate"
        region = "us-east-2"
    }
}

resource "aws_security_group" "transaction-service-sg" {
    name = "${var.host_name}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]   
    }

    ingress {
        from_port = "${var.ssh_port}"
        to_port   = "${var.ssh_port}"
        protocol  = "tcp"

        # We only allow SSH connection from the bastion host (cd-host-push)
        cidr_blocks = ["${data.terraform_remote_state.bastion_host.outputs.bastion_private_ip}/32"]
    }
}

resource "aws_instance" "transaction-service" {
    ami = "${data.aws_ami.latest-ubuntu.id}"
    instance_type = "${var.instance}"
    key_name = "${aws_key_pair.host_key.key_name}"
    iam_instance_profile = "${var.instance_profile_name}"
    vpc_security_group_ids = ["${aws_security_group.transaction-service-sg.id}"]

    tags = {
        Name = "transaction-service"
    }
}

resource "null_resource" "transaction-service-provisioner"{

    # We want to run this AFTER the host is successfully provisioned
    # The public IP is a good way to do this; maybe private IP too for private VPC hosts, but haven't tried
    triggers = {
        private_ip = "${aws_instance.transaction-service.private_ip}"
    }

    connection {
        type = "ssh"
        private_key = "${file(var.private_key)}"
        user = "${var.ansible_user}"
        port = "${var.ssh_port}"
        host = "${aws_instance.transaction-service.private_ip}"
        agent = false

        bastion_host="${data.terraform_remote_state.bastion_host.outputs.bastion_public_ip}"
        bastion_user="ubuntu"
        bastion_port="${data.terraform_remote_state.bastion_host.outputs.ssh_port}"
        bastion_private_key="${file("~/.ssh/cd-host-push-id_rsa")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install software-properties-common",
            "apt-get update",
            "sudo apt install python -y"]
    }

    provisioner "local-exec" {
        command = <<EOT
            sleep 3;
            cd ../../host_config_ansible
            touch inventory/${var.host_name}-hosts
            echo "[main]\n${aws_instance.transaction-service.private_ip}" > inventory/${var.host_name}-hosts
            # ansible-playbook -u ${var.ansible_user} -i inventory/${var.host_name}-hosts d-transaction-service.yml
        EOT
    }
}