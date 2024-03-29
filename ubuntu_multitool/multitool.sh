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
username="ansible"
tool_user="tool"
github_user="habbis"

config_folder="/local/etc/multitool"

terraform_install_folder="/opt/terraform/"
terraform_release="0.14.2"

packer_install_folder="/opt/packer/"
packer_release="1.6.5"

vault_install_folder="/opt/vault/"
vault_release="1.6.0"

package="python3-pip unzip tmux vim"
pip_package="paramiko ansible"
github_user_sshkeys="https://github.com/habbis.keys" 

apt-get update -y ; apt-get install -y ${package}

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

if test -d /home/${tool_user}/.ssh; then
	echo 'user have ssh_keys'

else

#sleep 1
cd /home/${username}/ || exit

# setup home dir of user
mkdir -p  /home/${tool_user}/.ssh
touch /home/${tool_user}/.ssh/authorized_keys

chown ${username}:${tool_user} /home/${username}/.ssh
chmod 700 /home/${tool_user}/.ssh
chmod 644 /home/${tool_user}/.ssh/authorized_keys

wget ${github_user_sshkeys} ; cat ${github_user}.keys >> .ssh/authorized_keys  ; rm ${github_user}.keys 

fi

# packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update -y && sudo apt-get install -y packer

#terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update -y && sudo apt-get install -y terraform

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update -y && sudo apt-get install -y vault
