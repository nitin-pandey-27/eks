# Create a Null Resource and Provisioners
# NOTE: The local-exec will change as per the HOST machine from where you are running terraform.

# THIS FILE IS NOT USED. Will be updated in future.

/*

resource "null_resource" "aws-auth-cm" {
  # depends_on = [module.ec2_bastion_host]
  # Connection Block for Provisioners to connect to EC2 Instance
 
## Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    #command = "kubectl apply -f 01-karpenter-aws-auth-cm.yaml"
    
    command = <<-EOT
              "set TOKEN="aws eks --region sa-east-1 --profile 278671418314_aws-default-dev get-token --cluster-name app-cluster""
              "kubectl --token %TOKEN% apply -f 01-karpenter-aws-auth-cm.yaml"
    EOT
    
  }
}
*/