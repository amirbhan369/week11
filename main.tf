terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1" # Set your desired region
}
resource "aws_security_group" "web_sg_secure" {
  name        = "web-sg-secure"
  description = "Allows specific HTTP/HTTPS from a limited range" 
  vpc_id      = "vpc-0a891759e63888382" 
  ingress {
    description = "Allow HTTP for Web Access" # Required description
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"] # Example of a specific CIDR block (Replace with your actual trusted IP/range)
  }
  
  ingress {
    description = "Allow HTTPS for Web Access" # Required description
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/24"] # Example of a specific CIDR block (Replace with your actual trusted IP/range)
  }
  egress {
    description = "Allow all outbound traffic" # Required description
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}
