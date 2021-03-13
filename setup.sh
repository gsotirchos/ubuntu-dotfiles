#!/usr/bin/bash

BRIGHT_COLOR='\033[0;97m'
NORMAL_COLOR='\033[0m'

# dotfiles path
DOTFILES=$(\
    builtin cd "$(\
    dirname "$(readlink -f "${BASH_SOURCE[0]}")"
    )" > /dev/null && pwd)

# macos dotfiles path
MACOS_DOTFILES=~/.macos-dotfiles
if [[ ! -d "${MACOS_DOTFILES}" ]] \
    || [[ -z "$( ls -A ${MACOS_DOTFILES})" ]]; then
    echo -e "${BRIGHT_COLOR}- Couldn't locate ~./macos-dotfiles folder, cloning...${NORMAL_COLOR}"
    git clone https://github.com/7555G/macos-dotfiles ${MACOS_DOTFILES}
    exit
fi

# prepare folders
mkdir -vp ~/.vim/undo
mkdir -vp ~/.vim/spell
mkdir -vp ~/.config/autostart
mkdir -vp ~/.local/share/fonts
touch ~/.hushlogin

# make soft symlinks
echo -e "${BRIGHT_COLOR}- Symlinking dotfiles (${DOTFILES})${NORMAL_COLOR}"
"${MACOS_DOTFILES}"/bin/ln_dotfiles "${DOTFILES}"
ln -sfv "${MACOS_DOTFILES}"/inputrc          ~/.inputrc
ln -sfv "${MACOS_DOTFILES}"/bash_aliases     ~/.bash_aliases
ln -sfv "${MACOS_DOTFILES}"/bash_prompt      ~/.bash_prompt
ln -sfv "${MACOS_DOTFILES}"/vimrc            ~/.vimrc
ln -sfv "${MACOS_DOTFILES}"/vim/*            ~/.vim
ln -sfv "${DOTFILES}"/config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css
ln -sfv "${DOTFILES}"/config/autostart/*     ~/.config/autostart
ln -sfv "${DOTFILES}"/fonts/*/*.otb          ~/.local/share/fonts

echo -e "${BRIGHT_COLOR}- Enable bitmap fonts & reconfigure fontconfig${NORMAL_COLOR}"
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo ln -sfv /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d
sudo dpkg-reconfigure fontconfig

# setup vundle
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    echo -e "${BRIGHT_COLOR}- Couldn't locate ~/.vim/bundle/Vundle.vim, setting up...${NORMAL_COLOR}"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

# setup julia
if command -v "julia" &> /dev/null; then
    echo -e "${BRIGHT_COLOR}- Setting up Julia${NORMAL_COLOR}"
    "${MACOS_DOTFILES}"/julia/setup-julia.sh
fi

echo -e "${BRIGHT_COLOR}- Don't forget to append the following in ~/.bashrc:
if [[ -f ~/.bash_extra ]]; then
    . ~/.bash_extra
fi${NORMAL_COLOR}"
