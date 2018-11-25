#!/bin/bash

readonly DOTFILES_INSTALL_DIR=~/projects/dotfiles

# projects
if [ ! -d ~/projects ]; then
  mkdir ~/projects
fi

# dotfiles
if [ -d "$DOTFILES_INSTALL_DIR" ]; then
  echo "\"$DOTFILES_INSTALL_DIR\" already exists!"
else
  git clone https://github.com/kwmur/dotfiles.git "$DOTFILES_INSTALL_DIR"
fi

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

# dein.vim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein.vim.installer.sh
sh ./dein.vim.installer.sh ~/.cache/dein

