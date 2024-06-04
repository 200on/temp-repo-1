#!/bin/bash

# Check if user is root or not
if (( $EUID != 0 )); then
    echo "PLEASE, LOGIN AS ROOT BEFORE RUNNING THIS SCRIPT!"
    exit
fi


# ---------- Docker installation ---------------
# Add Docker's official GPG key:
apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update


apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

service docker start
# --------------------------------------------------


# --- Installing kubeadm, kubelet and kubectl -----
apt-get install -y apt-transport-https ca-certificates curl gpg


# create directory "/etc/apt/keyrings" if not exists
keyrings_dir = "/etc/apt/keyrings"
if [ -d $keyrings_dir ]
then
    echo "Directory '$keyrings_dir' already exists"
else
    mkdir -m 755 /etc/apt/keyrings
fi

# Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list


apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

systemctl enable --now kubelet
# ------------------------------------------------