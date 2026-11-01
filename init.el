;; ---- Clean Up UI ----

(hl-line-mode t)

;; Hide the startup message
(setq inhibit-startup-message t)

;; Hide the graphical elements
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(set-fringe-mode 20)

;; Set up the visual bell
(setq visual-bell t)

;; Set Font and Fontsize
(set-face-attribute 'default nil :font "HackNerdFontMono" :height 160)
;; (set-face-attribute 'fixed-pitch nil :font "HackNerdFontMono" :height 160)
;; (set-face-attribute 'variable-pitch nil :font "Cambria" :height 160)


;; Make ESC quit prompts
;; (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Show Line Numbers

(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook
		pimacs-chat-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; ---- Packages ----

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

;; -- Use packages --

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-switch-buffer)
	 ("C-x C-f" . counsel-find-file))
  :config (setq ivy-initial-inputs-alist nil))

;; Command Log Mode
;;   shows a side panel that records your input
;;   along with the function it is binding to.
;; Can be toggled with: clm/toggle-command-log-mode
(use-package command-log-mode)

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

;; Evil, use Vim motion in Emacs
(defun rune/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circe-server-mode
		  circe-chat-mode
		  circe-query-mode
		  sauron-mode
		  term-mode
		  pimacs-chat-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

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
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
  (add-hook 'evil-mode-hook #'rune/evil-hook)

;; (use-package evil-collection
;;  :after evil
;;  :config
;;  (evil-collection-init))

;; DOOM Modeline

(use-package doom-modeline
  :ensure t
  :custom ((doom-modeline-height 40))
  :init (doom-modeline-mode 1)
  )

(use-package doom-themes)

(load-theme 'doom-gruvbox t)

;; Rainbow Delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Which Key
(use-package which-key
;; Uncomment if you want it on init
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

(use-package all-the-icons)

(use-package buffer-move)
(use-package ace-window)

(use-package general)

;; Other cool packages to explore
;; I'll get used to the existing ones for now

(use-package pimacs)

(use-package spacious-padding
  :init (spacious-padding-mode 1))

;; Hydra
;; can be used to make some cycling
(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
    "scale text"
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finished" :exit t)
)
;; (use-package swiper)

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

(use-package cursory)

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(defun dw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 0)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :config
  (setq org-ellipsis " [v]"
	org-hide-emphasis-markers t)
  :hook (org-mode . dw/org-mode-setup))

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
			   ))
			)

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package smartparens
  :config (smartparens-global-mode t))

;; ---- Key Binding ----

;; Switch window
(general-define-key
 "M-o" 'ace-window)
