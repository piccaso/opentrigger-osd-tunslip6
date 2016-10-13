## tunslip6 deb for raspbian (raspberry pi 3)

[![Build Status](https://travis-ci.org/piccaso/opentrigger-osd-tunslip6.svg?branch=master)](https://travis-ci.org/piccaso/opentrigger-osd-tunslip6)
[![Download](https://api.bintray.com/packages/ao/opentrigger/opentrigger-osd-tunslip6/images/download.svg)](https://bintray.com/ao/opentrigger/opentrigger-osd-tunslip6/_latestVersion)

### install from bintray
```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61 
echo "deb https://dl.bintray.com/ao/opentrigger jessie main" | sudo tee /etc/apt/sources.list.d/opentrigger.list 
apt-get update && apt-get install opentrigger-osd-tunslip6
```

### build with docker
```sh
docker run -it --rm -v`pwd`:/work dockcross/linux-armv6 make ARCH=armhf clean deb
```
