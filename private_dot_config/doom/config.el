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
(setq org-directory "~/Documents/org/")


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

;; begin gtd config
(setq org-agenda-files '("projects.org" ))

;; ;; inbox setup
;; (setq org-capture-templates
;;        `(("i" "Inbox" entry  (file "inbox.org")
;;         ,(concat "* TODO %?\n"
;;                  "/Entered on/ %U"))))

;; (defun org-capture-inbox ()
;;      (interactive)
;;      (call-interactively 'org-store-link)
;;      (org-capture nil "i"))

;; (define-key global-map (kbd "C-c i") 'org-capture-inbox)

;; todo setup
(after! org (setq org-todo-keywords
      '((sequence "TODO" "NOW" "WAITING" "SOMEDAY" "SNOOZED" "NEXT"))))
;; TODO colors
(after! org (setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "systemGreenColor" :weight bold))
        ("NOW" . (:foreground "systemBlueColor" :weight bold))
        ("WAITING" . (:foreground "systemBrownColor" :weight bold))
        ("SOMEDAY" . (:foreground "systemGrayColor" :weight bold))
        ("SNOOZED" . (:foreground "systemGrayColor" :weight bold))
        ("NEXT" . (:foreground "labelColor" :weight bold))
        )))


;; agenda setup
;; (define-key global-map (kbd "C-c a") 'org-agenda)
;; (setq org-agenda-hide-tags-regexp ".") ;; hides all tags
(setq org-agenda-prefix-format
      '((agenda . " %i %-30b %-12t% s")
        (todo   . " %i %-30b %-12t")
        (tags   . " %i %-30b %-12t")
        (search . " %i %-30b %-12t")))

;; Agenda View "d"
(defun air-org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

  PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(setq org-agenda-skip-deadline-if-done t)

(setq org-agenda-custom-commands
      '(
        ;; Daily Agenda & TODOs
        ("d" "Daily agenda and all TODOs"
         (
          ;; View 7 days in the calendar view
          (agenda "" ((org-agenda-span 7)))
          ;; TODO items with custom header
          (todo "TODO" ((org-agenda-overriding-header "all normal priority TODO")))
         )
         ;; General settings for this view
         ((org-agenda-compact-blocks nil))
        )
      ))

(defun org-next-action()
  "Automatically add default properties to TODO entries."
  (when (string= (org-get-todo-state) "TODO")
    (org-entry-put nil "FOCUS_NEEDED" "medium")
    ;; (org-entry-put nil "PRIORITY" "A")
    (org-entry-put nil "ESTIMATED_TIME" "0:30")))
