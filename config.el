;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; Commetary: My Doom Emacs Config

(setq user-full-name "Mia Kuon"
      user-mail-address "mia.kuon@gmail.com"
      doom-user-dir "/home/mia/.config/doom")

(add-to-list 'initial-frame-alist '(fullscreen . fullboth))
(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)
(show-paren-mode 1)

(set-language-environment "Russian")
(prefer-coding-system 'utf-8)

;(map! :leader
;      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/Гримуар/"
        org-default-notes-file (expand-file-name "Входящие/Заметки.org" org-directory)
        org-id-locations-file (expand-file-name ".orgids" org-directory)
        ;; org-ellipsis " ▼ " ; changes outline, default is "[...]"
        ;; org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        ;; org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        ;; org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
        ;;   '(("google" . "http://www.google.com/search?q=")
        ;;     ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
        ;;     ("ddg" . "https://duckduckgo.com/?q=")
        ;;     ("wiki" . "https://en.wikipedia.org/wiki/"))
        ;; org-table-convert-region-max-lines 20000
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
              "TODO(t)"           ; A task that is ready to be tackled
              "WAIT(w)"           ; Something is holding up this task
              "STRT(s)"           ; Task is started
              "IDEA(i)"           ; An idea that needs to be moved or to be done
              "PROJ(p)"           ; A project that contains other tasks
              "HBBT(h)"           ; A habbit
              "|"                 ; The pipe necessary to separate "active" states and "inactive" states
              "DONE(d)"           ; Task has been completed
              "FAIL(f)"           ; Task has been failed
              "CANCELLED(c)" )    ; Task has been cancelled
            (sequence
              "[ ](T)"
              "[-](S)"
              "[?](W)"
              "|"
              "[X](D)")
            (sequence
              "Написать(y)"
              "Дописать(l)"
              "Переписать(g)"
              "Переместить(G)"
              "|"))))

(require 'find-lisp)
(after! org
  (defvar org-agenda-directory (expand-file-name "Org/" org-directory) "My variable. Used for other variables in config.org")
  (setq org-agenda-files (find-lisp-find-files org-agenda-directory "\.org$")))

;; (setq
   ;; org-priority-faces
   ;; '((?A :foreground "#ff6c6b" :weight bold)
   ;;   (?B :foreground "#98be65" :weight bold)
   ;;   (?C :foreground "#c678dd" :weight bold))
   ;; org-agenda-block-separator 8411)

(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (tags "PRIORITY=\"B\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))
          (tags "customtag"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Tasks marked with customtag:")))

          (agenda "")
          (alltodo "")))))

