# COMP 7006
## Lab 4 - shell script

# Requirements
Due Date: October 17, 2017, 1200 hrs
You may work in groups of two.
## Objective: 
To design and implement a shell script that will install and configure a set of user-specified Linux packages.

## Assignment:
Design and develop a shell program that will provide a user with the ability to specify a set of packages to be installed and then configured as part of post-configuration script.
The application can be designed as a single script or as two separate scripts (i.e., an install script, and a post-install configuration script)

## Constraints:
Your script must prompt the user for, and allow the user to specify the following parameters:
- Name of the package(s) to be installed.
- Configuration details of each package to be implemented post installation.
- As a suggestion you can generate a configuration file using the user-specified parameters, which can then be read by the install and configuration script(s).
- Note that it is a requirement that the script handle all aspects of the installation including 
    - creating new directories, 
    - changing file permissions, etc.
    In other words this will be a fully-automated application that will not require a user to carry out any post installation tasks.
- Note that you are required to provide extensive documentation in the form of log entries and screen shots as part of your test and verification component.
- As a minimum test for your script, carry out the installation and configuration of the following applications:
- Apache as specified in lab #2
- NFS and Samba as specified in lab #3
- A demo of the application is required. This will be done in SE12-323 on the day the assignment is due.

## To Be Submitted:
- Hand in complete and well-documented design work and listings of your program.
- Make sure you include all your test and verification details (documentation) with your submission.
- Submit a detailed report outlining all the steps you took in configuring and testing your setup. Also submit copies of all the configuration files that you have modified.
- Submit a complete, zipped package that includes your report, configuration files and any supporting data and references in the sharein directory for this course under “Lab #4-FT”.

## Evaluation:
Design and documentation: 5 / 5
Test & Verification: 15 / 15
Script & Functionality: 40 / 40
Total: 60 / 60

# Design
## Overview
install script
take app name action and config file names as arguments
allow users to enter variables into config files
and then identify config file when calling script

can be self referencing - like a Makefile
kind of like an advanced installer

example usage:
$ superdnf {all|install|config} {apache|samba|nfs} [$config_file]

example config file can be included in package
initial thoughts are that file would be one entry per line
script reads config line by line
    looks for a variable
    and grabs associated value

read prompt
dnf: -y assumes yes, -c allows for config file, -q suppresses notifications

## apache
is apache installed?
    [root@datacomm ~]# systemctl status httpd
    Unit httpd.service could not be found.

install apache
    [root@datacomm ~]# dnf install -y httpd >> apache.log

config apache
    copy conf files 
        # add timestamp to copy
        cp -a /etc/httpd/conf/httpd.conf{,"-$(date +"%Y%m%d%H%M%S")"}
        cp -a /etc/httpd/conf.d/userdir.conf{,"-$(date +"%Y%m%d%H%M%S")"}
    [edit httpd.conf - not required [?add option to change port number]]
    edit userdir.conf
        change UserDir disable
            sed -i -e 's/UserDir disabled/UserDir Enabled/' userdir.conf
        remove comment on UserDir public_html
            sed -i -e 's/#Userdir/UserDir/' userdir.conf
        edit userdir.conf
            $passwordfilename
            allow from/deny from {all, $domain, $IP}
            comment out last stanza 
                <Directory "/home/*/public_html">...</Directory>
                sed -i '/\*\/public_html/,/\/Directory/ s/^/# &/g' userdir.conf
    mkdir /var/www/html/passwords     
    create user $username
    define user $password
        useradd -d /home/$user $user; echo $pass | passwd $user --stdinmkdirm
    create ~$username/public_html
        mkdir /home/$user/public_html; cp $idx /home/$user/public_html/
        chown -R $user.$user /home/$user/*; chmod -R 644 /home/$user/*
        sed -i "s/_uwd/\/home\/$user/" useradd.conf; sed -i -e "s/_hwd/\/var\/www\/html\/passwords\/$file/" userdir.add
    see if service is running
        restart if running
    start service if not

## NFS
create user $user
    useradd -d /home/$user $user; echo $pass | passwd $user --stdinmkdirm
copy files into directory
    cp $content/ /home/$user/
ensure directory and files are accessible
    chown -R $user.$user /home/$user/*; chmod -R 644 /home/$user/*
share /home/$user
    echo "/home/$user $net/$mask ( rw, no_root_squash ) >> /etc/exports
    restart if running
    start service if not
            
    ensure file system is shared
        /usr/sbin/exportfs -v

## SAMBA
install samba
share /home/$user
add section to smb.conf
set smbpasswd
	echo -ne "$pass\n$pass\n" | smbpasswd -s -a $user
