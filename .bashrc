
# Ubuntu
if [ -f /etc/issue ]; then
  cat /etc/issue | grep -i ubuntu > /dev/null
  if [ $? -eq 0 ]; then
    . ~/.bashrc.ubuntu
  fi
fi

case "${OSTYPE}" in
  cygwin)
    . ~/.bashrc.cygwin
    # alias
    alias ls='ls --color=auto'
    alias ll='ls -l'
    alias l='ls -alF'
    ;;
  darwin*)
    export LSCOLORS=gxfxcxdxbxegedabagacad
    alias ls='ls -G'
    alias ll='ls -l'
    alias la='ls -la'
    alias l='ls -alF'

    # Unity
    alias unity='open -n /Applications/Unity/Unity.app'
    alias unity452f1='open -n /Applications/Unity-4.5.2f1/Unity.app'
    alias unity453f3='open -n /Applications/Unity-4.5.3f3/Unity.app'
    alias unity462f1='open -n /Applications/Unity-4.6.2f1/Unity.app'
    alias unity500f4='open -n /Applications/Unity/Unity.app'

    # git settings
    source /usr/local/etc/bash_completion.d/git-prompt.sh
    source /usr/local/etc/bash_completion.d/git-completion.bash
    source /usr/local/etc/bash_completion.d/tig-completion.bash
    GIT_PS1_SHOWDIRTYSTATE=true
    export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\n\$ '
    ;;
#  linux*)
#    alias ls='ls --color'
#    alias ll='ls -l --color'
#    alias la='ls -la --color'
#    ;;
esac

# option
set -o noclobber

# alias

## system
alias rm='rm -i'
alias mv='mv -i'

## Emacs
alias emacs-daemon='emacs --daemon'
alias E='emacsclient -t'
alias kill-emacs="emacsclient -e '(kill-emacs)'"
alias emacs-debug-init='emacs --debug-init'

## Git
alias g='git'

