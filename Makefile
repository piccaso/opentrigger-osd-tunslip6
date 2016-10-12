VERSION := 0.1-$(shell date +%s)
ARCH ?= $(shell dpkg --print-architecture)
PKGBASE = opentrigger-osd-tunslip6
PKGNAME = $(PKGBASE)_$(VERSION)_$(ARCH)
PKGSIZE = $(shell du -s $(PKGNAME) | awk '{print $$1}')
INSTALL_ROOT ?= /

.PHONY : all clean install
all : tunslip6.bin smart-sarah.src deb

osd.src:
	git clone --depth 1 --branch osd https://github.com/osdomotics/osd-contiki osd.src
	
smart-sarah.src:
	git clone --depth 1 --branch master https://github.com/osdomotics/smart-sarah/ smart-sarah.src
	
tunslip6.bin: osd.src
		cd osd.src/tools && rm -f tunslip6 && make tunslip6
		cp osd.src/tools/tunslip6 tunslip6.bin
		
clean:	
	rm -rf *.src *.bin $(PKGBASE)* *.deb 2> /dev/null || true

install:
	mkdir -p $(INSTALL_ROOT)bin/
	install -v -m 755 tunslip6.bin $(INSTALL_ROOT)bin/tunslip6
	
	mkdir -p $(INSTALL_ROOT)boot/
	cp smart-sarah.src/raspi-edge/boot/cmdline.txt $(INSTALL_ROOT)boot/cmdline.txt
	cp smart-sarah.src/raspi-edge/boot/config.txt $(INSTALL_ROOT)boot/config.txt
	
	mkdir -p $(INSTALL_ROOT)lib/systemd/system/
	cp smart-sarah.src/raspi-edge/system/tunslip6.service $(INSTALL_ROOT)lib/systemd/system/

deb: all
	rm -rf $(PKGBASE)_* 2> /dev/null || true
	
	mkdir -p $(PKGNAME)/DEBIAN
	cp debian/* $(PKGNAME)/DEBIAN
	sed -i 's/__ARCH__/$(ARCH)/g' $(PKGNAME)/DEBIAN/control
	sed -i 's/__VERSION__/$(VERSION)/g' $(PKGNAME)/DEBIAN/control
	sed -i 's/__PKGBASE__/$(PKGBASE)/g' $(PKGNAME)/DEBIAN/control
	make install -e INSTALL_ROOT=$(PKGNAME)$(INSTALL_ROOT)
	#TODO: Installed-Size: __PKGSIZE__
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
	@curl -u "$(BINTRAYAUTH)" -X PUT --data-binary "@$(PKGNAME).deb" -H "X-Bintray-Publish: 1" -H "X-Bintray-Override: 1" -H "X-Bintray-Debian-Distribution: jessie" -H "X-Bintray-Debian-Component: main" -H "X-Bintray-Debian-Architecture: $(ARCH)" 'https://bintray.com/api/v1/content/ao/opentrigger/$(PKGBASE)/$(VERSION)/pool/main/o/$(PKGNAME).deb'
	