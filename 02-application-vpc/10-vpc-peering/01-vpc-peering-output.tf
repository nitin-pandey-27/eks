# Output For VPC Peering Requester

output "peering_id" {
  description   = "VPC Peering ID" 
  value         = aws_vpc_peering_connection.application.id
}

output "peering_status" {
  description   = "VPC Peering accept_status" 
  value         = aws_vpc_peering_connection.application.accept_status
}

# Output For VPC Peering Accepter

/*

output "accepter_peering_id" {
  description   = "VPC Peering ID" 
  value         = aws_vpc_peering_connection_accepter.monitoring.id
}

output "accepter_peering_status" {
  description   = "VPC Peering accept_status" 
  value         = aws_vpc_peering_connection_accepter.monitoring.accept_status
}

*/