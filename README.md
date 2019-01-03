# Emacs configuration for Ubuntu 18.4.

Codes are in `Main.org` (with comments) other files are generated (tangled) from this main file.


# Dependencies


## Softwares (`sudo apt install`)

emacs / hunspell / r-base / texlive-file / libgmime-2.6-dev / libxapian-dev / mu (from github) / offlineimap / libssl-dev / libcurl4-openssl-dev / libxml2-dev / libgdal-dev / gnutls-bin / gnupg2 / libapparmor-dev / libpoppler-cpp-dev


## Packages  (`package-install`)

Package manager configuration (open with `M-x list-packages`, choose with `i` and then `x`)

```emacs-lisp
(setq package-archives '(("gnu"      . "http://elpa.gnu.org/packages/")
                         ("marmalade". "http://marmalade-repo.org/packages/")
                         ("melpa"    . "http://melpa.org/packages/")
                         ("org"      . "http://orgmode.org/elpa/")))
(package-initialize)
```

cyber-punk theme (melpa) / org (org) / magit (melpa) / pager (marmalade) / ess (melpa) / auctex (gnu) / ox-gfm (melpa) / magithub (melpa) / org-ref (melpa) / use-package (melpa) / moody (melpa) / tabbar (melpa)


# Use

Emacs configurations from `Main.org` tangled (C-c C-v t) to `init.el` and loaded with:

```emacs-lisp
(setq default-directory "/home/jsay/")
(load-library "~/emacs-config/init.el")
```

Elisp code of this README file &#x2013; about package manager, default directory, loaded libraries &#x2013; tangled to `~/.emacs` and loaded automatically with emacs.
