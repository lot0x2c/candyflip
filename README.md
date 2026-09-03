# bubblegum & gumball

A pair of pink/teal [base16](https://github.com/tinted-theming/base16-emacs) themes for Emacs.

- **base16-bubblegum**: light, candy pink-white background with plum text
- **base16-gumball**: its dark counterpart, dark plum background with pale pink text

## Install

Both themes need [`base16-theme`](https://github.com/tinted-theming/base16-emacs).

Manually:

```elisp
(package-install 'base16-theme)
(add-to-list 'custom-theme-load-path "/path/to/bubblegum-theme/")
(load-theme 'base16-bubblegum t)   ; or 'base16-gumball
```

Doom Emacs (`packages.el`):

```elisp
(package! base16-theme)
(package! bubblegum-theme
  :recipe (:host github :repo "ro15rend/bubblegum-theme" :files ("*.el")))
```

and in `config.el`: `(setq doom-theme 'base16-bubblegum)`.

## Palette

| slot   | bubblegum | gumball   |
|--------|-----------|-----------|
| base00 | `#feedf3` | `#1a1218` |
| base05 | `#5c4250` | `#d4b8c8` |
| base08 | `#ed286f` | `#f03878` |
| base0A | `#c13fd2` | `#d050e0` |
| base0B | `#08c7a4` | `#10d4b0` |
| base0D | `#00a2b8` | `#00b8d4` |
| base0E | `#f030a8` | `#f848b8` |

## License

MIT
