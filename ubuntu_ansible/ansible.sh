#!/usr/bin/env bash

# Script= server_lite.sh
# Author= Eirik Habbestad Helleve
# Date: 17.12.2020 - 1  (ee = times edited)

# Purpose: Add user,install packages, adds dotfiles to new
# system  
# Notes:  

#let script exit if a command fails
set -e -u
#let script exit if an unsed variable is used
#set -u 
#
#
#echo "adding user to system"

# username and password are variables and are given a value
username="auser"
github_user="habbis"
install_folder="/opt/terraform/"
#release="0.14.2"
package="python3-pip unzip"
pip_package="paramiko ansible"
github_user_sshkeys="https://github.com/habbis.keys" 

apt-get install -y ${package}

yes | sudo python3 -m pip install ${pip_package}

useradd -m -s /bin/bash $username

if test -d /home/${username}/.ssh; then
	echo 'user have ssh_keys'

else

#sleep 1
cd /home/${username}/ || exit

# setup home dir of user
mkdir -p  /home/${username}/.ssh
touch /home/${username}/.ssh/authorized_keys

chown ${username}:${username} /home/${username}/.ssh
chmod 700 /home/${username}/.ssh
chmod 644 /home/${username}/.ssh/authorized_keys

wget ${github_user_sshkeys} ; cat ${github_user}.keys >> .ssh/authorized_keys  ; rm ${github_user}.keys 

fi

#mkdir -p ${install_folder}

#cd ${install_folder} || exit

#wget https://releases.hashicorp.com/terraform/${release}/terraform_${release}_linux_amd64.zip
#unzip terraform_${release}_linux_amd64.zip

#ln -s  ${install_folder}/terraform /usr/local/bin/terraform

