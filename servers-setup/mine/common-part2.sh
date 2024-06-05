#!/bin/bash

# Check if user is root or not
if (( $EUID != 0 )); then
    echo "PLEASE, LOGIN AS ROOT BEFORE RUNNING THIS SCRIPT!"
    exit
fi


apt-get install -y apt-transport-https ca-certificates curl gpg


# ---------- Install CRI (containerd) ---------------
apt update
apt upgrade -y

apt-get -y install containerd

service containerd enable
service containerd restart
# --------------------------------------------------


# ----- Installing kubeadm, kubelet and kubectl ------


# create directory "/etc/apt/keyrings" if not exists
keyrings_dir="/etc/apt/keyrings"
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
