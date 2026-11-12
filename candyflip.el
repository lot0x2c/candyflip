;;; candyflip.el --- shared options for candy and acid -*- lexical-binding: t; -*-

;; Author: lot0x2c
;; URL: https://github.com/lot0x2c/candyflip
;; Version: 0.2.0
;; Package-Requires: ((emacs "28.1") (base16-theme "3.0"))
;; Keywords: faces themes

;;; Commentary:

;; options shared by base16-candy and base16-acid.  set them
;; before `load-theme', or with `setopt'/customize afterwards, which
;; reloads the enabled theme.

;;; Code:

(require 'base16-theme)
(require 'cl-lib)

;;; options

(defgroup candyflip nil
  "Options for the candy and acid themes."
  :group 'faces
  :prefix "candyflip-")

(defun candyflip--reload ()
  "Reload whichever candyflip theme is enabled."
  (dolist (theme '(base16-candy base16-acid))
    (when (custom-theme-enabled-p theme)
      (load-theme theme t))))

(defun candyflip--set (symbol value)
  "Set SYMBOL to VALUE and reload the enabled candyflip theme."
  (set-default symbol value)
  (candyflip--reload))

(defcustom candyflip-accent 'pink
  "Accent color for the cursor, links, prompts, search and parens."
  :type '(choice (const :tag "Pink (base0E)" pink)
                 (const :tag "Teal (base0C)" teal))
  :set #'candyflip--set
  :initialize #'custom-initialize-default)

(defcustom candyflip-contrast 'normal
  "How far the text colors stand out from the background.
`high' raises every text color to a minimum contrast ratio, `low'
pulls bright colors back toward the background."
  :type '(choice (const low) (const normal) (const high))
  :set #'candyflip--set
  :initialize #'custom-initialize-default)

(defcustom candyflip-region-style 'inverse
  "How the selected region is drawn.
`inverse' swaps foreground and background, so it works over any
text color.  `background' uses the base02 background."
  :type '(choice (const :tag "Inverse video" inverse)
                 (const :tag "base02 background" background))
  :set #'candyflip--set
  :initialize #'custom-initialize-default)

(defcustom candyflip-mode-line-style 'flat
  "Style of the active mode line.
`boxed' draws a 1px border in the accent color."
  :type '(choice (const flat) (const boxed))
  :set #'candyflip--set
  :initialize #'custom-initialize-default)

(defcustom candyflip-transparent-background nil
  "Non-nil leaves the background unset in terminal frames.
This lets a transparent terminal show through.  Graphical frames
keep the theme background; use the `alpha-background' frame
parameter for those."
  :type 'boolean
  :set #'candyflip--set
  :initialize #'custom-initialize-default)

(defcustom candyflip-formats nil
  "Extra text formats per token type.
An alist of (TOKEN . FORMATS), where FORMATS is a list of `bold',
`italic' and `underline'.  For example:

  \\='((keyword bold) (comment italic))"
  :type '(alist :key-type (choice (const keyword) (const string)
                                  (const function) (const type)
                                  (const constant) (const variable)
                                  (const builtin) (const comment)
                                  (const preprocessor) (const doc))
                :value-type (set (const bold) (const italic)
                                 (const underline)))
  :set #'candyflip--set
  :initialize #'custom-initialize-default)

;;; color math

(defun candyflip--rgb (hex)
  "Return HEX as a list of three floats between 0 and 1."
  (mapcar (lambda (i) (/ (string-to-number (substring hex i (+ i 2)) 16) 255.0))
          '(1 3 5)))

(defun candyflip--hex (rgb)
  "Return RGB, a list of three floats, as a hex color string."
  (apply #'format "#%02x%02x%02x"
         (mapcar (lambda (c) (round (* 255 (min 1.0 (max 0.0 c))))) rgb)))

(defun candyflip--luminance (hex)
  "Return the WCAG relative luminance of HEX."
  (let ((c (mapcar (lambda (x)
                     (if (<= x 0.03928) (/ x 12.92)
                       (expt (/ (+ x 0.055) 1.055) 2.4)))
                   (candyflip--rgb hex))))
    (+ (* 0.2126 (nth 0 c)) (* 0.7152 (nth 1 c)) (* 0.0722 (nth 2 c)))))

(defun candyflip--contrast (a b)
  "Return the WCAG contrast ratio between colors A and B."
  (let ((la (candyflip--luminance a))
        (lb (candyflip--luminance b)))
    (/ (+ (max la lb) 0.05) (+ (min la lb) 0.05))))

(defun candyflip--mix (a b frac)
  "Return color A moved FRAC of the way toward color B."
  (candyflip--hex (cl-mapcar (lambda (x y) (+ x (* frac (- y x))))
                             (candyflip--rgb a) (candyflip--rgb b))))

(defun candyflip--push (color bg target done-p)
  "Mix COLOR toward TARGET in small steps until DONE-P holds against BG."
  (let ((frac 0.0) (out color))
    (while (and (not (funcall done-p (candyflip--contrast out bg)))
                (< frac 1.0))
      (setq frac (+ frac 0.02)
            out (candyflip--mix color target frac)))
    out))

;; minimum (high) and maximum (low) contrast ratios per slot; the
;; accent slots share the `t' entry.
(defconst candyflip--contrast-targets
  '((high (:base03 . 5.5) (:base04 . 7.5) (:base05 . 11.0)
          (:base06 . 12.0) (:base07 . 13.0) (t . 6.0))
    (low  (:base03 . 3.0) (:base04 . 4.5) (:base05 . 6.0)
          (:base06 . 7.0) (:base07 . 8.0) (t . 4.5)))
  "Contrast ratio targets for each `candyflip-contrast' level.")

(defun candyflip-adjust-colors (colors)
  "Return a copy of the base16 plist COLORS adjusted for `candyflip-contrast'."
  (let* ((targets (alist-get candyflip-contrast candyflip--contrast-targets))
         (bg (plist-get colors :base00))
         (away (if (< (candyflip--luminance bg) 0.5) "#ffffff" "#000000"))
         (out (copy-sequence colors)))
    (when targets
      (dolist (slot '(:base03 :base04 :base05 :base06 :base07 :base08 :base09
                      :base0A :base0B :base0C :base0D :base0E :base0F))
        (let ((ratio (or (alist-get slot targets) (alist-get t targets)))
              (color (plist-get colors slot)))
          (setq out (plist-put
                     out slot
                     (if (eq candyflip-contrast 'high)
                         (candyflip--push color bg away (lambda (r) (>= r ratio)))
                       (candyflip--push color bg bg (lambda (r) (<= r ratio)))))))))
    out))

;;; faces

(defconst candyflip--token-faces
  '((keyword      font-lock-keyword-face base0E)
    (string       font-lock-string-face base0B)
    (function     font-lock-function-name-face base0D)
    (type         font-lock-type-face base0A)
    (constant     font-lock-constant-face base09)
    (variable     font-lock-variable-name-face base08)
    (builtin      font-lock-builtin-face base0C)
    (comment      font-lock-comment-face base03)
    (comment      font-lock-comment-delimiter-face base03)
    (preprocessor font-lock-preprocessor-face base0D)
    (doc          font-lock-doc-face base04))
  "Token types for `candyflip-formats', with their face and base16 slot.")

(defun candyflip--format-faces ()
  "Return base16 face specs for the entries in `candyflip-formats'."
  (let (specs)
    (pcase-dolist (`(,token ,face ,slot) candyflip--token-faces)
      (when-let* ((formats (alist-get token candyflip-formats)))
        (push `(,face :foreground ,slot
                      ,@(when (memq 'bold formats) '(:weight bold))
                      ,@(when (memq 'italic formats) '(:slant italic))
                      ,@(when (memq 'underline formats) '(:underline t)))
              specs)))
    specs))

(defun candyflip--option-faces ()
  "Return base16 face specs for the accent, region and mode-line options."
  (let ((accent (if (eq candyflip-accent 'teal) 'base0C 'base0E)))
    `((cursor                   :background ,accent)
      (link                     :foreground ,accent :underline t)
      (minibuffer-prompt        :foreground ,accent)
      (isearch                  :foreground ,accent :background base01 :inverse-video t)
      (show-paren-match         :foreground base01 :background ,accent)
      (line-number-current-line :foreground ,accent :inherit fringe)
      (mode-line-highlight      :foreground ,accent :box nil :weight bold)
      (tab-bar-tab              :foreground ,accent :background base01)
      ,@(when (eq candyflip-region-style 'inverse)
          '((region :background unspecified :foreground unspecified :inverse-video t)))
      ,@(when (eq candyflip-mode-line-style 'boxed)
          `((mode-line :foreground base16-settings-mode-line-fg :background base02
                       :box (:line-width 1 :color ,accent)))))))

(defun candyflip--transparent (spec colors)
  "Turn base16 SPEC into a face spec with no background on terminals.
COLORS is the palette used to resolve slot names."
  (let ((face (base16-theme-transform-face spec colors)))
    (list (car face)
          (mapcar (lambda (clause)
                    (if (equal (car clause) '((type graphic)))
                        clause
                      (list (car clause)
                            (plist-put (copy-sequence (cadr clause))
                                       :background "unspecified-bg"))))
                  (cadr face)))))

(defun candyflip-define (theme colors &optional extra-faces)
  "Define THEME from the base16 plist COLORS with the candyflip options applied.
EXTRA-FACES is a list of base16 face specs for this theme only."
  (let ((colors (candyflip-adjust-colors colors)))
    ;; the first spec a theme declares for a face wins, so every
    ;; override goes in before `base16-theme-define'
    (when candyflip-transparent-background
      (apply #'custom-theme-set-faces theme
             (mapcar (lambda (spec) (candyflip--transparent spec colors))
                     '((default :foreground base05 :background base00)
                       (line-number :foreground base03 :background base16-settings-fringe-bg)))))
    (base16-theme-set-faces theme colors
                            (append (candyflip--format-faces)
                                    (candyflip--option-faces)
                                    extra-faces))
    (base16-theme-define theme colors)))

;;; commands

;;;###autoload
(defun candyflip-toggle ()
  "Switch between the candy and acid themes."
  (interactive)
  (let ((next (if (custom-theme-enabled-p 'base16-candy)
                  'base16-acid
                'base16-candy)))
    (dolist (theme '(base16-candy base16-acid))
      (when (custom-theme-enabled-p theme)
        (disable-theme theme)))
    (load-theme next t)))

;;;###autoload
(defalias 'flip #'candyflip-toggle
  "Switch between the candy and acid themes.")

(provide 'candyflip)

;;; candyflip.el ends here
