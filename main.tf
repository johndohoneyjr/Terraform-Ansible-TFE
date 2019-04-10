provider "aws" {
  region = "us-west-2"
}

## variables
variable "key_name" {
  default=""
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
      "git clone https://github.com/johndohoneyjr/ansible.git",
      "cd /home/ubuntu/ansible",
      "ansible-playbook httpd.yml"
    ]

    connection {
      type        = "ssh"
      private_key = "${var.key_contents}" 
      user        = "ubuntu"
      timeout     = "1m"
    }
  }
}

resource "aws_security_group" "example" {
  name        = "Capital Group Demo"
  description = "Demo for CG"

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
