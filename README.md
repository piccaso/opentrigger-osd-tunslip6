## tunslip6 as deb package

[![Build Status](https://travis-ci.org/piccaso/opentrigger-osd-tunslip6.svg?branch=master)](https://travis-ci.org/piccaso/opentrigger-osd-tunslip6)
[![Download](https://api.bintray.com/packages/ao/opentrigger/opentrigger-osd-tunslip6/images/download.svg)](https://bintray.com/ao/opentrigger/opentrigger-osd-tunslip6/_latestVersion)

### install prebuilt binaries
available for:  
- raspbian jessie (armhf) - only for the raspberry pi 3
- debian 8 jessie (amd64,i686,i386)
- ubuntu 16.04 xenial (amd64,i686,i386)
```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61 
echo "deb https://dl.bintray.com/ao/opentrigger `lsb_release -sc` main" | sudo tee /etc/apt/sources.list.d/opentrigger.list 
apt-get update && apt-get install opentrigger-osd-tunslip6
```
if yo dont have `lsb_release` isntalled substitue with `jessie` or `xenial`

### build (raspberry pi 3)
on any amd64 platfrom with docker:  
```sh
docker run -it --rm -v`pwd`:/work dockcross/linux-armv6 make ARCH=armhf clean deb
```
on raspbian:
```sh
make deb
```
