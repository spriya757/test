data "aws_availability_zones" "available"{}



resource "aws_security_group" "bastion_sg"{
    name = "bastion_sg"
    description = "used for public access"
    vpc_id = "${var.vpc}"

    #SSH access
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.accessip}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.accessip}"]
    
    }

      }

    resource "aws_instance" "bastion_host" {
    count = 1
    instance_type = "t2.micro"
    ami = "ami-0d8f6eb4f641ef691"
    tags = {
        Name = "bastion_server_${count.index}"
    }
    key_name = "myec2key"
    subnet_id = "${var.public_subnets[count.index]}"
    vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
    
}