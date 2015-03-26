@echo off
rem Windows 7 home directory
rem create dot files link

if "%HOME%" == "" (
  echo "%%HOME%% variable is not defined."
  goto :EOF
)

setlocal

rem set your dotfiles directory this
set DOTFILES="%HOME%\projects\dotfiles"

rem symbolic link .emacs.d
mklink /d "%HOME%\.emacs.d" "%DOTFILES%\.emacs.d"

rem symbolic link .vim
mklink /d "%HOME%\.vim" "%DOTFILES%\.vim"

endlocal

