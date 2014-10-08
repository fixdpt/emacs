;; Granville Barnett's Emacs Config
;; granvillebarnett@gmail.com

;; -----------------------------------------------------------------------------
;; Emacs generated
;; -----------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-start 1)
 '(ac-modes (quote (LaTeX-mode protobuf-mode latex-mode emacs-lisp-mode d-mode sml-mode graphviz-dot-mode erlang-shell-mode lisp-mode lisp-interaction-mode slime-repl-mode c-mode cc-mode c++-mode go-mode java-mode malabar-mode clojure-mode clojurescript-mode scala-mode scheme-mode ocaml-mode tuareg-mode coq-mode haskell-mode agda-mode agda2-mode perl-mode cperl-mode python-mode ruby-mode lua-mode tcl-mode ecmascript-mode javascript-mode js-mode js2-mode php-mode css-mode makefile-mode sh-mode fortran-mode f90-mode ada-mode xml-mode sgml-mode ts-mode sclang-mode verilog-mode qml-mode erlang-mode)))
 '(custom-safe-themes (quote ("6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "9eb5269753c507a2b48d74228b32dcfbb3d1dbfd30c66c0efed8218d28b8f0dc" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" default)))
 '(edts-inhibit-package-check t))
;; -----------------------------------------------------------------------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; *****************************************************************************
;; Basics
;; *****************************************************************************
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)            
(setq inhibit-startup-message t inhibit-startup-echo-area-message t)
(setq ring-bell-function 'ignore)                                   
(line-number-mode t)                     
(column-number-mode t)                   
(size-indication-mode t)                 
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq default-major-mode 'text-mode)
(global-font-lock-mode t)
(ido-mode t)
(setq ido-enable-flex-matching t) ; fuzzy matching is a must have
(setq ido-enable-last-directory-history nil) ; forget latest selected directory

;; dump all backup files in specific location
(defun my-backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let (backup-root bpath)
    (setq backup-root "~/.emacs.d/emacs-backup")
    (setq bpath (concat backup-root fpath "~"))
    (make-directory (file-name-directory bpath) bpath)
    bpath
  )
)
(setq make-backup-file-name-function 'my-backup-file-name)

(require 'uniquify)

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;; *****************************************************************************
;; Elpa 
;; *****************************************************************************
(require 'package)

(setq package-archives '(("elpa" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(magit 
		      autopair 
                      rainbow-delimiters 
		      highlight-symbol
                      markdown-mode 
		      ggtags
		      erlang 
		      soft-charcoal-theme
		      ack-and-a-half 
                      auto-complete 
		      tuareg 
		      evil 
		      smart-mode-line)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; *****************************************************************************
;; Configurations
;; *****************************************************************************
(load-theme 'soft-charcoal t)
(evil-mode)
(sml/setup)
(sml/apply-theme 'dark) 

;; Autocomplete ----------------------------------------------------------------
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-auto-show-menu 0.)		; show immediately
;; -----------------------------------------------------------------------------

;; AucTeX ----------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/no-elpa/auctex")
(add-to-list 'load-path "~/.emacs.d/no-elpa/auctex/preview")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)                  
(setq TeX-parse-self t)
(setq-default TeX-master nil)           ;set up AUCTeX to deal with
                                        ;multiple file documents.

(setq reftex-plug-into-AUCTeX t)

(setq reftex-label-alist
   '(("axiom"   ?a "ax:"  "~\\ref{%s}" nil ("axiom"   "ax.") -2)
     ("theorem" ?h "thr:" "~\\ref{%s}" t   ("theorem" "th.") -3)))

(setq reftex-cite-format 'natbib)
(add-hook 'LaTeX-mode-hook 'reftex-mode)
;; -----------------------------------------------------------------------------

(defun common-hooks() 
  (highlight-symbol-mode)
  (autopair-mode)
  (show-paren-mode)
  (rainbow-delimiters-mode))

;; Ocaml -----------------------------------------------------------------------

;; OPAM: path where Emacs bits are stored 
(setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

;; utop
(require 'utop)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
(add-hook 'typerex-mode-hook 'utop-setup-ocaml-buffer)

;; ocp-indent
(require 'ocp-indent)
(defun ocp-indent-buffer ()
  (interactive nil)
  (ocp-indent-region (point-min) (point-max)))

;; merlin
;; (require 'merlin)
;; (add-hook 'tuareg-mode-hook 'merlin-mode t)
;; (add-hook 'caml-mode-hook 'merlin-mode t)
;; (setq merlin-use-auto-complete-mode 'easy)
;; (setq merlin-command 'opam)

(defun ocaml-hooks()
  (local-set-key (kbd "M-e") 'tuareg-eval-buffer)
  (local-set-key (kbd "M-/") 'utop-edit-complete)
  (local-set-key (kbd "M-q") 'ocp-indent-buffer))

(add-hook 'utop-mode-hook 'repl-hooks)
(add-hook 'tuareg-mode-hook 'common-hooks)
(add-hook 'tuareg-mode-hook 'ocaml-hooks)
(add-hook 'tuareg-mode-hook 'common-hooks)

(defun repl-hooks()
 (highlight-symbol-mode)
 (autopair-mode)
 (rainbow-delimiters-mode))

;; C ---------------------------------------------------------------------------
(setq c-default-style "linux" c-basic-offset 4)

(defun c-hooks()
  ;; (local-set-key (kbd "ret") 'newline-and-indent)
  (c-set-offset 'arglist-intro '+)	; aligns args split across lines
  (ggtags-mode)
)

(add-hook 'c-mode-common-hook 'common-hooks)
(add-hook 'c-mode-common-hook 'c-hooks)

;; Erlang
(add-hook 'erlang-mode-hook 'common-hooks)
(add-hook 'erlang-shell-mode-hook 'common-hooks)

;; *****************************************************************************
;; Keybindings 
;; *****************************************************************************

;; Buffers, info in general
(global-set-key (kbd "M-f") 'ido-find-file)
(global-set-key (kbd "M-b") 'ido-switch-buffer)
(global-set-key (kbd "M-9") 'query-replace)
(global-set-key (kbd "M-0") 'ack-and-a-half)

;; Packages...
(global-set-key (kbd "M-7") 'magit-status)
(global-set-key (kbd "M--") 'ac-isearch)

;; window stuff
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-+") 'enlarge-window)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-m") 'compile)

;; Variables
;; -----------------------------------------------------------------------------
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
(set-face-attribute 'default nil :height 160)
(global-unset-key (kbd "M-3"))
(global-set-key (kbd "M-3") '(lambda() (interactive) (insert-string "#")))
;; -----------------------------------------------------------------------------
