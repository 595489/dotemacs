;; Remove welcome screen - open directly in scratch buffer
(setq inhibit-startup-message t
      initial-scratch-message ""
      initial-major-mode 'fundamental-mode
      inhibit-splash-screen t)

;; PDF stuff
(setq doc-view-continous t)

;; Visible bell
(setq visible-bell 1)

;; Line numbers as default
(setq global-display-line-numbers-mode t)

;; https://stackoverflow.com/questions/28221079/ctrl-backspace-in-emacs-deletes-too-much
;;; Intellij-style smart backward-kill-word
(defun aborn/backward-kill-word ()
  "Customize/Smart backward-kill-word."
  (interactive)
  (let* ((cp (point))
         (backword)
         (end)
         (space-pos)
         (backword-char (if (bobp)
                            ""           ;; cursor in begin of buffer
                          (buffer-substring cp (- cp 1)))))
    (if (equal (length backword-char) (string-width backword-char))
        (progn
          (save-excursion
            (setq backword (buffer-substring (point) (progn (forward-word -1) (point)))))
          (setq ab/debug backword)
          (save-excursion
            (when (and backword          ;; when backword contains space
                       (s-contains? " " backword))
              (setq space-pos (ignore-errors (search-backward " ")))))
          (save-excursion
            (let* ((pos (ignore-errors (search-backward-regexp "\n")))
                   (substr (when pos (buffer-substring pos cp))))
              (when (or (and substr (s-blank? (s-trim substr)))
                        (s-contains? "\n" backword))
                (setq end pos))))
          (if end
              (kill-region cp end)
            (if space-pos
                (kill-region cp space-pos)
              (backward-kill-word 1))))
      (kill-region cp (- cp 1)))         ;; word is non-english word
    ))

;;; Overwrite default function bound to key
(global-set-key [C-backspace]
                'aborn/backward-kill-word)

;; Org-roam
;;(setq org-roam-directory (file-truename "~/org-roam"))
;;(org-roam-db-autosync-mode)
;; Uncomment if using a vertical completion framework (IVY, SELECTRUM, etc)
;;(setq org-roam-node-display-template
;;      (concat "${title:*}"
;;	      (propertize "${tags:10}" 'face 'org-tag)))

;; ROS config
(add-to-list 'load-path "/opt/ros/noetic/share/emacs/site-lisp")
(require 'rosemacs-config)
(invoke-rosemacs)

;; Melpa package enabling
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Set theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/moe/moe-theme.el/")
(add-to-list 'load-path "~/.emacs.d/themes/moe/moe-theme.el/")
(require 'moe-theme)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org-roam tabbar session pod-mode muttrc-mode mutt-alias markdown-mode initsplit htmlize graphviz-dot-mode folding eproject diminish csv-mode browse-kill-ring boxquote bm bar-cursor apache-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
