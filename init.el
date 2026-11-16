;; initialize package sources
(require 'package)

(setq package-archives '(
      ("melpa" . "https://melpa.org/packages/")
      ("org" .   "https://orgmode.org/elpa/")
      ("elpa" .  "https://elpa.gnu.org/packages/")
      )
)

(package-initialize)
(unless package-archive-contents (package-refresh-contents))

;; Initialize use-package on non-linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Get packages that are not in standard libraries
;; (use-package quelpa-use-package)

;; Hydra
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finished" :exit t)
)

;; Evil, use Vim motion in Emacs

(use-package evil
:init
(setq evil-want-integration t)
(setq evil-want-keybinding nil)
;; (setq evil-want-C-u-scroll t)
(setq evil-want-C-i-jump nil)
:config
(evil-mode 1)
;; (define-key evil-insert-state-map (kbd "C-g") evil-normal-state)
;; (define-key evil-insert-state-map (kbd "C-h") evil-delete-backward-char-and-join)
;; use line motions globally
)

(use-package evil-collection
    :after evil
    :config
    (evil-collection-init)
    (add-hook 'evil-mode-hook #'rune/evil-hook)

(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)
(evil-set-initial-state 'messages-buffer-mode 'normal)
(evil-set-initial-state 'dashboard-mode 'normal)
(dolist (mode '(
custom-mode
eshell-mode
term-mode
agent-shell-mode
git-rebase-mode
erc-mode
circe-server-mode
circe-chat-mode
circe-query-mode
sauron-mode
))(evil-set-initial-state mode 'emacs))
    )

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 0)
  ;; This would create a new line to wrap the line
  ;; another way to do wrapping is to use visual fill 
  (auto-fill-mode 0) 
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :config
  (setq org-ellipsis " ⸙"
	org-hide-emphasis-markers t
	org-agenda-start-with-log-mode t
	org-log-done 'time
	org-log-into-drawer t
	org-agenda-files '("~/workspace/Agenda.org"))
  :hook (org-mode . efs/org-mode-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :init
  (dolist (face '((org-level-1 . 1.3)
	    (org-level-2 . 1.25)
	    (org-level-3 . 1.2)
	    (org-level-4 . 1.15)
	    (org-level-5 . 1.1)
	    (org-level-6 . 1.05)
	    (org-level-7 . 1.0)
	    (org-level-8 . 1.0)
	    ))
  (set-face-attribute (car face) nil :weight 'bold :height (cdr face))))

(font-lock-add-keywords 'org-mode
    '(("^ *\\([-]\\) "
	(0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "⦁")))
	)))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 80
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   ;; (cpp . t)
   (latex . t)
   (ocaml . t)
   (ruby . t)
   (sql . t)
   (java . t)
   (js . t)
   (lua . t)
   (shell . t)
   (python . t)))

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(general-define-key "C-c C-c" 'org-babel-execute-src-block)
(setq org-confirm-babel-evaluate nil)

(defun efs/org-babel-tangle-config ()
(when (string-equal
    (buffer-file-name)
    (expand-file-name "~/workspace/playground/emacs-conf/config.org"))
(let ((org-confirm-babel-evaluate nil))
(org-babel-tangle))))

(add-hook 'org-mode-hook
    (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

;; UI elements
(scroll-bar-mode -1) ;; disable scroll bar
(tool-bar-mode   -1) ;; disable tool bar
(tooltip-mode    -1) ;; disable tool tip
(menu-bar-mode   -1) ;; disable menu bar

;; Hide the startup message
(setq inhibit-startup-message t)

;; Fringe: Breathing Room
(set-fringe-mode 20)

;; Set Font and Fontsize
(set-face-attribute 'default nil :font "HackNerdFontMono" :height 160)
(set-face-attribute 'fixed-pitch nil :font "HackNerdFontMono" :height 160)
(set-face-attribute 'variable-pitch nil :font "HackNerdFontMono" :height 160)

;; TMP
;; Make ESC quit prompts
;; (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package doom-themes)

(load-theme 'doom-gruvbox t)

(use-package doom-modeline
  :ensure t
  :custom ((doom-modeline-height 40))
  :init (doom-modeline-mode 1)
  )

;; use-package with package.el:
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; Set the title
(setq dashboard-banner-logo-title "おかえり、アカツキ様。")

;; Set the banner
(setq dashboard-startup-banner 'logo)
;; Value can be:
;;  - 'official which displays the official emacs logo.
;;  - 'logo which displays an alternative emacs logo PNG or braille.
;;  - 'logo-ansi-truecolor which displays an alternative emacs logo
;;    using unicode block characters and ANSI escape sequences.
;;  - 'logo-ansi-256color which displays an alternative emacs logo
;;    using unicode block characters and ANSI escape sequences.
;;  - 'logo-braille which displays an alternative emacs logo
;;    using unicode braille characters.
;;  - an integer which displays one of the text banners
;;    (see dashboard-banners-directory files).
;;  - a string that specifies a path for a custom banner
;;    currently supported types are gif/image/text/xbm.
;;  - a cons of 2 strings which specifies the path of an image to use
;;    and other path of a text file to use if image isn't supported.
;;    (cons "path/to/image/file/image.png" "path/to/text/file/text.txt").
;;  - a list that can display an random banner,
;;    supported values are: string (filepath), 'official, 'logo and integers.

;; Content is not centered by default. To center, set
(setq dashboard-center-content t)
;; vertically center content
(setq dashboard-vertically-center-content t)

;; To disable shortcut "jump" indicators for each section, set
(setq dashboard-show-shortcuts nil)

(setq dashboard-startupify-list '(dashboard-insert-banner
                                  dashboard-insert-newline
                                  dashboard-insert-banner-title
                                  dashboard-insert-newline
                                  dashboard-insert-navigator
                                  dashboard-insert-newline
                                  dashboard-insert-init-info
                                  dashboard-insert-items
                                  dashboard-insert-newline
                                  ;; dashboard-insert-footer
                                  ))

;; Show Relative Line Numbers

(column-number-mode)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(dolist (mode '(
                org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                doc-view-mode-hook
                pdf-view-mode-hook
                agent-shell-mode-hook))
  (add-hook mode (lambda ()
                   (display-line-numbers-mode 0))))

;; auto revert buffer when file changes
(global-auto-revert-mode t)

;; Highlight Current Line
;; (global-hl-line-mode t)

(use-package buffer-move)

(global-unset-key (kbd "C-w"))
(define-prefix-command 'window-prefix)
(global-set-key (kbd "C-w") 'window-prefix)

(defhydra hydra-window-move (:timeout 10)
    "Move Window"
    ("h" buf-move-left)
    ("j" buf-move-down)
    ("k" buf-move-up)
    ("l" buf-move-right)
    ("f" nil "finished" :exit t)
)

(define-key evil-normal-state-map (kbd "C-w m") 'hydra-window-move/body)

(defhydra hydra-window-resize (:timeout 10)
    "Resize Window"
    ("h" shrink-window-horizontally)
    ("j" shrink-window)
    ("k" enlarge-window)
    ("l" enlarge-window-horizontally)
    ("f" nil "finished" :exit t))

(define-key evil-normal-state-map (kbd "C-w i") 'hydra-window-resize/body)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-switch-buffer)
	 ("C-x C-f" . counsel-find-file))
  :config (setq ivy-initial-inputs-alist nil))

;; Ivy, a completion framework
;; If you want to add additional info to ivy
;;   try ivy-rich package also.
(use-package ivy
  :diminish
  :bind ( :map ivy-minibuffer-map
	  ("TAB" . ivy-alt-done)
	  ("C-l" . ivy-alt-done)
	  ("C-j" . ivy-next-line)
	  ("C-k" . ivy-previous-line)
	  )
  :config
  (ivy-mode 1)
)

(use-package ivy-rich
  :init (ivy-rich-mode 1))

;; Which Key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 1))

;; Helpful: better help
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command ] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key     ] . helpful-key))

;; Command Log Mode
;;   shows a side panel that records your input
;;   along with the function it is binding to.
;; Can be toggled with: clm/toggle-command-log-mode
;; (use-package command-log-mode)

(setq calendar-week-start-day 1)

(use-package org-pomodoro)

(use-package term)

(setq-default tab-width 4)

;; use spaces for indent
(setq-default indent-tab-mode nil)

(use-package tablist)
(use-package pdf-tools)
(add-to-list 'auto-mode-alist '("\\.[pP][dD][fF]\\'" . pdf-view-mode))
(use-package org-pdftools)

;; (defun efs/exwm-update-class ()
;; (exwm-workspace-rename-buffer exwm-class-name)
;; )

;; (use-package exwm
;; :config
;; (setq exwm-workspace-number 5)
;; (exwm-enable)
;; )

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init (setq lsp-keymap-prefix "C-c l")
  :config (lsp-enable-which-key-integration t)
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "--log=error" "--clang-tidy"))
  )

