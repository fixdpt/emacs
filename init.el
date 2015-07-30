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
 '(ac-modes
   (quote
    (puml-mode tex-mode groovy-mode TeX-mode go-mode text-mode java-mode emacs-lisp-mode c-mode cc-mode c++-mode makefile-mode markdown-mode)))
 '(clang-format-executable "clang-format-3.5")
 '(clang-format-style "google")
 '(custom-safe-themes
   (quote
    ("de309af2ced9914b67077eecd0b89412dd9a60c5eb823e5c5ed66170bd4495a7" "3cc2385c39257fed66238921602d8104d8fd6266ad88a006d0a4325336f5ee02" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "46fd293ff6e2f6b74a5edf1063c32f2a758ec24a5f63d13b07a20255c074d399" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "0c29db826418061b40564e3351194a3d4a125d182c6ee5178c237a7364f0ff12" "72a81c54c97b9e5efcc3ea214382615649ebb539cb4f2fe3a46cd12af72c7607" "7bde52fdac7ac54d00f3d4c559f2f7aa899311655e7eb20ec5491f3b5c533fe8" "603a9c7f3ca3253cb68584cb26c408afcf4e674d7db86badcfe649dd3c538656" "40bc0ac47a9bd5b8db7304f8ef628d71e2798135935eb450483db0dbbfff8b11" "bdaab014ec6785f64b72efbea80808b762d8971247aacf2ffc6b76a39b9ed97c" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "9eb5269753c507a2b48d74228b32dcfbb3d1dbfd30c66c0efed8218d28b8f0dc" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" default))))

;; -----------------------------------------------------------------------------

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
(ido-mode 1)
(ido-everywhere 1)
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
(setq magit-last-seen-setup-instructions "1.4.0")

;; *****************************************************************************
;; Elpa 
;; *****************************************************************************
(require 'package)

(setq package-archives '(("elpa" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "https://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(
		      ;; general
		      auto-complete-nxml
		      magit 
		      autopair 
		      exec-path-from-shell
                      rainbow-delimiters 
		      highlight-symbol
                      markdown-mode 
		      soft-charcoal-theme
                      auto-complete 
		      yasnippet
		      evil 
		      smart-mode-line
		      ;; C/C++
		      ggtags
		      clang-format
		      google-c-style
		      ;; Java
		      javadoc-lookup
		      java-snippets
		      maven-test-mode
		      groovy-mode
		      gradle-mode
		      puml-mode
		      ;; Go
		      go-mode
		      go-autocomplete)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; *****************************************************************************
;; Configurations
;; *****************************************************************************
;; (require 'emacs-color-themes)
;; (load-theme 'soft-charcoal t)
(load-theme 'hickey t)
(evil-mode)
(sml/setup)
(sml/apply-theme 'dark) 
(yas-global-mode)

;; Autocomplete ----------------------------------------------------------------
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-auto-show-menu 0.)		; show immediately
;; -----------------------------------------------------------------------------

(defun common-hooks() 
  (highlight-symbol-mode)
  (autopair-mode)
  (show-paren-mode)
  (rainbow-delimiters-mode))

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

;; Markdown
(add-hook 'markdown-mode-hook 'common-hooks)

;; Go
(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)
(add-hook 'go-mode-hook 'common-hooks)
(add-hook 'before-save-hook #'gofmt-before-save)

;; C ---------------------------------------------------------------------------
(require 'clang-format)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(defun c-hooks()
  (c-set-offset 'arglist-intro '+)	; aligns args split across lines
  (ggtags-mode)
  (local-set-key (kbd "M-q") 'clang-format-buffer)
)

(add-hook 'c-mode-common-hook 'common-hooks)
(add-hook 'c-mode-common-hook 'c-hooks)

;; Java
(defun java-hooks()
  (setq c-basic-offset 4
	tab-width 4
	indent-tabs-mode nil)
  (maven-test-mode)
  (local-set-key (kbd "M-?") 'javadoc-lookup)
  (local-set-key (kbd "M-+") 'add-java-import)
  (local-set-key (kbd "M-p") 'maven-test-toggle-between-test-and-class)
  (local-set-key (kbd "M-n") 'maven-test-all))
(add-hook 'java-mode-hook 'common-hooks)
(add-hook 'java-mode-hook 'java-hooks)
(add-hook 'groovy-mode-hook 'common-hooks)

;; PlantUML
(add-to-list 'auto-mode-alist '("\\.uml\\'" . puml-mode))

;; Go
(add-hook 'go-mode-hook 'common-hooks)
(require 'go-autocomplete)
(require 'auto-complete-config)
(add-hook 'before-save-hook #'gofmt-before-save)

;; *****************************************************************************
;; Keybindings 
;; *****************************************************************************

(global-set-key (kbd "M-f") 'ido-find-file)
(global-set-key (kbd "M-b") 'ido-switch-buffer)
(global-set-key (kbd "M-9") 'query-replace)
(global-set-key (kbd "M-0") 'ack-and-a-half)
(global-set-key (kbd "M-m") 'compile)
(global-set-key (kbd "M-7") 'magit-status)
(global-set-key (kbd "M--") 'ac-isearch)
(global-set-key (kbd "M-1") 'delete-other-windows)
;; (global-set-key (kbd "M-+") 'enlarge-window)
(global-set-key (kbd "M-o") 'other-window)

;; Variables
;; -----------------------------------------------------------------------------
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
(cond
 ((string-equal system-type "darwin")   
  (progn
    (set-face-attribute 'default nil :height 200)
    )
  )
 ((string-equal system-type "gnu/linux") 
  (progn
    (set-face-attribute 'default nil :height 170)
    )
  )
 )
(global-unset-key (kbd "M-3"))
(global-set-key (kbd "M-3") '(lambda() (interactive) (insert-string "#")))
;; -----------------------------------------------------------------------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
