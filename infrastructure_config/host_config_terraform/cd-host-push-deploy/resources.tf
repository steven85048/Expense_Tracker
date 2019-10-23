resource "aws_key_pair" "host_key" {
    key_name = "host_ssh_key"
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

resource "aws_security_group" "cd-host-push-sg" {
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

        # TODO: Only allow connection from authorized users
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "cd-host-push" {
    ami = "${data.aws_ami.latest-ubuntu.id}"
    instance_type = "${var.instance}"
    key_name = "${aws_key_pair.host_key.key_name}"
    iam_instance_profile = "${var.instance_profile_name}"
    vpc_security_group_ids = ["${aws_security_group.cd-host-push-sg.id}"]

    tags = {
        Name = "${var.host_name}"
    }
}

# Executes the local and remote commands necessary for provisioning this instance
# Follows the design done here:
resource "null_resource" "cd-host-push-provisioner"{

    # We want to run this AFTER the host is successfully provisioned
    # The public IP is a good way to do this; maybe private IP too for private VPC hosts, but haven't tried
    triggers = {
        public_ip = "${aws_instance.cd-host-push.public_ip}"
    }

    connection {
        type = "ssh"
        private_key = "${file(var.private_key)}"
        user = "${var.ansible_user}"
        port = "${var.ssh_port}"
        host = "${aws_instance.cd-host-push.public_ip}"
        #agent = false
        timeout = "30m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt install python -y"]
    }

    provisioner "local-exec" {
        command = <<EOT
            sleep 3;
            cd ../../host_config_ansible
            touch inventory/${var.host_name}-hosts
            echo "[main]\n${aws_instance.cd-host-push.public_ip}" > inventory/${var.host_name}-hosts
            ansible-playbook -u ${var.ansible_user} -i inventory/${var.host_name}-hosts cd-host-push.yml
        EOT
    }
}