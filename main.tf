provider "aws" {
  region = "eu-west-1"
}

#VPC

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# EC2 
resource "aws_instance" "terraform_group_project" {
  ami                    = "YOURAMIHERE"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  subnet_id              = aws_subnet.main.id

  tags = {
    Name = "WebServer"
  }
}

#Security group 

resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
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

#subnet 
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "main-subnet"
  }
}


#EFS

resource "aws_efs_file_system" "tf-group" {
  creation_token = "my-product"

  tags = {
    Name = "efs-terraform-group"
  }
}

