## 📘 Terraform Backend Bootstrap Module

This module provisions all AWS resources required to support a remote Terraform backend before deploying any main infrastructure (ECS, VPC, ALB, etc.).

It solves the classic Terraform backend chicken-and-egg problem by being executed once locally, using local state, and then enabling remote state for the rest of the project.

## 🎯 Purpose

The bootstrap module creates secure, production-ready backend infrastructure:

### 🪣 S3 Buckets
| Bucket           | Purpose                                 |
| ---------------- | --------------------------------------- |
| **State Bucket** | Stores Terraform remote state           |
| **Log Bucket**   | Stores access logs for the state bucket |

### 🔐 Security Features

* Versioning enabled (state history / rollback)

* AES-256 server-side encryption

* Public access fully blocked

* Access logging enabled → log bucket

* Lifecycle rules to clean up old versions

### 🔒 DynamoDB Table (State Locking)

* Used for Terraform state locks to prevent concurrent plan / apply.

 Features:

* PAY_PER_REQUEST billing

* Primary key: LockID

* Tagged by environment for visibility

### 📦 Optional ECR Repository

If enabled via create_ecr, creates a private Amazon ECR registry with:

* Image scanning on push

* Mutable tags

* Environment-tagged resources

### 🌍 Region

* Default: eu-west-2 (London)

### 🚀 Quick Start

Create a terraform.tfvars inside the bootstrap module:

region            = "eu-west-2"
environment       = "dev"

state_bucket_name = "example-terraform-state-12345"
log_bucket_name   = "example-terraform-logs-12345"
lock_table_name   = "example-terraform-locks"

create_ecr        = true
ecr_repo_name     = "outline"



### ⚠️ Bucket names must be globally unique.

### 📁 Module Structure
backend-bootstrap/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md

### 🧱 Architecture Overview
Bootstrap (Local State)
   │
   ├─► S3 Bucket (Terraform State)
   │      ├─ Versioning Enabled
   │      ├─ AES256 Encryption
   │      ├─ Public Access Blocked
   │      ├─ Access Logging → Log Bucket
   │      └─ Lifecycle Rules
   │
   ├─► S3 Bucket (Access Logs)
   │      └─ Private bucket storing all access logs
   │
   ├─► DynamoDB Table (State Locks)
   │      ├─ LockID Primary Key
   │      ├─ Prevents concurrent Terraform operations
   │      └─ PAYG Billing
   │
   └─► ECR Repository (Optional)
          ├─ Private container registry
          ├─ Image scanning enabled
          └─ Mutable tags

### 🛠️ Deploying the Bootstrap Module

Run these commands ONCE ONLY:

cd terraform/backend-bootstrap
terraform init
terraform apply


You will receive outputs such as:

state_bucket_name

log_bucket_name

dynamodb_table_name

ecr_repository_url (if enabled)

region

### 🔗 Configuring Your Main Terraform Backend

After bootstrap completes, update your main Terraform backend configuration:

terraform {
  backend "s3" {
    bucket         = "example-terraform-state-12345"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "example-terraform-locks"
    encrypt        = true
  }
}


Then run:

terraform init -reconfigure


Terraform will ask:

“Do you want to copy existing local state to S3?”

### 👉 Select YES.