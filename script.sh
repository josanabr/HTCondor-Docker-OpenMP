#!/usr/bin/env bash
#sudo echo "deb http://research.cs.wisc.edu/htcondor/ubuntu/stable/ xenial contrib" >> /etc/apt/sources.list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes install condor docker.io build-essential
sudo -i
cat << EOT >> /etc/condor/condor_config.local
QUEUE_ALL_USERS_TRUSTED = TRUE
CONDOR_HOST = \$(FULL_HOSTNAME)
ALLOW_READ = *
ALLOW_WRITE = *
HOSTALLOW_READ = *
HOSTALLOW_WRITE = *
ALLOW_NEGOTIATOR = *
ALLOW_ADMINISTRATOR = *
COLLECTOR_DEBUG = D_FULLDEBUG
NEGOTIATOR_DEBUG = D_FULLDEBUG
MATCH_DEBUG = D_FULLDEBUG
SCHEDD_DEBUG = D_FULLDEBUG
START = TRUE
TRUST_UID_DOMAIN = TRUE
USE_SHARED_PORT=FALSE
NETWORK_INTERFACE = 127.0.0.1
DAEMON_LIST=MASTER,COLLECTOR,NEGOTIATOR,SCHEDD,STARTD
EOT
sudo gpasswd -a ${USER} docker
sudo gpasswd -a condor docker
sudo gpasswd -a vagrant docker
newgrp docker
sudo service docker restart
sudo service condor restart
echo "-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-"
echo "  Para probar la instalacion ejecute 'condor_submit /vagrant/demo.condor'"
echo "-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-=*=-"
