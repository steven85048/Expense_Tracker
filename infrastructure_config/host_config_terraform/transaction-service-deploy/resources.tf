resource "aws_key_pair" "host_key" {
    key_name = "host_ssh_key"
    public_key = "${file(var.public_key)}"
}

resource "aws_instance" "transaction-service" {
    ami = "${var.ami}"
    instance_type = "${var.instance}"
    key_name = "${aws_key_pair.host_key.key_name}"

    # Configure security groups

    connection {
        private_key = "${file(var.private_key)}"
        user = "${var.ansible_user}"
    }

    provisioner "remote-exec" {
        inline = ["sudo apt-get -qq install python -y"]
    }

    provisioner "local-exec" {
        command = <<EOT
            sleep 600;
            # Configure base ansible playbook here
        EOT
    }

    tags {
        Name = "transaction-service"
    }
}