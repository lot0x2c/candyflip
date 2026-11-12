# candyflip

A pink and teal colour theme for Emacs, in a light and a dark variant, built
on [base16-theme](https://github.com/tinted-theming/base16-emacs).

- **`base16-candy`**: light, candy pink-white background with plum text
- **`base16-acid`**: dark, dark plum background with pale pink text

| candy | acid |
|-------|------|
| ![candy, C](screenshots/candy-c.png) | ![acid, C](screenshots/acid-c.png) |
| ![candy, Org](screenshots/candy-org.png) | ![acid, Org](screenshots/acid-org.png) |

## Install

Needs Emacs 28.1+ and [`base16-theme`](https://github.com/tinted-theming/base16-emacs) 3.0+.

```elisp
(package-install 'base16-theme)
(add-to-list 'custom-theme-load-path "/path/to/candyflip/")
(load-theme 'base16-candy t)   ; or 'base16-acid
```

Doom Emacs, in `packages.el`, then `doom sync`:

```elisp
(package! base16-theme)
(package! candyflip
  :recipe (:host github :repo "lot0x2c/candyflip" :files ("*.el")))
```

and in `config.el`: `(setq doom-theme 'base16-candy)`.

## Usage

`M-x flip` switches between candy and acid.

## Configuration

You can build your own config on the website: pick the accent, contrast,
region and mode-line style, and bold/italic/underline per token, watch the
change live on your own code in both themes, then copy the generated `setq`
into your init file.

The website has everything else too: every option explained, the full
palette, how the colours were chosen, and all install methods.

<https://lot0x2c.github.io/p/candyflip/>

## License

[MIT](LICENSE)
