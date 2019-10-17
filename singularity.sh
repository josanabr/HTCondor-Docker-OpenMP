#!/usr/bin/env bash
# This script installs Singularity
#
# Los archivos relacionados a 'go' y fuentes de 'singularity' se guardaran en 
# el directorio /vagrant
#
cd /vagrant
#
# Descarga y descompresion del compilador de go
#
export VERSION=1.13 OS=linux ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz >& ./salida-wget.txt
sudo tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
#
# Inicializacion de variables
#
echo 'export GOPATH=${HOME}/go' >> /home/vagrant/.bashrc
export GOPATH=${HOME}/go
echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> /home/vagrant/.bashrc
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
#
# Instalacion de paquetes requeridos en Ubuntu
#
sudo apt-get install -y build-essential libssl-dev uuid-dev libgpgme11-dev squashfs-tools libseccomp-dev pkg-config
#
# Clonacion de Singularity, compilacion y despliegue del mismo 
#
git clone https://github.com/sylabs/singularity.git
cd singularity
git checkout v3.4.0
./mconfig -p /usr/local
make -C builddir/ -j$(nproc)
sudo make -C builddir/ install
#
# Borrado de los archivos descargados en /vagrant
#
cd /vagrant
rm go$VERSION.$OS-$ARCH.tar.gz
rm -rf singularity
