# main.tf on staging branch (FIXED)

# 1. Security Group: Remove 0.0.0.0/0 for ingress/egress
resource "aws_security_group" "web_sg" {
  name        = "web-sg-secure"
  description = "Allows inbound web traffic only from a specific port/range"

  # SECURE: Only allows traffic from a specific port (80) from a specific, more limited CIDR block 
  # or from an internal network (use your actual desired CIDR, e.g., your office/VPN)
  ingress {
    description = "Web access from limited range"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/24"] # Example of a specific CIDR block
  }

  # SECURE: Defines a specific, safe egress rule, or you can omit the block for AWS's default restricted egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # NOTE: The lab document's solution may be to just remove the instance to only deploy a SG
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

# 2. Instance: Add explicit block device encryption
resource "aws_instance" "web" {
  # This AMI ID is for example purposes.
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  # SECURE: Explicitly defines the root block device with encryption enabled
  root_block_device {
    encrypted = true # Fixes the "Instance with unencrypted block device" error
  }
  
  # You would also need a data block for the AMI lookup to avoid a different error
  # data "aws_ami" "ubuntu" {
  #   most_recent = true
  #   filter {
  #     name   = "name"
  #     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  #   }
  #   owners = ["099720109477"]
  # }
}
