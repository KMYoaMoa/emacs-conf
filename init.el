
;; ---- Clean Up UI ----

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

;; Make ESC quit prompts
;; (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Show Line Numbers

(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
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
	 ("C-x b" . counsel-ibuffer)
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
(use-package evil)

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
