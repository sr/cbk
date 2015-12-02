SOURCES = $(wildcard bin/* share/cbk/*)
VERSION = $(shell cat share/cbk/version)
VDIRSYNCER_DEBS = \
	python-atomicwrites_0.1.8_all.deb \
	python-click_5.0.0_all.deb \
	python-click-log_0.1.1_all.deb \
	python-click-threading_0.1.2_all.deb \
	python-requests-toolbelt_0.5.0_all.deb \
	python-vdirsyncer_0.7.3_all.deb
DEB_REPO = sr/cbk/ubuntu/wily

release: package
	package_cloud push $(DEB_REPO) cbk_$(VERSION)_all.deb

package: cbk_$(VERSION)_all.deb

package-vdirsyncer: $(VDIRSYNCER_DEBS)

release-vdirsyncer: package-vdirsyncer
	package_cloud push $(DEB_REPO) $(VDIRSYNCER_DEBS)

check: checkbashisms shellcheck

clean:
	@ rm -f cbk*.deb $(VDIRSYNCER_DEBS)

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
		-d "python-vdirsyncer = 0.7.3" \
		-d "rsync >= 3.1.0" \
		-d "sed >= 4.2.2" \
		-d "youtube-dl >= 2015.11.24" \
		--exclude .git \
		--deb-priority "extra" \
		--config-files "etc/cbk.conf" \
		--deb-no-default-config-files \
		bin/cbk-pull=/usr/bin/cbk-pull \
		etc/cbk.conf=/etc/cbk.conf \
		share/cbk=/usr/share

python-%_all.deb:
	@ package="$$(printf "$@" | cut -d_ -f1 | sed s/python\-//)"; \
		version="$$(printf "$@" | cut -d_ -f2)"; \
		fpm -v "$$version" -s python -t deb "$$package" \
			--deb-no-default-config-files

.PHONY: \
	package \
	release \
	package-vdirsyncer \
	release-vdirsyncer \
	check \
	checkbashisms \
	shellcheck \
	clean
