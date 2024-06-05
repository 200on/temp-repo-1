#!/bin/bash

# Check if user is root or not
if (( $EUID != 0 )); then
    echo "PLEASE, LOGIN AS ROOT BEFORE RUNNING THIS SCRIPT!"
    exit
fi


# ------ Initializing master node ---------------
kubeadm init

export KUBECONFIG=/etc/kubernetes/admin.conf

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# -----------------------------------------

# reboot
# kubeadm token create --print-join-command