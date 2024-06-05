#!/bin/bash

# Check if user is root or not
if (( $EUID != 0 )); then
    echo "PLEASE, LOGIN AS ROOT BEFORE RUNNING THIS SCRIPT!"
    exit
fi



# set hostname, convinient for further cluster management
read -p "Please, enter the hostname for this machine (for example 'mycluster-worker-11'): " new_hostname
hostnamectl set-hostname $new_hostname

# turn off swap permanently
sed -E '/^([^#].*)?swap/  s/^/#/' -i /etc/fstab

# turn on ip forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "PLEASE REBOOT THE MACHINE USING 'reboot' COMMAND FOR THE CHANGES TO TAKE EFFECT AND THEN EXECUTE 'common-part2.sh'"