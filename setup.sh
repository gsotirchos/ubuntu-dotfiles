#!/usr/bin/bash
# shellcheck disable=SC1090,SC2155

BR_TEXT='\033[1;97m'
TEXT='\033[0m'

# dotfiles path
DOTFILES=$( \
    builtin cd "$( \
        dirname "$(readlink -f "${BASH_SOURCE[0]}")"
    )" > /dev/null && pwd)

# macos dotfiles path
MACOS_DOTFILES=~/.macos-dotfiles
if [[ ! -d "${MACOS_DOTFILES}" ]] \
    || [[ -z "$( ls -A ${MACOS_DOTFILES})" ]]; then
    echo -e "${BR_TEXT}- Couldn't locate ~./macos-dotfiles folder, cloning...${TEXT}"
    git clone https://github.com/gsotirchos/macos-dotfiles ${MACOS_DOTFILES}
    exit
fi

# prepare folders
mkdir -vp ~/.vim/undo
mkdir -vp ~/.vim/spell
mkdir -vp ~/.config/gtk-3.0
mkdir -vp ~/.config/autostart
mkdir -vp ~/.local/share/fonts
touch ~/.hushlogin

# make soft symlinks
# TODO: replace this mess with a "macos-dotfiles submodule" & symlinks
echo -e "${BR_TEXT}- Symlinking dotfiles (${DOTFILES})${TEXT}"
source "${MACOS_DOTFILES}"/etc/ln_dotfiles.sh "${DOTFILES}" "${HOME}/."
ln -sfv "${DOTFILES}"/config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css
ln -sfv "${DOTFILES}"/config/autostart/*     ~/.config/autostart
ln -sfv "${DOTFILES}"/config/redshift.conf   ~/.config/redshift.conf
ln -sfv "${DOTFILES}"/fonts/*/*.otb          ~/.local/share/fonts
ln -sfv "${MACOS_DOTFILES}"/inputrc          ~/.inputrc
ln -sfv "${MACOS_DOTFILES}"/bash_extra       ~/.bash_extra
ln -sfv "${MACOS_DOTFILES}"/bash_aliases     ~/.bash_aliases
ln -sfv "${MACOS_DOTFILES}"/bash_prompt      ~/.bash_prompt
ln -sfv "${MACOS_DOTFILES}"/vim/*            ~/.vim
ln -sfv "${MACOS_DOTFILES}"/condarc          ~/.condarc

# enable bitmap fonts
echo -e "${BR_TEXT}\n- Enable bitmap fonts & reconfigure fontconfig${TEXT}"
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo ln -sfv /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d
sudo dpkg-reconfigure fontconfig

# setup vundle
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    echo -e "${BR_TEXT}\n- Couldn't locate ~/.vim/bundle/Vundle.vim, setting up...${TEXT}"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

# setup julia
if command -v "julia" &> /dev/null; then
    echo -e "${BR_TEXT}\n- Setting up Julia${TEXT}"
    source "${MACOS_DOTFILES}"/julia/setup-julia.sh
fi

echo -e "${BR_TEXT}\n- Don't forget to append the following to ~/.bashrc${TEXT}:
if [[ -f ~/.bash_extra ]]; then
    source ~/.bash_extra
fi"
