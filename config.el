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
        org-todo-keywords         ; This overwrites the default Doom org-todo-keywords
          '((sequence             ; Tasks
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
            (sequence             ; States
              "[ ](T)"
              "[-](S)"
              "[?](W)"
              "|"
              "[X](D)")
            (sequence             ; Notes states
              "Написать(y)"
              "Дописать(l)"
              "Переписать(g)"
              "Переместить(G)"
              "|"))))

(require 'find-lisp)
(after! org
  (defvar org-agenda-subdirectory "Организация" "Directory in org-directory that contains all organization realted files")
  (defvar org-agenda-directory (expand-file-name "Организация/" org-directory) "")
  (setq org-agenda-files (find-lisp-find-files org-agenda-directory "\.org$")))

;; (setq
   ;; org-priority-faces
   ;; '((?A :foreground "#ff6c6b" :weight bold)
   ;;   (?B :foreground "#98be65" :weight bold)
   ;;   (?C :foreground "#c678dd" :weight bold))
   ;; org-agenda-block-separator 8411)

(use-package! org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode))

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
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))))
        ("p" "Задачи по проектам"
         ((alltodo ""
                   ((org-super-agenda-groups
                     '((:auto-group t)
                       (:discard (:not (:tag t)))))))))
        ("d" "Задачи по дедлайнам"
         ((alltodo ""
           ((org-super-agenda-groups
             '((:name "🔴 Просроченные"
                :and (:deadline past :todo t))
               (:name "🟡 С дедлайном"
                :and (:deadline future :todo t))
               (:name "⚪ Без дедлайна"
                :and (:not (:deadline)) :todo t)))))))
        ("D" "Дедлайны"
         ((alltodo ""
                  ((org-super-agenda-groups
                    '((:name "🔴 Просроченные"
                       :and (:deadline past :todo t))
                      (:name "🟡 С дедлайном"
                       :and (:deadline future :todo t))
                      (:name "⚪ Без дедлайна"
                       :and (:not (:deadline)) :todo t)))
                   (org-agenda-prefix-format "  %12(deadline) %?-20t %s")))))
        ("g" "Get Things Done"
         ((agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-deadline-warning-days 0)))
          (todo "NEXT"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format "  %i %-12:c [%e] ")
                 (org-agenda-overriding-header "\nTasks\n")))
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                   (org-agenda-format-date "")
                   (org-deadline-warning-days 7)
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                   (org-agenda-overriding-header "\nDeadlines")))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "  %?-12t% s")
                      (org-agenda-overriding-header "\nInbox\n")))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today\n")))))))