(use-package lsp-ui
  :after lsp-mode
  :config (setq lsp-ui-doc-position 'top))

(use-package lua-mode)

(use-package markdown-mode)
(use-package markdown-mermaid)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/workspace/projects")
    (setq projectile-project-search-path '("~/workspace/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package all-the-icons)
(use-package general)
(use-package spacious-padding
  :init (spacious-padding-mode 1))
;; (use-package swiper)
(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))
(use-package smartparens
  :config (smartparens-global-mode t))
(use-package tuareg)

(use-package agent-shell :ensure t)

;; EAF is not on MELPA/ELPA, so quelpa builds it from upstream.  Its app
;; directories (app/browser, ...) are gitignored and generated by
;; install-eaf.py, so run `M-x eaf-install-and-update' once afterwards.
;; (use-package eaf
;;   ;; :quelpa (eaf :fetcher github
;;   ;;              :repo "emacs-eaf/emacs-application-framework"
;;   ;;              :files ("*"))
;;   :config
;;   ;; (require 'eaf-browser)
;;   ;; (require 'eaf-pyqterminal)
;;   (require 'eaf-pdf-viewer)
;;   (require 'eaf-video-player)
;;   (require 'eaf-js-video-player)
;;   )

(defun kareno/comment-this-line ()
  "Comment or uncomment this line"
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning)
              end (region-end))
      (setq beg (line-beginning-position)
            end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(define-key evil-normal-state-map (kbd "g c c")
            'kareno/comment-this-line)
(define-key evil-visual-state-map (kbd "g c c")
              'comment-or-uncomment-region)
