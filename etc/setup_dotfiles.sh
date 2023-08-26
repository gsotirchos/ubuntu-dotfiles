#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2155
# shellcheck source-path=.dotfiles

main() {
    # text styling
    local BR_TEXT='\033[1;97m'
    local TEXT='\033[0m'

    # dotfiles path
    local DOTFILES="$(
        builtin cd "$(
            realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/.."
        )" > /dev/null && pwd
    )"

    # macos dotfiles path
    local MACOS_DOTFILES=~/.macos-dotfiles
    if [[ ! -d "${MACOS_DOTFILES}" ]] || [[ -z "$(ls -A "${MACOS_DOTFILES}")" ]]; then
        echo -e "${BR_TEXT}\n- Couldn't locate ~./macos-dotfiles folder, cloning...${TEXT}"
        git clone git@github.com:gsotirchos/macos-dotfiles.git "${MACOS_DOTFILES}"
    fi

    # prepare folders
    mkdir -vp ~/.config/gtk-3.0
    mkdir -vp ~/.config/autostart
    mkdir -vp ~/.local/share/fonts

    # TODO: replace this mess with a "macos-dotfiles submodule" & symlinks
    echo -e "${BR_TEXT}\n- Setting up dotfiles from ~./macos-dotfiles...${TEXT}"
    source "${MACOS_DOTFILES}/etc/setup_dotfiles.sh"
    rm ~/.bash_profile

    # make soft symlinks
    echo -e "${BR_TEXT}\n- Symlinking dotfiles (${DOTFILES})${TEXT}"
    ln -sfv "${DOTFILES}/config/gtk-3.0/gtk.css" ~/.config/gtk-3.0/gtk.css
    ln -sfv "${DOTFILES}/config/redshift.conf" ~/.config/redshift.conf
    ln -sfv "${DOTFILES}/config/autostart/"* ~/.config/autostart
    ln -sfv "${DOTFILES}/fonts/"*/*.otb ~/.local/share/fonts

    # enable bitmap fonts
    echo -e "${BR_TEXT}\n- Enable bitmap fonts & reconfigure fontconfig${TEXT}"
    sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
    sudo ln -sfv /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d
    sudo dpkg-reconfigure fontconfig

    echo -e "${BR_TEXT}\n- Don't forget to append the following to ~/.profile${TEXT}:"
    echo "if [[ -f ~/.bashrc ]]; then"
    echo "    source ~/.bashrc"
    echo "fi"
}

main "$@"
unset main
