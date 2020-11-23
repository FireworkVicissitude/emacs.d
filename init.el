;;; package --- Summary
;;; ----- init.el -----
;;
;;; Commentary:
;;
;;; Code:

(load (expand-file-name "~/quicklisp/slime-helper.el"))
;;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")

(require 'package)

(add-to-list 'package-archives '("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/") t)
(package-initialize)

;;
;; set autosave and backup directory
;;
(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t)))
;;(setq auto-save-lsit-file-prefix emacs-tmp-dir)
(setq auto-save-list-file-prefix emacs-tmp-dir)

;;
;; custome variable path
;;
(load "~/.emacs.d/custom/custom-variables.el")

;;
;; use package
;;
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; package diminish
;; hide the mini-mode name
(use-package diminish :ensure t)
(use-package bind-key :ensure t)

(use-package auto-package-update
	     :ensure t
	     :config
	     (setq auto-package-update-delete-old-versions t)
	     (setq auto-package-update-hide-results t)
	     (auto-package-update-maybe))

;;
;; basic setup for editer
;;
;; close menu-bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-linum-mode t)
(scroll-bar-mode -1)
;; show paren
(show-paren-mode t)
;; 
(electric-pair-mode t)

;; auto complete double something
;;(setq electric-pair-pairs '(
;;			    (?\' . ?\')  ;; get ''
;;			    ))

(setenv "HOME" "c:\\Users\\shiyao")
(setq default-directory "~/")

;;
;; don't show openning screen
;;
(setq inhibit-splash-screen t)

;;
;; def function to open my init.el quickly
;;
(defun open-my-init-file ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
;; bind key
(global-set-key (kbd "<f2>") 'open-my-init-file)

;;
;; open full screen
;;
(setq initial-frame-alist (quote ((fullscreen . maximized))))

;;
;; highlight current line
;;
(global-hl-line-mode t)

;;
;; dumm bell
;;
;;(global)

;;
;; monokai theme
;;
(use-package monokai-theme
  :ensure t
  :config
  (load-theme 'monokai t))

;;
;; mac shell
;;
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

;;
;; powershell
;;
(use-package powershell
  :ensure t
  :config
  )


;; convert tab to space
(setq-default indent-tabs-mode nil)

;;
(winner-mode t)

;;
;; hideshow
;;
(add-hook 'prog-mode-hook #'hs-minor-mode)

;;
;; multiple cursors
;;
(use-package multiple-cursors
  :ensure t
  :bind(
        ("M-3" . mc/mark-next-like-this)
        ("M-4" . mc/mark-previous-like-this)
        :map ctl-x-map
        ("\C-m" . mc/mark-all-dwim)
        ("<return>" . mule-keymap)
        )
  )

;;
;; ivy-mode
;;
(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 10)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
        `((t . ivy--regex-ignore-order)))
  )

;;
;; counsel
;;
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))

;;
;; swiper
;;
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper))
  )

;;
;; yasnippet
;;
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  (use-package yasnippet-snippets :ensure t)
  )

;;
;; company
;;
(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (setq company-backends
        '((company-files
           company-keywords
           company-capf
           company-yasnippet)
          (company-abbrev company-dabbrev)
          )
        ))

;;
;; change C-n C-p for company
;;
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil))

;;
;; flycheck - grammer check
;;
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;;(use-package flycheck
;;  :defer t
;;  :diminish
;;  :hook ((prog-mode markdown-mode) . flycheck-mode)
;;  :custom
;;  (flycheck-global-modes
;;   '(not text-mode outline-mode fundamental-mode org-mode
;;         diff-mode shell-mode eshell-mode term-mode))
;;  (flycheck-emacs-lisp-load-path 'inherit)
;;  (flycheck-indication-mode 'right-fringe)
;;  :init
;;  (use-package flycheck-grammarly :defer t)
;;  (if (display-graphic-p)
;;      (use-package flycheck-posframe
;;        :custom-face (flycheck-posframe-border-face ((t (:inherit default))))
;;        :hook (flycheck-mode . flycheck-posframe-mode)
;;        :custom
;;        (flycheck-posframe-border-width 1)
;;        (flycheck-posframe-inhibit-functions
;;         '((lambda (&rest _) (bound-and-true-p company-backend)))))
;;    (use-package flycheck-pos-tip
;;      :defines flycheck-pos-tip-timeout
;;      :hook (flycheck-mode . flycheck-pos-tip-mode)
;;      :custom (flycheck-pos-tip-timeout 30)))
;;  :config
;;  (when (fboundp 'define-fringe-bitmap)
;;    (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
;;      [16 48 112 240 112 48 16] nil nil 'center))
;;  (flycheck-add-mode 'javascript-eslint 'js-mode)
;;  (flycheck-add-mode 'typescript-tslint 'rjsx-mode))

;;
;; git - Magit
;;
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status))
  )

;;
;; projectile
;;
(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode t)
  (setq projectile-completion-system 'ivy)
  (use-package counsel-projectile
    :ensure t))

;;
;; auto insert
;;
(use-package autoinsert
  :ensure t
  :config
  (setq auto-insert-query nil)
  (setq auto-insert-directory (locate-user-emacs-file "template"))
  (add-hook 'find-file-hook 'auto-insert)
  (auto-insert-mode t))

;;;;;;;;;;;;;;;;;
;;  c/c++
;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/c.el")


;;;;;;;;;;;;;;;;;
;; python
;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/custom/python.el")



(provide 'init)
;;; init.el ends here
