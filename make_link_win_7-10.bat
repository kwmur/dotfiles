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

rem symbolic link files
for %%f in (.bash_profile .bashrc .bashrc.cygwin .ccl-init.lisp .clisprc.lisp .ghci .gemrc .tigrc) do (
  rem symbolic link %%f
  mklink "%HOME%\%%f" "%DOTFILES%\%%f"
)

endlocal

