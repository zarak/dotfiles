;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zarak Mahmud"
      user-mail-address "zarak@hotmail.ca")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 14 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;; (setq doom-font (font-spec :family "monospace" :size 16))
(setq doom-font (font-spec :family "Pragmata Pro Mono" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-horizon)
;; (setq doom-theme 'doom-old-hope)
;; (setq doom-theme 'doom-badger)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")
(setq org-roam-directory "~/Dropbox/org/roam/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Mappings to correspond to neovim lsp diagnostics
(map! :leader :prefix "]" :desc "Visit the N-th error from the current point." "d" #'flycheck-next-error)
(map! :leader :prefix "[" :desc "Visit the N-th previous error." "d" #'flycheck-previous-error)

;; (require 'company-org-roam)
;;     (use-package company-org-roam
;;       :when (featurep! :completion company)
;;       :after org-roam
;;       :config
;;       (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))

(use-package org-journal
      :bind
      ("C-c n j" . org-journal-new-entry)
      :custom
      (org-journal-dir "~/Dropbox/org/")
      (org-journal-date-prefix "#+TITLE: ")
      (org-journal-file-format "%Y-%m-%d.org")
      (org-journal-date-format "%A, %d %B %Y"))
    (setq org-journal-enable-agenda-integration t)

(use-package deft
      :after org
      :bind
      ("C-c n d" . deft)
      :custom
      (deft-recursive t)
      (deft-use-filter-string-for-filename t)
      (deft-default-extension "org")
      (deft-directory "~/Dropbox/org/"))

;; (after! org-roam
;;       (setq org-roam-capture-ref-templates
;;             '(("r" "ref" plain (function org-roam-capture--get-point)
;;                "%?"
;;                :file-name "websites/${slug}"
;;                :head "#+TITLE: ${title}
;;     #+ROAM_KEY: ${ref}
;;     - source :: ${ref}"
;;                :unnarrowed t))))

(after! company-lean
 (global-set-key (kbd "S-SPC") #'company-complete))

(setq org-file-apps
      '((auto-mode . emacs)
        ("\\.x?html?\\'" . "chromium %s")))

;; Allow Emacs to access content from clipboard.
(setq select-enable-clipboard t
      select-enable-primary t)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

;; Capture screenshot with keybinding using window manager
;; Source: https://yiufung.net/post/anki-org/
(defun make-orgcapture-frame ()
   "Create a new frame and run org-capture."
   (interactive)
   (make-frame '((name . "org-capture") (window-system . x)))
   (select-frame-by-name "org-capture")
   (counsel-org-capture)
   (delete-other-windows)
   )

(use-package! org-download
  :after org
  :config
  (setq-default
                org-download-method 'directory
                org-download-image-dir "~/Dropbox/org/anki/"
                org-download-heading-lvl nil
                org-download-delete-image-after-download t
                org-download-screenshot-method "flameshot gui --raw > %s"
                ;; org-download-screenshot-method "xclip -selection clipboard -t image/png -o > %s"
                ;; org-download-heading-lvl 1
                )
  )

(use-package anki-editor
  :after org
  :init
  (setq-default anki-editor-use-math-jax t)
  :hook (org-capture-after-finalize . anki-editor-reset-cloze-number) ; Reset cloze number after each capture
  :config
  (defun anki-editor-cloze-region-auto-incr (&optional arg)
    "Cloze region without hint and increase card number."
    (interactive)
    (anki-editor-cloze-region my-anki-editor-cloze-number "")
    (setq my-anki-editor-cloze-number (1+ my-anki-editor-cloze-number))
    (forward-sexp))
  (defun anki-editor-cloze-region-dont-incr (&optional arg)
    "Cloze region without hint using the previous card number."
    (interactive)
    (anki-editor-cloze-region (1- my-anki-editor-cloze-number) "")
    (forward-sexp))
  (defun anki-editor-reset-cloze-number (&optional arg)
    "Reset cloze number to ARG or 1"
    (interactive)
    (setq my-anki-editor-cloze-number (or arg 1)))
  (defun anki-editor-push-tree ()
    "Push all notes under a tree."
    (interactive)
    (anki-editor-push-notes '(4))
    (anki-editor-reset-cloze-number))
  ;; Initialize
  (anki-editor-reset-cloze-number)
  )

(defun my/anki-editor-push-notes-wrapper ()
  "Wrapper for 'anki-editor-push-notes' that warns if 'anki-editor' mode is not active."
  (interactive)
  (if anki-editor-mode
      (anki-editor-push-notes)
    (message "Error: anki-editor minor mode is not active. \
              Media will not appear in media.collections")))

(after! anki-editor
  (map! :leader
        :prefix "n"
        :desc "Insert anki note" "i" #'anki-editor-insert-note
        :desc "Push notes to anki" "p" #'my/anki-editor-push-notes-wrapper
        :desc "Capture and insert screenshot" "x" #'org-download-screenshot
        (:prefix ("A" . "Anki")
         :desc "Cloze region without hint and increase card number" "k" #'anki-editor-cloze-region-auto-incr
         :desc "Cloze region without hint using the previous card number" "l" #'anki-editor-cloze-region-dont-incr
         :desc "Reset cloze number to ARG or 1" "h" #'anki-editor-reset-cloze-number
         :desc "Push all notes under a tree" "p" #'anki-editor-push-tree
         )
        )
  )

;; (after! org
  ;; https://github.com/hlissner/doom-emacs/issues/407#issuecomment-363215144
  ;; (setq org-agenda-files '("~/Dropbox/org/roam/daily")))
  ;;
  ;; (custom-set-variables
  ;;  '(org-agenda-files (list
  ;;                      org-directory
  ;;                      org-roam-directory))))

(custom-set-variables
        '(org-agenda-files (list
                        ;; org-directory
                            org-roam-directory
                            (concat org-roam-directory "/daily"))))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Dropbox/org/roam"))
  :config
  (org-roam-setup)
  (require 'org-roam-protocol))

(after! org-roam
  (map! :leader
     (:prefix-map ("n" . "notes")
       (:prefix ("r" . "roam")
         :desc "Jump to the previous position in the mark ring." "o" #'org-mark-ring-goto
         :desc "org-roam-buffer-toggle" "l" #'org-roam-buffer-toggle
         :desc "org-roam-node-insert" "i" #'org-roam-node-insert
         ;; :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
         :desc "org-roam-node-find" "f" #'org-roam-node-find
         :desc "org-roam-graph" "g" #'org-roam-graph
         (:prefix ("d" . "dailies")
                :desc "org-roam-dailies-goto-today" "t" #'org-roam-dailies-goto-today
                :desc "org-roam-dailies-goto-tomorrow" "m" #'org-roam-dailies-goto-tomorrow
                :desc "org-roam-dailies-goto-yesterday" "y" #'org-roam-dailies-goto-yesterday
                :desc "org-roam-dailies-goto-date" "d" #'org-roam-dailies-goto-date
                :desc "org-roam-dailies-goto-previous-note" "n" #'org-roam-dailies-goto-previous-note
                :desc "org-roam-dailies-capture-today" "j" #'org-roam-dailies-capture-today)
         :desc "org-roam-capture" "c" #'org-roam-capture)))
  ;; Org-roam buffer display
  (setq org-roam-mode-sections
        (list #'org-roam-backlinks-section
              #'org-roam-reflinks-section
              ;; #'org-roam-unlinked-references-section
              ))
  ;; Org-roam capture templates
  (setq org-roam-dailies-capture-templates
          '(
          ;; ("d" "default" entry
          ;;  "* %?"
          ;;  :if-new (file+head "%<%Y-%m-%d>.org"
          ;;               "#+title: %<%Y-%m-%d>\n"))
          ("m" "math" entry
          "* TODO Group theory %?\n* TODO Number theory"
          :if-new (file+head "%<%Y-%m-%d>.org"
                                  "#+title: %<%Y-%m-%d>\n")))))

;; Org-capture templates
(after! org
(setq org-my-anki-file "~/Dropbox/org/anki/anki.org")
(add-to-list 'org-capture-templates
             '("a" "Anki basic"
               entry
               (file+headline org-my-anki-file "Dispatch Shelf")
               ;; "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:ANKI_DECK: All\n:END:\n** Front\n%?\n** Back\n%x\n"))
               "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:ANKI_DECK: All\n:END:\n** Front\n%?\n** Back\n%x\n"))
(add-to-list 'org-capture-templates
             '("A" "Anki cloze"
               entry
               (file+headline org-my-anki-file "Dispatch Shelf")
               "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Cloze\n:ANKI_DECK: All\n:END:\n** Text\n%x\n** Extra\n"))
(add-to-list 'org-capture-templates
             '("m" "Math basic"
               entry
               (file+headline org-my-anki-file "Dispatch Shelf")
               "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: MathBasic\n:ANKI_DECK: All\n:END:\n** Front\n%?\n** Back\n%x\n"))
)

(after! org
  ;; Org-pomodoro
  ;; (setq org-pomodoro-audio-player "mplayer")
  ;; (setq org-pomodoro-finished-sound-args "-volume 20")
  ;; (setq org-pomodoro-long-break-sound-args "-volume 20")
  ;; (setq org-pomodoro-short-break-sound-args "-volume 20")
  ;; (setq org-pomodoro-ticking-sound "-volume 30")
  (setq org-pomodoro-play-sounds nil)
  (setq org-pomodoro-ticking-sound-p t)

  ;; Play sound during pomodoro only (and not during breaks)
  (setq org-pomodoro-ticking-sound-states `(:pomodoro))
  )

;; Turn off autosave mode because org-roam generates tons of
;; autosave files due to dailies
(setq auto-save-default nil)


(use-package ob-sql-mode
  :ensure t)
(after! ob-sql-mode
  (require 'ob-sql-mode))

(setq shell-file-name (executable-find "bash"))

(use-package org-tufte
  :ensure nil
  :config
  (setq org-tufte-htmlize-code t
        org-tufte-embed-images nil
        org-tufte-goto-top-button t))
