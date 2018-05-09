#!/bin/bash
digit=64  #it can be scan with "uname -m"
echo "Welcome to SystemC installer!"
echo "Downloading..."
wget http://www.accellera.com/images/downloads/standards/systemc/systemc-2.3.2.tar.gz
echo "Decompression..."
tar -xf systemc-2.3.2.tar.gz
echo "Deleting archive..."
rm systemc-2.3.2.tar.gz
echo "Internal prepairings..."
cd ./systemc-2.3.2/src/sysc/datatypes/bit
sed -i -e 's/mutable//' sc_bit_proxies.h
cd ../../../..
echo "Creating directory in \"root\"..."
sudo mkdir /usr/local/systemc-2.3.2
echo "Creating temporary directory..."
mkdir objdir
cd objdir
export CXX=g++
echo "Setting configurations..."
sudo ../configure -prefix=/usr/local/systemc-2.3.2
echo "Starting making..."
sudo make
sudo make install
echo "Making finished!"
cd ../..
echo "Uninstalling temporary directory..."
sudo rm -rf systemc-2.3.2
echo "Setting environment variables..."
export SYSTEMC_HOME=/usr/local/systemc-2.3.2/
export LD_LIBRARY_PATH=/usr/local/systemc-2.3.2/lib-linux$digit
echo "Adding extra paths..."
sudo echo "SYSTEMC_HOME=\"/usr/local/systemc-2.3.2/\"" | sudo tee -a /etc/environment #TODO eliminate the output of this string to terminal
echo "System will be rebooted after 10 seconds"
sleep 5; echo "5"; sleep 1; echo "4"; sleep 1; echo "3"; sleep 1; echo "2"; sleep 1; echo "1"
sleep 1
echo "REBOOTING"
sudo shutdown -r +0
