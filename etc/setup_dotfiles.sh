# shellcheck disable=SC1090,SC2155
# shellcheck source-path=.dotfiles

main() {
    # text styling
    local bright_style='\033[1;97m'
    local normal_style='\033[0m'

    # dotfiles path
    local dotfiles="$(
        builtin cd "$(
            realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/.."
        )" > /dev/null && pwd
    )"

    # macos dotfiles path
    local macos_dotfiles=~/.macos-dotfiles
    if [[ ! -d "${macos_dotfiles}" ]] || [[ -z "$(ls -A "${macos_dotfiles}")" ]]; then
        echo -e "${bright_style}\n- Couldn't locate ~./macos-dotfiles folder, cloning...${normal_style}"
        git clone git@github.com:gsotirchos/macos-dotfiles.git "${macos_dotfiles}" ||
            git clone https://github.com/gsotirchos/macos-dotfiles.git "${macos_dotfiles}"
    fi

    # prepare folders
    mkdir -vp ~/.config/gtk-3.0
    mkdir -vp ~/.config/autostart
    mkdir -vp ~/.local/share/fonts

    # TODO: replace this mess with a "macos-dotfiles submodule" & symlinks
    echo -e "${bright_style}\n- Setting up dotfiles from ~./macos-dotfiles...${normal_style}"
    source "${macos_dotfiles}/etc/setup_dotfiles.sh"

    # make soft symlinks
    echo -e "${bright_style}\n- Symlinking dotfiles (${dotfiles})${normal_style}"
    ln -sfv "${dotfiles}/config/gtk-3.0/gtk.css" ~/.config/gtk-3.0/gtk.css
    ln -sfv "${dotfiles}/config/redshift.conf" ~/.config/redshift.conf
    ln -sfv "${dotfiles}/config/autostart/"* ~/.config/autostart
    #ln -sfv "${dotfiles}/fonts/"*/*.otb ~/.local/share/fonts

    ## enable bitmap fonts
    #if [[ -n "$(groups | grep -w "sudo|admin")" ]]; then
    #    echo -e "${bright_style}\n- Enable bitmap fonts & reconfigure fontconfig${normal_style}"
    #    sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
    #    sudo ln -sfv /etc/fonts/conf.avail/70-yes-bitmaps.conf /etc/fonts/conf.d
    #    sudo dpkg-reconfigure fontconfig
    #fi
}

main "$@"
unset main
