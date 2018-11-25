#!/bin/bash

# projects
mkdir ~/projects
cd ~/projects

# dotfiles
git clone https://github.com/kwmur/dotfiles.git

case "${OSTYPE}" in
  cygwin)
    sh ~/projects/dotfiles/make_link_cygwin_linux_mac_unix.sh
    ;;
  darwin*)
    sh ~/projects/dotfiles/make_link_cygwin_linux_mac_unix.sh

    # Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    brew doctor
    brew bundle ~/projects/dotfiles/Brewfile
    ;;
esac

# neobundle
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

