#!/bin/bash
# vim: tw=0

# Cygwin, Unix, Linux, Mac OS X home directory
# make dot files link

# set your dotfiles directory this
readonly DOTFILES_DIR=$(cd $(dirname $0);pwd)
readonly BACKUP_TIME_PID="`date +_%Y_%m%d_%H%M%S`_PID$$"
readonly DOTFILES_BACKUP_DIR=~/.dotfiles.backup
readonly DOTFILES_BACKUP_TIME_DIR="$DOTFILES_BACKUP_DIR/date$BACKUP_TIME_PID"

mv_to_backup_dir(){
  if [ ! -d "$DOTFILES_BACKUP_DIR" ]; then
    echo "==> mkdir $DOTFILES_BACKUP_DIR"
    mkdir "$DOTFILES_BACKUP_DIR"
  fi

  if [ ! -d "$DOTFILES_BACKUP_TIME_DIR" ]; then
    echo "==> mkdir $DOTFILES_BACKUP_TIME_DIR"
    mkdir "$DOTFILES_BACKUP_TIME_DIR"
  fi

  for file_name in $@
  do
    if [ -e ~/$file_name ]; then
      echo "==> mv ~/$file_name $DOTFILES_BACKUP_TIME_DIR/."
      mv ~/$file_name "$DOTFILES_BACKUP_TIME_DIR/."
    else
      echo "==> WARNNING: ~/$file_name is missing."
    fi
  done
}

make_link(){
  for file_name in $@
  do
    if [ -h ~/$file_name ]; then
      echo "==> symbolic link exists ~/$file_name continue..."
      continue
    fi
    if [ -e ~/$file_name ]; then
      echo "==> mv_to_backup_dir ~/$file_name "
      mv_to_backup_dir $file_name
    fi
    # make symbolic link
    echo "==> ln -s $DOTFILES_DIR/$file_name ~/"
    ln -s "$DOTFILES_DIR/$file_name" ~/
    if [ $? -eq 0 ]; then
      echo "  => OK."
    else
      echo "  => NG."
    fi
  done
}

backup_and_copy(){
  for file_name in $@
  do
    if [ -e ~/$file_name ]; then
      echo "==> mv_to_backup_dir ~/$file_name"
      mv_to_backup_dir $file_name
    fi
    echo "==> cp $DOTFILES_DIR/$file_name ~/"
    cp "$DOTFILES_DIR/$file_name" ~/
  done
}

# local dot files
backup_and_copy .vimrc .gvimrc .gitconfig

# TODO: $OSTYPE is better ?
uname -a | grep -i cygwin > /dev/null # Cygwin?
if [ $? -eq 0 ]; then
  case `uname` in # OS
    CYGWIN_NT-5.1) # Windows XP ?
      echo "winXP"
      if [ ! -e ~/.vim -a ! -e ~/.emacs.d ]; then
        # make_link .bash_profile .bashrc .ccl-init.lisp .clisprc.lisp .ghci .gemrc .tigrc # TODO: hard link in .bat
        #./make_link_win_xp.bat # TODO: test
        echo "Please run a batch file make_link_win_xp.bat from the Command Prompt. (need admin?)"
      fi
      ;;
    CYGWIN_NT-10.0) # Windows 10
      echo "win10"
      echo "Please run a batch file make_link_win_7-10.bat from the Command Prompt as an administrator."

      # No log
      #powershell start-process make_link_win_7-10.bat -verb runas
      ;;
  esac
else
  # Unix, Linux, Mac OS X
  make_link .emacs.d .vim .bash_profile .bashrc .ccl-init.lisp .clisprc.lisp .ghci .gemrc .tigrc

  # Ubuntu
  uname -a | grep -i ubuntu > /dev/null
  if [ $? -eq 0 ]; then
    make_link .bashrc.ubuntu
  fi
fi

