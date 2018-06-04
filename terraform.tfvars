region = "us-east-1"

environment = "dev"

name = "SC-Test"

vpc_cidr = "192.168.0.0/16"

azs = ["us-east-1a", "us-east-1b"]

tags {
  Name        = "SC-Test"
  Description = "Terraform managed Infra"
  Environment = "Development"
  Owner       = "User"
}

private_subnets = ["192.168.1.0/24", "192.168.2.0/24"]

public_subnets = ["192.168.101.0/24", "192.168.102.0/24"]

database_subnets = ["192.168.201.0/24", "192.168.202.0/24"]

#single_nat_gateway #per availability zone
#security_groups = […]

