# candy & candy flip

A pair of pink/teal [base16](https://github.com/tinted-theming/base16-emacs) themes for Emacs.

- **base16-candy**: light, candy pink-white background with plum text
- **base16-candy-flip**: its dark counterpart, dark plum background with pale pink text

## Install

Both themes need [`base16-theme`](https://github.com/tinted-theming/base16-emacs).

Manually:

```elisp
(package-install 'base16-theme)
(add-to-list 'custom-theme-load-path "/path/to/candy-theme/")
(load-theme 'base16-candy t)   ; or 'base16-candy-flip
```

Doom Emacs (`packages.el`):

```elisp
(package! base16-theme)
(package! candy-theme
  :recipe (:host github :repo "ro15rend/candy-theme" :files ("*.el")))
```

and in `config.el`: `(setq doom-theme 'base16-candy)`.

## Options

Set these before `load-theme`. Changing them later with `setopt` or
`M-x customize-group RET candy` reloads the enabled theme.

| option | values | default |
|--------|--------|---------|
| `candy-accent` | `pink`, `teal` | `pink` |
| `candy-contrast` | `low`, `normal`, `high` | `normal` |
| `candy-region-style` | `inverse`, `background` (base02) | `inverse` |
| `candy-mode-line-style` | `flat`, `boxed` (accent border) | `flat` |
| `candy-transparent-background` | `nil`, `t` (terminal frames only) | `nil` |
| `candy-formats` | alist of token to `bold`/`italic`/`underline` | `nil` |

```elisp
(setq candy-accent 'teal
      candy-contrast 'high
      candy-formats '((keyword bold) (comment italic)))
(load-theme 'base16-candy-flip t)
```

Tokens for `candy-formats`: `keyword`, `string`, `function`, `type`,
`constant`, `variable`, `builtin`, `comment`, `preprocessor`, `doc`.

`high` raises every text color to a minimum contrast ratio against the
background; `low` pulls bright colors back toward it.

`M-x candy-toggle` switches between candy and candy flip.

For transparency in graphical Emacs (29+), use the frame parameter:
`(set-frame-parameter nil 'alpha-background 90)`.

## Palette

| slot   | candy | candy flip   |
|--------|-----------|-----------|
| base00 | `#feedf3` | `#1a1218` |
| base03 | `#816473` | `#927885` |
| base04 | `#745268` | `#aa8e9b` |
| base05 | `#5c4250` | `#d4b8c8` |
| base08 | `#d12362` | `#f03878` |
| base0A | `#ae39bd` | `#d050e0` |
| base0B | `#057b66` | `#10d4b0` |
| base0D | `#007888` | `#00b8d4` |
| base0E | `#c5278a` | `#f848b8` |
| base0F | `#cb2762` | `#db487b` |

## License

MIT
