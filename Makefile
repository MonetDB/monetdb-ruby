VERSION = 1.2

monetdb-sql-$(VERSION).gem: monetdb-sql.gemspec \
		lib/MonetDB.rb lib/MonetDBConnection.rb \
		lib/MonetDBData.rb lib/MonetDBExceptions.rb lib/hasher.rb
	gem build $<

.PHONY: clean
clean:
	rm -f *.gem
	rm -f *.rpm

.PHONY: srpm
srpm: rubygem-monetdb-sql.spec monetdb-sql-$(VERSION).gem
	mkdir -p rpmbuild/RPMS
	mkdir -p rpmbuild/SRPMS
	mkdir -p rpmbuild/BUILD
	mkdir -p rpmbuild/SOURCES
	cp monetdb-sql-$(VERSION).gem rpmbuild/SOURCES
	rpmbuild --define="_topdir $$PWD/rpmbuild" --define='_tmppath /tmp' --define='tmpdir %{_tmppath}' --define='dist %{?dummymacro}' -bs $<
	mv rpmbuild/SRPMS/*.src.rpm .
	rm -rf rpmbuild

.PHONY: rpm
rpm: rubygem-monetdb-sql.spec monetdb-sql-$(VERSION).gem
	mkdir -p rpmbuild/RPMS
	mkdir -p rpmbuild/SRPMS
	mkdir -p rpmbuild/BUILD
	mkdir -p rpmbuild/SOURCES
	cp monetdb-sql-$(VERSION).gem rpmbuild/SOURCES
	rpmbuild --define="_topdir $$PWD/rpmbuild" --define='_tmppath /tmp' --define='tmpdir %{_tmppath}' --define='dist %{?dummymacro}' -ba $<
	mv rpmbuild/RPMS/noarch/*.noarch.rpm .
	mv rpmbuild/SRPMS/*.src.rpm .
	rm -rf rpmbuild

.PHONY: deb
deb: monetdb-sql-$(VERSION).gem debian/changelog debian/control debian/rules \
		debian/copyright debian/source/format debian/compat
	pdebuild --use-pdebuild-internal

.PHONY: tar
tar:
	hg archive rubygem-monetdb-$(VERSION).tar.bz2
