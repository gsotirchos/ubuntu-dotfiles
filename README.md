# Ubuntu dotfiles
My dotfiles for my Ubuntu computers(s).

## Installation
Simply clone this repo in the user's home directory and source the [`etc/setup_dotfiles.sh`](etc/setup_dotfiles.sh) script. This repo works in tandem with my [macos-dotfiles](https://github.com/gsotirchos/macos-dotfiles) repo, which should be present in `~/.macos-dotfiles` and will be cloned there by the setup script.
``` bash
git clone https://github.com/gsotirchos/macos-dotfiles .macos-dotfiles  # optionally
git clone https://github.com/gsotirchos/ubuntu-dotfiles .dotfiles
source .dotfiles/etc/setup_dotfiles.sh
```

Optionally, install some packages to set up my coding environment:
``` bash
source .dotfiles/etc/install_editing_packages.sh
```
