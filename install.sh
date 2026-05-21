#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================="
echo "Updating System Packages..."
echo "=========================================="
sudo dnf update -y   # Use 'yum' instead of 'dnf' if on older Amazon Linux 2

echo "=========================================="
echo "Installing Git and Maven..."
echo "=========================================="
sudo dnf install -y git maven wget

echo "=========================================="
echo "Installing Docker..."
echo "=========================================="
sudo dnf install -y docker
sudo systemctl enable --now docker

echo "=========================================="
echo "Installing Jenkins..."
echo "=========================================="
# Install Java 17 (Required dependency for Jenkins) [1]
sudo dnf install -y java-21-amazon-corretto-devel

# Import the Jenkins repository and GPG key [1]
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install and start Jenkins [1]
sudo dnf install -y jenkins
sudo systemctl enable --now jenkins

echo "=========================================="
echo "Configuring Permissions..."
echo "=========================================="
# Add both ec2-user and jenkins to the docker group so they can run docker commands
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins

# Restart Docker and Jenkins to apply group changes
sudo systemctl restart docker
sudo systemctl restart jenkins

# Install kubectl for kubernetes
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client


echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo "Jenkins is running on port 8080."
echo "Your Initial Admin Password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

