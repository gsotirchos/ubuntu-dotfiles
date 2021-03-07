#!/usr/bin/bash

# dotfiles path
DOTFILES=$(\
    builtin cd "$(\
    dirname "$(readlink -f "${BASH_SOURCE[0]}")"
    )" > /dev/null && pwd)

# macos dotfiles path
MACOS_DOTFILES=~/.macos-dotfiles
if [[ ! -d "${MACOS_DOTFILES}" ]] \
	|| [[ -z "$( ls -A ${MACOS_DOTFILES})" ]]; then
    echo "- Couldn't locate ~./macos-dotfiles folder, cloning..."
    git clone https://github.com/7555G/macos-dotfiles ${MACOS_DOTFILES}
    exit
fi

# prepare folders
mkdir -vp ~/.vim/undo
mkdir -vp ~/.vim/spell
mkdir -vp ~/.config/autostart
touch ~/.hushlogin

# make soft symlinks
echo "- Symlinking dotfiles (${DOTFILES})"
"${MACOS_DOTFILES}"/bin/ln_dotfiles "${DOTFILES}"
ln -sfv "${MACOS_DOTFILES}"/inputrc          ~/.inputrc
ln -sfv "${MACOS_DOTFILES}"/bash_aliases     ~/.bash_aliases
ln -sfv "${MACOS_DOTFILES}"/bash_prompt      ~/.bash_prompt
ln -sfv "${MACOS_DOTFILES}"/vimrc            ~/.vimrc
ln -sfv "${MACOS_DOTFILES}"/vim/*            ~/.vim
ln -sfv "${DOTFILES}"/config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css
ln -sfv "${DOTFILES}"/config/autostart/*     ~/.config/autostart
ln -sfv "${DOTFILES}"/fonts/*/*.otb          ~/.local/share/fonts

echo "- Enable bitmap fonts & reconfigure fontconfig"
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo ln -sfv /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d
sudo dpkg-reconfigure fontconfig

# setup julia
if command -v "julia" &> /dev/null; then
    echo -e "\n- Setting up Julia"
    "${MACOS_DOTFILES}"/julia/setup-julia.sh
fi
