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

resource "aws_instance" "cd-host-push" {
    ami = "${data.aws_ami.latest-ubuntu.id}"
    instance_type = "${var.instance}"
    key_name = "${aws_key_pair.host_key.key_name}"
    iam_instance_profile = "${var.instance_profile_name}"

    # Configure security groups

    connection {
        private_key = "${file(var.private_key)}"
        user = "${var.ansible_user}"
        host = "${self.public_ip}"
    }

    provisioner "remote-exec" {
        inline = ["sudo apt-get -qq install python -y"]
    }

    provisioner "local-exec" {
        command = <<EOT
            sleep 600;
        EOT
    }

    tags = {
        Name = "cd-push-host"
    }
}