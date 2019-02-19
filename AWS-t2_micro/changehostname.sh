#!/bin/bash
set -x
#change hostname
instanceID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
hostname="Jenkins-"
instanceHN="$hostname$instanceID"
sudo hostnamectl set-hostname $instanceHN
sudo sh -c " cat <<EOF >> /etc/hosts
$instanceIP $instanceHN
EOF"
sudo reboot
set +x
