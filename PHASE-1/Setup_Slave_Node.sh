#!/bin/bash

# Exit on error
set -e

echo "Updating system packages..."
sudo apt-get update

echo "Installing Docker..."
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock

echo "Installing required dependencies for Kubernetes..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings

echo "Adding Kubernetes repository and GPG key..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating package list..."
sudo apt update

echo "Installing Kubernetes components..."
sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1

echo "Joining Kubernetes cluster..."
# Replace <MASTER_IP> and <JOIN_COMMAND> with actual values
# Obtain the join command from the master node after initialization
# Example: kubeadm join <MASTER_IP>:<PORT> --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
sudo kubeadm join <MASTER_IP>:<PORT> --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>

echo "Worker node setup complete!"
