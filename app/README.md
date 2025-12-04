<div align="center">
    <img src="./images/coderco.jpg" alt="CoderCo" width="300"/>
</div>

# Threat Composer Application - Open Source App Hosted on ECS with Terraform üöÄ

This project is based on Amazon's Threat Composer Tool, an open source tool designed to facilitate threat modeling and improve security assessments. You can explore the tool's dashboard here: [Threat Composer Tool](https://awslabs.github.io/threat-composer/workspaces/default/dashboard)

## Ì≥¶ Infrastructure Build Summary

This project demonstrates a full end-to-end deployment of a containerised application on AWS using Terraform.  
The initial phase was built as a single `main.tf` file to ensure a strong foundational understanding of each infrastructure component before modularisation.  

A summary of the first stages:

---

### Ì∑± **1. Core Networking (VPC Architecture)**
- Deployed a dedicated **VPC** with two public subnets across multiple Availability Zones  
- Configured an **Internet Gateway** and public route table  
- Enabled external connectivity for load balancer and Fargate workloads  

This established the secure network foundation for the entire platform.

---

### Ì¥ê **2. Security Controls**
- Created separate Security Groups for the **ALB** and **ECS Tasks**
- ALB allows controlled inbound web traffic  
- ECS tasks only accept traffic *from the ALB*, ensuring isolation and defence-in-depth  

This follows AWS best practices for workload segmentation.

---

### Ìºç **3. Application Load Balancer (ALB)**
- Launched an internet-facing **ALB** across multiple subnets  
- Configured an HTTP listener and a Target Group with health checks  
- Integrated the ALB with the ECS Service for traffic routing  

This provides high availability and centralised traffic control.

---

### Ì∫Ä **4. ECS (Fargate) Compute**
- Created an **ECS Cluster** using AWS Fargate (serverless compute)
- Defined an **ECS Task Definition** using the ECR container image  
- Configured non-root container execution and CloudWatch logging  
- Deployed an **ECS Service** to manage task scaling, health, and load balancing  

This automates container orchestration with no EC2 instances required.

---

### Ì¥í **5. HTTPS & Domain Integration**
- Provisioned an **ACM certificate** for `tm.fazops.com`  
- Automated DNS validation via Route53  
- Added an **HTTPS listener (443)** to the ALB  
- Mapped the domain to the ALB using a Route53 ALIAS record  

This delivers secure, production-grade HTTPS access to the application.

---

### ÌæØ **Outcome**
The result is a fully functional, secure, scalable, and load-balanced cloud architecture running on AWS ECS Fargate with:

- Automated TLS  
- Public domain routing  
- Robust networking & security  
- Containerised application delivery  
- Infrastructure-as-Code (Terraform)

This forms the foundation for the next stage: **modularising the Terraform codebase and implementing CI/CD pipelines.**

---

