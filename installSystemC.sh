#!/bin/bash
digit=64
sudo -i
wget https://http://www.accellera.com/images/downloads/standards/systemc/systemc-2.3.2.tar.gz
tar -xvFj systemc-2.3.2.tar.gz
cd ./systemc-2.3.2/src/sysc/datatypes/bit
sed -i -e 's/mutable/ /g'
cd ..
cd ..
cd ..
cd ..
mkdir /usr/local/systemc-2.3
mkdir objdir
cd objdir
../configure -prefix=/usr/local/systemc-2.3
make
make install
export SYSTEMC_HOME=/usr/local/systemc-2.3/
export LD_LIBRARY_PATH=/usr/local/systemc-2.3/lib-linux$digit
echo >> "SYSTEMC_HOME=\"/usr/local/systemc-2.3/\"" >>  /etc/environment
reboot now
