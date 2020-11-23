;;; python.el --- python related                     -*- lexical-binding: t; -*-
;; Copyright (C) 2020

;; Author:  <shiyao@SHIYAO>
;; Keywords: languages, abbrev

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:
;;(use-package python
;;  :ensure t
;;  :mode ("\\.py\\'" . python-mode)
;;  :interpreter ("c:\\Python38\\python.exe" . python-mode)
;;  :config
;;  (setq indent-tabs-mode nil)
;;  (setq python-indent-offset 4)
;;  (use-package py-autopep8
;;    :ensure t
;;    :hook ((python-mode . py-autopep8-enable-on-save))
;;    )
;;  )

(use-package python-mode
  :ensure nil
  :after flycheck
  :mode "\\.py\\'"
  :custom
  (python-indent-offset 4)
  (flycheck-python-pycompile-executable "python")
  (python-shell-interpreter "python"))

;;
;; company jedi use jedi-core
;;
(use-package company-jedi
  :ensure t
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook (lambda ()
                                (add-to-list (make-local-variable 'company-backends)
                                             'company-jedi)))
  )

;;
;; pyvenv
;;
(use-package pyvenv
  :ensure t
  :diminish
  :config
  (pyvenv-mode t)
  (setq pyvenv-post-activate-hooks
        (list (lambda ()
                (setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python3")))))
  (setq pyvenv-post-deactivate-hooks
        (list (lambda ()
                (setq python-shell-interpreter "python3"))))
  (setq pyvenv-mode-line-indicator
        '(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "] ")))
  )

;;
;; Anaconda mode
;;
(use-package anaconda-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(provide 'python)
;;; python.el ends here