(after! org
 (setq org-capture-templates
       `(("g" "GTD")
         ("gi" "Inbox" entry  (file "Организация/Входящее.org")
          "* TODO %?\n/Entered on/ %U" :prepend t :empty-lines-before 1)
         ("gm" "Meeting" entry  (file+headline "Организация/Расписание.org" "Личное")
          "* %? %^G\nSCHEDULED: %^T\n/Entered on/ %U" :prepend t)
         ("gc" "Current" entry (file "Организация/Текущее.org")
          "* TODO %?\nSCHEDULED: %t\n/Entered on/ %U" :prepend t)
         ("gh" "Habbit" entry (function (lambda () (read-file-name "Ценность: "
                                              "~/Гримуар/Организация/Ценности/" nil t nil
                                              (lambda (f)
                                                (and (file-regular-p f)
                                                     (string-match "\\.org$" f))))))
          "* HBBT %?\nSCHEDULED: <%<%Y-%m-%d %a %H:00> +1d>\n:PROPERTIES:\n:STYLE:           Habbit\n:REPEAT_TO_STATE: HBBT\n:END:\n/Entered on/ %U"
          :heading "Привычки"
          :prepend nil)
         ;; ("j" "Journal")
         ;; ("jd" "Daily" entry
         ;;  (file+olp+datetree +org-capture-journal-file)
         ;;  "* %U %?\n%i\n%a" :prepend t)
         ;; ("jw" "Weekly" entry)
         ;; ("jm" "Monthly" entry)
         ;; ("jy" "Yearly" entry)
         ("p" "Templates for projects")
         ("pt" "Project-local todo" entry
          (file+headline +org-capture-project-todo-file "Inbox")
          "* TODO %?\n%i\n%a" :prepend t)
         ("pn" "Project-local notes" entry
          (file+headline +org-capture-project-notes-file "Inbox")
          "* %U %?\n%i\n%a" :prepend t)
         ("pc" "Project-local changelog" entry
          (file+headline +org-capture-project-changelog-file "Unreleased")
          "* %U %?\n%i\n%a" :prepend t)
         ("o" "Centralized templates for projects")
         ("ot" "Project todo" entry
          #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
         ("on" "Project notes" entry
          #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
         ("oc" "Project changelog" entry
          #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t))))

(after! org
  (setq org-log-into-drawer t))

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
        `(("c" "Записка, Черновик" plain "%?\n* Ссылки"
           :target (file+head
                    "Заметки/Входящие/%<%Y%m%d%H%M%S>.org"
                    ":PROPERTIES:
:DATE:     %<%FT%T%z>
:END:
#+title: ${title}
#+notetype: %^{Тип заметки|записка|черновик}
#+filetags: %^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("f" "Фундаментальная, Мысль, Цитата" plain "%?\n* Ссылки\n** Связи\n** Источники"
           :target (file+head
                    "Заметки/%<%Y%m%d%H%M%S>-${slug}.org"
                    ":PROPERTIES:
:DATE:     %<%FT%T%z>
:ACCESS:   %^{Доступ|public|private|personal|confidentional}
:ROAM_ALIASES: %^{Синонимы (в кавычках)}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: %^{Тип заметки|фундаментальная|мысль|цитата}
#+filetags: %^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("n" "Заметка, Статья, Руководство" plain "* ${title}\n%?\n* Ссылки"
           :target (file+head
                    "Заметки/%<%Y%m%d%H%M%S>-${slug}.org"
                    ":PROPERTIES:
:DATE:     %<%FT%T%z>
:ACCESS:   %^{Доступ|public|private|personal|confidentional}
:ROAM_ALIASES: %^{Синонимы (в кавычках)}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: %^{Тип заметки|заметка|статья|руководство}
#+filetags: %^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("a" "Конспект" plain "* ${title}\n%?\n* Источник\n%A\n* Ссылки\n* TODO Добавить синонимы, если нужно"
           :target (file+head
                    "Заметки/%<%Y%m%d%H%M%S>-${slug}.org"
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
          ("c" "Копия" plain "* Источник\n%A\n* ${title}\n%?"
           :target (file+head
                    "Заметки/%<%Y%m%d%H%M%S>-${slug}.org"
                    ":PROPERTIES:
:DATE:     %<%FT%T%z>
:ACCESS:   %^{Доступ|public|private|personal|confidentional}
:ROAM_ALIASES: %^{Синонимы (в кавычках)}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: копия
#+sourcetype: %^{Тип источника|статья|видео|аудио|занятие}
#+filetags: %^G"))
          ("o" "Организация")
          ("oa" "Ценность" plain "* Цели\n%?\n* Ценности\n* Проекты\n* Привычки\n:PROPERTIES:\n:CATEGORY: Привычка\n:END:\n* Заметки\n* Задачи"

           :target (file+head
                    "Организация/Ценности/area-${slug}.org"
                    ":PROPERTIES:
:DATE:         %<%FT%T%z>
:ACCESS:       %^{Доступ|public|private|personal|confidentional}
:CATEGORY:     %^{Category для Agenda}
:ROAM_ALIASES: %^{Синонимы (в кавычках)}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: организация
#+filetags: :${slug}:%^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("op" "Проект" plain "* Цели\n%?\n* Заметки\n* Проекты\n* Задачи"
           :target (file+head
                    "Организация/Проекты/${title}/proj-${slug}.org"
                    ":PROPERTIES:
:DATE:         %<%FT%T%z>
:ACCESS:       %^{Доступ|public|private|personal|confidentional}
:CATEGORY:     %^{Category для Agenda}
:ROAM_ALIASES: %^{Синонимы (в кавычках)}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: организация
#+filetags: :${slug}:%^G")
           :unnarrowed t
           :empty-lines-before 1)
          ("or" "План" plain "* Цели\n%?\n* Заметки\n* Проекты"
           :target (file+head
                    "Организация/Планирование/plan-${slug}.org"
                    ":PROPERTIES:
:DATE:         %<%FT%T%z>
:ACCESS:       %^{Доступ|public|private|personal|confidentional}
:ROAM_ALIASES: %^{Синонимы (в кавычках)}
:END:
#+title: ${title}
#+author: %n
#+language: %^{Язык|русский|english|français|中文}
#+notetype: организация
#+filetags: :${slug}:%^G")
           :unnarrowed t
           :empty-lines-before 1))))

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

(defun extract-org-roam-templates ()
  "Extract org-roam-capture-templates from config.org and save to org-roam-templates.el"
(let ((config-file (expand-file-name "config.org" doom-user-dir))
        (output-file (expand-file-name "org-roam-templates.el" doom-user-dir))
        (template-section nil))
    ;; (message "Читаем файл: %s" config-file)
    (with-temp-buffer
      ;; Читаем config.org
      (insert-file-contents config-file)
      (goto-char (point-min))
      ;; (message "Файл загружен, ищем шаблоны...")

      ;; Ищем начало секции с шаблонами
      (when (re-search-forward "(setq org-roam-capture-templates" nil t)
        ;; (message "Найдено в строке: %d" (line-number-at-pos))
        (beginning-of-line)
        (setq template-section (buffer-substring (point) (progn (forward-sexp) (point)))))

      ;; Если нашли, записываем в отдельный файл
      ;; (when template-section
        ;; (message "Шаблоны извлечены, записываем в %s" output-file)
        (with-temp-file output-file
          ;; (insert ";; Automatically extracted org-roam-capture-templates\n")
          (insert template-section)
          (insert "\n")))))

;; Автоматически запускать после сохранения config.org
(defun auto-extract-org-roam-templates ()
  "Run extract-org-roam-templates when saving config.org."
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.dotfiles/.config/doom/config.org"))
    (message "Extracting org-roam-templates")
    (extract-org-roam-templates)))

(add-hook 'after-save-hook #'auto-extract-org-roam-templates)

(after! org
  (setq org-brain-path org-directory))

(after! org
  (setq +org-capture-journal-file (expand-file-name "Дневник" org-directory)))

(defvar my/autocommit-timer "auto-commit-grimuar.timer" "Название auto-commit таймера")

(defun my/start-autocommit ()
  "Запустить таймер автокоммитов через systemd."
  (interactive)
  (let ((output (shell-command-to-string (format "systemctl --user start %s && echo 'Autocommit timer started'" my/autocommit-timer))))
    (message "%s" (string-trim output))))

(defun my/stop-autocommit ()
  "Остановить таймер автокоммитов через systemd."
  (interactive)
  (let ((output (shell-command-to-string (format "systemctl --user stop %s && echo 'Autocommit timer stopped'" my/autocommit-timer))))
    (message "%s" (string-trim output))))

(defun my/toggle-autocommit ()
  "Переключить таймер автокоммитов через systemd."
  (interactive)
  (let ((exit-code (call-process-shell-command
                    (format "systemctl --user is-active --quiet %s" my/autocommit-timer))))
    (if (eq exit-code 0)
        (my/stop-autocommit)
        (my/start-autocommit))))

(defvar my/autocommit-service "auto-commit-grimuar.service"
  "Имя systemd сервиса, запускающего скрипт один раз.")

(defun my/run-autocommit-once ()
  "Однократно выполнить автокоммит через systemd service."
  (interactive)
  (let ((output (shell-command-to-string (format "systemctl --user start %s && echo 'Гримуар auto-commit done'" my/autocommit-service))))
    (message "%s" (string-trim output))))

(map! :leader
      (:prefix "n" ;; notes menu
       (:prefix ("g" . "git")
       :desc "Enable autosave"        "e" #'my/start-autocommit
       :desc "Disable autosave"       "d" #'my/stop-autocommit
       :desc "Toggle autosatve"       "t" #'my/toggle-autocommit
       :desc "Save"                   "s" #'my/run-autocommit-once)))

(map! :leader
      (:prefix "t"  ;; toggle menu
       :desc "Toggle notes autosave"  "n" #'my/toggle-autocommit))

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
