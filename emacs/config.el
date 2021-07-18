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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-horizon)

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

(after! org-roam
        (map! :leader
            :prefix "n"
            :desc "org-roam-buffer-toggle" "l" #'org-roam-buffer-toggle
            :desc "org-roam-node-insert" "i" #'org-roam-node-insert
            ;; :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
            :desc "org-roam-node-find" "f" #'org-roam-node-find
            :desc "org-roam-graph" "g" #'org-roam-graph
            :desc "org-roam-dailies-capture-today" "j" #'org-roam-dailies-capture-today
            :desc "org-roam-capture" "c" #'org-roam-capture))

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

(use-package! org-drill
  :after org)

(after! org-drill
  (setq org-drill-left-cloze-delimiter "<["
        org-drill-right-cloze-delimiter "]>"))

(setq org-file-apps
      '((auto-mode . emacs)
        ("\\.x?html?\\'" . "chromium %s")))


;; Org-capture templates
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

;; Allow Emacs to access content from clipboard.
(setq select-enable-clipboard t
      select-enable-primary t)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

;;
;; From https://github.com/poligen/dotfiles/blob/25785810f9bf98f6eec93e400c686a4ad65ac310/doom.d/config.el
;; My customized org-download to incorporate flameshot gui Workaround to setup flameshot, which enables annotation.
;; In flameshot, set filename as "screenshot", and the command as "flameshot gui -p /tmp", so that we always ends up
;; with /tmp/screenshot.png. Nullify org-download-screenshot-method by setting it to `echo', so that essentially we
;; are only calling (org-download-image org-download-screenshot-file).
;; (defun hz-org-download-screenshot ()
;;   "Capture screenshot and insert the resulting file.
;; The screenshot tool is determined by `org-download-screenshot-method'."
;;   (interactive)
;;   (let ((tmp-file "/tmp/screenshot.png"))
;;     (delete-file tmp-file)
;;     (call-process-shell-command "flameshot gui -p /tmp/")
;;     ;; Because flameshot exit immediately, keep polling to check file existence
;;     (while (not (file-exists-p tmp-file))
;;       (sleep-for 2))
;;     (org-download-image tmp-file)))
;; (global-set-key (kbd "M-p") 'hz-org-download-screenshot)

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
  (setq-default org-download-image-dir "./images/"
                org-download-screenshot-method "flameshot gui --raw > %s"
                ;; org-download-screenshot-method "xclip -selection clipboard -t image/png -o > %s"
                org-download-delete-image-after-download t
                org-download-method 'directory
                org-download-heading-lvl 1
                org-download-screenshot-file "/tmp/screenshot.png"
                )
  )

(map! :leader
        :prefix "n"
        :desc "Push notes to anki" "p" #'anki-editor-push-notes
        :desc "Capture and insert screenshot" "x" #'org-download-screenshot
        )

;; https://github.com/hlissner/doom-emacs/issues/407#issuecomment-363215144
(after! org
  (setq org-agenda-files (list "~/Dropbox/org/roam/daily")))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Dropbox/org/roam")
  :config
  (org-roam-setup)
  (require 'org-roam-protocol))
