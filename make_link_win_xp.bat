@echo off
rem Windows XP home directory
rem create dot files link

if "%HOME%" == "" (
  echo "%%HOME%% variable is not defined."
  goto :EOF
)

setlocal

rem set your dotfiles directory this
set DOTFILES="%HOME%\projects\dotfiles"

rem junction .emacs.d
rem http://technet.microsoft.com/ja-jp/sysinternals/bb896768
junction "%HOME%\.emacs.d" "%DOTFILES%\.emacs.d"

rem junction .vim
rem http://technet.microsoft.com/ja-jp/sysinternals/bb896768
junction "%HOME%\.vim" "%DOTFILES%\.vim"

rem TODO: hard link
rem fsutil create hardlink <hardlink name> <source filename>
rem for %%f in (.bash_profile .bashrc .bashrc.cygwin .ccl-init.lisp .clisprc.lisp .ghci .gemrc .tigrc) do (
rem   rem symbolic link %%f
rem   mklink "%HOME%\%%f" "%DOTFILES%\%%f"
rem )

endlocal

