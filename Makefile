NAME=vmtools-check
SPEC_FILE=SPECS/$(NAME).spec

RPMBUILD := $(shell if test -f /usr/bin/rpmbuild ; then echo /usr/bin/rpmbuild ; else echo "x" ; fi)

RPM_DEFINES =   --define "_specdir $(shell pwd)/SPECS" --define "_rpmdir $(shell pwd)/RPMS" --define "_sourcedir $(shell pwd)/SOURCES" --define  "_srcrpmdir $(shell pwd)/SRPMS" --define "_builddir $(shell pwd)/BUILD"

MAKE_DIRS= $(shell pwd)/SPECS $(shell pwd)/SOURCES $(shell pwd)/BUILD $(shell pwd)/SRPMS $(shell pwd)/RPMS

OLD_VERSION=$(shell grep ^Version $(SPEC_FILE) | awk -F: '{print $$NF}')
VERSION=$(shell date +"%Y%m%d")
PKGDIR=$(NAME)-$(VERSION)
TARBALL=$(PKGDIR).tar.gz
EXCLUDES=--exclude ".git" --exclude ".gitignore" --exclude "$(TARBALL)" --exclude "*rpm"
.PHONEY: clean tarball

rpmcheck:
ifeq ($(RPMBUILD),x)
	$(error "rpmbuild not found, exiting...")
endif
	@mkdir -p $(MAKE_DIRS)

bumpspec:
	@sed -i "s/^Version:*$(OLD_VERSION)/Version:        $(VERSION)/" SPECS/vmtools-check.spec

tarball: bumpspec
	ln -sf SOURCES $(PKGDIR); 
	tar -p -c -v -z -h $(EXCLUDES) -f  /tmp/$(TARBALL) $(PKGDIR)
	@mv -f /tmp/$(TARBALL) .
	@rm -f $(PKGDIR) 

## use this to build an srpm locally
srpm:  rpmcheck bumpspec tarball
	@cp -f $(TARBALL) SOURCES
	@wait
	$(RPMBUILD) $(RPM_DEFINES)  -bs $(SPEC_FILE)
	@mv -f SRPMS/* .
	@rm -rf BUILD SRPMS RPMS SOURCES/$(TARBALL)

## use this to build rpm locally
rpm:   rpmcheck  bumpspec tarball
	#cp -f $(TARBALL) SOURCES
	@wait
	$(RPMBUILD) $(RPM_DEFINES) -bb  $(SPEC_FILE)
	@mv -f RPMS/noarch/* .
	@rm -f SOURCES/$(TARBALL)

clean:
	rm -rf BUILD SRPMS RPMS *.rpm *tar.gz doc 


