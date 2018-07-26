(prefer-coding-system 'utf-8)
(modify-coding-system-alist 'file "\\.tex\\'" 'utf-8)
(modify-coding-system-alist 'file "\\.org\\'" 'utf-8)
(setq org-export-latex-coding-system 'utf-8)
(setq org-export-coding-system 'utf-8)

(load-library "iso-transl")

(add-to-list 'custom-theme-load-path "/home/jsay/.emacs.d/themes/")
(load-theme 'cyberpunk t)

  (set-face-attribute 'default nil :height 175)

  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  (blink-cursor-mode -1)

  (setq split-width-threshold 175)

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

  (delete-selection-mode t)
  (fset 'yes-or-no-p 'y-or-n-p)

  (require 'pager)
  (global-set-key [next]     'pager-page-down)
  (global-set-key [prior]    'pager-page-up)

(global-unset-key "\M-r")
(global-set-key "\M-r" 'replace-string)

(global-set-key [f2] 'split-window-horizontally)

  (defvar LIMIT 1)
  (defvar time 0)
  (defvar mylist nil)
  (defun time-now ()
    (car (cdr (current-time))))
  (defun bubble-buffer ()
    (interactive)
    (if (or (> (- (time-now) time) LIMIT) (null mylist))
        (progn (setq mylist (copy-alist (buffer-list)))
               (delq (get-buffer " *Minibuf-0*") mylist)
               (delq (get-buffer " *Minibuf-1*") mylist)))
    (bury-buffer (car mylist))
    (setq mylist (cdr mylist))
    (setq newtop (car mylist))
    (switch-to-buffer (car mylist))
    (setq rest (cdr (copy-alist mylist)))
    (while rest
      (bury-buffer (car rest))
      (setq rest (cdr rest)))
    (setq time (time-now)))
  (global-set-key [f4] 'bubble-buffer)

(defvar my-latest-killed-buffer)
(defun my-kill-buffer()
  "Kill current buffer without confirmation"
  (interactive)
  (setq my-latest-killed-buffer (buffer-file-name))
  (kill-buffer (buffer-name))
  (delete-window)
)
(defun my-unkill-buffer()
  "Undo the latest buffer kill"
  (interactive)
  (find-file my-latest-killed-buffer)
)
(global-set-key [f5] 'my-kill-buffer)
(global-set-key [S-f5] 'my-unkill-buffer)

(autoload 'linum-mode "linum"
  "toggle line numbers on/off" t)
(global-set-key [f11] 'linum-mode)
(eval-after-load "linum"
  '(set-face-attribute 'linum nil :height 150))

(global-set-key [f12] 'other-window)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

  (setq make-backup-files nil)

;(global-unset-key [mouse-2])

 (setq-default ispell-program-name "hunspell")
 (setq ispell-dictionary "american"
       ispell-extra-args '() ;; TeX mode "-t"
       ispell-silently-savep t)
 (setq flyspell-mode-map nil)
 (add-hook 'ispell-initialize-spellchecker-hook
	   (lambda ()
	     (setq ispell-base-dicts-override-alist
		   '((nil ; default
		      "[A-Za-z]" "[^A-Za-z]" "[']" t
		      ("-d" "en_GB" "-i" "utf-8") utf-8)
		     ("american" ; Yankee English
		      "[A-Za-z]" "[^A-Za-z]" "[']" t
		      ("-d" "en_US" "-i" "utf-8") nil utf-8)
		     ("british" ; British English
		      "[A-Za-z]" "[^A-Za-z]" "[']" t
		      ("-d" "en_GB" "-i" "utf-8") nil utf-8)
		     ("francais" ; Francais
		      "[A-Za-z]" "[^A-Za-z]" "[']" t
		      ("-d" "fr_FR" "-i" "utf-8") nil utf-8)))))

   (global-set-key (kbd "C-c F")
		(lambda() (interactive)
                  (ispell-change-dictionary "francais")
                  (flyspell-buffer)))
   (global-set-key (kbd "C-c E")
		(lambda() (interactive)
                  (ispell-change-dictionary "english")
                  (flyspell-buffer)))

 (put 'LaTeX-mode 'flyspell-mode-predicate 'auctex-mode-flyspell-skip-myenv)
 (defun auctex-mode-flyspell-skip-myenv ()
   (save-excursion
     (widen)
     (let ((p (point))
           (count 0))
       (not (or (and (re-search-backward "\\\\begin{\\(equation\\|align\\|equation*\\)}" nil t)
                     (> p (point))
                     (or (not (re-search-forward "^\\\\end{\\(equation\\|align\\|equation*\\)}" nil t))
                         (< p (point))))
		(eq 1 (progn (while (re-search-backward "`" (line-beginning-position) t)
                               (setq count (1+ count)))
                             (- count (* 2 (/ count 2)))))))))
   )
 (add-hook 'LaTeX-mode-hook (lambda () (setq flyspell-generic-check-word-predicate 
                         'auctex-mode-flyspell-skip-myenv)))

 (add-hook 'org-mode-hook
   (lambda()
     (flyspell-mode 1)))
 (defun my-org-switch-language ()
     "Switch language if a `#+LANGUAGE:' Org meta-tag is on top 8 lines."
     (save-excursion
       (goto-line (1+ 8))
       (let (lang
             (dico-alist '(("nil". nil)
			   ("fr" . "francais")
                           ("en" . "american"))))
         (when (re-search-backward "#\\+LANGUAGE: +\\([[:alpha:]_]*\\)" 1 t)
           (setq lang (match-string 1))
           (ispell-change-dictionary (cdr (assoc lang dico-alist)))))))
   (add-hook 'org-mode-hook 'my-org-switch-language)

 (put 'LaTeX-mode 'flyspell-mode-predicate 'auctex-mode-flyspell-skip-myenv)
 (defun auctex-mode-flyspell-skip-myenv ()
   (save-excursion
     (widen)
     (let ((p (point))
           (count 0))
       (not (or (and (re-search-backward "\\\\begin{\\(equation\\|align\\|equation*\\)}" nil t)
                     (> p (point))
                     (or (not (re-search-forward "^\\\\end{\\(equation\\|align\\|equation*\\)}" nil t))
                         (< p (point))))
		(eq 1 (progn (while (re-search-backward "`" (line-beginning-position) t)
                               (setq count (1+ count)))
                             (- count (* 2 (/ count 2)))))))))
   )
 (add-hook 'LaTeX-mode-hook (lambda () (setq flyspell-generic-check-word-predicate 
                         'auctex-mode-flyspell-skip-myenv)))

(require 'org-checklist)

(setq org-export-allow-BIND t)

  (setq org-src-fontify-natively t)

(setq require-final-newline t)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key "\C-p" 'outline-previous-visible-heading)
(global-set-key "\C-n" 'outline-next-visible-heading)

(global-set-key (kbd "s-k") (lambda () (interactive) (org-export-dispatch "l")))

(require 'ox-gfm)(eval-after-load "org"
  '(require 'ox-gfm nil t))

(setq org-agenda-files '("~/Main.org"))

  (setq calendar-day-name-array
	["Dimanche" "Lundi" "Mardi"
	 "Mercredi" "Jeudi" "Vendredi" "Samedi"])
  (setq calendar-month-name-array
	["janvier" "février" "mars" "avril" "mai" "juin" "juillet"
	 "août" "septembre" "octobre""novembre" "décembre"])
  (setq-default system-time-locale "fr")

(setq org-return-follows-link t)

(add-hook 'org-mode-hook
      '(lambda ()
         (delete '("\\.pdf\\'" . default) org-file-apps)
         (add-to-list 'org-file-apps '("\\.pdf\\'" . "evince %s"))))

(setq org-loop-over-headlines-in-active-region t)
(add-hook 'org-mode-hook 'turn-on-font-lock)

 (setq org-confirm-babel-evaluate nil)

   (require 'ob-css)
   (require 'ob-latex)
   (require 'ob-R)
   (require 'ob-sh)
   (require 'ob-python)
   (require 'ob-maxima)
 (org-babel-do-load-languages
  'org-babel-load-languages
  '((R          . t)
    (emacs-lisp . nil)
    (latex      . t)
    ))

 (eval-after-load 'org
   '(progn
      (add-to-list 'org-structure-template-alist
		   '("e" "#+begin_src emacs-lisp \n?\n#+end_src\n"))
      (add-to-list 'org-structure-template-alist
		   '("g" "#+Name: Lst:\n#+Header: :width 7 :height 7
#+begin_src R :results graphics :file \"Figures/?.pdf\"\n\n#+end_src\n
#+Name: Fig:\n#+ATTR_LaTeX: :options scale= .5\n#+Caption: \n#+RESULTS: Lst:"))
      (add-to-list 'org-structure-template-alist
		   '("i" "#+begin_src R :results silent\n?\n#+end_src\n"))
      (add-to-list 'org-structure-template-alist
		   '("x" "#+begin_src R :results output exemple\n?\n#+end_src\n"))
      (add-to-list 'org-structure-template-alist
		   '("t" "#+begin_src R :results value exemple :rownames yes :colnames yes
 \n#+end_src\n\n#+ATTR_LaTeX: :placement [htb]\\small\n#+Caption: ?\n#+RESULTS:"))))

 (setq org-eval-blocks-without-name
       '(lambda() (interactive)
          (backward-paragraph) (previous-line) (org-end-of-line)
	  (insert " :eval yes") (org-babel-execute-src-block)
	  (backward-kill-word 2) (org-delete-backward-char 2))
 )
 (global-set-key (kbd "C-c y") org-eval-blocks-without-name)

 (setq org-latex-listings 'listings)

   (setq org-capture-templates
	 '(("t" "Agenda"
	    entry (file+headline  "~/Main.org" "AGENDA")
				  "* TODO %?\n\n")))

   (add-to-list 'org-capture-templates 
		'("b" "Biblio" entry 
                  (file+headline "/media/HD/Biblio/Biblio.org" "Refile")
 "*** %^{BibKey} : [[/media/HD/Biblio/citations/%\\1.bib]]\n
    - %?\n\n   [[/media/HD/Biblio/papiers/%\\1.pdf]], le %U\n
 #+NAME: Cite-%\\1\n#+BEGIN_SRC sh :tangle no :exports none
     cat /media/HD/Biblio/citations/%\\1.bib\n#+END_SRC\n
 #+begin_src bibtex :tangle ./Biblio.bib :noweb yes\n<<Cite-%\\1()>>\n#+end_src\n"))
    (global-set-key (kbd "s-b")
    (lambda () (interactive) (org-capture nil "b")))

(setq-default inferior-R-args "--no-restore-history --no-save")
(add-hook 'ess-R-post-run-hook
          (lambda () (set-buffer-process-coding-system 'utf-8 'utf-8)))

(setq comint-input-ring-size 1000)
(setq ess-indent-level 4)
(setq ess-arg-function-offset 4)
(setq ess-else-offset 4)

(global-set-key [C-tab] 'dabbrev-expand)
; following do not work
;(require 'auto-complete)
;(add-to-list 'ac-dictionary-directories "/usr/share/auto-complete/dict/")
;(require 'auto-complete-config)
;(ac-config-default)
(setq ess-use-auto-complete t)

(add-hook 'inferior-ess-mode-hook
    '(lambda nil
          (define-key inferior-ess-mode-map [\C-up]
              'comint-previous-matching-input-from-input)
          (define-key inferior-ess-mode-map [\C-down]
              'comint-next-matching-input-from-input)
          (define-key inferior-ess-mode-map [\C-x \t]
              'comint-dynamic-complete-filename)))

(setq ess-nuke-trailing-whitespace-p t)

(require 'tex-site)

(setq TeX-auto-save t)
(setq TeX-electric-sub-and-superscript t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)

(list "Clean" "del %s.aux %s.log %s.out %s.toc %s.bbl %s.blg" 'TeX-run-command nil t)
(setq TeX-PDF-mode t)
(setq-default TeX-master t)
(setq TeX-command-force "")
(add-hook 'LaTeX-mode-hook
          '(lambda()
             (define-key LaTeX-mode-map "\C-c\C-a"
               (lambda (arg) (interactive "P")
                 (let ((TeX-command-force nil))
                   (TeX-command-master arg))))))

(global-set-key [M-n] 'TeX-next-error)

(global-set-key (kbd "\C-c t") 'align-current)

(global-set-key (kbd "C-x g") 'magit-status)

(autoload 'helm-bibtex "helm-bibtex" "" t)
; (require 'ox-bibtex)

(require 'reftex)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(autoload 'reftex-mode     "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex  "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make citation" nil)
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase mode" t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)   ; with Emacs latex mode

(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
(setq reftex-plug-into-AUCTeX t)

(defun org-mode-reftex-setup ()
  (load-library "reftex") 
  (and (buffer-file-name)
  (file-exists-p (buffer-file-name))
  (reftex-parse-all))
  (define-key org-mode-map (kbd "C-c (") 'reftex-citation))
(add-hook 'org-mode-hook 'org-mode-reftex-setup)

(setq reftex-cite-format
      '(
        (?\C-m . "\\cite[]{%l}")
        (?t . "\\textcite{%l}")
        (?a . "\\autocite[]{%l}")
        (?p . "\\parencite{%l}")
        (?f . "\\footcite[][]{%l}")
        (?F . "\\fullcite[]{%l}")
        (?x . "[]{%l}")
        (?X . "{%l}")
        ))

(setq font-latex-match-reference-keywords
      '(("cite" "[{")
        ("cites" "[{}]")
        ("footcite" "[{")
        ("footcites" "[{")
        ("parencite" "[{")
        ("textcite" "[{")
        ("fullcite" "[{") 
        ("citetitle" "[{") 
        ("citetitles" "[{") 
        ("headlessfullcite" "[{")))
(setq reftex-cite-prompt-optional-args nil)
(setq reftex-cite-cleanup-optional-args t)

(require 'org-bibtex)
(defun my-location-bib (type)
  "If there is completion support for link type TYPE, offer it."
  (let ((fun (intern (concat "org-" type "-complete-link"))))
    (if (functionp fun)
	(funcall fun)
      (read-string "Link (no completion support): " (concat type ":")))))

(org-add-link-type                       
 "ref"
 (lambda (key)
   (org-open-file cby-references-file t nil key))
 (lambda (path desc format)
   (cond
    ((eq format 'html)
     (let* ((postnote (cby-org-link-get-postnote desc))
            (prenote (cby-org-link-get-prenote desc)))
       (cond
        ((and postnote)
     (format "<a href= \"#%s\">%s</a>" path postnote)))))
    ((eq format 'latex)
     (let* ((postnote (cby-org-link-get-postnote desc))
            (prenote (cby-org-link-get-prenote desc)))
       (cond
        ((and prenote)
	  (format "\\cite%s{%s}" prenote path))
	 (t
	  (format "\\cite{%s}" path))))))))

(defun cby-org-link-get-prenote (desc)
     "Extract prenote from org-mode link description. Prenote
      starts at the first '(' and ends at first ','."
     (let ((prenote (cadr (split-string desc "[\",]"))))
       (if prenote
           (copy-sequence
            ;; clean string
            (replace-regexp-in-string "[ \t\n]" "" prenote)))))
(defun cby-org-link-get-postnote (desc)
     "Extract postnote from org-mode link description. Postnote
      starts at last ',' and ends at last ')'."
     (let ((postnote (cadr (split-string desc "[,]"))))
       (if postnote
           (copy-sequence
            ;; clean string
            (replace-regexp-in-string "[ \t\n]" "" postnote)))))

(setq org-odt-data-dir nil)
(setq org-html-coding-system 'utf-8-unix)
(require 'ox-beamer)
(add-to-list 'org-export-backends 'beamer)

(setq org-export-allow-bind-keywords t)
;(setq org-export-in-background t)

 (add-to-list 'org-emphasis-alist '("¤" bold))

   (defun my-latex-fixed-width-filter (fixed-width backend info)
       (replace-regexp-in-string
	"\\(begin\\|end\\){\\(verbatim\\)}"
	"something" fixed-width nil nil 2))
   (add-to-list 'org-export-filter-fixed-width-functions
		'my-latex-fixed-width-filter)

 (defun my-export-delete-headlines-tagged-noheading (backend)
   (dolist (hl (nreverse (org-element-map 
			     (org-element-parse-buffer 'headline)
			                               'headline
			                               'identity)))
     (when (member "noheading" (org-element-property :tags hl))
       (goto-char (org-element-property :begin hl))
       (delete-region (point) (progn (forward-line) (point))))))
 (add-to-list 'org-export-before-processing-hook
	      'my-export-delete-headlines-tagged-noheading)
 ;; (defun as/delete-ignored-heading (backend)
 ;;       "Remove every headline with a tag `ignoreheading' in the
 ;;     current buffer. BACKEND is the export back-end being used, as
 ;;     a symbol."
 ;;       (org-map-entries
 ;;        (lambda () (delete-region (point) (progn (forward-line) (point))))
 ;;        "+ignoreheading"))
 ;; AN ALTERNATIVE WITH NOHEAD
 ;; (defun my-ignore-headline (contents backend info)
 ;;   "Ignore headlines with tag `nohead'."
 ;;   (when (and (org-export-derived-backend-p backend 'latex 'html 'ascii)
 ;; 	     (string-match "\\`.*nohead.*\n"
 ;; 			   (downcase contents)))
 ;;     (replace-match "" nil nil contents)))
 ;; (add-to-list 'org-export-filter-headline-functions 'my-ignore-headline)

 (defun ngz-latex-filter-nobreaks (text backend info)
   "Ensure \"_\" are properly handled in Beamer/LaTeX export."
   (when (memq backend '(beamer latex))
     (replace-regexp-in-string " " "~" text)))
 (add-to-list 'org-export-filter-plain-text-functions
	      'ngz-latex-filter-nobreaks)

 ;; DROP THE USELESS LATEX FILES
 (list "Clean" "del %s.bbl %s.blg %s.aux %s.blg %s.out" 'org-latex-pdf-process nil t)
 ;; DEFINE THE PROCESS OF COMPILATION
 (setq org-latex-pdf-process 
       '("pdflatex %b" "bibtex %b" "pdflatex %b" "pdflatex %b" "Clean"))
 ;(setq org-latex-hyperref-format "\\ref{%s}")
 (setq org-latex-toc-command
       "\\begin{spacing}{1}\n \\tableofcontents\n\\end{spacing}\n\\clearpage")
 ;; IMPORTANT FOR THE BABEL CODE BETWEEN BUFFERS
 (setq org-src-preserve-indentation t)

 (setq org-export-html-style
  "<style type=\"text/css\">
     <!--/*--><![CDATA[/*><!--*/
       .src             { background-color: #F5FFF5; position: relative; overflow: visible; }
       .src:before      { position: absolute; top: -15px; background: #ffffff; padding: 1px; border: 1px solid #000000; font-size: small; }
       .src-sh:before   { content: 'sh'; }
       .src-bash:before { content: 'sh'; }
       .src-R:before    { content: 'R'; }
       .src-perl:before { content: 'Perl'; }
       .src-sql:before  { content: 'SQL'; }
       .example         { background-color: #FFF5F5; }
     /*]]>*/-->
  </style>")
