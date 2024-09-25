## VPC Peering 
/*
App Cluster Prod 
vpc_cidr_block 			      = "172.21.0.0/16"
cluster_service_ipv4_cidr = "172.23.0.0/16"

Monitoring Cluster 
vpc_cidr_block 			      = "172.17.0.0/16"
cluster_service_ipv4_cidr = "172.20.0.0/16"

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter

NOTE: Peering Requester will be Application Cluster and Accepter will be Common Monitoring Cluster 
*/

data "aws_caller_identity" "peer" {

  provider = aws

}

resource "aws_vpc_peering_connection" "application" {
  peer_owner_id = data.aws_caller_identity.peer.account_id

  peer_vpc_id   = data.terraform_remote_state.vpc_monitoring.outputs.vpc_id
  ##peer_vpc_id   = "vpc-05a3defc58730bfc4"
  vpc_id        = data.terraform_remote_state.vpc_application_prod.outputs.vpc_id
  #peer_region   = "${var.aws_region}"

  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

   tags = {
    Name       = data.terraform_remote_state.vpc_application_prod.outputs.vpc_id
    Terraform  = "true"
    Side       = "Requester"
  }
}


# Accepter's side of the connection.
/*
resource "aws_vpc_peering_connection_accepter" "monitoring" {

  depends_on = [ aws_vpc_peering_connection.application ]

  provider                  = aws
  vpc_peering_connection_id = aws_vpc_peering_connection.application.id
  auto_accept               = true 

  tags = {
    Name       = data.terraform_remote_state.vpc_monitoring.outputs.vpc_id
    Terraform  = "true"
    Side       = "Accepter"
  }
}
*/

resource "aws_vpc_peering_connection_options" "enable_dns" {

  depends_on = [ aws_vpc_peering_connection.application ]

  vpc_peering_connection_id = aws_vpc_peering_connection.application.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

}

### NOTE: 
## However, Terraform only allows the VPC Peering Connection to be deleted from the requester's side by removing the corresponding aws_vpc_peering_connection resource from your configuration. 
## Removing a aws_vpc_peering_connection_accepter resource from your configuration will remove it from your statefile and management, but will not destroy the VPC Peering Connection.
## SO, YOU WILL NEED TO DELETE THE VPC_PEERING MANUALLY FROM CONSOLE.