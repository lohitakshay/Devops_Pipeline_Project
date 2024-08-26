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

echo "Initializing Kubernetes master node..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

echo "Configuring Kubernetes cluster..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Deploying networking solution (Calico)..."
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo "Deploying ingress controller (NGINX)..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/baremetal/deploy.yaml

echo "Master node setup complete!"
