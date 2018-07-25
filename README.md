
# Presentation

Emacs configuration in `init.el` tangled (C-c C-v t) from
`Main.org`, work on Ubuntu 18.4.


# Dependencies

Softwares (`sudo apt install`)

emacs / hunspell / r-base / texlive-file

emacs packages from manager, configuration:

    (setq default-directory "/home/jsay/")
    (setq load-path (cons "~/emacs-config/" load-path))
    (setq package-archives '(("gnu"      . "http://elpa.gnu.org/packages/")
    			 ("marmalade". "http://marmalade-repo.org/packages/")
    			 ("melpa"    . "http://melpa.org/packages/")
    			 ("org"      . "http://orgmode.org/elpa/")))
    (package-initialize)
    (load-library "~/emacs-config/init.el")

(load with `M-x list-packages`, choose with `i` and then `x`.

cyber-punk theme (melpa) / org (org) / magit (elpa) / pager
(marmalade) / ess (melpa) / auctex (gnu) / ox-gfm (melpa)

