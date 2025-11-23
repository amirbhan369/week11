# main.tf on staging branch
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allows inbound web traffic"

  # INSECURE: Allows all inbound traffic from anywhere (0.0.0.0/0)
  ingress {
    description = "Web access from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This will trigger a tfsec alert (ingress rule allows traffic from /0) 
  }

  # INSECURE: Allows all outbound traffic (default is usually bad practice)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # This will trigger a tfsec alert (egress rule allows traffic to /0) 
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

resource "aws_instance" "web" {
  # This AMI ID is for example purposes.
  # ami is a variable, not a direct value in the lab document's snippet
  # You can replace this with a valid AMI ID if you plan to deploy.
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.micro" 

  # INSECURE: Missing 'ebs_block_device' settings for encryption.
  # This will trigger a tfsec alert (Instance with unencrypted block device) [cite: 54, 56]
  
  # For the lab, you'll also need a data block to define the AMI lookup
  # data "aws_ami" "ubuntu" {
  #   most_recent = true
  #   filter {
  #     name   = "name"
  #     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  #   }
  #   owners = ["099720109477"]
  # }
}
