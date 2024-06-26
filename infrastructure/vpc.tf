module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "172.16.0.0/16"

  networks = [
    {
      name     = "private-a"
      new_bits = 2
    },
    {
      name     = "private-b"
      new_bits = 2
    },
    {
      name     = "private-c"
      new_bits = 2
    },
    {
      name     = "public-a"
      new_bits = 8
    },
    {
      name     = "public-b"
      new_bits = 8
    },
    {
      name     = "public-c"
      new_bits = 8
    },
    {
      name     = "database-a"
      new_bits = 8
    },
    {
      name     = "database-b"
      new_bits = 8
    },
    {
      name     = "database-c"
      new_bits = 8
    },
  ]
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "stefanb-vpc"

  cidr = module.subnet_addrs.base_cidr_block

  azs = data.aws_availability_zones.available.names

  public_subnets   = [lookup(module.subnet_addrs.network_cidr_blocks, "public-a"), lookup(module.subnet_addrs.network_cidr_blocks, "public-b"), lookup(module.subnet_addrs.network_cidr_blocks, "public-c")]
  private_subnets  = [lookup(module.subnet_addrs.network_cidr_blocks, "private-a"), lookup(module.subnet_addrs.network_cidr_blocks, "private-b"), lookup(module.subnet_addrs.network_cidr_blocks, "private-c")]
  database_subnets = [lookup(module.subnet_addrs.network_cidr_blocks, "database-a"), lookup(module.subnet_addrs.network_cidr_blocks, "database-b"), lookup(module.subnet_addrs.network_cidr_blocks, "database-c")]



  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  create_igw = true

  tags = {
    Owner = var.owner
  }
}
