# main.tf on staging branch (FIXED AND SECURE)

# 1. Define a more restrictive Security Group
resource "aws_security_group" "web_sg_secure" {
  name        = "web-sg-secure"
  description = "Security Group for Web Access"
  vpc_id      = "vpc-0a891759e63888382" # Replace with your actual VPC ID

  # Ingress rule is specific and limited, NOT 0.0.0.0/0
  ingress {
    description = "HTTPS from my IP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"] # Replace with your actual trusted CIDR block
  }
  
  # Egress can be left open (0.0.0.0/0) if specific egress rules aren't strictly required, 
  # or you can make it more restrictive. For tfsec to pass, the ingress needs to be fixed.
  # The lab's solution was also to only deploy a Security Group.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

# 2. Instance resource removed or fixed (if kept, must enforce encryption)
resource "aws_instance" "web" {
  # This AMI ID is for example purposes.
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  # SECURE: Explicitly defines the root block device with encryption enabled
  root_block_device {
    encrypted = true # Fixes the "Instance with unencrypted block device" error
  }
resource "aws_instance" "web" {
  # ... (other instance configuration blocks) ...

  # FIX: Add this block to enforce IMDSv2 (Session Token Requirement)
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # This is the critical line to fix the alert
  }

  # ... (rest of the aws_instance configuration) ...
}
/* If you kept the 'aws_instance' resource, you must explicitly enforce encryption 
    to fix the "Instance with unencrypted block device" error.

resource "aws_instance" "web" {
  # ... (other instance configuration) ...
  
  # FIX: Add the root_block_device block to explicitly enable encryption.
  root_block_device {
    encrypted = true
    # Optionally, specify the size and volume type
    volume_size = 8
    volume_type = "gp3"
  }
  */
  # This resource must be added to your staging branch to fix the alert
#  vpc_security_group_ids = [aws_security_group.web_sg_secure.id]
}
