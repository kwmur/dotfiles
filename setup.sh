#!/bin/bash

# projects
mkdir ~/projects
cd ~/projects

# dotfiles
git clone https://github.com/kwmur/dotfiles.git
sh ~/projects/dotfiles/make_link_Cygwin_Linux_Mac_Unix.sh

# neobundle
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

case "${OSTYPE}" in
  darwin*)
    # Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    brew doctor
    brew bundle ~/projects/dotfiles/Brewfile
    ;;
esac

