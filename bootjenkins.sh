#!/usr/bin/env bash
#
# Author:      Taco Bakker
#
# Purpose:	   Provision a VM with Jenkins running on it.
#              
# Description: The standard out-of-the box Debian package installation is done
#



echo   
echo "**********************************************************************"
echo "*                                                                    *"
echo "* Update Update your local package index and                         *"  
echo "* install jenkins                                                    *"  
echo "* start the jenkins service                                          *"
echo "*                                                                    *" 
echo "**********************************************************************" 
echo

yum install -y dnf-automatic
systemctl enable dnf-automatic.timer
systemctl start dnf-automatic.timer
systemctl status dnf-automatic.timer

echo "************************************************************************"
yum install -y dnf
echo "************************************************************************"
dnf --version
echo "************************************************************************"
dnf update -y
echo "************************************************************************"
dnf upgrade -y
echo "************************************************************************"
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
echo "************************************************************************"
yum upgrade -y
echo "************************************************************************"
yum install -y jenkins java-1.8.0-openjdk-devel
systemctl daemon-reload
echo "************************************************************************"
systemctl start jenkins

echo "************************************************************************"
#dnf list nginx
#dnf install -y nginx
#systemctl enable nginx
#systemctl start nginx
echo "************************************************************************"

firewall-cmd --zone=public --add-port=8080/tcp --permanent

firewall-cmd --zone=public --add-service=http --permanent

firewall-cmd --reload

echo "************************************************************************"
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
echo "************************************************************************"

ifconfig
echo "The initial password for Jenkins is:"
cat /var/jenkins_home/secrets/initialAdminPassword

exit 0
