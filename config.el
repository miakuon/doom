;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; Commetary: My Doom Emacs Config

(setq user-full-name "Mia Kuon"
      user-mail-address "mia.kuon@gmail.com"
      doom-user-dir (getenv "DOOMDIR"))

(add-to-list 'initial-frame-alist '(fullscreen . fullboth))
(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)
(show-paren-mode 1)

(set-language-environment "Russian")
(prefer-coding-system 'utf-8)

(defun my-doom-dashboard-banner ()
  "Custom dashboard banner."
  (let* ((banner
          '("I had once screamed."
            "              Gradually, I lost my voice."
            "I had once cried."
            "              Gradually, I lost my tears."
            "I had once grieved."
            "              Gradually, I became able to withstand everything."
            "I had once rejoiced."
            "              Gradually, I became unmoved by the world."
            "And now!"
            " "
            "All I have left is an expressionless face,"
            "              My gaze is as tough as a monolith,"
            "Only perseverance remains in my heart."
            " "
            "This is my own insignificant person, Kuon Mia's – Perseverance!"
            " "
            " "))
         (width (window-width))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat
                 line (make-string (max 0 (- longest-line (length line)))
                                   32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(after! doom
  (setq +doom-dashboard-menu-sections
        '(("Recently opened files" :icon
           (nerd-icons-faicon "nf-fa-file_text" :face 'doom-dashboard-menu-title)
           :action recentf-open-files)
          ("Reload last session" :icon
           (nerd-icons-octicon "nf-oct-history" :face 'doom-dashboard-menu-title)
           :when
           (cond
            ((modulep! :ui workspaces)
             (file-exists-p
              (expand-file-name persp-auto-save-fname persp-save-dir)))
            ((require 'desktop nil t)
             (file-exists-p
              (desktop-full-file-name))))
           :action doom/quickload-session)
          ("Open org-agenda" :icon
           (nerd-icons-octicon "nf-oct-calendar" :face 'doom-dashboard-menu-title)
           :when
           (fboundp 'org-agenda)
           :action org-agenda)
          ("Open project" :icon
           (nerd-icons-octicon "nf-oct-briefcase" :face 'doom-dashboard-menu-title)
           :action projectile-switch-project)
          ("Jump to bookmark" :icon
           (nerd-icons-octicon "nf-oct-bookmark" :face 'doom-dashboard-menu-title)
           :action bookmark-jump)
          ("Open private configuration" :icon
           (nerd-icons-octicon "nf-oct-tools" :face 'doom-dashboard-menu-title)
           :when
           (file-directory-p doom-user-dir)
           :action doom/open-private-config)
          ("Open documentation" :icon
           (nerd-icons-octicon "nf-oct-book" :face 'doom-dashboard-menu-title)
           :action doom/help))
        +doom-dashboard-ascii-banner-fn #'my-doom-dashboard-banner
        +doom-dashboard-inhibit-refresh t))

;(map! :leader
;      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/Гримуар/"
        org-default-notes-file (expand-file-name "Организация/Входящее.org" org-directory)
        org-id-locations-file (expand-file-name ".orgids" org-directory)
        ;; org-ellipsis " ▼ " ; changes outline, default is "[...]"
        ;; org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        ;; org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
          '(("google" . "http://www.google.com/search?q=")
            ("archwiki" . "https://wiki.archlinux.org/index.php/")
            ("doomdir" . "/home/mia/.dotfiles/.config/doom/%s")
            ("emacsdir" . "/home/mia/.config/emacs/%s")
            ("doom-repo" . "https://github.com/doomemacs/doomemacs/%s")
            ("wolfram" . "https://wolframalpha.com/input/?i=%s")
            ("wikipedia" . "https://en.wikipedia.org/wiki/%s")
            ("duckduckgo" . "https://duckduckgo.com/?q=%s")
            ("gmap" . "https://maps.google.com/maps?q=%s")
            ("gimages" . "https://google.com/images?q=%s")
            ("youtube" . "https://youtube.com/watch?v=%s")
            ("github" . "https://github.com/%s"))
        ;; org-table-convert-region-max-lines 20000
        org-todo-keywords         ; This overwrites the default Doom org-todo-keywords
          '((sequence             ; Tasks
              "TODO(t)"           ; A task that is ready to be tackled
              "STRT(s)"           ; Task is started
              "WAIT(w)"           ; Something is holding up this task
              "IDEA(i)"           ; An idea that needs to be moved or to be done
              "PROJ(p)"           ; A project that contains other tasks
              "HBBT(h)"           ; A habbit
              "|"                 ; The pipe necessary to separate "active" states and "inactive" states
              "CANCELLED(c)"      ; Task has been cancelled
              "DONE(d)"           ; Task has been completed
              "FAIL(f)")          ; Task has been failed
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
                      (expand-file-name "config.org" doom-user-dir))
    (message "Extracting org-roam-templates")
    (extract-org-roam-templates)))

(add-hook 'after-save-hook #'auto-extract-org-roam-templates)

(after! org
  (cl-defmethod org-roam-node-slug ((node org-roam-node))
  "My custom slug of NODE."
  (let ((title (org-roam-node-title node)))
    (cl-flet* ((cl-replace (title pair) (replace-regexp-in-string (car pair) (cdr pair) title)))
      (let* ((pairs `(("[^[:word:][:digit:]]" . "_")  ;; convert anything not word chars, digits, or hyphens
                      ("__*" . "_")                    ;; remove sequential underscores
                      ("^_" . "")                      ;; remove starting underscore
                      ("_$" . "")))                    ;; remove ending underscore
             (slug (-reduce-from #'cl-replace title pairs)))
        (downcase slug))))))

;; Переменные конфигурации
(defvar ontology-file (expand-file-name "ontology.org" (getenv "DOOMDIR"))
  "Путь к файлу онтологий")

(defvar ontology-pattern "\\(_[^_]+_\\):\\s-*\\[\\[\\([^]]+\\)\\]\\[\\([^]]+\\)\\]\\]"
  "Регулярное выражение для поиска конструкций онтологии")

(defun ontology-extract-and-save ()
  "Извлекает онтологию из конструкции под курсором и сохраняет в ontology.org"
  (interactive)
  (let ((ontology-name (ontology-get-at-point)))

    (unless ontology-name
      (error "Курсор не находится на конструкции онтологии"))

    ;; Проверяем, существует ли уже такая онтология
    (let ((existing-category (ontology-get-category ontology-name)))
      (if existing-category
          (message "Онтология '%s' уже существует в категории '%s'" ontology-name existing-category)

        ;; Предлагаем выбрать категорию
        (let ((category (completing-read
                        (format "Выберите категорию для '%s': " ontology-name)
                        '("Parent" "Child" "Friend" "None" "Unassigned")
                        nil t)))

          ;; Добавляем онтологию в файл
          (ontology-add-to-file ontology-name category)
          (message "Онтология '%s' добавлена в категорию '%s'" ontology-name category))))))

(defun ontology-get-category (ontology-name)
  "Возвращает категорию онтологии или nil, если онтология не найдена"
  (when (file-exists-p ontology-file)
    (with-temp-buffer
      (insert-file-contents ontology-file)
      (goto-char (point-min))
      (let ((current-category nil)
            (found nil))
        (while (and (not (eobp)) (not found))
          (let ((line (string-trim (thing-at-point 'line t))))
            (cond
             ;; Заголовок категории
             ((string-match "^\\* \\(.+\\)$" line)
              (setq current-category (match-string 1 line)))
             ;; Элемент списка
             ((string-match "^-\\s-*\\(.+\\)$" line)
              (when (string= (match-string 1 line) ontology-name)
                (setq found current-category)))))
          (forward-line 1))
        found))))

(defun ontology-add-to-file (ontology category)
  "Добавляет онтологию в указанную категорию в файле"
  (with-temp-buffer
    ;; Если файл существует, загружаем его содержимое
    (when (file-exists-p ontology-file)
      (insert-file-contents ontology-file))

    ;; Если файл пустой или не существует, создаем базовую структуру
    (when (= (point-min) (point-max))
      (insert "* Parent\n* Friend\n* Child\n* None\n* Unassigned\n"))

    ;; Ищем нужную категорию
    (goto-char (point-min))
    (if (re-search-forward (format "^\\* %s$" category) nil t)
        (progn
          ;; Находим конец секции (следующий заголовок или конец файла)
          (let ((section-start (point))
                (section-end (if (re-search-forward "^\\*" nil t)
                                (progn (beginning-of-line) (point))
                              (point-max))))
            ;; Переходим к концу секции
            (goto-char section-end)
            ;; Если мы не в конце файла, вставляем перед следующим заголовком
            (when (< (point) (point-max))
              (backward-char))
            ;; Вставляем новую онтологию
            (unless (bolp) (insert "\n"))
            (insert (format "- %s\n" ontology))))

      ;; Если категория не найдена, добавляем её в конец
      (goto-char (point-max))
      (unless (bolp) (insert "\n"))
      (insert (format "* %s\n- %s\n" category ontology)))

    ;; Сохраняем файл
    (write-file ontology-file)))

(defun ontology-get-at-point ()
  "Возвращает название онтологии под курсором или nil"
  (save-excursion
    (beginning-of-line)
    (when (re-search-forward ontology-pattern (line-end-position) t)
      (substring (match-string 1) 1 -1))))

(defun ontology-list-all ()
  "Возвращает список всех онтологий из файла"
  (let ((ontologies nil))
    (when (file-exists-p ontology-file)
      (with-temp-buffer
        (insert-file-contents ontology-file)
        (goto-char (point-min))
        (while (re-search-forward "^-\\s-*\\(.+\\)$" nil t)
          (push (match-string 1) ontologies))))
    (reverse ontologies)))

;; Дополнительная функция для быстрого просмотра онтологий
(defun ontology-show-all ()
  "Показывает все существующие онтологии"
  (interactive)
  (let ((ontologies (ontology-list-all)))
    (if ontologies
        (message "Существующие онтологии: %s" (mapconcat 'identity ontologies ", "))
      (message "Файл онтологий пуст или не существует"))))

(after! org
  (setq +org-capture-journal-file (expand-file-name "Дневник" org-directory)))

(after! org
  (defvar org-contacts-directory (expand-file-name "Контакты/" org-directory) "Directory with Org Contacts files")
  (setq org-contacts-files (directory-files-recursively org-contacts-directory "\.org$")))

(after! ob-plantuml
  (setq plantuml-jar-path nil)
  (setq org-plantuml-jar-path plantuml-jar-path)
  (setq plantuml-exec-mode 'executable)
  (setq org-plantuml-exec-mode plantuml-exec-mode))

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
  (setq yas-snippet-dirs '((expand-file-name "snippets" doom-user-dir))))

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
        rmh-elfeed-org-files '((expand-file-name "elfeed.org" doom-user-dir))
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
