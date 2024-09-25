# Create a Null Resource and Provisioners



resource "null_resource" "execute-commands" {
  depends_on = [aws_instance.ec2_public, aws_iam_instance_profile.packer-profile]

  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_instance.ec2_public.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("${var.cluster}-key.pem")
  }

  /*
## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/sept-key-pair.pem"
    destination = "/tmp/eks-terraform-key.pem"
  }
## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
*/


  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install git yum-utils",
      "sudo yum-config-manager -y --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo",
      "sudo yum -y install packer",
      "sudo /usr/bin/packer plugins install github.com/hashicorp/amazon",
      "sudo yum -y install make",
      "sudo /usr/bin/git clone https://github.com/awslabs/amazon-eks-ami.git",
      "cd /home/ec2-user/amazon-eks-ami",
    ]
  }




  ## File Provisioner:
  /*
  provisioner "file" {
    source      = "./install-worker.sh"
    destination = "/tmp/install-worker.sh"
    #destination = "/home/ec2-user/amazon-eks-ami/templates/al2/provisioners/install-worker.sh"
  }
  */


  provisioner "remote-exec" {
    inline = [
      ###"sudo /usr/bin/cp /tmp/install-worker.sh /home/ec2-user/amazon-eks-ami/templates/al2/provisioners/install-worker.sh",
      "sudo /usr/bin/rm -rf /usr/sbin/packer",
      "cd /home/ec2-user/amazon-eks-ami",
      "sudo make aws_region=us-east-2 subnet_id=subnet-03288a724fe08da0a encrypted=true launch_block_device_mappings_volume_size=10 k8s=1.29 iam_instance_profile=packer-profile kubernetes_build_date='2024-01-04' kubernetes_version=1.29.0"

      ## NOT WORKING AUG 2024"sudo make aws_region=us-east-2 subnet_id=subnet-03288a724fe08da0a ami_regions=us-east-2 binary_bucket_region=us-east-2 encrypted=true launch_block_device_mappings_volume_size=10 k8s=1.29 iam_instance_profile=packer-profile kubernetes_build_date='2024-01-04' kubernetes_version=1.29.0"
      #NOT WORKING IN FEB 2024#"sudo make aws_region=sa-east-1 subnet_id=subnet-0ee6c670d9fbc4787 ami_regions=sa-east-1 binary_bucket_region=sa-east-1 encrypted=true launch_block_device_mappings_volume_size=8 kubernetes_version=1.28" --> not working in FEB 2024
      #WORKING in FEB 2024#" make aws_region=sa-east-1 subnet_id=subnet-0ee6c670d9fbc4787 ami_regions=sa-east-1 binary_bucket_region=us-west-2 encrypted=true launch_block_device_mappings_volume_size=10 k8s=1.29"
    ]
  }


  /*
  ## ONCE YOUR EC2 INSTANCE is UP AND RUNNING. Please follow below steps 
  1. Login via Instance Connect
  2. Execute below commands 

  - Login to root user and goto GIT repo
   # sudo su -
   # cd /home/ec2-user/amazon-eks-ami

  - Export the KEYID / KEY and TOKEN 
   # export AWS_ACCESS_KEY_ID=""
   # export AWS_SECRET_ACCESS_KEY=""
   # export AWS_SESSION_TOKEN="" 

  - Run below command
  # cd /home/ec2-user/amazon-eks-ami
  # make aws_region=sa-east-1 subnet_id=subnet-0610e8c06b5950b4a ami_regions=sa-east-1 binary_bucket_region=sa-east-1 encrypted=true launch_block_device_mappings_volume_size=8

  NOTE: 
  1. Please change below information - 
   aws_region=sa-east-1               --> REGION as per your REGION 
   subnet_id=subnet-0610e8c06b5950b4a --> PUBLIC SUBNET from MONITORING CLUSTER 
   ami_regions                        --> REGION where you want to store new AMI
   binary_bucket_region=sa-east-1     --> Same as above REGION
   encrypted=true                     --> true to create encrypted image 
   launch_block_device_mappings_volume_size=8 --> Minimum size is 8

  2. By default it will take latest kubernetes version.

  3. If MAKE command is not running. May be there is another package for PACKER installed. Please run below commands to check and delete.
  # ls -lrth /usr/sbin/packer
lrwxrwxrwx 1 root root 15 Jan  9 22:37 /usr/sbin/packer -> cracklib-packer
  # rm -rf /usr/sbin/packer
  # ls -lrth /usr/sbin/packer
  # packer version
*/

}

