(prefer-coding-system 'utf-8)
(modify-coding-system-alist 'file "\\.tex\\'" 'utf-8)
(modify-coding-system-alist 'file "\\.org\\'" 'utf-8)
(setq org-export-latex-coding-system 'utf-8)
(setq org-export-coding-system 'utf-8)

(load-library "iso-transl")

(add-to-list 'custom-theme-load-path "/home/jsay/.emacs.d/themes/")
(load-theme 'cyberpunk t)

(set-face-attribute 'default nil :height 150)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(blink-cursor-mode -1)

(setq split-width-threshold 150)

(setq inhibit-startup-message t)
(find-file "Main.org")

(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
)
(toggle-fullscreen)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
