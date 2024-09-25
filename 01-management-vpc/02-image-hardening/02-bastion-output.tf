## SSH KEY PAIR OUTPUT 

output "ssh_keypair" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}

output "ssh_keypair_name" {
  value = aws_key_pair.key_pair.key_name
}


## SECURITY GROUP 

output "sg_pub_id" {
  value = aws_security_group.allow_ssh_pub.id
}

## INSTANCE EC2

output "public_ip" {
  value = aws_instance.ec2_public.public_ip
}

## INSTANCE SUBNET 

output "subnet_id" {
  value = aws_instance.ec2_public.public_ip
}