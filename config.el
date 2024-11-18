;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Mia Kuon"
      user-mail-address "mia.kuon@gmail.com")


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq
 projectile-project-search-path `("~/Documents/Code/" "~/source/" "~/.suckless/" "~/.config/")
 )
(emms-add-directory-tree "~/Music/")

;;(add-to-list 'default-frame-alist  '(alpha-background .8))

;; ENCODING
(set-language-environment "Russian")
(prefer-coding-system 'utf-8)

;; FONTS
;; (setq doom-font                (font-spec :family "JetBrainsMono" :size 12 :weight 'light)
;;       doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 13)
;;       ;;doom-symbol-font         (font-spec :family "JuliaMono")
;;       ;;doom-big-font            (font-spec :family "JetBrainsMono" :size 24)
;;       )



(setq org-directory "~/Гримуар/")
(after! org
  (setq org-hide-emphasis-markers t) ; Спрятать символы форматирования текста в `org'
  ;;(setq org-tag-alist '(("саморазвитие" . ?c) ("отдых" . ?j) ("хобби" . ?p))) ;Быстрый выбор тэгов
  (setq org-log-done 'time)
  )

(require 'find-lisp)
(setq org-agenda-files
      (find-lisp-find-files "~/Гримуар/Org/" "\.org$")
      ;;'("~/Гримур/Org/Задачи.org")
      )
;; (setq org-agenda-custom-commands
;;       '(("c" "TODO entries by category"
;;          (
;;           ))
;;         ("x" "TODO entries by occasion"
;;          (
;;           )))))

(setq org-roam-directory org-directory)
(setq org-roam-capture-templates
      `(("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d>-${slug}.org" "#+title: ${title}\n#+filetags: \n\n* ${title}")
         :unnarrowed t)))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; (use-package! nov
;;   :hook (nov-mode . variable-pitch-mode)
;;   :mode ("\\.\\(epub\\|mobi\\)\\'" . nov-mode)
;;   ;; :config
;;   ;; (setq nov-save-place-file)
;;   )

;; (defun my-nov-font-setup ()
;;  (face-remap-add-relative 'variable-pitch :family "Roboto"
;;                                           :height 1.6))
;; (add-hook 'nov-mode-hook 'my-nov-font-setup)



;; (require 'justify-kp)
;;  (setq nov-text-width t)

;; (defun my-nov-window-configuration-change-hook ()
;;   (my-nov-post-html-render-hook)
;;   (remove-hook 'window-configuration-change-hook
;;                    'my-nov-window-configuration-change-hook
;;                    t))

;; (defun my-nov-post-html-render-hook ()
;;   (if (get-buffer-window)
;;     (let ((max-width (pj-line-width))
;;       buffer-read-only)
;;     (save-excursion
;;       (goto-char (point-min))
;;       (while (not (eobp))
;;         (when (not (looking-at "^[[:space:]]*$"))
;;           (goto-char (line-end-position))
;;           (when (> (shr-pixel-column) max-width)
;;                     (goto-char (line-beginning-position))
;;                     (pj-justify)))
;;                 (forward-line 1))))
;;         (add-hook 'window-configuration-change-hook
;;                   'my-nov-window-configuration-change-hook
;;                   nil t)))

;; (add-hook 'nov-post-html-render-hook 'my-nov-post-html-render-hook)

;; (use-package! nov-xwidget
;;   :demand t
;;   :after nov
;;   :config
;;   (define-key nov-mode-map (kbd "o") 'nov-xwidget-view)
;;   (add-hook 'nov-mode-hook 'nov-xwidget-inject-all-files))

;; SNIPPETS
(after! yasnippet
  (setq yas-snippet-dirs '("~/.config/doom/snippets"))
  )

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
