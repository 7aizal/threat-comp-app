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

<img width="1289" height="714" alt="image" src="https://github.com/user-attachments/assets/218946bc-0b59-41e6-be42-1c8ae93bb9bb" />



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

  <img width="1503" height="701" alt="image" src="https://github.com/user-attachments/assets/0ab520e1-0149-4951-837c-c6012b654931" />


### 2. Terraform Plan

* Runs automatically after build

* Shows changes before deployment
  <img width="1810" height="738" alt="image" src="https://github.com/user-attachments/assets/8ac78749-599e-4e6f-91d0-db3efd482e88" />


### 3. Terraform Apply (Manual Approval)

* Deploys full infrastructure stack:

* VPC, Subnets

* ALB

* ECS Cluster & Service

* IAM Roles

ACM Cert

Cloudflare DNS

<img width="1500" height="837" alt="image" src="https://github.com/user-attachments/assets/ebe067cb-6ab0-4f14-8d8b-33867458b550" />


### 4. Terraform Destroy (Manual Input “DESTROY”)

Safely tears everything down

Prevents AWS cost leakage
<img width="1498" height="688" alt="image" src="https://github.com/user-attachments/assets/33cfddbc-532d-41cc-a91d-66b42563de19" />


## 🔐 Security Best Practices Implemented

* Compute workloads isolated in private subnets

* ALB is the only public entry point

* ECS only accepts traffic from ALB SG

* Terraform backend stored in secure S3 bucket

* IAM least-privilege roles

* HTTPS enforced with ACM

* Cloudflare DNS for secure routing

* GitHub Secrets used for all sensitive data



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
