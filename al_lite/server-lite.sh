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
username="user"
github_user="habbis"
admin_group="admins"

# place other users her if you need to
#otherdir="root"

github_user_sshkeys="https://github.com/habbis.keys"
github_sudo_admin="https://raw.githubusercontent.com/habbis/sudoers/master/admins"

# utils for the server
utils="vim tmux python3 nmap git sudo"


# add new sudo group
groupadd ${admin_group}
# add user without password
useradd -m -s /bin/bash $username
# add user to sudo group in ubuntu
usermod -aG ${admin_group} ${username} 

# sudo setup 
wget ${github_sudo_admin} ; cat admins >> /etc/sudoers.d/admins
rm admins 



if [ -e /usr/bin/apt ]; then
# enable repo universe ubuntu 18.04
apt-add-repository universe

# install packages
apt-get update -y && apt-get install -y ${utils}

else

yum update -y ; yum install -y ${utils}

fi

# This install packages 
#sleep 1
cd /root/ || exit

# setup home dir of user
mkdir -p  /root/.ssh
touch /root/.ssh/authorized_keys


chown root:root /root/.ssh
chmod 700 /root/.ssh
chmod 644 /root/.ssh/authorized_keys

wget ${github_user_sshkeys} ; cat ${github_user}.keys >> .ssh/authorized_keys  ; rm ${github_user}.keys 

mkdir -p  /root/.ssh
touch /root/.ssh/authorized_keys


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




# ufw firewall

ufw allow ssh 
ufw default deny  incoming
ufw default allow outgoing
