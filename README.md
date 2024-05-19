# Darko's dotfiles

A collection of my dotfiles. Trying to keep it simple here, but you can find my configuration for the following software:

- Neovim
- zsh
- ranger
- tmux
- qtile
- leftwm
- alacritty
- fontconfig

Best way to get these dotfiles to their respective locations is to use [GNU stow](https://www.gnu.org/software/stow/):
```bash
stow --target=${HOME} *
```
