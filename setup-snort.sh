#!/bin/bash
#This makes the script exit on the first error

#set -e 

echo "This script will setup snort. Please review the contents of the script before running"
sleep 20;


#create install directory 

rm -rf /tmp/snort-install
mkdir -p /tmp/snort-install
cd /tmp/snort-install/


#install packages for needed to build snort

#sudo apt-get -y install flex bison build-essential checkinstall libpcap-dev libnet1-dev libpcre3-dev libmysqlclient-dev libnetfilter-queue-dev iptables-dev libdnet-dev

#Download libdnet-1.12 , install using checkinstall and dpkg -i 

wget https://libdnet.googlecode.com/files/libdnet-1.12.tgz
tar -xvf libdnet-1.12.tgz 
cd libdnet-1.12/
./configure "CFLAGS=-fPIC"
make 
sudo checkinstall -y
sudo dpkg -i libdnet_1.12-1_amd64.deb
sudo ln -s /usr/local/lib/libdnet.1.0.1 /usr/lib/libdnet.1
cd -

wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz
tar xvfz daq-2.0.6.tar.gz 
cd daq-2.0.6
./configure 
make 
sudo checkinstall -y
sudo dpkg -i daq_2.0.6-1_amd64.deb
cd - 

wget https://www.snort.org/downloads/snort/snort-2.9.8.0.tar.gz
tar xvfz snort-2.9.8.0.tar.gz
cd snort-2.9.8.0
./configure --enable-sourcefire
make
sudo checkinstall -y
sudo dpkg -i snort_2.9.8.0-1_amd64.deb
ln -s /usr/local/bin/snort /usr/sbin/snort
sudo ldconfig -v
snort -V
cd -  

sudo groupadd snort
sudo useradd snort -d /var/log/snort -s /sbin/nologin -c SNORT_IPS -g snort
sudo mkdir /var/log/snort
sudo chown snort:snort /var/log/snort

sudo mkdir -p /etc/snort
tar -xvfz $workingDir/snortrules-snapshot-2976.tar.gz -C /etc/snort
sudo touch /etc/snort/rules/white_list.rules
sudo touch /etc/snort/rules/black_list.rules
sudo mkdir /usr/local/lib/snort_dynamicrules

sudo chown -R snort:snort /etc/snort/*
sudo mv /etc/snort/etc/* /etc/snort

