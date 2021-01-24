#!/usr/bin/bash 

# dotfiles path
DOTFILES=$(\
    builtin cd "$(\
    dirname "$(readlink -f "${BASH_SOURCE[0]}")")"\
    > /dev/null && pwd)
MACOS_DOTFILES=~/.macos-dotfiles

# prepare folders
mkdir -vp ~/.vim/undo
mkdir -vp ~/.vim/spell

# make soft symlinks
echo "- Symlinking dotfiles (${DOTFILES})"
"${MACOS_DOTFILES}/bin/ln_dotfiles"        ${DOTFILES}
ln -sfv ${MACOS_DOTFILES}/inputrc          ~/.inputrc
ln -sfv ${MACOS_DOTFILES}/bash_aliases     ~/.bash_aliases
ln -sfv ${MACOS_DOTFILES}/vim/*            ~/.vim
ln -sfv ${DOTFILES}/config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css
