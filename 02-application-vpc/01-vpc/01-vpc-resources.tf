# VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = "${var.vpc_name}-${var.environment}"
    Terraform = "true"
  }
}

# Internet Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.cluster}-${var.vpc_name}-igw"
    Terraform = "true"
  }
}

# Subnet 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

resource "aws_subnet" "private_sa_east_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_private_subnets[0]
  availability_zone = var.aws_availability_zones[0]

  tags = {
    "Name"                                            = "private-${var.aws_availability_zones[0]}-${var.cluster}"
    "Type"                                            = "Private Subnets"
    "kubernetes.io/role/internal-elb"                 = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "Terraform"                                       = "true"
    "karpenter.sh/discovery"                          = "${local.eks_cluster_name}"

  }
}


resource "aws_subnet" "private_sa_east_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_private_subnets[1]
  availability_zone = var.aws_availability_zones[1]

  tags = {
    "Name"                                            = "private-${var.aws_availability_zones[1]}-${var.cluster}"
    "Type"                                            = "Private Subnets"
    "kubernetes.io/role/internal-elb"                 = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "Terraform"                                       = "true"
    "karpenter.sh/discovery"                          = "${local.eks_cluster_name}"

  }
}


resource "aws_subnet" "public_sa_east_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc_public_subnets[0]
  availability_zone       = var.aws_availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    "Name"                                            = "public-${var.aws_availability_zones[0]}-${var.cluster}"
    "Type"                                            = "Public Subnets"
    "kubernetes.io/role/elb"                          = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "Terraform"                                       = "true"
  }
}

resource "aws_subnet" "public_sa_east_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc_public_subnets[1]
  availability_zone       = var.aws_availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    "Name"                                            = "public-${var.aws_availability_zones[1]}-${var.cluster}"
    "Type"                                            = "Public Subnets"
    "kubernetes.io/role/elb"                          = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "Terraform"                                       = "true"
  }
}


/*
resource "aws_subnet" "cache_sa_east_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_elasticache_subnets[0]
  availability_zone = var.aws_availability_zones[0]

  tags = {
    "Name"      = "cache-${var.aws_availability_zones[0]}-${var.cluster}"
    "Type"      = "Cache Subnets"
    "Terraform" = "true"

  }
}

resource "aws_subnet" "cache_sa_east_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc_elasticache_subnets[1]
  availability_zone = var.aws_availability_zones[1]

  tags = {
    "Name"      = "cache-${var.aws_availability_zones[1]}-${var.cluster}"
    "Type"      = "Cache Subnets"
    "Terraform" = "true"

  }
}
*/

# NAT Gateway 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_eip" "eip_public_sa_east_1a" {
  domain = "vpc"
  tags = {
    Name        = "eip-public-${var.aws_availability_zones[0]}-${var.cluster}"
    "Terraform" = "true"
  }
  depends_on = [aws_vpc.main]
}

# Uncomment below block if you need NAT GATEWAY on 2 AZ's 
/*
resource "aws_eip" "eip_public_sa_east_1c" {
  domain = "vpc"
  tags = {
    Name = "eip-public-${var.aws_availability_zones[1]}-${var.cluster}"
    "Terraform"     = "true"
  }
  depends_on = [aws_vpc.main]
}
*/

resource "aws_nat_gateway" "nat_public_sa_east_1a" {
  allocation_id = aws_eip.eip_public_sa_east_1a.id
  subnet_id     = aws_subnet.public_sa_east_1a.id

  tags = {
    Name        = "nat-public-${var.aws_availability_zones[0]}-${var.cluster}"
    "Terraform" = "true"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Uncomment below block if you need NAT GATEWAY on 2 AZ's 
/* 
resource "aws_nat_gateway" "nat_public_sa_east_1c" {
  allocation_id = aws_eip.eip_public_sa_east_1c.id
  subnet_id     = aws_subnet.public_sa_east_1c.id

  tags = {
    Name            = "nat-public-${var.aws_availability_zones[1]}"
    "Terraform"     = "true"
  }

  depends_on = [aws_internet_gateway.igw]
}
*/

# Routing Table 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_public_sa_east_1a.id
  }
  # Uncomment below block if you want to change the NAT Gateway
  /*
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_public_sa_east_1c.id
  }
  */
  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }

  tags = {
    Name        = "private-route-table-${var.cluster}"
    "Terraform" = "true"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }

  tags = {
    Name        = "public-route-table-${var.cluster}"
    "Terraform" = "true"
  }
}


/*

resource "aws_route_table" "cache" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }
  tags = {
    Name        = "cache-route-table-${var.cluster}"
    "Terraform" = "true"
  }
}
*/


resource "aws_route_table_association" "private_sa_east_1a" {
  subnet_id      = aws_subnet.private_sa_east_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_sa_east_1c" {
  subnet_id      = aws_subnet.private_sa_east_1c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_sa_east_1a" {
  subnet_id      = aws_subnet.public_sa_east_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_sa_east_1c" {
  subnet_id      = aws_subnet.public_sa_east_1c.id
  route_table_id = aws_route_table.public.id
}


/*
resource "aws_route_table_association" "cache_sa_east_1a" {
  subnet_id      = aws_subnet.cache_sa_east_1a.id
  route_table_id = aws_route_table.cache.id
}

resource "aws_route_table_association" "cache_sa_east_1c" {
  subnet_id      = aws_subnet.cache_sa_east_1c.id
  route_table_id = aws_route_table.cache.id
}
*/

# Network ACL for Subnets 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl

resource "aws_network_acl" "public_subnet" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [aws_subnet.public_sa_east_1a.id, aws_subnet.public_sa_east_1c.id]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  egress {
    protocol   = "-1"
    rule_no    = "32766"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  ingress {
    protocol   = "-1"
    rule_no    = "32766"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  tags = {
    Name        = "public-subnet-nacl-${var.cluster}"
    "Terraform" = "true"
  }
}

resource "aws_network_acl" "private_subnet" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [aws_subnet.private_sa_east_1a.id, aws_subnet.private_sa_east_1c.id]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  egress {
    protocol   = "-1"
    rule_no    = "32766"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  ingress {
    protocol   = "-1"
    rule_no    = "32766"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  tags = {
    Name        = "private-subnet-nacl-${var.cluster}"
    "Terraform" = "true"
  }
}

/*
resource "aws_network_acl" "cache_subnet" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [aws_subnet.cache_sa_east_1a.id, aws_subnet.cache_sa_east_1c.id]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  egress {
    protocol   = "-1"
    rule_no    = "32766"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  ingress {
    protocol   = "-1"
    rule_no    = "32766"
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  tags = {
    Name        = "cache-subnet-nacl-${var.cluster}"
    "Terraform" = "true"
  }
}
*/