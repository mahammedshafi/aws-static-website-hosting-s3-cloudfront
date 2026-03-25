# ☁️ AWS Cloud Infrastructure Automation

Full AWS infrastructure provisioning using **Terraform IaC** + **Ansible configuration management** + **AWS CLI scripting**. Improved infrastructure deployment efficiency by **30%**.

## 📌 Project Overview

Automates provisioning of EC2, S3, VPC, Subnets, Security Groups, and IAM using Terraform. Ansible handles server configuration post-provisioning. AWS CLI scripts automate recurring infrastructure tasks.

## 🏗️ Architecture

```
Terraform → AWS Cloud
              ├── VPC (10.0.0.0/16)
              │    ├── Public Subnet  → EC2 Instance
              │    └── Private Subnet
              ├── Internet Gateway
              ├── Security Groups (SSH, HTTP, 8080)
              ├── IAM (Users, Groups, Roles — Least Privilege)
              └── S3 Bucket (Static Website Hosting)
                      ↓
              Ansible → Configure EC2
              (Docker, Java, UFW, packages)
```

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| Terraform | Infrastructure as Code |
| Ansible | Configuration Management |
| AWS EC2 | Compute |
| AWS S3 | Static website + artifact storage |
| AWS VPC | Networking |
| AWS IAM | Access control (least privilege) |
| AWS CloudWatch | Monitoring & logging |
| AWS CLI | Scripted automation |
| Bash | CLI automation scripts |

## 📁 Project Structure

```
4-aws-infrastructure/
├── main.tf                    # Core AWS resources (VPC, EC2, S3)
├── variables.tf               # Input variables
├── outputs.tf                 # Output values (IPs, URLs)
├── iam.tf                     # IAM users, groups, roles, policies
├── terraform.tfvars.example   # Example variable values
├── ansible/
│   ├── playbook.yml           # Server configuration playbook
│   └── inventory.ini          # Target hosts
├── scripts/
│   ├── userdata.sh            # EC2 bootstrap script
│   └── aws-cli-automation.sh  # AWS CLI infrastructure script
└── README.md
```

## ⚙️ Setup Instructions

### Prerequisites
- Terraform >= 1.0 installed
- Ansible installed
- AWS CLI configured (`aws configure`)
- AWS account with appropriate permissions

### Step 1 — Configure Variables
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### Step 2 — Terraform Deploy
```bash
# Initialize
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# View outputs
terraform output
```

### Step 3 — Ansible Configuration
```bash
# Update inventory with your EC2 IP
nano ansible/inventory.ini

# Test connectivity
ansible app_servers -i ansible/inventory.ini -m ping

# Run playbook
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

### Step 4 — AWS CLI Alternative
```bash
chmod +x scripts/aws-cli-automation.sh
./scripts/aws-cli-automation.sh
```

### Step 5 — Destroy (Cleanup)
```bash
terraform destroy
```

## 🔐 IAM — Least Privilege Principles

| Resource | Permissions |
|----------|------------|
| EC2 Role | S3 Read + CloudWatch Write only |
| DevOps User | EC2 Describe/Start/Stop + S3 Full |
| No root credentials | IAM users for all access |

## 📊 Results

- ✅ 30% faster infrastructure setup via automation
- ✅ Full IaC — reproducible, version-controlled infrastructure
- ✅ IAM least-privilege for all resources
- ✅ S3 static website with versioning enabled
- ✅ Ansible eliminates manual server configuration
