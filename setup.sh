#!/usr/bin/bash

BR_TEXT='\033[0;97m'
DEF_TEXT='\033[0m'

# dotfiles path
DOTFILES=$(\
    builtin cd "$(\
        dirname "$(readlink -f "${BASH_SOURCE[0]}")"
    )" > /dev/null && pwd)

# macos dotfiles path
MACOS_DOTFILES=~/.macos-dotfiles
if [[ ! -d "${MACOS_DOTFILES}" ]] \
    || [[ -z "$( ls -A ${MACOS_DOTFILES})" ]]; then
    echo -e "${BR_TEXT}- Couldn't locate ~./macos-dotfiles folder, cloning...${DEF_TEXT}"
    git clone https://github.com/7555G/macos-dotfiles ${MACOS_DOTFILES}
    exit
fi

# prepare folders
mkdir -vp ~/.vim/undo
mkdir -vp ~/.vim/spell
mkdir -vp ~/.vim/words
mkdir -vp ~/.config/gtk-3.0/gtk.css
mkdir -vp ~/.config/autostart
mkdir -vp ~/.local/share/fonts
touch ~/.hushlogin

# make soft symlinks
# TODO: replace this mess with a "macos-dotfiles submodule" & symlinks
echo -e "${BR_TEXT}- Symlinking dotfiles (${DOTFILES})${DEF_TEXT}"
"${MACOS_DOTFILES}"/bin/ln_dotfiles "${DOTFILES}" "${HOME}/."
ln -sfv "${MACOS_DOTFILES}"/inputrc          ~/.inputrc
ln -sfv "${MACOS_DOTFILES}"/bash_aliases     ~/.bash_aliases
ln -sfv "${MACOS_DOTFILES}"/bash_prompt      ~/.bash_prompt
ln -sfv "${MACOS_DOTFILES}"/vim/*            ~/.vim
ln -sfv "${MACOS_DOTFILES}"/condarc          ~/.condarc
ln -sfv "${DOTFILES}"/config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css
ln -sfv "${DOTFILES}"/config/autostart/*     ~/.config/autostart
ln -sfv "${DOTFILES}"/fonts/*/*.otb          ~/.local/share/fonts

# enable bitmap fonts
echo -e "${BR_TEXT}- Enable bitmap fonts & reconfigure fontconfig${DEF_TEXT}"
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo ln -sfv /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d
sudo dpkg-reconfigure fontconfig

# setup vundle
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    echo -e "${BR_TEXT}- Couldn't locate ~/.vim/bundle/Vundle.vim, setting up...${DEF_TEXT}"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi

# setup julia
if command -v "julia" &> /dev/null; then
    echo -e "${BR_TEXT}- Setting up Julia${DEF_TEXT}"
    "${MACOS_DOTFILES}"/julia/setup-julia.sh
fi

echo -e "${BR_TEXT}- Don't forget to append the following to ~/.bashrc:
if [[ -f ~/.bash_extra ]]; then
    source ~/.bash_extra
fi${DEF_TEXT}"
