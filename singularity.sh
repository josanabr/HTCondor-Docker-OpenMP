#!/usr/bin/env bash
# This script installs Singularity
#
export VERSION=1.13 OS=linux ARCH=amd64
cd /vagrant
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz >& ./salida-wget.txt
sudo tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
echo 'export GOPATH=${HOME}/go' >> /home/vagrant/.bashrc
export GOPATH=${HOME}/go
echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> /home/vagrant/.bashrc
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
sudo apt-get install -y build-essential libssl-dev uuid-dev libgpgme11-dev squashfs-tools libseccomp-dev pkg-config
git clone https://github.com/sylabs/singularity.git
cd singularity
git checkout v3.4.0
./mconfig -p /usr/local
make -C builddir/ -j$(nproc)
sudo make -C builddir/ install
