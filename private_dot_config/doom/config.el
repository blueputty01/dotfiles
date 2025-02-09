;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Nextcloud/org/")

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

(setq which-key-idle-delay 0.5)

;; interacting with internet
;; (after! org-download
;;       (setq org-download-method 'directory)
;;       (setq org-download-image-dir (concat (file-name-sans-extension (buffer-file-name)) "-img"))
;;       (setq org-download-image-org-width 600)
;;       (setq org-download-link-format "[[file:%s]]\n"
;;         org-download-abbreviate-filename-function #'file-relative-name)
;;       (setq org-download-link-format-function #'org-download-link-format-function-default))

;; (setq org-download-image-dir ".attachments")

;; adapted from https://gist.github.com/kim366/8abe978cc295b027df636b218862758e
;; Automatically fetch link description (C-c C-l) for link at point

(defun my/url-get-title (url &optional descr)
  "Fetch the title of the page at URL. Return an error message on failure."
  (let ((buffer (url-retrieve-synchronously url t)))
    (if buffer
        (with-current-buffer buffer
          (goto-char (point-min))
          (if (search-forward-regexp (rx "<title>" (group (*? anything)) "</title>") nil t)
              (prog1
                  (match-string 1)
                (kill-buffer buffer)) ;; Clean up buffer
            (prog1
                "No title found"
              (kill-buffer buffer)))) ;; Clean up buffer
      "Failed to fetch URL")))

(setq org-make-link-description-function 'my/url-get-title)

;; https://emacs.stackexchange.com/questions/12121/org-mode-parsing-rich-html-directly-when-pasting
(defun kdm/html2org-clipboard ()
  "Convert clipboard contents from HTML to Org and then paste (yank)."
  (interactive)
  (kill-new (shell-command-to-string "osascript -e 'the clipboard as \"HTML\"' | perl -ne 'print chr foreach unpack(\"C*\",pack(\"H*\",substr($_,11,-3)))' | pandoc -f html -t json | pandoc -f json -t org | sed 's/ / /g'"))
  (yank))
(define-key global-map (kbd "C-c v") 'kdm/html2org-clipboard)
;; "xclip -o -t text/html | pandoc -f html -t json | pandoc -f json -t org"
;; begin gtd config
(setq org-agenda-files '("1 GTD/projects.org" ))

;; inbox setup
(setq org-inbox-directory (concat org-directory "0 Inbox/"))

(defun open-new-project-file ()
   (let ((fpath (expand-file-name
                 (read-file-name "Project file name: "
                                 org-inbox-directory
                               nil nil nil))))
    fpath))  ; Return the file path instead of opening it

(setq org-capture-templates
      `(("i" "Inbox" plain
         (file open-new-project-file)  ; Remove the function call parentheses
         "#+title: %?")))
(define-key global-map (kbd "C-c c") 'org-capture)

(defun org-capture-inbox ()
  "Capture a new item to the inbox using the defined template."
  (interactive)
  (org-capture nil "i"))

(define-key global-map (kbd "C-c i") 'org-capture-inbox)


;; todo setup
(after! org (setq org-todo-keywords
                  '((sequence "TODO" "TODOLOW" "WAITING" "SOMEDAY" "SNOOZED" "NEXT" "DEADLINE"))))
;; TODO colors
(after! org (setq org-todo-keyword-faces
                  '(
                    ("TODO" . (:foreground "systemGreenColor" :weight bold))
                    ("TODOLOW" . (:foreground "systemGreenColor" :weight bold))
                    ("WAITING" . (:foreground "systemBrownColor" :weight bold))
                    ("SOMEDAY" . (:foreground "systemGrayColor" :weight bold))
                    ("SNOOZED" . (:foreground "systemGrayColor" :weight bold))
                    ("NEXT" . (:foreground "systemGrayColor" :weight bold))
                    ("DEADLINE" . (:foreground "systemYellowColor" :weight bold))
                    )))

;; agenda setup
(define-key global-map (kbd "C-c a") 'org-agenda)

(setq org-startup-with-inline-images t)

;; (defun my/org-agenda-truncate-breadcrumb (breadcrumb max-length)
;;   "Truncate the BREADCRUMB string from the beginning if it exceeds MAX-LENGTH."
;;   (if (> (length breadcrumb) max-length)
;;       (concat "…" (substring breadcrumb (- (length breadcrumb) max-length)))
;;     breadcrumb))

;; (defun my/org-agenda-format-prefix (marker)
;;   "Custom format for agenda prefix, truncating the breadcrumb if needed."
;;   (let ((breadcrumb (org-get-outline-path marker))
;;         (max-length 20)) ;; Set the desired max length for breadcrumbs
;;     (if breadcrumb
;;         (format " %s" (my/org-agenda-truncate-breadcrumb
;;                        (string-join breadcrumb "/") max-length))
;;       "")))

;; (advice-add 'org-agenda-format-item :around
;;             (lambda (orig-fn extra txt &rest args)
;;               "Apply custom prefix formatting for Org Agenda items."
;;               (let* ((marker (get-text-property 0 'org-marker txt))
;;                      (prefix (if marker (my/org-agenda-format-prefix marker) "")))
;;                 (apply orig-fn extra (concat prefix txt) args))))



(defun org-next-action()
  "Automatically add default properties to TODO entries."
  (when (string= (org-get-todo-state) "TODO")
    (org-entry-put nil "FOCUS_NEEDED" "medium")
    ))


(use-package! org-super-agenda :after org-agenda :config (org-super-agenda-mode))


(setq org-agenda-prefix-format
      '((agenda . "%-12s %-5e %-30b")
       (timeline . "  % s")
       (todo . " %i %-12:c")
       (tags . " %i %-12:c")
       (search . " %i %-12:c")))

(defun my/count-inbox-files ()
  "Count files in the inbox directory."
  (length (directory-files org-inbox-directory nil "\\.org$")))
(defun my/inbox-warning-string ()
  "Create a warning string about inbox files."
  (let ((count (my/count-inbox-files)))
    (when (> count 0)
      (propertize (format "⚠ You have %d file(s) in your inbox!" count)
                  'face '(:foreground "red" :weight bold)))))
(setq org-agenda-custom-commands
      '(
        ("d" "Dashboard"
         (
         (tags "TODO=\"SOMEDAY\"-SCHEDULED={.+}"
                ((org-agenda-prefix-format "%-50b %s")
                 (org-agenda-overriding-header "Not scheduled reviews")))
          ;; SNOOZED items with deadlines or scheduled dates for today or earlier
          ;; (tags "+SNOOZED+DEADLINE<=<now>|+SNOOZED+SCHEDULED<=<now>"
          (tags "TODO=\"SNOOZED\"+SCHEDULED<=\"<now>\""
                ;; (todo "SNOOZED"
                ((org-agenda-overriding-header "SNOOZED Items")
                 (org-agenda-prefix-format "%-50b")
                 (org-agenda-sorting-strategy '(deadline-up))))

          ;; WAITING items
          (todo "WAITING"
                ((org-agenda-overriding-header "WAITING Items")
                 (org-agenda-sorting-strategy '(deadline-up))))

          ;; DEADLINE items: items with a deadline that have not been turned into actions
          (todo "DEADLINE"
                ((org-agenda-overriding-header "DEADLINE Items")
                 (org-agenda-sorting-strategy '(deadline-up))))

          ;; (agenda "" ((org-agenda-span 7)))
          ;; Next 7 days (excluding SOMEDAY)
          (agenda ""
                  ((org-agenda-span 7)
                   (org-agenda-overriding-header "Next 7 Days (Excluding SOMEDAY)")
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'todo '("SOMEDAY")))))

          ;; Categorized by Tags
          (todo "TODO"
                     (
                      (org-agenda-prefix-format "%-30b %e %s")
                      (org-agenda-remove-tags t)
                      (org-agenda-sorting-strategy '(deadline-up priority-up effort-up))
                      (org-super-agenda-groups
                       '(
                         ;; (:name "School" :and (:heading-regexp ("school.*") :auto-parent ""))
                         (:name "House" :tag "@house" )
                         (:name "Makerspace" :tag "@makerspace" )
                         (:name "Mom" :tag "@mom" )
                         (:name "Jessica" :tag "@jessica")
                         (:name "Store" :tag "@store")
                         (:name "Amazon" :tag "@amazon")
                         (:name "Bike Shop" :tag "@bikeshop")
                         (:name "Untagged"  )))))
          )
         ((org-agenda-start-with-log-mode nil)
          (org-agenda-window-setup 'current-window)
          (org-agenda-start-with-follow-mode nil)
          (org-agenda-block-separator ?─)
          ;; Add the warning through a different mechanism
          (org-agenda-finalize-hook (lambda () (insert (or (my/inbox-warning-string) "") "\n\n")))
          )
         )
        ("w" "Weekly Review"
         (
          ;; (agenda "" ((org-agenda-skip-function `(org-agenda-skip-entry-if 'todo '("WAITING" "TODO" "TODOLOW" "SNOOZED")))))
          (tags "TODO=\"SOMEDAY\"-SCHEDULED={.+}"
                ((org-agenda-prefix-format "%-50b %s")
                 (org-agenda-overriding-header "Not scheduled reviews")))
          (tags "TODO=\"SOMEDAY\"+SCHEDULED<=\"<now>\""
                ((org-agenda-prefix-format "%-50b %s")
                 (org-agenda-overriding-header "Scheduled or Past Scheduled SOMEDAY Items")))
         (tags "TODO=\"SOMEDAY\"+SCHEDULED>\"<now>\""
               ((org-agenda-overriding-header "Future SOMEDAY items"))))
         )
        ))

;; org roam config
(setq org-roam-directory org-directory)
(setq org-roam-capture-templates
       '(("d" "default" plain
          "%?"
          :if-new (file+head "0 Inbox/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
          :unnarrowed t)
         ("t" "tag" plain
          "%?"
          :if-new (file+head "4 Tags/${slug}.org" "#+title: ${title}\n")
          :unnarrowed t)
         ("s" "source material" plain
          "%?"
          :if-new (file+head "5 Sources/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n\n* tags\n\n\n")
          :unnarrowed t)
         ("n" "note" plain
          "%?"
          :if-new (file+head "3 Notes/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n\n* tags\n\n\n* references")
          :unnarrowed t)
         ))

(define-key global-map (kbd "C-c n") 'org-roam-capture)
