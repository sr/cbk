SOURCES = $(wildcard bin/* share/cbk/*)
VERSION = $(shell $(shell pwd)/bin/cbk-pull --version | cut -d' ' -f3)

release: package
	package_cloud push sr/utils/ubuntu/trusty cbk_$(VERSION)_all.deb
	package_cloud push sr/utils/ubuntu/wily cbk_$(VERSION)_all.deb

package: cbk_$(VERSION)_all.deb

check: checkbashisms shellcheck

clean:
	@ rm -f cbk*.deb

shellcheck:
	@ shellcheck -s sh -f gcc $(SOURCES)

checkbashisms:
	@ checkbashisms -p $(SOURCES)

cbk_$(VERSION)_all.deb:
	@ fpm \
		-s dir \
		-n cbk \
		-t deb \
		--version "$(VERSION)" \
		--maintainer "Simon Rozet <me@simonrozet.com>" \
		--license "MIT" \
		--category "utils" \
		--architecture "all" \
		--url "https://github.com/sr/cbk" \
		-d "curl" \
		-d "coreutils >= 8.21" \
		-d "git >= 1.9.1" \
		-d "offlineimap >= 6.5.4" \
		-d "rsync >= 3.1.0" \
		-d "sed >= 4.2.2" \
		-d "youtube-dl >= 2015.11.10" \
		--exclude .git \
		--deb-priority "extra" \
		bin/cbk-pull=/usr/bin/cbk-pull \
		share/cbk=/usr/share

.PHONY: \
	package \
	release \
	check \
	checkbashisms \
	shellcheck \
	clean
