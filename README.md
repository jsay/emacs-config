# Emacs configuration for Ubuntu 18.4.

Codes are in `Main.org`, other files are generated (tangled) from this main file.


# Dependencies


## Softwares (`sudo apt install`)

emacs / hunspell / r-base / texlive-file / libgmime-2.6-dev / libxapian-dev / mu (from github) / offlineimap / libssl-dev / libcurl4-openssl-dev / libxml2-dev


## Packages  (`package-install`)

Package manager configuration (open with `M-x list-packages`, choose with `i` and then `x`)

```emacs-lisp
(setq package-archives '(("gnu"      . "http://elpa.gnu.org/packages/")
                         ("marmalade". "http://marmalade-repo.org/packages/")
                         ("melpa"    . "http://melpa.org/packages/")
                         ("org"      . "http://orgmode.org/elpa/")))
(package-initialize)
```

cyber-punk theme (melpa) / org (org) / magit (elpa) / pager (marmalade) / ess (melpa) / auctex (gnu) / ox-gfm (melpa) / magithub (melpa)


# Use

Elisp code of this README file tangled (C-c C-v t) to "~/.emacs" and loaded automatically.

Other configurations made on `Main.org`, tangled to `init.el` and loaded with:

```emacs-lisp
(setq default-directory "/home/jsay/")
(load-library "~/emacs-config/init.el")
```
