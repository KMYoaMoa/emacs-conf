
;; ---- Clean Up UI ----

;; Hide the startup message
(setq inhibit-startup-message t)

;; Hide the graphical elements
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(set-fringe-mode 10)

;; Set up the visual bell
(setq visual-bell t)

;; Set Font and Fontsize
(set-face-attribute 'default nil :font "HackNerdFontMono" :height 180)

;; Set Theme
(load-theme 'wombat)

;; Make ESC quit prompts
;; (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

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

;; Command Log Mode
;;   shows a side panel that records your input
;;   along with the function it is binding to.
;; Can be toggled with: clm/toggle-command-log-mode
(use-package command-log-mode)

;; Ivy, a completion framework
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

;; Evil, use Vim motion in Emacs
(use-package evil)

;; DOOM Modeline

(use-package doom-modeline
  :ensure t
  :custom ((doom-modeline-height 50))
  :init (doom-modeline-mode 1)
  )
