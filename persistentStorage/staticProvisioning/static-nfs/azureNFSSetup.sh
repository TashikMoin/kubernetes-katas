#!/bin/bash
# NOTE: The nfs server vm should be inside the K8 cluster's virtual network.
# Execute this script with sudo prefix,   
# sudo <./script.sh>

# Your AKS Cluster will need to live in the same or peered virtual networks as the NFS Server. 
# The cluster must be created in an existing VNET, which can be the same VNET as your VM.


# This script should be executed on Linux Ubuntu Virtual Machine

EXPORT_DIRECTORY=${1:-/export/data}
# default value for $1 variable /export/data
DATA_DIRECTORY=${2:-/data}
# default value for $2 variable /data
AKS_SUBNET=10.0.0.0/16
# AKS_SUBNET=${3:-*}  
# AKS_SUBNET means the cidr ip range of the subnet of K8 cluster. 
# This can be viewed from K8cluster -> networking from Microsoft Azure.
# default value for $3 variable *

echo "Updating packages"
apt-get -y update

echo "Installing NFS kernel server"

apt-get -y install nfs-kernel-server

echo "Making data directory ${DATA_DIRECTORY}"
mkdir -p ${DATA_DIRECTORY}

echo "Making new directory to be exported and linked to data directory: ${EXPORT_DIRECTORY}"
mkdir -p ${EXPORT_DIRECTORY}

echo "Mount binding ${DATA_DIRECTORY} to ${EXPORT_DIRECTORY}"
mount --bind ${DATA_DIRECTORY} ${EXPORT_DIRECTORY}

echo "Giving 777 permissions to ${EXPORT_DIRECTORY} directory"
chmod 777 ${EXPORT_DIRECTORY}

parentdir="$(dirname "$EXPORT_DIRECTORY")"
echo "Giving 777 permissions to parent: ${parentdir} directory"
chmod 777 $parentdir

echo "Appending bound directories into fstab"
echo "${DATA_DIRECTORY}    ${EXPORT_DIRECTORY}   none    bind  0  0" >> /etc/fstab

echo "Appending localhost and Kubernetes subnet address ${AKS_SUBNET} to exports configuration file"
echo "/export        ${AKS_SUBNET}(rw,async,insecure,fsid=0,crossmnt,no_subtree_check)" >> /etc/exports
echo "/export        localhost(rw,async,insecure,fsid=0,crossmnt,no_subtree_check)" >> /etc/exports

nohup service nfs-kernel-server restart