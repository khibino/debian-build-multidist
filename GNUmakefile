##
## $Header$
##

include pkg.GNUmakefile

libsubdir=pbuilder/multidist

deb-tree::
	rsync -av \
		GNUmakefile pkg.GNUmakefile \
		*.sh *.sh.in *.8.in \
		$(deb_src_top)/.

all:: mbuilder.sh cowbuilder-md.8 pbuilder-md.8

mbuilder.sh: mbuilder.sh.in
	./vexpand.sh < $< > $@
	chmod a+x $@

cowbuilder-md.8: mbuilder.8.in
	./bexpand.sh cowbuilder < $< > $@

pbuilder-md.8: mbuilder.8.in
	./bexpand.sh pbuilder < $< > $@

clean::
	rm -f mbuilder.sh
	rm -f cowbuilder-md.8 pbuilder-md.8

check:: all
	bash -n ./mbuilder.sh
	sh -n ./post-create-hook.sh

install:: check
	install -m 755 mbuilder.sh $(DESTDIR)/usr/lib/$(libsubdir)/
	install -m 755 post-create-hook.sh $(DESTDIR)/usr/lib/$(libsubdir)/
	ln -s '../lib/$(libsubdir)/mbuilder.sh' $(DESTDIR)/usr/sbin/pbuilder-md
	ln -s '../lib/$(libsubdir)/mbuilder.sh' $(DESTDIR)/usr/sbin/cowbuilder-md

##
## end of $Source$
##
