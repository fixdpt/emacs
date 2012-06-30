;; Setup the mode hooks and any other odd bits

;; perspectives
(persp-mode)
;; some default perspectives...
(persp-switch "hs")
;; (persp-switch "scala")
(persp-switch "clj")
(persp-switch "main")
(persp-rename "wrk")

;; AC
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;; Clojure
(defun clojure-hooks()
  (paredit-mode)
  (show-paren-mode)
  (rainbow-delimiters-mode))

(add-hook 'clojure-mode-hook 'clojure-hooks)

(add-hook 'slime-repl-mode-hook
          (defun clojure-mode-slime-font-lock ()
            (require 'clojure-mode)
            (let (font-lock-mode)
              (clojure-mode-font-lock-setup))))

(add-hook 'slime-repl-mode-hook 'clojure-hooks)
(add-hook 'inferior-lisp-mode-hook 'clojure-hooks)

; ac-slime
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

;; Haskell
(defun haskell-hooks ()
  (turn-on-haskell-doc-mode)
  (turn-on-haskell-indent)
  (paredit-mode)
  (rainbow-delimiters-mode)
  (show-paren-mode))

(add-hook 'haskell-mode-hook 'haskell-hooks)

(defun scala-hooks() 
  (show-paren-mode)
  (rainbow-delimiters-mode)
  (paredit-mode))

(add-hook 'scala-mode-hook 'scala-hooks)

;; to get indentation right...
(add-hook 'scala-mode-hook
      (lambda () (local-set-key (kbd "RET") 'newline-and-indent)))

;; Browse kill ring
(browse-kill-ring-default-keybindings) 	; use M-y to browse kill ring

(require 'fastnav)
