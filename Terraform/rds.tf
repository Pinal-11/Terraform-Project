/*
1. rds tf resource
2. security group
    - 3306 for RDS
     - Security Group => tf_ec2_sg
     - cidr-blocks => ["local_ip"]
3. Output
*/

# RDS resource
resource "aws_db_instance" "tf_rds_instance" {
  allocated_storage    = 10
  db_name              = "Pinal_demo" # DB name, that is inside the RDS instance
  identifier           = var.rds_identifier_name #RDS instance name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "Pinal123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [ aws_security_group.tf_ec2_sg.id ]

}

resource "aws_security_group" "tf_rds_sg" {
  name        = "allow-nodejsapp"
  description = "Allow Mysql traffic"
  vpc_id      = var.vpc_ID #default VPC

  ingress {
    description = "From the EC2"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["43.241.144.58/32"]
    security_groups = [ aws_security_group.tf_ec2_sg.id ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

#locals:
locals {
  rds_endpoint = element(split(":", aws_db_instance.tf_rds_instance.endpoint), 0)
}

#output:
output "rds_endpoint" {
    value = local.rds_endpoint
  #value = aws_db_instance.tf_rds_instance.endpoint 
  #here the output of this line so for that we have to use the local variable for spilting
  #rds_endpoint = "nodejs-rds-mysql.c76c6m28ov6h.ap-south-1.rds.amazonaws.com:3306"
}

output "rds_dbname" {
  value = aws_db_instance.tf_rds_instance.db_name
}

output "rds_username" {
  value = aws_db_instance.tf_rds_instance.username
}