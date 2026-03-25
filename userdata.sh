#!/bin/bash
# ============================================================
# userdata.sh — EC2 bootstrap script (runs on first launch)
# ============================================================

set -e
exec > >(tee /var/log/userdata.log | logger -t userdata -s 2>/dev/console) 2>&1

echo "🚀 Starting EC2 bootstrap..."

# Update system
apt-get update -y
apt-get upgrade -y

# Install essentials
apt-get install -y curl wget git unzip software-properties-common

# Install Java 11
apt-get install -y openjdk-11-jdk
java -version

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
aws --version

# Install CloudWatch Agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb
systemctl enable amazon-cloudwatch-agent

echo "✅ EC2 bootstrap complete!"
