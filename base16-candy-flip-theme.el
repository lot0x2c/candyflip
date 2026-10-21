;;; base16-candy-flip-theme.el --- dark counterpart to candy -*- lexical-binding: t; -*-

;; Author: ro15rend
;; URL: https://github.com/ro15rend/candy-theme
;; Version: 0.2.0
;; Package-Requires: ((emacs "28.1") (base16-theme "3.0"))
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

(defconst base16-candy-flip-theme-colors
  '(:base00 "#1a1218"    ; bg, dark plum
    :base01 "#2a2028"    ; lighter bg, dark mauve
    :base02 "#3d2d38"    ; selection, dusty plum
    :base03 "#927885"    ; comments, muted mauve
    :base04 "#aa8e9b"    ; dark fg, faded rose
    :base05 "#d4b8c8"    ; fg, pale pink
    :base06 "#e8d0dc"    ; lighter fg, soft blush
    :base07 "#f5e8ef"    ; lightest fg, pink-white
    :base08 "#f03878"
    :base09 "#d47098"
    :base0A "#d050e0"
    :base0B "#10d4b0"
    :base0C "#00c8b0"
    :base0D "#00b8d4"
    :base0E "#f848b8"
    :base0F "#db487b")
  "All colors for Base16 Flip are defined here.")

(deftheme base16-candy-flip)

(candy-define 'base16-candy-flip base16-candy-flip-theme-colors
                  '((org-level-3 :foreground base09 :weight bold)))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'base16-candy-flip)

(provide 'base16-candy-flip-theme)

;;; base16-candy-flip-theme.el ends here
