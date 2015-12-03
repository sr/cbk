SOURCES = $(wildcard bin/* share/cbk/*)
VERSION = $(shell cat share/cbk/version)
CBK_DEB = cbk_$(VERSION)_all.deb
VDIRSYNCER_DEBS = \
	python-atomicwrites_0.1.8_all.deb \
	python-click_5.0.0_all.deb \
	python-click-log_0.1.1_all.deb \
	python-click-threading_0.1.2_all.deb \
	python-requests-toolbelt_0.5.0_all.deb \
	python-vdirsyncer_0.7.3_all.deb
MANPAGE_SRC = share/doc/cbk/cbk-pull.1.ronn
MANPAGE_DEST = share/man/man1/cbk-pull.1
MANPAGE_HTML_REPO = $(HOME)/src/github.com/sr/sr.github.com
MANPAGE_HTML_DEST = $(MANPAGE_HTML_REPO)/2015/cbk/cbk-pull.1.html
DEB_REPO = sr/cbk/ubuntu/wily

release: $(CBK_DEB) publish-manpage
	package_cloud push $(DEB_REPO) $(CBK_DEB)
	git tag $(VERSION) HEAD
	git push origin $(VERSION)

publish-manpage: clean-html-manpage $(MANPAGE_HTML_DEST)
	@ cd $(MANPAGE_HTML_REPO) && \
			git add $(MANPAGE_HTML_DEST) && \
			git commit -m "update cbk-pull man page" && \
			git push origin master

package-vdirsyncer: $(VDIRSYNCER_DEBS)

release-vdirsyncer: package-vdirsyncer
	package_cloud push $(DEB_REPO) $(VDIRSYNCER_DEBS)

check: checkbashisms shellcheck

clean:
	@ rm -f $(CBK_DEB) $(VDIRSYNCER_DEBS)
	@ rm -rf share/man

clean-html-manpage:
	@ rm -f $(MANPAGE_HTML_DEST)

shellcheck:
	@ shellcheck -s sh -f gcc $(SOURCES)

checkbashisms:
	@ checkbashisms -p $(SOURCES)

$(CBK_DEB): $(MANPAGE_DEST)
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
		share=/usr \
		README.md=/usr/share/doc/cbk/README.md \
		LICENSE=/usr/share/doc/cbk/LICENSE

python-%_all.deb:
	@ package="$$(printf "$@" | cut -d_ -f1 | sed s/python\-//)"; \
		version="$$(printf "$@" | cut -d_ -f2)"; \
		fpm -v "$$version" -s python -t deb \
			--deb-no-default-config-files "$$package"

$(MANPAGE_HTML_REPO):
	@ git clone https://github.com/sr/sr.github.com $@

$(MANPAGE_HTML_DEST): $(MANPAGE_SRC) $(MANPAGE_HTML_REPO)
	@ mkdir -p $(@D)
	@ ronn -5 --style=toc < $< > $@

$(MANPAGE_DEST): $(MANPAGE_SRC) share/man/man1
	@ ronn < $< > $@

share/man/man1:
	@ mkdir -p $@

.PHONY: \
	release \
	publish-manpage \
	package-vdirsyncer \
	release-vdirsyncer \
	check \
	checkbashisms \
	shellcheck \
	clean \
	clean-html-manpage
