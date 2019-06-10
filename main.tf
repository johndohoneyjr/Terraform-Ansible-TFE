provider "aws" {
  region = "us-west-2"
}

## variables

variable "github_repo" {
   default="https://github.com/johndohoneyjr/ansible.git"
}

variable "ansible_playbook" {
   default="httpd.yml"
}

variable "key_name" {
   default="id_rsa"
}

## In TFE, it is no longer a file, but the actual contents of the file (which the file function performs on OSS)
variable "key_contents" {}

## -- outputs
output "public-ip" {
    value = "${aws_instance.example.public_ip}" 
}

resource "aws_instance" "example" {
  ami             = "ami-08692d171e3cf02d6"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.example.name}"]
  key_name        = "${ var.key_name }"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt -y update",
      "sudo apt -y install ansible",
      "cd /home/ubuntu/",
      "git clone ${var.github_repo}",
      "cd /home/ubuntu/ansible",
      "ansible-playbook ${var.ansible_playbook}"
    ]

    connection {
      host        = "${aws_instance.example.public_ip}"
      type        = "ssh"
      private_key = "${var.key_contents}" 
      user        = "ubuntu"
      timeout     = "1m"
    }
  }
}

resource "aws_security_group" "example" {
  name        = "Ansible with TFE Demo"
  description = "Demo showing IaC and CM"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
