;;; base16-candy-theme.el --- a pink/teal light theme for emacs -*- lexical-binding: t; -*-

;; Author: ro15rend
;; URL: https://github.com/ro15rend/candy-theme
;; Version: 0.2.0
;; Package-Requires: ((base16-theme "0"))
;; Keywords: faces themes

;;; Commentary:

;; keep the palette in one place for all generated faces.

;;; Code:

(require 'base16-theme)
;; theme files are found through `custom-theme-load-path', which is
;; not `load-path', so load the shared file from this directory
(require 'candy-common
         (expand-file-name "candy-common"
                           (file-name-directory
                            (or (macroexp-file-name) buffer-file-name))))

(defconst base16-candy-theme-colors
  '(:base00 "#feedf3"    ; bg, candy pink-white
    :base01 "#f8e2e7"    ; lighter bg, blush
    :base02 "#e0ccd1"    ; selection, petal
    :base03 "#816473"    ; comments, dusty mauve
    :base04 "#745268"    ; dark fg, dusty rose
    :base05 "#5c4250"    ; fg, plum
    :base06 "#463840"    ; darker fg, dark mauve
    :base07 "#352930"    ; darkest fg, deep plum
    :base08 "#d12362"
    :base09 "#a45174"
    :base0A "#ae39bd"
    :base0B "#057b66"
    :base0C "#007a6c"
    :base0D "#007888"
    :base0E "#c5278a"
    :base0F "#cb2762")
  "All colors for Base16 Candy are defined here.")

(deftheme base16-candy)

(candy-define 'base16-candy base16-candy-theme-colors)

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'base16-candy)

(provide 'base16-candy-theme)

;;; base16-candy-theme.el ends here
