## MANAGEMENT VPC

This VPC will be used for any management tasks like AWS Service Logs / AMIs / Jenkins / Vault / S3 Storage etc. 

1. To create S3 and Dynamo DB for storing Terraform tfstate and lock file. 

	Please run terraform script mentioned at this location - 01-management-vpc/00-s3 

```
kubectl apply -f 01-management-vpc/00-s3
```

3. To create a management VPC so that we can create a EC2 instance for AMI Hardening / Jenkins / Vault.

	Please run terraform script mentioned at this location - 01-management-vpc/01-vpc

```
kubectl apply -f 01-management-vpc/01-vpc
```

5. To create an hardened AMI for EKS cluster worker nodes 

	Please run terraform script mentioned at this location - 01-management-vpc/02-image-hardening

```
kubectl apply -f 01-management-vpc/02-image-hardening
```
   
![Successful image hardened output will look this an attached snapshot.](https://github.com/nitin-pandey-27/demo/blob/main/01-management-vpc/02-image-hardening/AMI-Hardening-Output.jpg)

6. To create certificate using ACM

	Please run terraform script mentioned at this location - 01-management-vpc/03-acm-resource

```
kubectl apply -f 01-management-vpc/03-acm-resource
```

NOTE: For this, we need to have a VALID DNS HOSTED ZONE created. This is required for certificate validation.


## APPLICATION VPC

This VPC will be used for running the EKS cluster responsible for running the Application. Each Environment (demo/stag/test/prod) should have a different VPC. 

Please execute GITHUB Action pipeline. 

```
Select Actions -> Run Workflow -> Select "sequential_directory_apply" -> Select "apply" -> Select "02-application-vpc/01-vpc"
```
![This is how a RUN ACTION WORKFLOW looks.](https://github.com/nitin-pandey-27/demo/blob/main/02-application-vpc/Action-Workflow.jpg)

![Output of an execution plan.](https://github.com/nitin-pandey-27/demo/blob/main/02-application-vpc/Action-Workflow-Execution.jpg)

Argocd Configuration with Cognito, ALB Ingress and ACM 

Goto Cognito UI and select the user pool. Goto "App integration" and select "argocd_application" app client. 
Copy clientID and clientSecret and use  below commands to generate the base64.

```
echo -n "client-id" | base64
echo -n "client-secret" | base64
```

```
Select Actions -> Run Workflow -> Select "single_directory" -> Select "apply" -> Select "02-application-vpc/08-argocd"
```



## MONITORING VPC

This VPC will be used for running the EKS cluster responsible for running the Monitoring Applications like Grafana, Elasticsearch, Kibana. 

All the Application Environment (demo/stag/test/prod) can have a same Monitoring VPC. 

Please execute GITHUB Action pipeline. 

```
Select Actions -> Run Workflow -> Select "sequential_directory_apply" -> Select "apply" -> Select "02-application-vpc/01-vpc"
```

Argocd Configuration with Cognito, ALB Ingress and ACM 

Goto Cognito UI and select the user pool. Goto "App integration" and select "argocd_application" app client. 
Copy clientID and clientSecret and use  below commands to generate the base64.

```
echo -n "client-id" | base64
echo -n "client-secret" | base64
```

```
Select Actions -> Run Workflow -> Select "single_directory" -> Select "apply" -> Select "03-monitoring-vpc/08-argocd"
```
