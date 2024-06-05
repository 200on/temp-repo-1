#!/bin/bash

# Check if user is root or not
if (( $EUID != 0 )); then
    echo "PLEASE, LOGIN AS ROOT BEFORE RUNNING THIS SCRIPT!"
    exit
fi


# ---------- Install CRI (CRI-O) ---------------
apt-get update -qq && apt-get install -y \
    libbtrfs-dev \
    containers-common \
    git \
    libassuan-dev \
    libglib2.0-dev \
    libc6-dev \
    libgpgme-dev \
    libgpg-error-dev \
    libseccomp-dev \
    libsystemd-dev \
    libselinux1-dev \
    pkg-config \
    go-md2man \
    cri-o-runc \
    libudev-dev \
    software-properties-common \
    gcc \
    make
# --------------------------------------------------


# ----- Installing kubeadm, kubelet and kubectl ------
apt-get install -y apt-transport-https ca-certificates curl gpg


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