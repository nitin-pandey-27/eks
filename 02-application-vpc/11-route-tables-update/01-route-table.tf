## VPC Peering 
/*
App Cluster Prod 
vpc_cidr_block 			      = "172.21.0.0/16"
cluster_service_ipv4_cidr = "172.23.0.0/16"

Monitoring Cluster 
vpc_cidr_block 			      = "172.17.0.0/16"
cluster_service_ipv4_cidr = "172.20.0.0/16"

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

NOTE: Peering Requester will be Application Cluster and Accepter will be Common Monitoring Cluster 
*/

#### UPDATE REQUESTER ROUTE TABLE #########
# vpc_cidr_block

data "aws_route_table" "requester" {

  subnet_id = data.terraform_remote_state.vpc_application_prod.outputs.private_subnets_1

}

resource "aws_route" "route_requester_1" {
  route_table_id            = data.aws_route_table.requester.id
  #destination_cidr_block    = "172.17.0.0/16"
  destination_cidr_block    = "${data.terraform_remote_state.vpc_monitoring.outputs.vpc_cidr_block}"
  vpc_peering_connection_id = data.terraform_remote_state.vpc_peering.outputs.peering_id
}

# EKS Service CIDR
/* 
resource "aws_route" "route_requester_2" {
  route_table_id            = data.aws_route_table.requester.id
  destination_cidr_block    = "172.20.0.0/16"
  vpc_peering_connection_id = data.terraform_remote_state.vpc_peering.outputs.peering_id
}
*/


#### UPDATE ACCEPTER ROUTE TABLE ##########


data "aws_route_table" "accepter" {

  subnet_id = data.terraform_remote_state.vpc_monitoring.outputs.private_subnets_1

}

resource "aws_route" "route_accepter_1" {
  route_table_id            = data.aws_route_table.accepter.id
  #destination_cidr_block    = "172.21.0.0/16"
  destination_cidr_block    = "${data.terraform_remote_state.vpc_application_prod.outputs.vpc_cidr_block}"
  vpc_peering_connection_id = data.terraform_remote_state.vpc_peering.outputs.peering_id
}

# EKS Service CIDR
/*
resource "aws_route" "route_accepter_2" {
  route_table_id            = data.aws_route_table.accepter.id
  destination_cidr_block    = "172.23.0.0/16"
  vpc_peering_connection_id = data.terraform_remote_state.vpc_peering.outputs.peering_id
}
*/