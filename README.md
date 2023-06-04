# ubuntu-dotfiles
My dotfiles for Ubuntu 20.04 on an iMac14,1.

## Installation
Simply clone this repo in the user's home directory and run the [`etc/setup_dotfiles.sh`](etc/setup_dotfiles.sh) script. This repo works in tandem with my [macos-dotfiles](https://github.com/gsotirchos/macos-dotfiles), so they should be present in `~/.macos-dotfiles`.
``` bash
git clone https://github.com/gsotirchos/macos-dotfiles .macos-dotfiles
git clone https://github.com/gsotirchos/ubuntu-dotfiles .dotfiles
source .dotfiles/etc/setup_dotfiles.sh
```

Optionally, install some packages to set up a code editing environment:
``` bash
source .dotfiles/etc/install_editing_packages.sh
```
