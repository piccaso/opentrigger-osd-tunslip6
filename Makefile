VERSION ?= $(shell git describe --tags | sed -e 's/^v//')
ARCH ?= $(shell dpkg --print-architecture)
PKGBASE = opentrigger-osd-tunslip6
PKGNAME = $(PKGBASE)_$(VERSION)_$(ARCH)
INSTALL_ROOT ?= /
DIST = jessie

.PHONY : all clean install deb publish
all : tunslip6.bin smart-sarah.src

osd.src:
	git clone --depth 1 --branch osd https://github.com/osdomotics/osd-contiki osd.src

smart-sarah.src:
	git clone --depth 1 --branch master https://github.com/osdomotics/smart-sarah/ smart-sarah.src

tunslip6.bin: osd.src
ifeq ($(ARCH),i386)
		cd osd.src/tools && rm -f tunslip6 && make tunslip6 CFLAGS=-m32
else
		cd osd.src/tools && rm -f tunslip6 && make tunslip6
endif
	cp osd.src/tools/tunslip6 tunslip6.bin
	strip -v tunslip6.bin || true

clean:
	rm -rf *.src *.bin $(PKGBASE)* *.deb 2> /dev/null || true

install:
	mkdir -p $(INSTALL_ROOT)usr/sbin/
	install -v -m 755 tunslip6.bin $(INSTALL_ROOT)usr/sbin/tunslip6

ifeq ($(ARCH),armhf)
		mkdir -p $(INSTALL_ROOT)boot/
		install -v -m 755 smart-sarah.src/raspi-edge/boot/cmdline.txt $(INSTALL_ROOT)boot/cmdline.txt
		install -v -m 755 smart-sarah.src/raspi-edge/boot/config.txt $(INSTALL_ROOT)boot/config.txt
endif
	mkdir -p $(INSTALL_ROOT)lib/systemd/system/
	cp smart-sarah.src/raspi-edge/system/tunslip6.service $(INSTALL_ROOT)lib/systemd/system/

deb: all
	rm -rf $(PKGBASE)_* 2> /dev/null || true

	mkdir -p $(PKGNAME)/DEBIAN
	cp debian/* $(PKGNAME)/DEBIAN
ifeq ($(ARCH),armhf)
		cp debian.$(ARCH)/* $(PKGNAME)/DEBIAN
endif
	sed -i 's/__ARCH__/$(ARCH)/g' $(PKGNAME)/DEBIAN/control
	sed -i 's/__VERSION__/$(VERSION)/g' $(PKGNAME)/DEBIAN/control
	sed -i 's/__PKGBASE__/$(PKGBASE)/g' $(PKGNAME)/DEBIAN/control
	make install -e INSTALL_ROOT=$(PKGNAME)$(INSTALL_ROOT)
	du -s $(PKGNAME) | grep -oP ^[0-9]+ > __PKGSIZE__
	bash -c "sed -i 's/__PKGSIZE__/`cat __PKGSIZE__`/g' $(PKGNAME)/DEBIAN/control"
	rm __PKGSIZE__
	fakeroot dpkg-deb --build $(PKGNAME)
	rm -rf $(PKGNAME) 2> /dev/null || true
	dpkg-deb -I $(PKGNAME).deb
	@echo !----
	@echo ! to install the package type:
	@echo ! sudo dpkg -i $(PKGNAME).deb
	@echo !----

publish:
	@test -n "$(BINTRAYAUTH)" || { echo "Error: BINTRAYAUTH not defined" ; false ; }
	@test -f "$(PKGNAME).deb" || { echo "Error: $(PKGNAME).deb does not exist" ; false ; }
	@curl -H "Content-Type: application/json" -u "$(BINTRAYAUTH)" -X POST -d '{"name":"$(VERSION)","desc":"$(VERSION) $(CONFIGURATION)"}' https://bintray.com/api/v1/packages/ao/opentrigger/$(PKGBASE)/versions
	@curl -u "$(BINTRAYAUTH)" -X PUT --data-binary "@$(PKGNAME).deb" -H "X-Bintray-Publish: 1" -H "X-Bintray-Override: 1" -H "X-Bintray-Debian-Distribution: $(DIST)" -H "X-Bintray-Debian-Component: main" -H "X-Bintray-Debian-Architecture: $(ARCH)" 'https://bintray.com/api/v1/content/ao/opentrigger/$(PKGBASE)/$(VERSION)/pool/main/o/$(PKGNAME).deb'

