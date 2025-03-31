variable "EC2_ami_id" {
  type = string
  description = "Please provide the AMI id to EC2"
  default = "ami-0e35ddab05955cf57"
}

variable "EC2_instance_type" {
  type = string
  description = "Provide the EC2 instance Type"
  default = "t2.micro"
}

variable "vpc_ID" {
  type = string
  description = "Provide the VPC ID where you want to create the resource"
  default = "vpc-ce7db8a5"
}

variable "rds_identifier_name" {
  type = string
  description = "Provide the RDS identifiers name"
  default = "RDS-Instance"
}