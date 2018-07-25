# Emacs configuration for Ubuntu 18.4.


# Dependencies


## Softwares (`sudo apt install`)

emacs / hunspell / r-base / texlive-file


## Packages  (`package-install`)

Package manager configuration (open with `M-x list-packages`, choose with `i` and then `x`)

```emacs-lisp
(setq package-archives '(("gnu"      . "http://elpa.gnu.org/packages/")
			 ("marmalade". "http://marmalade-repo.org/packages/")
			 ("melpa"    . "http://melpa.org/packages/")
			 ("org"      . "http://orgmode.org/elpa/")))
(package-initialize)
```

cyber-punk theme (melpa) / org (org) / magit (elpa) / pager (marmalade) / ess (melpa) / auctex (gnu) / ox-gfm (melpa)


# Use

Elisp code from this README are tangled (C-c C-v t) to "~/.emacs" to be loaded automatically.

Other configurations are made on `Main.org`, tangled to `init.el` and loaded as follows:

```emacs-lisp
(setq default-directory "/home/jsay/")
(load-library "~/emacs-config/init.el")
```