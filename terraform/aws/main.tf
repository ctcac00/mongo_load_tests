provider "aws" {
  region = var.region
}

locals {
  user_data = <<-EOT
  #!/bin/bash
  
  cat << EOF >> /etc/security/limits.conf
  * soft     nproc          65535    
  * hard     nproc          65535   
  * soft     nofile         65535   
  * hard     nofile         65535
  root soft     nproc          65535    
  root hard     nproc          65535   
  root soft     nofile         65535   
  root hard     nofile         65535
  EOF

  cat << EOF >> /etc/pam.d/common-session
  session required pam_limits.so
  EOF

  apt-get -y update && apt-get -y install python3 python3-pip git python3.8-venv
  echo "setting up mongolocust"
  cd /home/ubuntu
  git clone https://github.com/carlosmdb/mongolocust
  cd mongolocust
  python3 -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt
  EOT

  tags = {
    owner   = var.owner
    purpose = var.purpose
    "expire-on" = var.expire-on
  }

}

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "locust"
  description = "Security group for locust"
  vpc_id      = var.vpc_id

  ingress_with_self = [ {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      description      = "internal communication"
  } ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8089
      to_port     = 8089
      protocol    = "tcp"
      description = "locust ports"
      cidr_blocks = var.public_ip
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh port"
      cidr_blocks = var.public_ip
    },
  ]
  egress_rules        = ["all-all"]
  tags = local.tags
}

module "loadtest-demo" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(var.instances)

  name = "${each.key}"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = var.subnet_id

  user_data_base64 = base64encode(local.user_data)  

  tags = local.tags
}
