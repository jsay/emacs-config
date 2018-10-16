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

(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg) (set-face-foreground 'mode-line fg))
                               orig-fg))))

  (delete-selection-mode t)
  (fset 'yes-or-no-p 'y-or-n-p)

  (require 'pager)
  (global-set-key [next]     'pager-page-down)
  (global-set-key [prior]    'pager-page-up)

(global-unset-key "\M-r")
(global-set-key "\M-r" 'replace-string)

(global-set-key [f2] 'split-window-horizontally)
(setq split-width-threshold 120)

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

(global-set-key (kbd "C-x C-b") 'buffer-menu-other-window)

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

(global-unset-key [mouse-2])

 (setq-default ispell-program-name "hunspell")
 (setq ispell-dictionary "francais"
       ispell-extra-args '() ;; TeX mode "-t"
       ispell-silently-savep t)
 (setq flyspell-mode-map nil)
 (add-hook 'ispell-initialize-spellchecker-hook
	   (lambda ()
	     (setq ispell-base-dicts-override-alist
		   '((nil ; default
		      "[A-Za-z]" "[^A-Za-z]" "[']" t
		      ("-d" "fr_FR" "-i" "utf-8") utf-8)
		     ("american"
		      "[A-Za-z]" "[^A-Za-z]" "[']" t
		      ("-d" "en_US" "-i" "utf-8") nil utf-8)
		     ("british" ; British English
		      "[A-Za-z]" "[^A-Za-z]" "[']" t
		      ("-d" "en_GB" "-i" "utf-8") nil utf-8)))))

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

(put 'dired-find-alternate-file 'disabled nil)

(setq org-export-allow-BIND t)

  (setq org-src-fontify-natively t)

(setq require-final-newline t)

(setq org-tags-column 45)

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

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium-browser")

(setq org-loop-over-headlines-in-active-region t)
(add-hook 'org-mode-hook 'turn-on-font-lock)

 (setq org-confirm-babel-evaluate nil)

   (require 'ob-css)
   (require 'ob-latex)
   (require 'ob-emacs-lisp)
   (require 'ob-R)
   (require 'ob-shell)
   (require 'ob-python)
   (require 'ob-maxima)
 (org-babel-do-load-languages
  'org-babel-load-languages
  '((R          . t)
    (emacs-lisp . t)
    (latex      . t)
    (shell      . t)
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

(require 'magithub)

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

;; DROP THE USELESS LATEX FILES
;(list "Clean" "del %s.bbl %s.blg %s.aux %s.blg %s.out" 'org-latex-pdf-process nil t)
;; DEFINE THE PROCESS OF COMPILATION
;(setq org-latex-pdf-process 
 ;     '("pdflatex %b" "bibtex %b" "pdflatex %b" "pdflatex %b" "Clean"))
;(setq org-latex-hyperref-format "\\ref{%s}")
(setq org-latex-logfiles-extensions (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl")))
(setq org-latex-toc-command
      "\\begin{spacing}{1}\n \\tableofcontents\n\\end{spacing}\n\\clearpage")
;; IMPORTANT FOR THE BABEL CODE BETWEEN BUFFERS
(setq org-src-preserve-indentation t)

(setq org-latex-packages-alist nil)
(add-to-list 'org-latex-packages-alist '(""         "microtype"))
(add-to-list 'org-latex-packages-alist '(""         "graphicx" ))
(add-to-list 'org-latex-packages-alist '(""         "ragged2e" ))
(add-to-list 'org-latex-packages-alist '(""         "booktabs" ))
(add-to-list 'org-latex-packages-alist '("official" "eurosym"  ))
(add-to-list 'org-latex-packages-alist '("utf8"     "inputenc" ))
(add-to-list 'org-latex-packages-alist '(""         "paralist" )) 
(add-to-list 'org-latex-packages-alist '(""         "amstext"  t))
(add-to-list 'org-latex-packages-alist '(""         "amsmath"  t))

(setq org-entities-user nil)
(add-to-list 'org-entities-user '(("space" "\\ "  nil " " " " " " " ")))
(add-to-list 'org-entities-user '(("RLOG"  "\\texttt{\\bfseries R}" nil "R" "R" "R" "R")))

   (add-to-list 'org-latex-classes
		'("CovLetter"
                  "\\documentclass[12pt, a4paper]{article}
      \\usepackage{amsmath, amssymb, amsthm, amsfonts}
      \\usepackage{graphicx, color, natbib, url, setspace}
      \\usepackage[left=1in, right=1in, top=1in, bottom=0.75in, includefoot,
                   headheight=13.6pt]{geometry}
      \\usepackage[adobe-utopia]{mathdesign}
                   [NO-PACKAGES]
      \\parindent 20pt \\parskip 1ex
      \\usepackage[colorlinks, pdfstartview= FitH, urlcolor= blue]{hyperref}"
                      ("\\subsubsection*{%s}"   . "\\subsubsection*{%s}")
                      ("\\par"             . "")))

   (add-to-list 'org-latex-classes
		'("ManueBibt"
                  "\\documentclass[12pt]{article}
                  [NO-DEFAULT-PACKAGES]
                  [PACKAGES]
                  [EXTRA]
 \\usepackage[sf]{titlesec} \\usepackage{natbib}
 \\parindent 20pt \\parskip 1ex
 %\\usepackage[colorlinks, pdfstartview= FitH, urlcolor= blue, bookmarksdepth= 1]{hyperref}
 \\usepackage[left= 1in, right=  1in, top=  1in, bottom= 1in]{geometry}
                  \\usepackage{ascii, mathptmx, listings, xcolor, setspace}
                  \\let\\itemize\\compactitem
                  \\let\\description\\compactdesc
                  \\let\\enumerate\\compactenum
 \\lstset{backgroundcolor= \\color[gray]{.85}, basicstyle= \\small\\ttfamily,
          breaklines= true, keywordstyle= \\color{red!75}, columns= fullflexible}
 \\lstdefinelanguage{bibtex}{keywords={@article, @book, @collectedbook,
       @conference, @electronic, @ieeetranbstctl, @inbook, @incollectedbook,
       @incollection, @injournal, @inproceedings, @manual, @mastersthesis,
       @misc, @patent, @periodical, @phdthesis, @preamble, @proceedings, @standard,
       @string, @techreport, @unpublished}, comment=[l][\\itshape]{@comment}, sensitive=false}"
                  ("\\section{%s}"       . "\\section*{%s}")
                  ("\\subsection{%s}"    . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))

 (add-to-list 'org-latex-classes
      '("ManueLisp"
	"\\documentclass[12pt]{article}
         [NO-DEFAULT-PACKAGES]
         [PACKAGES]
         [EXTRA]
  \\usepackage[T1]{fontenc}
  \\usepackage[colorlinks, pdfstartview= FitH, urlcolor= blue]{hyperref}
  \\usepackage[left= 1in, right=  1in, top=  1in, bottom= 1in]{geometry}
  \\usepackage{fourier, ascii, listings, setspace, color, natbib}
  \\let\\itemize\\compactitem 
	\\let\\description\\compactdesc \\let\\enumerate\\compactenum
  \\lstloadlanguages{Lisp} \\definecolor{gray}{rgb}{0.5,0.5,0.5}
  \\lstset{language= Lisp, commentstyle= \\color{gray},
           basewidth= .51em, tabsize= 2, frame= tb,
           xleftmargin= 0.3cm, framexleftmargin=   10pt,
           aboveskip=   0.5cm,  framextopmargin=    6pt,
           belowskip=   0.5cm,  framexbottommargin= 6pt, 
           firstnumber= 1, numbersep= 5pt,
           basicstyle= {\\small  \\ttfamily\\bfseries},
           stringstyle= \\ttfamily\\bfseries\\color{blue}, 
           showstringspaces= false, breaklines=true,}"
                  ("\\section{%s}"       . "\\section*{%s}")
                  ("\\subsection{%s}"    . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))

   (add-to-list 'org-latex-classes
		'("ManueStat"
                  "\\documentclass[11pt]{article}
			[NO-DEFAULT-PACKAGES]
    \\parindent 20pt \\parskip 1ex \\usepackage{natbib, dcolumn}
     \\usepackage[colorlinks, pdfstartview= FitH, urlcolor= blue]{hyperref}
      \\hypersetup{bookmarksnumbered, pdfstartview= {FitH}, citecolor= {blue},
                   linkcolor= {red}, urlcolor= {blue}, pdfpagemode= None}
     \\usepackage[left= 1in, right= 1in, top= 1in, bottom= 1in]{geometry}
     \\usepackage[singlespacing]{setspace} \\usepackage[bottom]{footmisc}
     \\usepackage{dcolumn} 
       \\setlength{\\belowcaptionskip}{5pt} \\usepackage{subcaption}
       \\usepackage{mathpazo, amscd, upgreek, booktabs, listings, color, longtable, amssymb, bm}  
                      \\let\\itemize\\compactitem
                       \\let\\description\\compactdesc
			\\let\\enumerate\\compactenum
   \\lstloadlanguages{R} \\definecolor{storg}{rgb}{1,0.5,0}
    \\definecolor{gray}{rgb}{0.5,0.5,0.5}
     \\newcommand{\\indexfonction}[1]{\\index{#1@\\texttt{#1}}}
     \\lstset{language= R, basewidth= .51em, tabsize= 2,
       inputencoding=utf8,
       literate={à}{{\\'a}}1 {è}{{\\`e}}1 {é}{{\\'e}}1 {ù}{{\\`u}}1
		{ç}{{\c{c}}}1 {ï}{{i}}1 {ö}{{o}}1 {û}{{\\^u}}1,
       xleftmargin= 0.3cm, framexleftmargin=   10pt,
       aboveskip=   0.5cm,  framextopmargin=    6pt,
       belowskip=   0.5cm,  framexbottommargin= 6pt,
       showstringspaces= false, extendedchars= true,
       commentstyle=      \\color{gray} , frame= tb,
       keywordstyle=       \\color{storg},
       backgroundcolor=     \\color{white},
       basicstyle= {\\footnotesize  \\ttfamily\\bfseries},
       stringstyle= \\ttfamily\\bfseries\\color{blue}}"
			("\\section{%s}"       . "\\section*{%s}")
			("\\subsection{%s}"    . "\\subsection*{%s}")
			("\\subsubsection{%s}" . "\\subsubsection*{%s}")
			("\\paragraph{%s}"     . "\\paragraph*{%s}")
			("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))

     (add-to-list 'org-latex-classes
                  '("PlanCours"
                    "\\documentclass[13pt]{article}
                    [NO-DEFAULT-PACKAGES]
                    [PACKAGES]
                    [EXTRA]
   \\usepackage[colorlinks, pdfstartview= FitH, urlcolor= blue]{hyperref}
   \\usepackage[left= 1in, right= 1in, top= 1in, bottom= 1in]{geometry}
                    \\usepackage{fouriernc, inconsolata, natbib}"
                    ("\\section*{%s}"      . "\\section*{%s}")
                    ("%s ; "               . "%s ; ")))

   (add-to-list 'org-latex-classes
		'("PresPrint"
                  "\\documentclass[bigger]{beamer}
                   \\usepackage{/home/jsay/Softwares/Latex/handoutWithNotes}
                   \\pgfpagesuselayout{3 on 1 with notes}[a4paper,border shrink=5mm]
                  [NO-DEFAULT-PACKAGES]\\usepackage{natbib}"
                  ("\\section*{%s}"       . "\\section*{%s}")
                  ("\\subsection*{%s}"    . "\\subsection*{%s}")
                  ("\\subsubsection*{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph*{%s}"     . "\\paragraph*{%s}")
                  ("\\subparagraph*{%s}"  . "\\subparagraph*{%s}")))

   (add-to-list 'org-latex-classes
		'("PresOther"
                  "\\documentclass[serif, 13pt]{beamer}
                  [NO-PACKAGES]
                  \\setbeamercolor{alerted text}{fg= beamer@blendedblue!50}
                  \\usepackage[T1]{fontenc}
                  \\usepackage[style=nejm, url=false, backend=bibtex]{biblatex} 
                  \\usepackage{ctable, graphics, epsfig, hyperref, color, url, concmath, amssymb, pifont}
                  \\setbeamertemplate{navigation symbols}{} \\definecolor{violet}{rgb}{0.25,0,0.75}
 \\makeatletter
 \\ExecuteBibliographyOptions{sorting=none}

 \\DeclareCiteCommand{\\notefullcite}[\\mkbibbrackets]
   {\\usebibmacro{cite:init}%
    \\usebibmacro{prenote}}
   {\\usebibmacro{citeindex}%
    \\usebibmacro{notefullcite}%
    \\usebibmacro{cite:comp}}
   {}
   {\\usebibmacro{cite:dump}%
    \\usebibmacro{postnote}}

 \\newbibmacro*{notefullcite}{%
   \\ifciteseen
     {}
     {\\footnotetext[\\thefield{labelnumber}]{%
	\\usedriver{}{\\thefield{entrytype}}.}}}
 \\DeclareCiteCommand{\\superfullcite}[\\cbx@superscript]%
   {\\usebibmacro{cite:init}%
    \\let\\multicitedelim=\\supercitedelim
    \\iffieldundef{prenote}
      {}
      {\\BibliographyWarning{Ignoring prenote argument}}%
    \\iffieldundef{postnote}
      {}
      {\\BibliographyWarning{Ignoring postnote argument}}}
   {\\usebibmacro{citeindex}%
    \\usebibmacro{superfullcite}%
    \\usebibmacro{cite:comp}}
   {}
   {\\usebibmacro{cite:dump}}
 \\newbibmacro*{superfullcite}{%
   \\ifciteseen
     {}
     {\\xappto\\cbx@citehook{%
	\\noexpand\\footnotetext[\\thefield{labelnumber}]{%
          \\fullcite{\\thefield{entrykey}}.}}}}
 \\newrobustcmd{\\cbx@superscript}[1]{%
  \\mkbibsuperscript{#1}%
   \\cbx@citehook
   \\global\\let\\cbx@citehook=\\empty}
 \\let\\cbx@citehook=\\empty"
                  ("\\section{%s}"       . "\\section*{%s}")
                  ("\\subsection{%s}"    . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))

   (add-to-list 'org-latex-classes
		'("PresSemin"
                  "\\documentclass[serif, 14pt, aspectratio=169]{beamer}
                  [NO-PACKAGES]
                  \\setbeamercolor{alerted text}{fg= beamer@blendedblue!50}
                  \\usepackage[T1]{fontenc}
                  \\usepackage[style=nejm, url=false, backend=bibtex]{biblatex} 
                  \\usepackage{ctable, graphics, epsfig, hyperref, color, url, concmath, amssymb, pifont}
                  \\setbeamertemplate{navigation symbols}{} \\definecolor{violet}{rgb}{0.25,0,0.75}
                  \\AtBeginSection[]{
                  \\begin{frame}<beamer>
                  \\frametitle{Outline}
                  \\tableofcontents[currentsection]
                  \\end{frame}}
                  \\hypersetup{urlcolor= {blue}}
 \\makeatletter
 \\ExecuteBibliographyOptions{sorting=none}

 \\DeclareCiteCommand{\\notefullcite}[\\mkbibbrackets]
   {\\usebibmacro{cite:init}%
    \\usebibmacro{prenote}}
   {\\usebibmacro{citeindex}%
    \\usebibmacro{notefullcite}%
    \\usebibmacro{cite:comp}}
   {}
   {\\usebibmacro{cite:dump}%
    \\usebibmacro{postnote}}

 \\newbibmacro*{notefullcite}{%
   \\ifciteseen
     {}
     {\\footnotetext[\\thefield{labelnumber}]{%
	\\usedriver{}{\\thefield{entrytype}}.}}}
 \\DeclareCiteCommand{\\superfullcite}[\\cbx@superscript]%
   {\\usebibmacro{cite:init}%
    \\let\\multicitedelim=\\supercitedelim
    \\iffieldundef{prenote}
      {}
      {\\BibliographyWarning{Ignoring prenote argument}}%
    \\iffieldundef{postnote}
      {}
      {\\BibliographyWarning{Ignoring postnote argument}}}
   {\\usebibmacro{citeindex}%
    \\usebibmacro{superfullcite}%
    \\usebibmacro{cite:comp}}
   {}
   {\\usebibmacro{cite:dump}}
 \\newbibmacro*{superfullcite}{%
   \\ifciteseen
     {}
     {\\xappto\\cbx@citehook{%
	\\noexpand\\footnotetext[\\thefield{labelnumber}]{%
          \\fullcite{\\thefield{entrykey}}.}}}}
 \\newrobustcmd{\\cbx@superscript}[1]{%
  \\mkbibsuperscript{#1}%
   \\cbx@citehook
   \\global\\let\\cbx@citehook=\\empty}
 \\let\\cbx@citehook=\\empty"
                  ("\\section{%s}"       . "\\section*{%s}")
                  ("\\subsection{%s}"    . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))

   (add-to-list 'org-latex-classes
		'("PresSeminF"
                  "\\documentclass[serif, 14pt, aspectratio=169]{beamer}
                  [NO-PACKAGES]
                  \\setbeamercolor{alerted text}{fg= beamer@blendedblue!50}
                  \\usepackage[T1]{fontenc}
                  \\usepackage[style=nejm, url=false, backend=bibtex]{biblatex} 
                  \\usepackage{ctable, graphics, epsfig, hyperref, color, url, concmath, amssymb, pifont}
                  \\setbeamertemplate{navigation symbols}{} \\definecolor{violet}{rgb}{0.25,0,0.75}
                  \\AtBeginSection[]{
                  \\begin{frame}<beamer>
                  \\frametitle{Plan}
                  \\tableofcontents[currentsection]
                  \\end{frame}}
                  \\hypersetup{urlcolor= {blue}}
 \\makeatletter
 \\ExecuteBibliographyOptions{sorting=none}

 \\DeclareCiteCommand{\\notefullcite}[\\mkbibbrackets]
   {\\usebibmacro{cite:init}%
    \\usebibmacro{prenote}}
   {\\usebibmacro{citeindex}%
    \\usebibmacro{notefullcite}%
    \\usebibmacro{cite:comp}}
   {}
   {\\usebibmacro{cite:dump}%
    \\usebibmacro{postnote}}

 \\newbibmacro*{notefullcite}{%
   \\ifciteseen
     {}
     {\\footnotetext[\\thefield{labelnumber}]{%
	\\usedriver{}{\\thefield{entrytype}}.}}}
 \\DeclareCiteCommand{\\superfullcite}[\\cbx@superscript]%
   {\\usebibmacro{cite:init}%
    \\let\\multicitedelim=\\supercitedelim
    \\iffieldundef{prenote}
      {}
      {\\BibliographyWarning{Ignoring prenote argument}}%
    \\iffieldundef{postnote}
      {}
      {\\BibliographyWarning{Ignoring postnote argument}}}
   {\\usebibmacro{citeindex}%
    \\usebibmacro{superfullcite}%
    \\usebibmacro{cite:comp}}
   {}
   {\\usebibmacro{cite:dump}}
 \\newbibmacro*{superfullcite}{%
   \\ifciteseen
     {}
     {\\xappto\\cbx@citehook{%
	\\noexpand\\footnotetext[\\thefield{labelnumber}]{%
          \\fullcite{\\thefield{entrykey}}.}}}}
 \\newrobustcmd{\\cbx@superscript}[1]{%
  \\mkbibsuperscript{#1}%
   \\cbx@citehook
   \\global\\let\\cbx@citehook=\\empty}
 \\let\\cbx@citehook=\\empty"
                  ("\\section{%s}"       . "\\section*{%s}")
                  ("\\subsection{%s}"    . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))

     (add-to-list 'org-latex-classes
                  '("RapConsul"
                    "\\documentclass[12pt]{hitec}
                    [NO-DEFAULT-PACKAGES]
                    [PACKAGES]
                    [EXTRA]
                    \\usepackage{setspace} \\onehalfspacing
                    \\parindent 30pt \\parskip 2ex 
                    \\usepackage{scrextend}\\changefontsizes[14pt]{13pt}
   \\usepackage[colorlinks, pdfstartview= FitH, urlcolor= blue, citecolor= black]{hyperref}
                    \\usepackage{mathptmx, txfonts, natbib, etoolbox}"
                    ("\\section{%s}"       . "\\section*{%s}")
                    ("\\subsection{%s}"    . "\\subsection*{%s}")
                    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                    ("\\paragraph{%s}"     . "\\paragraph{%s}")))

     (add-to-list 'org-latex-classes
                  '("StandAlon"
                    "\\documentclass[varwidth= \\maxdimen, border=20pt, convert={size=640x}]{standalone}
                    [NO-DEFAULT-PACKAGES]
                    [PACKAGES]
                    [EXTRA]
   \\usepackage[colorlinks, pdfstartview= FitH, urlcolor= blue, citecolor= black]{hyperref}
   \\usepackage[left= 1in, right= 1in, top= 1in, bottom= 1in]{geometry}
                    \\parindent 20pt \\parskip 1ex
                    \\usepackage{natbib, etoolbox, dcolumn}
   \\AtBeginEnvironment{quote}{\\small}   \\AtEndEnvironment{quote}{}"
                    ("\\subsection*{%s}"      . "\\subsection*{%s}")
                    ("\\subsubsection*{\\emph{%s}}"   . "\\subsubsection*{%s}")
                    ("\\paragraph{%s}"        . "\\paragraph{%s}")))

   (add-to-list 'org-latex-classes
		'("TextCours"
                  "\\documentclass[12pt]{article}
                    [NO-DEFAULT-PACKAGES]
                    [PACKAGES]
                    [EXTRA]
    \\parindent 20pt \\parskip 1ex
    \\usepackage[colorlinks, pdfstartview= FitH, urlcolor= blue]{hyperref}
    \\hypersetup{bookmarksnumbered, pdfstartview= {FitH}, citecolor= {blue},
                 linkcolor= {red}, urlcolor= {blue}, pdfpagemode= None}
    \\usepackage[left= 1in, right=  1in, top=  1in, bottom= 1in]{geometry}
    \\usepackage[singlespacing]{setspace} \\usepackage[bottom]{footmisc}
    \\usepackage[small, bf, margin=20pt]{caption}
    \\setlength{\\belowcaptionskip}{5pt}
    \\usepackage{fouriernc, amscd, upgreek, booktabs, listings, color}
			\\let\\itemize\\compactitem
                         \\let\\description\\compactdesc
                          \\let\\enumerate\\compactenum
     \\lstloadlanguages{R} \\definecolor{dkgreen}{rgb}{0,0.6,0}
      \\definecolor{gray}{rgb}{0.5,0.5,0.5}
       \\lstset{language= R, basewidth= .51em, tabsize= 2, frame= l,
         xleftmargin= 0.5cm,  framexleftmargin=  10pt,
         aboveskip=   0.5cm,  framextopmargin=    5pt,
         belowskip=     0cm,  framexbottommargin= 5pt,
         showstringspaces= false, extendedchars= true,
       inputencoding=utf8,
       literate={à}{{\\'a}}1 {è}{{\\`e}}1 {é}{{\\'e}}1 {ù}{{\\`u}}1
		{ç}{{\c{c}}}1 {ï}{{i}}1 {ö}{{o}}1 {û}{{\\^u}}1,
         commentstyle=      \\color{gray} ,
         keywordstyle=      {\\color{dkgreen}},
         backgroundcolor=     \\color{white},
         basicstyle= {\\small  \\ttfamily\\bfseries},
         stringstyle= \\ttfamily\\bfseries\\color{magenta}}"
                    ("\\section{%s}"       . "\\section{%s}")
                    ("\\subsection{%s}"    . "\\subsection{%s}")
                    ("\\subsubsection{%s}" . "\\subsubsection{%s}")))

   (add-to-list 'org-latex-classes
		'("WorkinPap"
                  "\\documentclass[12pt]{article}
                  [NO-DEFAULT-PACKAGES]
 \\usepackage[sf]{titlesec} \\usepackage{bm, amssymb, natbib}
 \\parindent 20pt \\parskip 1ex
 \\usepackage[usenames,dvipsnames]{xcolor}
 \\usepackage[colorlinks, pdfstartview= FitH, citecolor= Fuchsia, linkcolor= red, urlcolor= blue]{hyperref}
 \\usepackage[left= 1in, right= 1in, top= 1in, bottom= 1in]{geometry}
                  \\usepackage{times, inconsolata, setspace}"
                  ("\\section{%s}"       . "\\section*{%s}")
                  ("\\subsection{%s}"    . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))

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

(call-interactively 'mu4e-in-new-frame)

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)

(setq mu4e-sent-messages-behavior 'delete)

(defun mu4e-in-new-frame ()
  "Start mu4e in new frame."
  (interactive)
  (select-frame (make-frame))
  (mu4e))

(setq mail-user-agent 'mu4e-user-agent
      mu4e-get-mail-command "offlineimap"
      mu4e-update-interval 300
      message-kill-buffer-on-exit t
      mu4e-confirm-quit nil
      mu4e-maildir      "/home/jsay/.Maildir"
      mu4e-user-mail-address '("jsay.site@gmail.com"
                               "jeansauveur.ay@sciencespo.fr")
;      mu4e-compose-in-new-frame t
      mu4e-compose-format-flowed t
      mu4e-view-show-addresses 't
      message-kill-buffer-on-exit t
      user-full-name    "Jean-Sauveur Ay"
      mu4e-compose-signature
      (concat "Jean-Sauveur\n"))

;; (setq mu4e-trash-folder nil ;; must be configured later by context
;;       mu4e-drafts-folder nil ;; must be configured later by context
;;       mu4e-sent-folder nil ;; must be configured later by context
;;       mu4e-compose-reply-to-address nil ;; must be configured later by context
;;       mu4e-compose-signature nil ;; must be configured later by context
;;       )
(setq mu4e-drafts-folder "/Draft")
(setq mu4e-sent-folder   "/Sent")
(setq mu4e-trash-folder  "/Trash")
(setq mu4e-refile-folder "/Archives")

(setq mu4e-maildir-shortcuts
    '( ("/Gmail/INBOX"       . ?g)
       ("/SciencesPo/INBOX"  . ?s)
       ("/Gmail/Sent"        . ?G)
       ("/SciencesPo/Sent"   . ?S)
       ("/Draft"             . ?d)
       ("/Trash"             . ?t)
       ("/Archives"          . ?a)))

(setq mu4e-compose-dont-reply-to-self t)
(add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "My settings for message composition."
           (set-fill-column 72)
           (flyspell-mode)))

(require 'smtpmail)
(setq
 send-mail-funtion 'smtpmail-send-it
 message-send-mail-function 'smtpmail-send-it
 mail-user-agent 'mu4e-user-agent
 starttls-use-gnutls t
 smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
 smtpmail-default-smtp-server "smtp.gmail.com"
 smtpmail-smtp-server "smtp.gmail.com"
 smtpmail-smtp-service 587)

(setq mu4e-contexts
    `( ,(make-mu4e-context
          :name "Gmail"
          :enter-func (lambda () (mu4e-message "Entering jsay.site@gmail.com"))
          :leave-func (lambda () (mu4e-message "Leaving jsay.site@gmail.com"))
          :match-func (lambda (msg)
                        (when msg 
                          (mu4e-message-contact-field-matches msg 
                            :to "jsay.site@gmail.com")))
          :vars '( ( user-mail-address      . "jsay.site@gmail.com"  )
                   ( user-full-name         . "Jean-Sauveur Ay" )
                   ( smtpmail-smtp-server   . "smtp.gmail.com" )
		   ( smtpmail-mail-address  . "jsay.site@gmail.com" )
                   ( mu4e-compose-signature .
                     (concat
                       "Jean-Sauveur Ay\n"
                       "INRA, UMR CESAER DIJON\n"))))
       ,(make-mu4e-context
          :name "SciencesPo"
          :enter-func (lambda () (mu4e-message "Switch to SciencesPo context"))
          :match-func (lambda (msg)
                        (when msg 
                          (mu4e-message-contact-field-matches msg 
                            :to "jeansauveur.ay@sciencespo.fr")))
          :vars '( ( user-mail-address       . "jeansauveur.ay@sciencespo.fr" )
                   ( user-full-name          . "Jean-Sauveur Ay" )
                   ( smtpmail-smtp-server    . "smtp.gmail.com" )
		   ( smtpmail-mail-address   . "jeansauveur.ay@sciencespo.fr")
                   ( mu4e-compose-signature  .
                     (concat
                       "Jean-Sauveur\n"))))))
(setq mu4e-context-policy nil)
(setq mu4e-compose-context-policy 'ask)

(require 'gnus-dired)
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
        (set-buffer buffer)
        (when (and (derived-mode-p 'message-mode)
                (null message-sent-message-via))
          (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

(require 'org-mu4e)
(setq org-mu4e-link-query-in-headers-mode nil)
(add-to-list 'org-capture-templates 
	     '("m" "Mail" entry 
	       (file+headline "Main.org" "MESSAGERIE")
	       "** TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n"))
