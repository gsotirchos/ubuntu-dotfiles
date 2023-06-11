#!/usr/bin/env bash

main() {
    local BR_TEXT='\033[1;97m'
    local TEXT='\033[0m'

    # install mambaforge
    if ! [[ -d /opt/mambaforge ]]; then
        local CONDA_DIR="/opt/mambaforge"

        echo -e "${BR_TEXT}\n- Setting up Mambaforge in ${CONDA_DIR}${TEXT}"
        curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
        sudo bash "Mambaforge-$(uname)-$(uname -m).sh" -b -p /opt/mambaforge
        sudo chmod -R o+w /opt/mambaforge # allow write access for all users
        rm "Mambaforge-$(uname)-$(uname -m).sh"
        export MAMBA_NO_BANNER=1
        source "${CONDA_DIR}/etc/profile.d/conda.sh"
        source "${CONDA_DIR}/etc/profile.d/mamba.sh"
        mamba update --name base --all -y
        #mamba create --name editing -y
    fi

    # remove old clang
    if command -v "clang-10" &> /dev/null; then
        echo -e "${BR_TEXT}\n- Removing clang-10 ${TEXT}"
        sudo apt remove -y \
            clang-10 \
            clang \
            libclang-common-10-dev \
            libclang-cpp10
    fi

    # install latest clang
    local latest="17" # or whatever is currently the latest
    if ! command -v "clang-${latest}" &> /dev/null; then
        echo -e "${BR_TEXT}\n- Installing clang-17 ${TEXT}"
        wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
        sudo add-apt-repository -y 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal main'
        sudo apt update
        local tools=("clang" "clang-format" "clang-tidy")
        for tool in "${tools[@]}"; do
            sudo apt install -y "${tool}-${latest}"
            echo -n "Adding symlink: "
            sudo cp -nv --no-dereference \
                "$(which "${tool}-${latest}")" \
                "$(dirname "$(which "${tool}-${latest}")")/${tool}"
        done
    fi

    # install other linters and fixers
    echo -e "${BR_TEXT}\n- Installing some code linters and fixers${TEXT}"
    sudo apt install -y \
        gdb \
        ccls \
        cppcheck \
        python3-pip \
        python3-bashate
    sudo snap install \
        bash-language-server \
        shellcheck \
        universal-ctags
    #mamba install -y --name editing \
    #    mamba-bash-completion \
    pip install \
        cmakelang \
        python-lsp-server \
        python-lsp-ruff \
        autopep8 \
        isort

    # (optional) install GCC7
    echo -e "${BR_TEXT}\n- Installing GCC7${TEXT}"
    sudo apt install -y gcc-7 g++-7

    # install latest vim
    echo -e "${BR_TEXT}\n- Installing the latest Vim${TEXT}"
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo apt update && sudo apt upgrade -y

    echo -e "${BR_TEXT}\n- Finished${TEXT}"
}

main "$@"
unset main