(setq org-journal-dir "~/Гримуар/Дневник/"
      org-journal-date-prefix "* "
      org-journal-time-prefix "** "
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org")

(setq org-download-image-dir "~/Гримуар/Вложения/")

(after! org
  (setq org-roam-directory org-directory
        org-roam-graph-viewer "/usr/bin/firefox") ; TODO поменять на qutebrowser

  (setq org-roam-capture-templates
        `(("c" "new chit" plain "%?\n* Ссылки"
           :target (file+head
                    "%<%Y%m%d%H%M%S>.org"
                    ":PROPERTIES:
:DATE:     %<%FT%T%z>
:END:
#+title: ${title}
#+notetype: %^{Тип заметки:записка|черновик}
#+filetags: %^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("f" "new fundamental" plain "%?\n* Ссылки\n** Связи\n** Источники"
           :target (file+head
                    "%<%Y%m%d%H%M%S>-${slug}.org"
                    ":PROPERTIES:
:ROAM_ALIASES: %^{Синонимы}
:DATE:     %<%FT%T%z>
:ACCESS:   %^{Доступ|public|private|personal|confidentional}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: %^{Тип заметки:фундаментальная|мысль|цитата}
#+filetags: %^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("n" "new note" plain "* ${title}\n%?\n* Ссылки"
           :target (file+head
                    "%<%Y%m%d%H%M%S>-${slug}.org"
                    ":PROPERTIES:
:ROAM_ALIASES: %^{Синонимы}
:DATE:     %<%FT%T%z>
:ACCESS:   %^{Доступ|public|private|personal|confidentional}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: %^{Тип заметки|заметка|статья|руководство}
#+filetags: %^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("a" "new abstract" plain "* ${title}\n%?\n* Источник\n%A\n* Ссылки\n* TODO Добавить синонимы, если нужно"
           :target (file+head
                    "%<%Y%m%d%H%M%S>-${slug}.org"
                    ":PROPERTIES:
:DATE:     %<%FT%T%z>
:ACCESS:   %^{Доступ|public|private|personal|confidentional}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: коспект
#+sourcetype: %^{Тип источника|статья|видео|аудио|занятие}
#+filetags: %^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("c" "new copy" plain "* Источник\n%A\n* ${title}\n%?"
           :target (file+head
                    "%<%Y%m%d%H%M%S>-${slug}.org"
                    ":PROPERTIES:
:ROAM_ALIASES: %^{Синонимы}
:DATE:     %<%FT%T%z>
:ACCESS:   %^{Доступ|public|private|personal|confidentional}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: копия
#+sourcetype: %^{Тип источника|статья|видео|аудио|занятие}
#+filetags: %^G")))))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; (map! :leader
;;       (:prefix ("n r" . "org-roam")
;;        :desc "Completion at point" "c" #'completion-at-point
;;        :desc "Find node"           "f" #'org-roam-node-find
;;        :desc "Show graph"          "g" #'org-roam-ui-open
;;        :desc "Show local graph"    "G" #'org-roam-ui-node-local
;;        :desc "Insert node"         "i" #'org-roam-node-insert
;;        :desc "Capture to node"     "n" #'org-roam-capture
;;        :desc "Toggle roam buffer"  "r" #'org-roam-buffer-toggle))

(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")

(after! yasnippet
  (setq yas-snippet-dirs '("~/.config/doom/snippets"))
  )

(setq projectile-project-search-path `("~/Documents/Code/" "~/source/" "~/.suckless/" "~/.config/"))

(map! :leader
      (:prefix "TAB"
       :desc "Move workspace right"     [left]  #'+workspace/swap-left
       :desc "Move workspace left"      [right] #'+workspace/swap-right))

(map! :map python-mode-map
      :localleader
      :desc "run REPL"                "s" #'run-python                ;; SPC m s — запустить REPL
      :desc "restart REPL"            "R" #'python-shell-restart      ;; SPC m r — перезапустить REPL
      :desc "run"                     "c" #'python-shell-send-buffer  ;; SPC m c — запустить весь скрипт
      :desc "run region"              "r" #'python-shell-send-region  ;; SPC m r — запустить выделенный код
      :desc "run function"            "j" #'python-shell-send-defun)  ;; SPC m j — отправить функцию в REPL

(use-package! calfw)
(use-package! calfw-org)  ; for Org and Agenda
(use-package! calfw-ical) ; for Google Calendar
;; (use-package! calfw-cal)  ; for diary
(load "$DOOMDIR/secrets.el")

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; org-agenda source
    (cfw:org-create-file-source "ecal" (expand-file-name "Расписание.org" org-agenda-directory) "Cyan")  ; other org source
    (cfw:ical-create-source "My gcal" mia-google-calendar-url "IndianRed") ; google calendar ICS
   )))

(after! elfeed
  (setq elfeed-search-filter "@1-month-ago +unread"
        rmh-elfeed-org-files '("~/.config/doom/elfeed.org")
        elfeed-goodies/entry-pane-size 0.5))

(add-hook 'elfeed-search-mode-hook #'elfeed-update)

(evil-define-key 'normal elfeed-show-mode-map
  (kbd "J") 'elfeed-goodies/split-show-next
  (kbd "K") 'elfeed-goodies/split-show-prev)
(evil-define-key 'normal elfeed-search-mode-map
  (kbd "J") 'elfeed-goodies/split-show-next
  (kbd "K") 'elfeed-goodies/split-show-prev)

;; (setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      :desc "Search web for text between BEG/END"
      "s w" #'eww-search-words
      (:prefix ("e" . "ERC/EWW")
       :desc "Eww web browser" "w" #'eww
       :desc "Eww reload page" "R" #'eww-reload))

(map! :leader
      (:prefix ("r" . "registers")
       :desc "Copy to register" "c" #'copy-to-register
       :desc "Frameset to register" "f" #'frameset-to-register
       :desc "Insert contents of register" "i" #'insert-register
       :desc "Jump to register" "j" #'jump-to-register
       :desc "List registers" "l" #'list-registers
       :desc "Number to register" "n" #'number-to-register
       :desc "Interactively choose a register" "r" #'counsel-register
       :desc "View a register" "v" #'view-register
       :desc "Window configuration to register" "w" #'window-configuration-to-register
       :desc "Increment register" "+" #'increment-register
       :desc "Point to register" "SPC" #'point-to-register))
