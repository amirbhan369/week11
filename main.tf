# main.tf on staging branch (FINAL SECURE VERSION)

# 1. Define the AWS provider and region
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. Get the current region (or define one)
provider "aws" {
  region = "us-east-1" # Set your desired region
}

# 3. Secure AWS Security Group (The resource that passed the final check)
resource "aws_security_group" "web_sg_secure" {
  name        = "web-sg-secure"
  # Ensures a clear description is present (to help clear Sourcery AI/Notes)
  description = "Allows specific HTTP/HTTPS from a limited range" 
  
  # NOTE: Replace 'vpc-xxxxxxxx' with your actual VPC ID from AWS (e.g., vpc-0a891759e63888382 from your image)
  vpc_id      = "vpc-0a891759e63888382" 

  # FIX: Ingress rule is specific and limited (not 0.0.0.0/0)
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

  # Egress rule: Default is usually safe, but defining it ensures a description is present
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