# Threat Composer App 
## Cloud-Native Deployment on AWS ECS 

<img width="535" alt="architecture" src="https://github.com/user-attachments/assets/da59c9f0-17c2-40ce-b7af-31610d14a3df" />

This repository contains a full production-grade deployment pipeline and cloud architecture for hosting the Threat Composer application on AWS ECS Fargate using Terraform, GitHub Actions with OIDC, ECR, Cloudflare, and multi-AZ networking.


The goal of this project is to demonstrate modern DevOps engineering through:

* Automated Docker builds

* Secure ECR image storage

* Modular Terraform IaC

* CI/CD deployments

* A highly available AWS architecture

* HTTPS with ACM + Cloudflare DNS

* Multi-AZ resilience

* OIDC-based authentication from GitHub Actions to AWS (no long-lived IAM keys)


## 🚀 Project Overview

This project deploys the open-source Threat Composer UI into a secure, scalable AWS environment.

It includes:

* Fully containerised app

* End-to-end CI/CD

* Terraform provisioning of all infrastructure

* Multi-AZ load balancing

* Private compute with public ALB

* HTTPS termination

* Cloudflare-managed DNS

This mirrors real production architectures used by engineering teams across the industry.


## 🧩 High-Level Architecture
<img width="1304" alt="diagram" src="https://github.com/user-attachments/assets/c923a7be-d24c-4971-9264-9d9313e19664" />

## AWS Components:

<img width="951" height="528" alt="image" src="https://github.com/user-attachments/assets/7b7ba9c6-8165-4590-910a-4a0f19300a21" />




### Networking / VPC

* VPC (10.0.0.0/16)

* Two public subnets (AZa + AZb)

* Two private subnets (AZa + AZb)

* Internet Gateway for public ingress

* NAT Gateway for private subnet egress

### Compute & Load Balancing

* Application Load Balancer (public)

* ECS Fargate tasks inside private subnets

* ALB forwards traffic to ECS Tasks

* ECS pulls images from ECR

### Security

* ALB Security Group → allows ports 80 / 443

* ECS Task Security Group → allows only ALB traffic

* IAM roles for ECS + task execution

* ACM TLS Certificate for tm.fazops.com

### DNS

* Cloudflare manages DNS

* CNAME → points domain to ALB DNS

* HTTPS termination handled at ALB

### State & Storage

* S3 backend storing Terraform state

## Repository Structure
```bash

├── app/                      
│   └── (React UI + Dockerfile)
│
├── terraform/                
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── modules/
│       ├── vpc/
│       ├── alb/
│       ├── ecs/
│       ├── acm/
│       ├── dns/
│       ├── iam/
│       ├── sg/
│       └── s3/
│
└── .github/
    └── workflows/
        ├── build.yaml
        ├── tf-plan.yaml
        ├── tf-apply.yaml
        └── tf-destroy.yaml
```

## 🔄 CI/CD Pipeline Workflow
### 1. Build & Push (Automatic on Push)

* Checkout repo

* Build Docker image

* Push to ECR

* Outputs image URI

<img width="1476" height="845" alt="image" src="https://github.com/user-attachments/assets/ccf31f50-d22a-448b-be0e-ddd24a9bbc65" />



### 2. Terraform Plan

* Runs automatically after build

* Shows changes before deployment
  <img width="1512" height="639" alt="image" src="https://github.com/user-attachments/assets/f28fb8bc-9d95-4c0e-867e-0fadb262dbf7" />



### 3. Terraform Apply [Manual Trigger]

* Deploys full infrastructure stack:

* VPC, Subnets

* ALB

* ECS Cluster & Service

* IAM Roles

ACM Cert

Cloudflare DNS

<img width="1494" height="685" alt="image" src="https://github.com/user-attachments/assets/4e033371-3ac1-42d9-a274-bcb27fe3da85" />



### 4. Terraform Destroy [Manual Trigger]

Safely tears everything down

Prevents AWS cost leakage
<img width="1498" height="688" alt="image" src="https://github.com/user-attachments/assets/33cfddbc-532d-41cc-a91d-66b42563de19" />


### Demo

https://github.com/user-attachments/assets/564ecc4b-3288-404a-bd74-5b71e5b70d76

## 🔐 Security Best Practices Implemented

* Compute workloads isolated in private subnets

* ALB is the only public entry point

* ECS only accepts traffic from ALB SG

* Terraform backend stored in secure S3 bucket

* IAM least-privilege roles

* HTTPS enforced with ACM

* Cloudflare DNS for secure routing

* GitHub Secrets used for all sensitive data

## Terraform State Import (Existing Infrastructure Adoption)

During development, previously deployed AWS resources (ALB, Target Group, ACM cert, IAM roles) were imported into Terraform state using terraform import.
This ensures Terraform manages all cloud resources consistently.

```bash
terraform import module.alb.aws_lb.alb arn:aws:elasticloadbalancing:eu-west-2:ACCOUNT_ID:loadbalancer/app/threat-comp-alb/XYZ
```

## Two-phase Terraform Apply (because of Cloudflare + ACM)

Your deployment required:

* First apply WITHOUT the DNS module

* After ACM validation record appears, enable DNS module and apply again

### Two-Phase Apply for ACM DNS Validation

Because ACM DNS validation depends on Cloudflare DNS records, deployment is done in two phases:

* Deploy infrastructure without dns module enabled

* Once ACM outputs validation records, enable the dns module

* Run terraform apply again to create Cloudflare DNS records

* This avoids cyclic dependencies between ACM and Cloudflare.
Cloudflare Duplicate DNS Record Fix

You had to delete Cloudflare's automatically created _acme-challenge record.

### Cloudflare Duplicate DNS Record Fix

You had to delete Cloudflare's automatically created _acme-challenge record.

### Cloudflare DNS Considerations

Cloudflare may auto-generate previous _acme-challenge records from past certificates.
These must be deleted before Terraform creates new ACM validation records, otherwise Terraform will return:
```bash
An A, AAAA, or CNAME record with that host already exists.
```


Once deployed, the application is available at:

## https://tm.fazops.com

Cloudflare creates a CNAME pointing to:
```bash
threat-comp-alb-850082577.eu-west-2.elb.amazonaws.com
```

HTTPS termination is handled at the ALB using an ACM certificate.


## To Run Locally

In order to run the app locally, using Dockerhub for development and further testing, 
the steps taken are the following.
```bash
git clone https://github.com/7aizal/threat-comp-app.git
cd threat-comp-app
cd app
npm install 
npm start
docker build -t threat-comp-app
docker run -p 8080:8080 threat-comp-app
```


## 🎯 Why I Built This Project

This project demonstrates:

* Real-world cloud infrastructure design

* ECS + ECR + ALB + Terraform integration

* Production-ready CI/CD pipelines

* Cloud security fundamentals

* DNS + TLS provisioning

* Multi-AZ high availability

* End-to-end container lifecycle automation

* * Production-ready CI/CD pipelines using GitHub OIDC (no AWS keys)


## ✔️ Verified Functionality

* Docker builds succeed

* ECR image pushes confirmed

* Terraform deploys full stack

* ECS tasks run successfully

* ALB health checks pass

* HTTPS via tm.fazops.com

* Multi-AZ routing operational

* Full CI/CD Automation Complete

* GitHub Actions OIDC used for AWS access (no IAM keys in repo); GitHub Secrets only for non-AWS sensitive config (e.g. terraform tfvars)


MIT License - AWS OPEN SOURCE TOOL, Feel free to use. 




