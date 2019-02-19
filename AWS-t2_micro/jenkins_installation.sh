#!/bin/bash
#
#Set debug mode
set -x
sudo apt-get update
# INSTALLING JAVA
sudo apt-get install default-jdk -y
#
# INSTALLATION OF JENKINS
#Add the key and source list to apt for Jenkins.
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl start jenkins.service
#
#configure firewall
sudo ufw allow OpenSSH
sudo ufw enable -y
#open firewall for jenkins
sudo ufw allow 8080
# Tell Jenkins where is Java
# /etc/init.d/jenkins
#replace Java path for jenkins:
sudo sed -i 's;PATH=/bin:/usr/bin:/sbin:/usr/sbin;'"PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/"';' /etc/init.d/jenkins
#
#Install plugins
#git plugin #git integration with jenkins
#maven integration plugin #maven integration with jenkins
#deploy to container plugin #allows to deploy a war to a container after a successful build.
#
sudo systemctl daemon-reload
sudo systemctl restart jenkins.service
#
sudo apt install maven -y
sudo touch /etc/profile.d/apache-maven.sh
sudo sh -c " cat <<EOF > /etc/profile.d/apache-maven.sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export M2_HOME=/usr/share/maven
export MAVEN_HOME=/usr/share/maven
export PATH=${M2_HOME}/bin:${PATH}
EOF"
source /etc/profile.d/apache-maven.sh
# change hostname
instanceIP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
instanceID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
hostname="NewJenkins-"
instanceHN="$hostname$instanceID"
sudo hostnamectl set-hostname $instanceHN
sudo sh -c " cat <<EOF >> /etc/hosts
$instanceIP $instanceHN
EOF"
sudo reboot
set +x
