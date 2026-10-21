EMACS   ?= emacs
NAME    := candy-theme
VERSION := 0.2.0
FILES   := candy-common.el base16-candy-theme.el base16-candy-flip-theme.el

# where `make install` copies the theme files
PREFIX ?= $(HOME)/.emacs.d/themes
# package.el directory for `make install-elpa`
PACKAGE_USER_DIR ?= $(HOME)/.emacs.d/elpa
# directory holding base16-theme.el; empty means use the one package.el installed
BASE16_DIR ?=

ifeq ($(BASE16_DIR),)
LOADPATH := --eval "(setq package-user-dir (expand-file-name \"$(PACKAGE_USER_DIR)\"))" -f package-initialize
else
LOADPATH := -L $(BASE16_DIR)
endif

DIST := dist/$(NAME)-$(VERSION)

.PHONY: check install package install-elpa clean

check:
	$(EMACS) -Q --batch $(LOADPATH) -L . \
	  --eval "(setq byte-compile-error-on-warn t)" \
	  -f batch-byte-compile $(FILES)
	$(EMACS) -Q --batch $(LOADPATH) -L . \
	  --eval "(add-to-list 'custom-theme-load-path default-directory)" \
	  --eval "(load-theme 'base16-candy t)" \
	  --eval "(load-theme 'base16-candy-flip t)" \
	  --eval "(message \"both themes load\")"
	rm -f *.elc

install:
	install -d "$(PREFIX)"
	install -m 644 $(FILES) "$(PREFIX)"

package: $(DIST).tar

$(DIST).tar: $(FILES) $(NAME)-pkg.el README.md LICENSE
	rm -rf $(DIST)
	mkdir -p $(DIST)
	cp $^ $(DIST)/
	tar -cf $@ -C dist $(NAME)-$(VERSION)
	rm -rf $(DIST)

install-elpa: package
	$(EMACS) -Q --batch \
	  --eval "(setq package-user-dir (expand-file-name \"$(PACKAGE_USER_DIR)\"))" \
	  --eval "(require 'package)" \
	  --eval "(add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t)" \
	  -f package-initialize \
	  --eval "(unless (package-installed-p 'base16-theme) (package-refresh-contents))" \
	  --eval "(package-install-file (expand-file-name \"$(DIST).tar\"))"

clean:
	rm -rf dist *.elc
