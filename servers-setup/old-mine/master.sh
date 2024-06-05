#!/bin/bash

# ------ Initializing master node ---------------
kubeadm init

export KUBECONFIG=/etc/kubernetes/admin.conf
