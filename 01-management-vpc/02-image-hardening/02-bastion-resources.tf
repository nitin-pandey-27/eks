
## Generate the SSH keypair that we’ll use to configure the EC2 instance. 
## After that, write the private key to a local file and upload the public key to AWS
## Building Amazon Linux 2 CIS Benchmark AMIs for Amazon EKS | Containers
## https://aws.amazon.com/blogs/containers/building-amazon-linux-2-cis-benchmark-amis-for-amazon-eks/
## https://github.com/awslabs/amazon-eks-ami/

resource "tls_private_key" "key" {
  algorithm = "RSA"
}


resource "aws_key_pair" "key_pair" {
  key_name   = "${var.cluster}-key"
  public_key = tls_private_key.key.public_key_openssh
}



resource "local_sensitive_file" "private_key" {
  filename        = "./${var.cluster}-key.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}


## SECURITY GROUP 

resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.cluster}-image-hardening"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.cluster}-image-hardening"
    Terraform = true
  }
}

## EC2 INSTANCE IN PUBLIC SUBNET 

resource "aws_instance" "ec2_public" {

  depends_on = [aws_security_group.allow_ssh_pub, aws_key_pair.key_pair, aws_iam_instance_profile.packer-profile]

  ami                         = data.aws_ami.amzlinux2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets_2
  vpc_security_group_ids      = [aws_security_group.allow_ssh_pub.id]

  iam_instance_profile = aws_iam_instance_profile.packer-profile.name

  #iam_instance_profile = aws_iam_instance_profile.packer_profile.name

  tags = {
    "Name"      = "${var.cluster}-image-hardening"
    "Terraform" = true
  }

  ## Copy the ssh key file to home dir of ec2-user
  provisioner "file" {
    source      = "./${var.cluster}-key.pem"
    destination = "/home/ec2-user/${var.cluster}-key.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./${var.cluster}-key.pem")
      host        = self.public_ip
    }
  }

  ## chmod key 400 on EC2 instance
  provisioner "remote-exec" {
    inline = ["chmod 400 ~/${var.cluster}-key.pem"]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./${var.cluster}-key.pem")
      host        = self.public_ip
    }

  }

}

## Policy and Role for Builder EC2 Instance 
## https://developer.hashicorp.com/packer/integrations/hashicorp/amazon

resource "aws_iam_policy" "packer_iam_policy" {
  name        = "packer-policy"
  path        = "/"
  description = "Packer IAM Policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CopyImage",
          "ec2:CreateImage",
          "ec2:CreateKeyPair",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteKeyPair",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSnapshot",
          "ec2:DeleteVolume",
          "ec2:DeregisterImage",
          "ec2:DescribeImageAttribute",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSnapshots",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume",
          "ec2:GetPasswordData",
          "ec2:ModifyImageAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifySnapshotAttribute",
          "ec2:RegisterImage",
          "ec2:RunInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeVpcs",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2-instance-connect:SendSSHPublicKey",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey",
          "iam:PassRole",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:GetRole",
          "iam:GetInstanceProfile",
          "iam:DeleteRolePolicy",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:AddRoleToInstanceProfile"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = {
    tag-key   = "packer-policy"
    Name      = "${var.cluster}-${var.environment}-packer-policy"
    Terraform = "true"
  }

}

# Resource: Create IAM Role 
resource "aws_iam_role" "packer_role" {
  name = "packer-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    Name      = "${var.cluster}-${var.environment}-packer-role"
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "packer-role-policy" {
  policy_arn = aws_iam_policy.packer_iam_policy.arn
  role       = aws_iam_role.packer_role.name
}



resource "aws_iam_instance_profile" "packer-profile" {
  name = "packer-profile"
  role = aws_iam_role.packer_role.name
}