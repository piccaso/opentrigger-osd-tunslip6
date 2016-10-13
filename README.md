## tunslip6.deb 

[![Build Status](https://travis-ci.org/piccaso/opentrigger-osd-tunslip6.svg?branch=master)](https://travis-ci.org/piccaso/opentrigger-osd-tunslip6)
[![Download](https://api.bintray.com/packages/ao/opentrigger/opentrigger-osd-tunslip6/images/download.svg)](https://bintray.com/ao/opentrigger/opentrigger-osd-tunslip6/_latestVersion)

### install prebuilt binaries
available for:  
- raspbian jessie (armhf) - only for the raspberry pi 3 (the binary would work for earlier models, but the configuration will cause conflicts)
- debian 8 jessie (amd64,i686,i386)
- ubuntu 16.04 xenial (amd64,i686,i386)
```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61 
echo "deb https://dl.bintray.com/ao/opentrigger `lsb_release -sc` main" | sudo tee /etc/apt/sources.list.d/opentrigger.list 
apt-get update && apt-get install opentrigger-osd-tunslip6
```
### build with docker
for raspbian:  
```sh
docker run -it --rm -v`pwd`:/work dockcross/linux-armv6 make ARCH=armhf clean deb
```
