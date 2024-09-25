# VPC Output Values
# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# VPC Private Subnets
output "private_subnets_1" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_sa_east_1a.id
}

# VPC Private Subnets
output "private_subnets_2" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_sa_east_1c.id
}



# VPC Public Subnets
output "public_subnets_1" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_sa_east_1a.id
}

# VPC Public Subnets
output "public_subnets_2" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_sa_east_1c.id
}

/*
# VPC Cache Subnets
output "cache_subnets_1" {
  description = "List of IDs of cache subnets"
  value       = aws_subnet.cache_sa_east_1a.id
}

# VPC Cache Subnets
output "cache_subnets_2" {
  description = "List of IDs of cache subnets"
  value       = aws_subnet.cache_sa_east_1c.id
}
*/


# VPC Internet gateway Public IP
output "internet_public_ips" {
  description = "List of public Elastic IPs created for AWS Internet Gateway"
  value       = aws_internet_gateway.igw.id
}


# VPC NAT gateway Public IP
output "nat_public_ips_1" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.eip_public_sa_east_1a.address
}

# VPC NAT gateway Public IP
# Uncomment if you need 1 more NAT Gateway
/*
output "nat_public_ips_2" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.eip_public_sa_east_1a.address
}
*/

# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = var.aws_availability_zones.*
}

# VPC Private NACL ID
output "private_network_acl_id" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_network_acl.private_subnet.id
}

# VPC Private NACL ARN
output "private_network_acl_arn" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_network_acl.private_subnet.arn
}

# VPC Private ROUTE  ID
output "private_network_route_id" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_route_table.private.id
}

# VPC Private ROUTE ARN
output "private_network_route_arn" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_route_table.private.arn
}

# VPC Public NACL ID
output "public_network_acl_id" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_network_acl.public_subnet.id
}

# VPC Public NACL ARN
output "public_network_acl_arn" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_network_acl.public_subnet.arn
}

# VPC Public ROUTE  ID
output "public_network_route_id" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_route_table.public.id
}

# VPC Public ROUTE ARN
output "public_network_route_arn" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_route_table.public.arn
}

# VPC Flow Logs

/*
output "vpc_flow_logs_cloudwatch_log_arn" {
  description = "Cloudwatch Log ARN"
  value       = aws_flow_log.vpc_flow_logs.arn
}

output "vpc_flow_logs_cloudwatch_log_name" {
  description = "Cloudwatch Log ARN"
  value       = aws_flow_log.vpc_flow_logs.id
}
*/


/*

# VPC Cache NACL ID
output "cache_network_acl_id" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_network_acl.cache_subnet.id
}

# VPC Cache NACL ARN
output "cache_network_acl_arn" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_network_acl.cache_subnet.arn
}


# VPC Cache ROUTE  ID
output "cache_network_route_id" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_route_table.cache.id
}

# VPC Cache ROUTE ARN
output "cache_network_route_arn" {
  description = "A list of availability zones spefified as argument to this module"
  value       = aws_route_table.cache.arn
}


*/


