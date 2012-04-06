##
## $Header$
##

orig_debian_dir = orig-debian
debian_dir = $(shell if [ -f $(orig_debian_dir)/changelog ]; then echo $(orig_debian_dir); else echo debian; fi)
deb_version = $(shell dpkg-parsechangelog -l$(debian_dir)/changelog | grep '^Version: ' | sed 's/^Version: //')
version = $(shell echo $(deb_version) | sed 's/-.*$$//')

deb_srcpkg_name = $(shell dpkg-parsechangelog -l$(debian_dir)/changelog | grep '^Source: ' | sed 's/^Source: //')

rel_tag = RELEASE_$(shell echo $(deb_srcpkg_name) | tr 'a-z-' 'A-Z_')_$(shell echo $(deb_version) | sed -e 's/\./_/g' -e 's/-/__/')

deb_arch = $(shell dpkg-architecture -qDEB_BUILD_ARCH)
deb_work = $(shell pwd)/deb-work
deb_src_top = $(deb_work)/$(deb_srcpkg_name)-$(version)
deb_src_files = $(shell \
	if [ x$(deb_version) != x$(version) ]; then echo \
		$(deb_work)/$(deb_srcpkg_name)_$(deb_version).diff.gz \
		$(deb_work)/$(deb_srcpkg_name)_$(version).orig.tar.gz \
		; \
	else \
		echo $(deb_work)/$(deb_srcpkg_name)_$(deb_version).tar.gz; \
	fi) \
	$(deb_work)/$(deb_srcpkg_name)_$(deb_version).dsc

dist = 

control = $(shell if [ -r $(debian_dir)/control ]; then echo $(debian_dir)/control; elif [ x != "x$(dist)" -a -r $(debian_dir)/control.$(dist) ]; then echo $(debian_dir)/control.$(dist); else echo ''; fi)
deb_pkg_name_list = $(shell grep '^Package: ' $(control) | sed 's/^Package: //')

deb_dist_list = \
	deb-dist-as-sid \
	deb-dist-as-wheezy \
	deb-dist-as-squeeze \
	deb-dist-as-lenny

maint_scripts = 

omit_list = 

all install clean::

info:
	@echo "deb_version = $(deb_version)"
	@echo "deb_srcpkg_name = $(deb_srcpkg_name)"
	@echo "rel_tag = $(rel_tag)"
	@echo "deb_src_top = $(deb_src_top)"
	@echo "deb_src_files = $(deb_src_files)"
	@echo "deb_old_src_pat = $(deb_old_src_pat)"
	@echo "omit_list = '$(omit_list)'"

deb-tree:: deb-clean
	mkdir -p $(deb_src_top)

debian-dir:: deb-tree
	if [ x$(deb_version) != x$(version) ]; then \
		(cd $(deb_work) && tar zcvf $(deb_srcpkg_name)_$(version).orig.tar.gz $(deb_srcpkg_name)-$(version)); \
	fi
	rsync -av orig-debian $(deb_src_top)/. ; mv $(deb_src_top)/orig-debian $(deb_src_top)/debian
	(cd $(deb_src_top) && \
	if [ ! -r debian/control ]; then \
		if [ x != "x$(dist)" ]; then \
			if [ -r debian/control.$(dist) ]; then \
				cp -a debian/control.$(dist) debian/control; \
			else \
				echo 'ERROR: debian/control of target dist not found'; \
				false; \
			fi; \
		else \
			echo 'ERROR: dist not specified'; \
			false; \
		fi; \
	fi)

deb-src: debian-dir
	(cd $(deb_work) && dpkg-source -b $(deb_srcpkg_name)-$(version))

dpkg:
	make PMKD=.. deb-src
	(cd $(deb_src_top) && debuild -uc -us)

pbuild: deb-src
	sudo pbuilder-md --build $(deb_work)/$(deb_srcpkg_name)_$(deb_version).dsc

deb-clean:
	rm -fr $(deb_work)

$(deb_dist_list):
	dist=$(shell echo $@ | sed 's/^deb-dist-as-//'); \
	make deb-dist dist=$${dist}

dist: deb-src-dist $(deb_dist_list)

release: deb-clean
	cvs commit
	cvs update -dP
	cvs tag -d $(rel_tag)
	cvs tag $(rel_tag)
	make dpkg

##
## end of $Source$
##
