;;;; init.el

; ;; == package mgmt ==========================================================

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'tls)
;; window size
(setq default-frame-alist '((font . "Sauce Code Powerline-13")
                            (width . 120)
                            (height . 60)))

;; UI
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; 4px left, and no right right fringe
(if (fboundp 'set-fringe-style) (set-fringe-style '(4 . 0)))
(if window-system (x-focus-frame nil))
(setq default-line-spacing 0)
(setq ns-use-srgb-colorspace t)

;; set the theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'base16-ocean t nil)

;; cursor
(setq-default cursor-type 'bar)
(setq-default cursor-in-non-selected-windows 'hollow)
(blink-cursor-mode t)
(setq-default blink-matching-paren t)

;; mouse
(setq mouse-wheel-scroll-amount '(0.001))

;; cua mode
(cua-mode t)
(setq cua-auto-tabify-rectangles nil
      cua-keep-region-after-copy t)
(transient-mark-mode 1)

(defun emacs-d (filename)
  "Expand FILENAME relative to `user-emacs-directory'."
  (expand-file-name filename user-emacs-directory))

;; *scratch* buffer
(setq initial-scratch-message nil)
(setq initial-major-mode 'text-mode)
;; Never kill, just bury
(defun dont-kill-but-bury-scratch ()
  (if (equal (buffer-name (current-buffer)) "*scratch*")
      (progn (bury-buffer) nil)
    t))
(add-hook 'kill-buffer-query-functions 'dont-kill-but-bury-scratch)

;; annoyances
(setq inhibit-splash-screen t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq ring-bell-function 'ignore)

;; no backup files, no auto-saving
(setq make-backup-files nil)
(setq auto-save-default nil
      auto-save-list-file-prefix nil
      create-lockfiles nil)

;; Do not ask for confirmation
(setq confirm-nonexistent-file-or-buffer nil)

;; Do not show annoying menu-bar tips
(setq suggest-key-bindings nil)

;; ido
(ido-mode 1)
(ido-everywhere 1)
(add-to-list 'ido-ignore-files "\\.DS_Store")
(setq ido-use-virtual-buffers t
      recentf-save-file (emacs-d "var/recentf")
      ido-save-directory-list-file (emacs-d "var/ido-last.el"))

;; Display completions vertically
; (setq ido-decorations (quote ("\n> " "" "\n  " "\n  ..." "[" "]"
;                          " [No Match]" " [Matched]" " [Not Readable]"
;                          " [Too Big]" " [Confirm]")))

(defun ido-disable-line-truncation ()
  (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)

(defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
(add-hook 'ido-setup-hook 'ido-define-keys)

;; os x
(when (string= system-type "darwin")
  (setq mac-option-modifier 'meta
        mac-command-modifier 'super
        mac-allow-anti-aliasing t
        delete-by-moving-to-trash t
        browse-url-browser-function 'browse-url-default-macosx-browser
        trash-directory (expand-file-name ".Trash" (getenv "HOME"))))

;; linux specific
(when (string= system-type "linux")
  (setq browse-url-browser-function 'browse-url-chromium
        browse-url-chromium-program "google-chrome"))

;; whitespace
(setq whitespace-line-column 120)
(setq whitespace-style '(face lines-tail))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; autofill
(setq-default fill-column 80)

;; highlight matching parenthesis
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

;; highlight the current line
(global-hl-line-mode +1)

;; Tabs/indentation
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; aquamacs specific
(when (boundp 'aquamacs-version)
  (setq user-emacs-directory "~/.emacs.d")
  (one-buffer-one-frame-mode 0))

;;show a marker in the left fringe for lines not in the buffer
(setq default-indicate-empty-lines t)

;; Set the frame's title. %b is the name of the buffer. %+ indicates the
;; state of the buffer: * if modified, % if read only, or - otherwise.
;; Two of them to emulate the mode line. %f for the file name
;; (absolute path actually).
(setq frame-title-format "Emacs: %b %+%+ %f")

;; recent file list
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

;; Auto pair brackets, etc.
(electric-pair-mode 1)

;; configure hooks before we load packages and modes
(load (emacs-d "autohooks"))
(load-autohooks)

;; external packages
(load (emacs-d "packages"))

;; -- load everything from dotfiles-init-dir ---------------------------------
;; other vendored plugins
(add-to-list 'load-path (emacs-d "vendor"))
(load (emacs-d "vendor/powerline-separators"))
(load (emacs-d "vendor/powerline-themes.el"))
(load (emacs-d "vendor/powerline"))

(setq init-file (or load-file-name buffer-file-name))
(setq dotfiles-dir (file-name-directory init-file))
(setq dotfiles-init-dir (expand-file-name "configs" dotfiles-dir))
(if (file-exists-p dotfiles-init-dir)
  (dolist (file (directory-files dotfiles-init-dir t "\\.el$"))
    (load file)))

(load (emacs-d "vendor/jekyll"))
(load (emacs-d "vendor/linum+"))
(load (emacs-d "vendor/protobuf-mode"))
;; window numbering
(load (emacs-d "vendor/window_numbering"))
(window-numbering-mode 1)
;; folding mode
(load (emacs-d "vendor/folding"))
(folding-mode-add-find-file-hook)

(load (emacs-d "vendor/jsfmt"))
(add-hook 'before-save-hook 'jsfmt-before-save)

;; custom functions
(load (emacs-d "functions"))
;; keybindings
(load (emacs-d "keybindings"))



;; configure jekyll blog
(setq jekyll-post-ext ".md"
      jekyll-directory (expand-file-name "~/blog/"))

;; emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "978ff9496928cc94639cb1084004bf64235c5c7fb0cfbcc38a3871eb95fa88f6" "bc89fda3d232a3daa4eb3a9f87d6ffe1272fea46e4cf86686d9e8078e4209e2c" "96b023d1a6e796bab61b472f4379656bcac67b3af4e565d9fb1b6b7989356610" "fc3ba70e150efbe45db40b4b4886fc75716b4f3b1247a4b96e5be7cfbe4bc9e1" "f41fd682a3cd1e16796068a2ca96e82cfd274e58b978156da0acce4d56f2b0d5" "42ac06835f95bc0a734c21c61aeca4286ddd881793364b4e9bc2e7bb8b6cf848" "a99e7c91236b2aba4cd374080c73f390c55173c5a1b4ac662eeb3172b60a9814" "96efbabfb6516f7375cdf85e7781fe7b7249b6e8114676d65337a1ffe78b78d9" "9bac44c2b4dfbb723906b8c491ec06801feb57aa60448d047dbfdbd1a8650897" "f0a99f53cbf7b004ba0c1760aa14fd70f2eabafe4e62a2b3cf5cabae8203113b" "53e29ea3d0251198924328fd943d6ead860e9f47af8d22f0b764d11168455a8e" default)))
 '(powerline-default-separator (quote utf-8)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
