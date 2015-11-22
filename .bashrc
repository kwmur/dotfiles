
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
    alias ls='ls -G'
    alias ll='ls -l'
    alias la='ls -la'
    alias l='ls -alF'

    # Unity
    #alias unity='open -n /Applications/Unity/Unity.app'
    alias unity='unity510f3'
    alias unity462f1='open -n /Applications/Unity-4.6.2f1/Unity.app'
    alias unity510f3='open -n /Applications/Unity-5.1.0f3/Unity.app'

    # git settings
    source /usr/local/etc/bash_completion.d/git-prompt.sh
    source /usr/local/etc/bash_completion.d/git-completion.bash
    source /usr/local/etc/bash_completion.d/tig-completion.bash
    GIT_PS1_SHOWDIRTYSTATE=true
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


### Added by the Heroku Toolbelt
if [ -d /usr/local/heroku ]
then
  export PATH="/usr/local/heroku/bin:$PATH"
fi


