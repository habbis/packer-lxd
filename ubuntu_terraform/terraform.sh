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
tf_user="tfuser"
github_user="habbis"
install_folder="/opt/terraform/"
package="unzip"
github_user_sshkeys="https://github.com/habbis.keys" 

apt-get install -y ${package}

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

if test -d /home/${tf_user}/.ssh; then
	echo 'user have ssh_keys'

else

#sleep 1
cd /home/${tf_user}/ || exit

# setup home dir of user
mkdir -p  /home/${tf_user}/.ssh
touch /home/${username}/.ssh/authorized_keys

chown ${username}:${tf_user} /home/${username}/.ssh
chmod 700 /home/${tf_user}/.ssh
chmod 644 /home/${tf_user}/.ssh/authorized_keys

wget ${github_user_sshkeys} ; cat ${github_user}.keys >> .ssh/authorized_keys  ; rm ${github_user}.keys 

fi

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update -y && sudo apt-get install -y terraform
