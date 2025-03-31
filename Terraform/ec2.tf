/*
1. Create a EC2 resource
2. Create a new Security Group
    - open the port
    - 22 (ssh)
    - 443 (https)
    - 3000 (nodejs application) //where we run ip:3000
3. need to confire the nodejs app while creation that means we have to provide the userdata (bootstrap script while creating the EC2)
    Automation
    - install the nodejs and npm
    - clone nodejs from git repo
    - configure env
    - npm start to start the app
*/
resource "aws_instance" "tf_ec2_instance" {
  ami                         = var.EC2_ami_id #ubuntu
  instance_type               = var.EC2_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tf_ec2_sg.id] #attach the sg id to ec2
  #vpc_security_group_ids = [module.tf_module_ec2_sg.security_group_id]
  key_name               = "tf_key_ubuntu"
  depends_on             = [aws_s3_bucket.tf_s3_bucket] #create the dependencies btween the EC2 instance and S3, here S3 bucket will create 1st and them EC2 will create
  #user_data = file("script.sh")
  user_data                   = <<-EOF
                                #!/bin/bash

                                # Git clone 
                                git clone https://github.com/verma-kunal/nodejs-mysql.git /home/ubuntu/nodejs-mysql
                                cd /home/ubuntu/nodejs-mysql

                                # install nodejs
                                sudo apt update -y
                                sudo apt install -y nodejs npm

                                # edit env vars
                                echo "DB_HOST=${local.rds_endpoint}" | sudo tee .env
                                echo "DB_USER=${aws_db_instance.tf_rds_instance.username}" | sudo tee -a .env
                                sudo echo "DB_PASS=${aws_db_instance.tf_rds_instance.password}" | sudo tee -a .env
                                echo "DB_NAME=${aws_db_instance.tf_rds_instance.db_name}" | sudo tee -a .env
                                echo "TABLE_NAME=users" | sudo tee -a .env
                                echo "PORT=3000" | sudo tee -a .env

                                # start server
                                npm install
                                EOF
  user_data_replace_on_change = true
  tags = {
    Name = "nodejas app"
  }
}

# AWS Security Group

resource "aws_security_group" "tf_ec2_sg" {
  name        = "allow_ssh_https_3000_for_nodejsapp"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_ID #default VPC

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


# Security group for EC2 instance (using terraform module)
# module "tf_ec2_module" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "5.2.0"
#   vpc_id  = "" # default VPC
#   name    = "ec2-security-group"

#   ingress_cidr_blocks = [
#     {
#       from_port   = 3000
#       to_port     = 3000
#       protocol    = "tcp"
#       description = "for nodejs app"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       rule        = "https-443-tcp"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       rule        = "ssh-tcp"
#       cidr_blocks = "0.0.0.0/0"
#     },

#   ]
#   egress_rules = ["all-all"]
# }

output "ec2_instance_publicIP" {
  value = "ssh -i tf_key_ubuntu.pem ubuntu@${aws_instance.tf_ec2_instance.public_ip}"
}
