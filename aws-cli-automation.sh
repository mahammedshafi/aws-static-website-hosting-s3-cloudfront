#!/bin/bash
# ============================================================
# aws-cli-automation.sh — AWS infrastructure via AWS CLI
# ============================================================

set -e

# ── CONFIG ──────────────────────────────────────────────────
REGION="ap-south-1"
PROJECT="devops-infra"
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
AMI_ID="ami-0f5ee92e2d63afc18"
INSTANCE_TYPE="t2.micro"
KEY_NAME="devops-key"

echo "=========================================="
echo " AWS CLI Infrastructure Automation Script"
echo "=========================================="

# ── CREATE VPC ──────────────────────────────────────────────
echo ""
echo "📦 Creating VPC..."
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block $VPC_CIDR \
    --region $REGION \
    --query 'Vpc.VpcId' \
    --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value="${PROJECT}-vpc" --region $REGION
echo "✅ VPC created: $VPC_ID"

# ── CREATE SUBNET ────────────────────────────────────────────
echo ""
echo "📦 Creating Subnet..."
SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $SUBNET_CIDR \
    --availability-zone "${REGION}a" \
    --region $REGION \
    --query 'Subnet.SubnetId' \
    --output text)
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value="${PROJECT}-subnet" --region $REGION
echo "✅ Subnet created: $SUBNET_ID"

# ── CREATE INTERNET GATEWAY ──────────────────────────────────
echo ""
echo "📦 Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
    --region $REGION \
    --query 'InternetGateway.InternetGatewayId' \
    --output text)
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
echo "✅ IGW created and attached: $IGW_ID"

# ── CREATE SECURITY GROUP ────────────────────────────────────
echo ""
echo "🔒 Creating Security Group..."
SG_ID=$(aws ec2 create-security-group \
    --group-name "${PROJECT}-sg" \
    --description "DevOps project security group" \
    --vpc-id $VPC_ID \
    --region $REGION \
    --query 'GroupId' \
    --output text)

aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 8080 --cidr 0.0.0.0/0 --region $REGION
echo "✅ Security Group created: $SG_ID"

# ── LAUNCH EC2 ───────────────────────────────────────────────
echo ""
echo "🖥️  Launching EC2 Instance..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SG_ID \
    --subnet-id $SUBNET_ID \
    --associate-public-ip-address \
    --count 1 \
    --region $REGION \
    --query 'Instances[0].InstanceId' \
    --output text)

aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value="${PROJECT}-server" --region $REGION
echo "✅ EC2 Instance launched: $INSTANCE_ID"

# ── WAIT FOR INSTANCE ────────────────────────────────────────
echo ""
echo "⏳ Waiting for instance to be running..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION

PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --region $REGION \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo ""
echo "=========================================="
echo "✅ Infrastructure ready!"
echo "   VPC ID:      $VPC_ID"
echo "   Subnet ID:   $SUBNET_ID"
echo "   SG ID:       $SG_ID"
echo "   Instance ID: $INSTANCE_ID"
echo "   Public IP:   $PUBLIC_IP"
echo "   SSH:         ssh -i ${KEY_NAME}.pem ubuntu@${PUBLIC_IP}"
echo "=========================================="

# Save IDs to file for cleanup
cat > infra-ids.txt <<EOF
VPC_ID=$VPC_ID
SUBNET_ID=$SUBNET_ID
IGW_ID=$IGW_ID
SG_ID=$SG_ID
INSTANCE_ID=$INSTANCE_ID
PUBLIC_IP=$PUBLIC_IP
REGION=$REGION
EOF
echo "📄 IDs saved to infra-ids.txt"
